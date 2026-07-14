`timescale 1ns / 1ps
/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Project Title       : RISC-V 5 stage pipelined processor design
Module name         : ie_im_reg.sv
File Description    : This file implements the EX/MEM pipeline register, which transfers the ALU result, write data, destination register address, 
immediate value, PC + 4, AUIPC result, and associated control signals from the Execute (EX) stage to the Memory (MEM) stage. 
It synchronizes the flow of datapath and control information between pipeline stages and supports synchronous reset by clearing all stored values.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

module ie_im_reg(
    input logic clk,
    input logic reset,
    input logic [31:0] aluresult_e,
    input logic [31:0] wd_e,
    input logic [4:0] a3_e,
    input logic [31:0] pcplus4_e,
    input logic regwrite_e,
    input logic [2:0] resultsrc_e,
    input logic memwrite_e,
    input logic [31:0] immext_e,
    input logic [31:0] auipc_result_e,
    output logic [31:0] aluresult_m,
    output logic [31:0] wd_m,
    output logic [4:0] a3_m,
    output logic [31:0] pcplus4_m,
    output logic regwrite_m,
    output logic [2:0] resultsrc_m,
    output logic memwrite_m,
    output logic [31:0] immext_m,
    output logic [31:0] auipc_result_m
    );
    always@(posedge clk)
    begin
        if(reset)
        begin
            aluresult_m<=0;
            wd_m<=0;
            a3_m<=0;
            pcplus4_m<=0;            
            regwrite_m<=0;
            resultsrc_m<=0;
            memwrite_m<=0;
            immext_m<=0;
            auipc_result_m<=0;
        end
        else 
        begin
            aluresult_m<=aluresult_e;
            wd_m<=wd_e;
            a3_m<=a3_e;
            pcplus4_m<=pcplus4_e;
            regwrite_m<=regwrite_e;
            resultsrc_m<=resultsrc_e;
            memwrite_m<=memwrite_e;
            immext_m<=immext_e;
            auipc_result_m<=auipc_result_e;
        end
    end
endmodule
