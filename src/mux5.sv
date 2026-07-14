`timescale 1ns / 1ps
/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Project Title       : RISC-V 5 stage pipelined processor design
Module name         : mux5.sv
File Description    : This file implements a 32-bit 5-to-1 multiplexer used in the pipelined RISC-V processor to select the appropriate result based 
on a 3-bit select signal. It is primarily used in the Memory and Write-Back stages to choose among the ALU result, data memory output, PC + 4, immediate value (LUI), 
and AUIPC result, ensuring that the correct value is forwarded or written back to the register file.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

module mux5(
    input logic [31:0]a,
    input logic [31:0]b,
    input logic [31:0]c,
    input logic [31:0] d,
    input logic [31:0] e,
    input logic [2:0] sel,
    output logic [31:0] y
    );
    always_comb begin
    case(sel)
        3'b000:y=a;
        3'b001:y=b;
        3'b010:y=c;
        3'b011:y=d;
        3'b100:y=e;
        default:y=32'b0;
    endcase
    end
endmodule
