`timescale 1ns / 1ps
/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Project Title       : RISC-V 5 stage pipelined processor design
Module name         : id_ie_reg.sv
File Description    : This file implements the ID/EX pipeline register, which transfers data operands, immediate values, program counter information, 
register addresses, and control signals from the Instruction Decode (ID) stage to the Execute (EX) stage. It preserves both datapath and control information 
required for instruction execution while supporting pipeline flushing during reset or hazard conditions by clearing all stored values, 
thereby inserting a bubble into the pipeline.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

module id_ie_reg(
    input logic clk,
    input logic reset,
    input logic [31:0] rd1_d,
    input logic [31:0] rd2_d,
    input logic [31:0] pc_d,
    input logic [4:0]  a3_d,
    input logic [31:0] immext_d,
    input logic [31:0] pcplus4_d,
    input logic regwrite_d,
    input logic [2:0] resultsrc_d,
    input logic memwrite_d,
    input logic jump_d,
    input logic branch_d,
    input logic [3:0] alucontrol_d,
    input logic alusrc_d,
    input logic [2:0] funct3_d,
    input logic jalr_d,
    input logic [4:0] rs1_d,
    input logic [4:0] rs2_d,
    input logic flush_e,
    output logic jalr_e,
    output logic [31:0] rd1_e,
    output logic [31:0] rd2_e,
    output logic [31:0] pc_e,
    output logic [4:0]  a3_e,
    output logic [31:0] immext_e,
    output logic [31:0] pcplus4_e,
    output logic regwrite_e,
    output logic [2:0] resultsrc_e,
    output logic memwrite_e,
    output logic jump_e,
    output logic branch_e,
    output logic [3:0] alucontrol_e,
    output logic alusrc_e,
    output logic [2:0] funct3_e,
    output logic [4:0] rs1_e,
    output logic [4:0] rs2_e
    );
    
    always@(posedge clk)
    begin
        if(reset || flush_e) //flushing after the stalling
        begin
            rd1_e<=0;
            rd2_e<=0;
            pc_e<=0;
            a3_e<=0;
            immext_e<=0;
            pcplus4_e<=0;
            regwrite_e<=0;
            resultsrc_e<=0;
            memwrite_e<=0;
            jump_e<=0;
            branch_e<=0;
            alucontrol_e<=0;
            alusrc_e<=0;
            funct3_e<=0;
            jalr_e<=0;
            rs1_e<=0;
            rs2_e<=0;
        end
        else
        begin
            rd1_e<=rd1_d;
            rd2_e<=rd2_d;
            pc_e<=pc_d;
            a3_e<=a3_d;
            immext_e<=immext_d;
            pcplus4_e<=pcplus4_d;
            regwrite_e<=regwrite_d;
            resultsrc_e<=resultsrc_d;
            memwrite_e<=memwrite_d;
            jump_e<=jump_d;
            branch_e<=branch_d;
            alucontrol_e<=alucontrol_d;
            alusrc_e<=alusrc_d;
            funct3_e<=funct3_d;
            jalr_e<=jalr_d;
            rs1_e<=rs1_d;
            rs2_e<=rs2_d;
        end
    end
endmodule
