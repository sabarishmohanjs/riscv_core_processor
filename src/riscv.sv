`timescale 1ns / 1ps

module riscv(
    input logic clk,
    input logic reset
    );        
//    logic [31:0] pctarget;
//    logic [31:0] pcplus4;    
//    logic pcsrc;    
//    logic [31:0] instr;
//    logic [31:0] readdata;    
//    logic [31:0] srca;    
//    logic [31:0] writedata;      
//    logic zero;
//    logic [31:0] auipc_result;
    logic [31:0] jalrtarget;
    logic jalr_d;
    logic jalr_e; 
    logic [31:0] jumptarget;
    
    
    //fetch stage registers
    logic [31:0] instr_f;
    logic [31:0] pc_f;
    logic [31:0] pcplus4_f;    
    logic [31:0] instr_d;
    logic [31:0] pc_d;
    logic [31:0] pcplus4_d;  
    logic [31:0] pcnext_f;
    
    //decode stage
    logic regwrite_d;
    logic [31:0] rd1_d;
    logic [31:0] rd2_d;
    logic [31:0] immext_d;
    logic [2:0] immsrc_d;
    logic [2:0] resultsrc_d;
    logic memwrite_d;
    logic jump_d;
    logic branch_d; 
    logic [3:0] alucontrol_d;
    logic alusrc_d;
    logic [4:0] a3_d;
    logic [2:0] funct3_d;
    assign funct3_d=instr_d[14:12];
    
    //execute stage
    logic [31:0] srcb_e;
    logic [31:0] aluresult_e;
    logic pcsrc_e;
    logic [31:0] pctarget_e;
    logic [31:0] rd1_e;
    logic [31:0] rd2_e;
    logic [31:0] pc_e;
    logic [4:0]  a3_e;
    logic [31:0] immext_e;
    logic [31:0] pcplus4_e;
    logic regwrite_e;
    logic [2:0] resultsrc_e;
    logic memwrite_e;
    logic jump_e;
    logic branch_e;
    logic [3:0] alucontrol_e;
    logic alusrc_e;
    logic zero_e;
    logic [31:0] auipc_result_e;
    logic [2:0] funct3_e;
    //memory stage
    logic [31:0] aluresult_m;
    logic [31:0] wd_m;
    logic [31:0] result_w;
    logic [4:0] a3_m;
    logic [31:0] pcplus4_m;
    logic regwrite_m;
    logic [2:0] resultsrc_m;
    logic memwrite_m;
    logic [31:0] rd_m;
    logic [31:0] immext_m;
    logic [31:0] auipc_result_m;
    
    //write back stage
    logic [31:0] rd_w;
    logic [4:0] a3_w;
    logic [31:0] aluresult_w;
    logic [31:0] pcplus4_w;
    logic regwrite_w;
    logic [2:0] resultsrc_w;
    logic [31:0] immext_w;
    logic [31:0] auipc_result_w;
    
    //hazard signals
    //forwarding
    logic [31:0] out_fae;
    logic [31:0] out_fbe;
    logic [1:0] forward_ae;
    logic [1:0] forward_be;
    //stalling
    logic stall_f;
    logic stall_d;
    logic flush_e;
    
    assign auipc_result_e=pc_e+immext_e;
    assign pcplus4_f=pc_f+32'd4;
    assign jalrtarget=rd1_e+immext_e;
    assign jalr_d=(instr_d[6:0]==7'b1100111);  //jalr_e since all executions happen in IE stage  
    assign pctarget_e=immext_e+pc_e;
    assign jumptarget=(jalr_e)?jalrtarget:pctarget_e;
    //fetch stage   
    
    mux mux_pc(
    .a(pcplus4_f),
    .b(jumptarget),
    .sel(pcsrc_e),
    .y(pcnext_f)
    );
    
    pc_ff instr_pc(
    .pcnext(pcnext_f),
    .clk(clk),
    .pc(pc_f),
    .reset(reset),
    .stall_f(stall_f)
    );
    
    instr_mem im(
    .a(pc_f),
    .rd(instr_f)
    );

    if_id_reg   fd(
    .clk(clk),
    .reset(reset),
    .instr_f(instr_f),
    .pc_f(pc_f),
    .pcplus4_f(pcplus4_f),
    .stall_d(stall_d),
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
    
    extend imm(
    .instr(instr_d),
    .immext(immext_d),
    .immsrc(immsrc_d)
    );

    //execute stage
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
    
        
    branching_unit branch(
    .funct3(funct3_e),
    .srca(rd1_e),
    .srcb(rd2_e),  //rd2_e always
    .branch(branch_e),
    .jump(jump_e),           
    .pcsrc(pcsrc_e)
    );
    

    //hazard unit 
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
    .forward_ae(forward_ae),
    .forward_be(forward_be),
    .stall_f(stall_f),
    .stall_d(stall_d),
    .flush_e(flush_e)
    );
    
    mux3 mux_fae(
    .a(rd1_e),
    .b(result_w),
    .c(aluresult_m),
    .sel(forward_ae),
    .y(out_fae)
    );
    
    mux3 mux_fbe(
    .a(rd2_e),
    .b(result_w),
    .c(aluresult_m),
    .sel(forward_be),
    .y(out_fbe)
    );
    
    mux mux_alu(
    .a(out_fbe),
    .b(immext_e),
    .sel(alusrc_e),
    .y(srcb_e)
    );
        
    alu alu(
    .srca(out_fae),
    .srcb(srcb_e),
    .aluresult(aluresult_e),
    .alucontrol(alucontrol_e),
    .zero(zero_e)
    );
    
    
    //memory stage 
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
    
    data_mem dm(
    .clk(clk),
    .a(aluresult_m),
    .we(memwrite_m),
    .wd(wd_m),
    .rd(rd_m)
    );
    
    //write back stage
  
    
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
