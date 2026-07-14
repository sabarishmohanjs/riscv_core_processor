`timescale 1ns / 1ps
/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Project Title       : RISC-V 5 stage pipelined processor design
Module name         : riscv.sv
File Description    : This file implements the top-level module of a 32-bit five-stage pipelined RISC-V processor
compliant with the RV32I instruction set. It integrates all major datapath components, pipeline registers, control logic, 
hazard handling mechanisms, and memory interfaces to execute instructions in a pipelined manner.

The processor is organized into the standard Fetch (IF), Decode (ID), Execute (EX), Memory (MEM), and Write-Back (WB) stages. 
Each stage is separated by dedicated pipeline registers that store both data and control signals, enabling multiple instructions to be processed concurrently.

The module instantiates the instruction memory, program counter, register file, immediate generator, control unit, ALU, branch unit, data memory,
forwarding multiplexers, hazard detection unit, and pipeline registers. It also implements the next program counter logic for sequential execution,
branching, jumping, and JALR instructions.

To ensure correct pipeline execution, the design incorporates:

---> Data forwarding from the Memory and Write-Back stages to resolve most Read-After-Write (RAW) hazards.
---> Load-use hazard detection, which stalls the Fetch and Decode stages and inserts a bubble into the Execute stage when forwarding alone cannot resolve a dependency.
---> Control hazard handling, which flushes incorrect instructions following taken branches and jump instructions.
---> Support for AUIPC, JAL, and JALR instructions through dedicated target address generation and result selection logic.

The write-back stage selects the final result from multiple sources, including the ALU result, data memory output, PC + 4, immediate value, 
and AUIPC result, before updating the destination register.

Overall, this module serves as the central integration point for the pipelined RISC-V processor, coordinating instruction flow, control signal propagation, 
hazard management, and communication between all functional units to achieve efficient instruction execution.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
module riscv(
    input logic clk,        //clock signal
    input logic reset       //sync async reset signal
    );        
    
    logic [31:0] jalrtarget;    //compute target address for JALR instr
    logic jalr_d;               //jalr opcode detection in decode stage              
    logic jalr_e;               //jalr flag pipelined into Execute stage
    logic [31:0] jumptarget;    //final branch jump target
    
    
    //fetch stage registers
    logic [31:0] instr_f;       //instr fetch in fetch stage
    logic [31:0] pc_f;          //current pc in fetch stage
    logic [31:0] pcplus4_f;     //add pc+4 in fetch stage
    logic [31:0] instr_d;       //instr latched in decode stage
    logic [31:0] pc_d;          //current pc latched in in decode stage
    logic [31:0] pcplus4_d;     //pc+4 latched in in decode stage
    logic [31:0] pcnext_f;      //next pc value fed into the pc ff
    
    //decode stage
    logic regwrite_d;           //reg write enable in decode stage
    logic [31:0] rd1_d;         //read data 1 in decode stage
    logic [31:0] rd2_d;         //read data 2 in decode stage
    logic [31:0] immext_d;      //sign extended immediate in decode stage
    logic [2:0] immsrc_d;       //imm ext select signal in decode stage
    logic [2:0] resultsrc_d;    //write back result select in decode stage 
    logic memwrite_d;           //dm write enable in decode stage
    logic jump_d;               //jump instr select in decode stage
    logic branch_d;             //branch instr select in decode stage
    logic [3:0] alucontrol_d;   //alu operation select in decode stage
    logic alusrc_d;             //alu srcb select in decode stage
    logic [4:0] a3_d;           //write register content or destination register in decode stage
    logic [2:0] funct3_d;       //funct3 field in decode stage
    assign funct3_d=instr_d[14:12];
    
    //execute stage             // in the execute stage
    logic [31:0] srcb_e;        //srcb alu operand B 
    logic [31:0] aluresult_e;   //alu output
    logic pcsrc_e;              //pc source select
    logic [31:0] pctarget_e;    //pc relative branch or jump
    logic [31:0] rd1_e;         //read data 1
    logic [31:0] rd2_e;         //read data 2
    logic [31:0] pc_e;          //current pc
    logic [4:0]  a3_e;          //destination register
    logic [31:0] immext_e;      //sign extended immediate
    logic [31:0] pcplus4_e;     //pc+4 value
    logic regwrite_e;           
    logic [2:0] resultsrc_e;
    logic memwrite_e;
    logic jump_e;
    logic branch_e;
    logic [3:0] alucontrol_e;
    logic alusrc_e;
    logic zero_e;               //zero flag from alu
    logic [31:0] auipc_result_e;//auipc result 
    logic [2:0] funct3_e;       
    
    //memory stage              //in memory stage
    logic [31:0] aluresult_m;   
    logic [31:0] wd_m;          //write data to data memory
    logic [31:0] result_w;      //final write back result
    logic [4:0] a3_m;
    logic [31:0] pcplus4_m;
    logic regwrite_m;
    logic [2:0] resultsrc_m;
    logic memwrite_m;
    logic [31:0] rd_m;
    logic [31:0] immext_m;
    logic [31:0] auipc_result_m;
    
    //write back stage          //in write back stage
    logic [31:0] rd_w;          //data memory read result
    logic [4:0] a3_w;       
    logic [31:0] aluresult_w;
    logic [31:0] pcplus4_w;
    logic regwrite_w;
    logic [2:0] resultsrc_w;
    logic [31:0] immext_w;
    logic [31:0] auipc_result_w;
    
    //hazard signals
    //forwarding
    logic [31:0] out_fae;       //forward operand A into alu
    logic [31:0] out_fbe;       //forward operand B into alu
    logic [1:0] forward_ae;     //forwarding select for alu operand A
    logic [1:0] forward_be;     //forwarding select for alu operand B
    //stalling
    logic stall_f;              //stall fetch stage 
    logic stall_d;              //stall decode stage
    logic flush_e;              //flush execute stage
    //control hazard 
    logic flush_d;              //flush decode stage on taken branch or jump 
    //auipc jalr
    logic [31:0] result_m;      
    
    assign auipc_result_e=pc_e+immext_e;
    assign pcplus4_f=pc_f+32'd4;
    assign jalrtarget = (out_fae + immext_e) & 32'hFFFFFFFE;
    assign jalr_d=(instr_d[6:0]==7'b1100111);  //jalr_e since all executions happen in IE stage  
    assign pctarget_e=immext_e+pc_e;
    assign jumptarget=(jalr_e)?jalrtarget:pctarget_e;
    //fetch stage   
    
    // selects next PC: sequential (PC+4) or taken branch/jump target
    mux mux_pc(
    .a(pcplus4_f),
    .b(jumptarget),
    .sel(pcsrc_e),
    .y(pcnext_f)
    );
    
    // program counter register
    pc_ff instr_pc(
    .pcnext(pcnext_f),
    .clk(clk),
    .pc(pc_f),
    .reset(reset),
    .stall_f(stall_f)
    );
    
    // instruction memory (combinational read)
    instr_mem im(
    .a(pc_f),
    .rd(instr_f)
    );

    // IF/ID pipeline register
    if_id_reg   fd(
    .clk(clk),
    .reset(reset),
    .instr_f(instr_f),
    .pc_f(pc_f),
    .pcplus4_f(pcplus4_f),
    .stall_d(stall_d),
    .flush_d(flush_d),
    .instr_d(instr_d),
    .pc_d(pc_d),
    .pcplus4_d(pcplus4_d)        
    );
        
    //decode
    assign a3_d=instr_d[11:7];
    logic [4:0] rs1_d;
    logic [4:0] rs2_d;
    assign rs1_d=instr_d[19:15];
    assign rs2_d=instr_d[24:20];
    logic [4:0] rs1_e;
    logic [4:0] rs2_e;
    
    // main control unit: decodes opcode/funct3/funct7 into control signals
    control_unit cu(
    .opcode(instr_d[6:0]),
    .funct3(instr_d[14:12]),
    .funct7b5(instr_d[30]),   
    .resultsrc(resultsrc_d),     
    .memwrite(memwrite_d),      
    .alucontrol(alucontrol_d),  
    .alusrc(alusrc_d),        
    .immsrc(immsrc_d), 
    .regwrite(regwrite_d),     
    .jump(jump_d),         
    .branch(branch_d)       
    );
    
    // register file: 2 read ports (Decode), 1 write port (Writeback)
    reg_file rf(
    .a1(instr_d[19:15]),
    .a2(instr_d[24:20]),
    .a3(a3_w),
    .wd3(result_w),
    .we3(regwrite_w),
    .clk(clk),
    .rd1(rd1_d),
    .rd2(rd2_d)
    );
    
    // immediate generator: extends immediate per format
    extend imm(
    .instr(instr_d),
    .immext(immext_d),
    .immsrc(immsrc_d)
    );

    //execute stage
    // ID/EX pipeline register
    id_ie_reg de(
    .clk(clk),
    .reset(reset),
    .rd1_d(rd1_d),
    .rd2_d(rd2_d),
    .pc_d(pc_d),
    .a3_d(a3_d),
    .immext_d(immext_d),
    .pcplus4_d(pcplus4_d),
    .regwrite_d(regwrite_d),
    .resultsrc_d(resultsrc_d),
    .memwrite_d(memwrite_d),
    .jump_d(jump_d),
    .branch_d(branch_d),
    .alucontrol_d(alucontrol_d),
    .alusrc_d(alusrc_d),
    .flush_e(flush_e),
    .jalr_d(jalr_d),
    .funct3_d(funct3_d),
    .rs1_d(rs1_d),
    .rs2_d(rs2_d),
    .jalr_e(jalr_e),
    .rd1_e(rd1_e),
    .rd2_e(rd2_e),
    .pc_e(pc_e),
    .a3_e(a3_e),
    .immext_e(immext_e),
    .pcplus4_e(pcplus4_e),
    .regwrite_e(regwrite_e),
    .resultsrc_e(resultsrc_e),
    .memwrite_e(memwrite_e),
    .jump_e(jump_e),
    .branch_e(branch_e),
    .alucontrol_e(alucontrol_e),
    .alusrc_e(alusrc_e),
    .funct3_e(funct3_e),
    .rs1_e(rs1_e),
    .rs2_e(rs2_e)
    );
    
    // resolves branch/jump outcome (pcsrc_e) using forwarded operands
    branching_unit branch(
    .funct3(funct3_e),
    .srca(out_fae),
    .srcb(out_fbe),  //rd2_e always
    .branch(branch_e),
    .jump(jump_e),           
    .pcsrc(pcsrc_e)
    );
    

    //hazard unit 
     // detects data hazards (forwarding), load-use hazard (stall), and control hazard (flush)
    hazard_unit hu(
    .rs1_e(rs1_e),
    .rs2_e(rs2_e),
    .rd_m(a3_m),
    .rd_w(a3_w),
    .rs1_d(rs1_d),
    .rs2_d(rs2_d),
    .rd_e(a3_e),
    .regwrite_m(regwrite_m),
    .regwrite_w(regwrite_w),
    .resultsrc_e0(resultsrc_e[0]),
    .pcsrc_e(pcsrc_e),
    .forward_ae(forward_ae),
    .forward_be(forward_be),
    .stall_f(stall_f),
    .stall_d(stall_d),
    .flush_e(flush_e),
    .flush_d(flush_d)
    );
    
     // forwarding mux for ALU operand A
    mux3 mux_fae(
    .a(rd1_e),
    .b(result_w),
    .c(result_m),
    .sel(forward_ae),
    .y(out_fae)
    );
    
    // forwarding mux for ALU operand B
    mux3 mux_fbe(
    .a(rd2_e),
    .b(result_w),
    .c(result_m),
    .sel(forward_be),
    .y(out_fbe)
    );
    
    // ALU source B select
    mux mux_alu(
    .a(out_fbe),
    .b(immext_e),
    .sel(alusrc_e),
    .y(srcb_e)
    );
        
    // arithmetic logic unit
    alu alu(
    .srca(out_fae),
    .srcb(srcb_e),
    .aluresult(aluresult_e),
    .alucontrol(alucontrol_e),
    .zero(zero_e)
    );
    
    
    //memory stage 
    // EX/MEM pipeline register
    ie_im_reg em(
    .clk(clk),
    .reset(reset),
    .aluresult_e(aluresult_e),
    .wd_e(out_fbe),
    .a3_e(a3_e),
    .pcplus4_e(pcplus4_e),
    .regwrite_e(regwrite_e),
    .resultsrc_e(resultsrc_e),
    .memwrite_e(memwrite_e),
    .immext_e(immext_e),
    .auipc_result_e(auipc_result_e),
    .aluresult_m(aluresult_m),
    .wd_m(wd_m),
    .a3_m(a3_m),
    .pcplus4_m(pcplus4_m),
    .regwrite_m(regwrite_m),
    .resultsrc_m(resultsrc_m),
    .memwrite_m(memwrite_m),
    .immext_m(immext_m),
    .auipc_result_m(auipc_result_m)
    );
    
    // selects Memory-stage forwarding value
    mux5 mem_result_mux(
    .a(aluresult_m),
    .b(rd_m),
    .c(pcplus4_m),
    .d(immext_m),
    .e(auipc_result_m),
    .sel(resultsrc_m),
    .y(result_m)
    );
    
    // data memory (load/store)
    data_mem dm(
    .clk(clk),
    .a(aluresult_m),
    .we(memwrite_m),
    .wd(wd_m),
    .rd(rd_m)
    );
    
    //write back stage
  
    // MEM/WB pipeline register
    im_iwb_reg memwb(
    .clk(clk),
    .reset(reset),
    .rd_m(rd_m),
    .a3_m(a3_m),
    .aluresult_m(aluresult_m),
    .pcplus4_m(pcplus4_m),
    .regwrite_m(regwrite_m),
    .resultsrc_m(resultsrc_m),
    .immext_m(immext_m),
    .auipc_result_m(auipc_result_m),
    .rd_w(rd_w),
    .a3_w(a3_w),
    .aluresult_w(aluresult_w),
    .pcplus4_w(pcplus4_w),
    .regwrite_w(regwrite_w),
    .resultsrc_w(resultsrc_w),
    .immext_w(immext_w),
    .auipc_result_w(auipc_result_w)
    );
    
    // final writeback result select
    mux5 mux_dm(
    .a(aluresult_w),
    .b(rd_w),
    .c(pcplus4_w),
    .d(immext_w),
    .e(auipc_result_w),
    .sel(resultsrc_w),
    .y(result_w)
    );
endmodule
