`timescale 1ns / 1ps
/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Project Title       : RISC-V 5 stage pipelined processor design
Module name         : pc_ff.sv
File Description    : This file implements the Program Counter (PC) register for the Fetch stage of the pipelined RISC-V processor. 
The register updates the current program counter with the next instruction address on every rising clock edge. 
It supports a synchronous reset to initialize the PC to zero and a stall control signal that holds the current PC value 
during pipeline stalls caused by hazards.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

module pc_ff(
    input logic [31:0] pcnext,
    input logic clk,
    output logic [31:0] pc,
    input logic reset,
    input logic stall_f
    );
    always_ff @(posedge clk)begin
        if(reset)begin
            pc<=0;
        end
        else if(!stall_f) begin
            pc<=pcnext;
        end
    end
endmodule
