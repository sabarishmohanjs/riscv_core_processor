`timescale 1ns / 1ps

module pc_ff(
    input logic [31:0] pcnext,
    input logic clk,
    output logic [31:0] pc,
    input logic reset
    );
    always_ff @(posedge clk)begin
        if(reset)begin
            pc<=0;
        end
        else begin
            pc<=pcnext;
        end
    end
endmodule
