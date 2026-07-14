`timescale 1ns / 1ps
/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Project Title       : RISC-V 5 stage pipelined processor design
Module name         : reg_file.sv
File Description    : This file implements the 32 × 32-bit register file for the pipelined RISC-V processor. It provides two combinational read ports 
and one synchronous write port, enabling simultaneous reading of two source operands and writing of a destination register. 
Register x0 is hardwired to zero and cannot be modified. The module also includes write-first (write-through) behavior, allowing newly written data to be forwarded 
to the read ports within the same clock cycle, thereby avoiding read-after-write hazards during simulation.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

//32 bit 32 registers
module reg_file(
    input logic [4:0] a1,
    input logic [4:0] a2,
    input logic [4:0] a3,
    input logic [31:0] wd3,
    input logic we3,
    input logic clk,
    output logic [31:0] rd1,
    output logic [31:0] rd2
    );
    
reg [31:0] register [0:31];

initial begin
    $readmemh("registers.mem",register);
end

//assign rd1=(a1==5'd0)?32'b0:register[a1];
//assign rd2=(a2==5'd0)?32'b0:register[a2];

//write first read during second half of the cycle 
assign rd1 =
    (a1 == 0) ? 32'b0 :
    (we3 && (a1 == a3) && (a3 != 0)) ? wd3 :
    register[a1];

assign rd2 =
    (a2 == 0) ? 32'b0 :
    (we3 && (a2 == a3) && (a3 != 0)) ? wd3 :
    register[a2];

always_ff@(posedge clk)begin
    if(we3 && (a3!=5'd0)) // x0 is hardwired to zero
        register[a3]<=wd3;
end
endmodule
