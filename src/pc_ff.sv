`timescale 1ns / 1ps

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
