`timescale 1ns / 1ps

module mux3(
    input logic [31:0] a,
    input logic [31:0] b,
    input logic [31:0] c,
    input logic [1:0] sel,
    output logic [31:0] y
    );
    assign y=sel[1]?c:(sel[0]?b:a);
endmodule
