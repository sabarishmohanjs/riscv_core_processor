`timescale 1ns / 1ps

module if_id_reg(
    input logic clk,
    input logic reset,
    input logic [31:0] instr_f,
    input logic [31:0] pc_f,
    input logic [31:0] pcplus4_f,
    input logic stall_d,
    input logic flush_d,
    output logic [31:0] instr_d,
    output logic [31:0] pc_d,
    output logic [31:0] pcplus4_d        
    );
    always@(posedge clk)
    begin
        if(reset || flush_d)
        begin
            instr_d<=0;
            pc_d<=0;
            pcplus4_d<=0;
        end
        else if(!stall_d)
        begin
            instr_d<=instr_f;
            pc_d<=pc_f;
            pcplus4_d<=pcplus4_f;
        end
    end
endmodule
