`timescale 1ns / 1ps
/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Project Title       : RISC-V 5 stage pipelined processor design
Module name         : mux3.sv
File Description    : This file implements a 32-bit 3-to-1 multiplexer used in the pipelined RISC-V processor to select one of three input operands
 based on a 2-bit select signal. It is primarily used in the forwarding unit to choose between the original register operand and forwarded results 
 from the Memory or Write-Back stages, enabling efficient resolution of data hazards without stalling the pipeline.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

module mux3(
    input logic [31:0] a,
    input logic [31:0] b,
    input logic [31:0] c,
    input logic [1:0] sel,
    output logic [31:0] y
    );
    assign y=sel[1]?c:(sel[0]?b:a);
endmodule
