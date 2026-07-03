`timescale 1ns / 1ps

module im_iwb_reg(
    input logic clk,
    input logic reset,
    input logic [31:0] rd_m,
    input logic [4:0] a3_m,
    input logic [31:0] aluresult_m,
    input logic [31:0] pcplus4_m,
    input logic regwrite_m,
    input logic [2:0] resultsrc_m,
    input logic [31:0] immext_m,
    input logic [31:0] auipc_result_m,
    output logic [31:0] rd_w,
    output logic [4:0] a3_w,
    output logic [31:0] aluresult_w,
    output logic [31:0] pcplus4_w,
    output logic regwrite_w,
    output logic [2:0] resultsrc_w,
    output logic [31:0] immext_w,
    output logic [31:0] auipc_result_w
    );
    always@(posedge clk)
    begin
        if(reset)begin
            rd_w<=0;
            a3_w<=0;
            aluresult_w<=0;
            pcplus4_w<=0;     
            regwrite_w<=0;
            resultsrc_w<=0;   
            immext_w<=0;
            auipc_result_w<=0;
        end
        else
        begin
            rd_w<=rd_m;
            a3_w<=a3_m;
            aluresult_w<=aluresult_m;
            pcplus4_w<=pcplus4_m;
            regwrite_w<=regwrite_m;
            resultsrc_w<=resultsrc_m;
            immext_w<=immext_m;
            auipc_result_w<=auipc_result_m;
        end
    end
endmodule
