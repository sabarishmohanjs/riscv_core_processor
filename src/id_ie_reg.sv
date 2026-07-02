`timescale 1ns / 1ps

module id_ie_reg(
    input logic clk,
    input logic reset,
    input logic [31:0] rd1_d,
    input logic [31:0] rd2_d,
    input logic [31:0] pc_d,
    input logic [4:0]  a3_d,
    input logic [31:0] immext_d,
    input logic [31:0] pcplus4_d,
    output logic [31:0] rd1_e,
    output logic [31:0] rd2_e,
    output logic [31:0] pc_e,
    output logic [4:0]  a3_e,
    output logic [31:0] immext_e,
    output logic [31:0] pcplus4_e
    );
    
    always@(posedge clk)
    begin
        if(reset)
        begin
            rd1_e<=0;
            rd2_e<=0;
            pc_e<=0;
            a3_e<=0;
            immext_e<=0;
            pcplus4_e<=0;
        end
        else
        begin
            rd1_e<=rd1_d;
            rd2_e<=rd2_d;
            pc_e<=pc_d;
            a3_e<=a3_d;
            immext_e<=immext_d;
            pcplus4_e<=pcplus4_d;
        end
    end
endmodule
