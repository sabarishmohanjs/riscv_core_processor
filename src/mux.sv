`timescale 1ns / 1ps

/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Project Title       : RISC-V 5 stage pipelined processor design
Module name         : mux.sv
File Description    : This file implements a 32-bit 2-to-1 multiplexer, a fundamental combinational logic component used throughout the RISC-V processor datapath.
The multiplexer selects one of two 32-bit input signals based on a single-bit select signal and forwards the selected input to the output.
In the pipelined RISC-V processor, this multiplexer is used in multiple locations, such as selecting the next program counter (PC), choosing between a register operand 
and an immediate value for the ALU, and other datapath selection operations where two alternative data sources must be selected.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
module mux(
    input logic [31:0]a,
    input logic [31:0]b,
    input logic sel,
    output logic [31:0] y
    );
assign y=(sel)?b:a;
endmodule
