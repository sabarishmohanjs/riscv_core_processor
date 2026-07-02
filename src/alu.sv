`timescale 1ns / 1ps

module alu(
    input logic [31:0] srca,
    input logic [31:0] srcb,
    output logic [31:0] aluresult,
    input logic [3:0] alucontrol,
    output logic zero
    );
    assign zero=(aluresult==0)?1'b1:1'b0;
    always_comb
    begin
        case(alucontrol)
            4'b0000:aluresult=srca+srcb;     //add  addi
            4'b0001:aluresult=srca-srcb;     //sub
            4'b0010:aluresult=srca^srcb;     //xor  xori
            4'b0011:aluresult=srca|srcb;     //or   ori
            4'b0100:aluresult=srca&srcb;     //and  andi
            4'b0101:aluresult=srca<<srcb[4:0];    //sll  slli
            4'b1010:aluresult=srca>>srcb[4:0];    //srl  srli
            4'b0111:aluresult=$signed(srca)>>>srcb[4:0]; //sra   srai
            4'b1000:aluresult=($signed(srca)<$signed(srcb))?32'b1:32'b0; //slt  slti
            4'b1001:aluresult=(srca<srcb)?32'b1:32'b0; //sltu   sltiu
            default:aluresult=32'b0;        //default
        endcase
    end
endmodule
