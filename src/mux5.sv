`timescale 1ns / 1ps

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
