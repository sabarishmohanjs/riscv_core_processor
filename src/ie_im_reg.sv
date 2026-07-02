`timescale 1ns / 1ps

module ie_im_reg(
    input logic clk,
    input logic reset,
    input logic [31:0] aluresult_e,
    input logic [31:0] wd_e,
    input logic [4:0] a3_e,
    input logic [31:0] pcplus4_e,
    output logic [31:0] aluresult_m,
    output logic [31:0] wd_m,
    output logic [4:0] a3_m,
    output logic [31:0] pcplus4_m
    );
    always@(posedge clk)
    begin
        if(reset)
        begin
            aluresult_m<=0;
            wd_m<=0;
            a3_m<=0;
            pcplus4_m<=0;
        end
        else 
        begin
            aluresult_m<=aluresult_e;
            wd_m<=wd_e;
            a3_m<=a3_e;
            pcplus4_m<=pcplus4_e;
        end
    end
endmodule
