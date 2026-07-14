`timescale 1ns / 1ps

/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Project Title       : RISC-V 5 stage pipelined processor design
Module name         : instr_mem.sv
File Description    : This file implements the instruction memory for the pipelined RISC-V processor. The memory stores the program instructions 
loaded from the instruction.mem file during simulation. It performs a combinational read based on the program counter address, 
using word-aligned addressing (a[31:2]) to fetch and output a 32-bit instruction.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

module instr_mem(
    input logic [31:0] a,
    output logic [31:0] rd
    );

reg [31:0]instr[0:99]; 
initial begin
    $readmemh("instruction.mem",instr);
end

assign rd=instr[a[31:2]]; //divide by 4 word aligned
endmodule
