`timescale 1ns / 1ps

module riscv(
    input logic clk,
    input logic reset
    );
    
    logic [31:0] pcnext;
    logic [31:0] pc;
    logic [31:0] pctarget;
    logic [31:0] pcplus4;
    logic [31:0] immext;
    logic pcsrc;
    logic [2:0] resultsrc;
    logic [31:0] instr;
    logic [31:0] readdata;
    logic regwrite;
    logic [31:0] srca;
    logic [31:0] srcb;
    logic [31:0] writedata;
    logic [31:0] result;        //data memory mux
    logic [31:0] aluresult;
    logic [3:0] alucontrol;
    logic [2:0] immsrc;
    logic alusrc;
    logic zero;
    logic memwrite;  
    logic jump;
    logic branch; 
    logic [31:0] jalrtarget;
    logic jalr; 
    logic [31:0] jumptarget;
    logic [31:0] auipc_result;
    
    assign auipc_result=pc+immext;
    assign pcplus4=pc+32'd4;
    assign jalrtarget=srca+immext;
    assign jalr=(instr[6:0]==7'b1100111);    
    assign pctarget=immext+pc;
    assign jumptarget=(jalr)?jalrtarget:pctarget;
    
    mux mux_pc(
    .a(pcplus4),
    .b(jumptarget),
    .sel(pcsrc),
    .y(pcnext)
    );
    
    pc_ff instr_pc(
    .pcnext(pcnext),
    .clk(clk),
    .pc(pc),
    .reset(reset)
    );
    
    instr_mem im(
    .a(pc),
    .rd(instr)
    );
    
    
    control_unit cu(
    .opcode(instr[6:0]),
    .funct3(instr[14:12]),
    .funct7b5(instr[30]),
    .zero(zero), 
    .srca(srca),
    .srcb(srcb),          
    .pcsrc(pcsrc),         
    .resultsrc(resultsrc),     
    .memwrite(memwrite),      
    .alucontrol(alucontrol),  
    .alusrc(alusrc),        
    .immsrc(immsrc), 
    .regwrite(regwrite),     
    .jump(jump),         
    .branch(branch)       
    );
    
    reg_file rf(
    .a1(instr[19:15]),
    .a2(instr[24:20]),
    .a3(instr[11:7]),
    .wd3(result),
    .we3(regwrite),
    .clk(clk),
    .rd1(srca),
    .rd2(writedata)
    );
    
    extend imm(
    .instr(instr),
    .immext(immext),
    .immsrc(immsrc)
    );
    
    mux mux_alu(
    .a(writedata),
    .b(immext),
    .sel(alusrc),
    .y(srcb)
    );
    
    
    alu alu(
    .srca(srca),
    .srcb(srcb),
    .aluresult(aluresult),
    .alucontrol(alucontrol),
    .zero(zero)
    );
    
    data_mem dm(
    .clk(clk),
    .a(aluresult),
    .we(memwrite),
    .wd(writedata),
    .rd(readdata)
    );
    
    
    mux5 mux_dm(
    .a(aluresult),
    .b(readdata),
    .c(pcplus4),
    .d(immext),
    .e(auipc_result),
    .sel(resultsrc),
    .y(result)
    );
endmodule
