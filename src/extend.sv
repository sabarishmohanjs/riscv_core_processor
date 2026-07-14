`timescale 1ns / 1ps
/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Project Title       : RISC-V 5 stage pipelined processor design
Module name         : extend.sv
File Description    : This file implements the immediate generator for the pipelined RISC-V processor. It extracts and sign-extends 
the immediate field from a 32-bit instruction based on the instruction format specified by the immsrc control signal. 
The module supports R-type, I-type, S-type, B-type, J-type, and U-type instruction formats, generating a 32-bit immediate value for use in 
ALU operations, branch target calculation, jump instructions, and upper immediate instructions such as LUI and AUIPC.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

module extend(
    input logic [31:0] instr,
    output logic [31:0] immext,
    input logic [2:0] immsrc
    );
    always_comb
    begin
        case(immsrc)
        3'b000:immext={{20{instr[31]}},instr[31:20]};              //load instr I type
        3'b001:immext={{20{instr[31]}},instr[31:25],instr[11:7]}; //store instr S type
        3'b010:immext={{20{instr[31]}},instr[7],instr[30:25],instr[11:8],1'b0};  //branch instr B type
        3'b011:immext={{11{instr[31]}},instr[31],instr[19:12],instr[20],instr[30:21],1'b0}; //jump instr J type
        3'b100:immext={instr[31:12],12'b0};     //lui instr U type
        default : immext=32'b0;
        endcase
    end
    
endmodule
