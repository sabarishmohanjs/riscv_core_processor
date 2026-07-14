`timescale 1ns / 1ps
/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Project Title       : RISC-V 5 stage pipelined processor design
Module name         : data_mem.sv
File Description    : This file implements the data memory for the pipelined RISC-V processor. It provides a word-addressable memory with 
combinational read access and synchronous write capability. The memory is initialized from the data_mem.mem file during simulation and 
supports load and store instructions by reading or writing 32-bit data using word-aligned addresses.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

module data_mem(
    input logic clk,
    input logic [31:0] a,
    input logic we,
    input logic [31:0] wd,
    output logic [31:0] rd
    );

reg [31:0] data[0:63];
initial begin
    $readmemh("data_mem.mem",data);
end

assign rd=data[a[7:2]];

always_ff@(posedge clk)begin
    if(we)
        data[a[7:2]]<=wd;
end
endmodule
