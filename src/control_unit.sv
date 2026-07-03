`timescale 1ns / 1ps

module control_unit(
    input logic [6:0] opcode,
    input logic [2:0] funct3,
    input logic funct7b5,          
    output logic [2:0] resultsrc,     
    output logic memwrite,      
    output logic [3:0] alucontrol,  
    output logic alusrc,        
    output logic [2:0] immsrc, 
    output logic regwrite,     
    output logic jump,         
    output logic branch        
    );
    logic [1:0] aluop;         
    logic [12:0] controls;
    assign {regwrite,immsrc,alusrc,memwrite,resultsrc,branch,aluop,jump}=controls;

    always_comb begin
        case(opcode)
            7'b0000011: controls = 13'b1_000_1_0_001_0_00_0; // lw
            7'b0100011: controls = 13'b0_001_1_1_000_0_00_0; // sw 
            7'b0110011: controls = 13'b1_xxx_0_0_000_0_10_0; // R-type 
            7'b1100011: controls = 13'b0_010_0_0_000_1_01_0; // beq
            7'b0010011: controls = 13'b1_000_1_0_000_0_10_0; // I-type ALU 
            7'b1101111: controls = 13'b1_011_0_0_010_0_00_1; // jal 
            7'b1100111: controls = 13'b1_000_1_0_010_0_00_1; //jalr
            7'b0110111: controls = 13'b1_100_0_0_011_0_00_0; //lui
            7'b0010111: controls = 13'b1_100_0_0_100_0_00_0; //auipc
            default: controls = 13'b0_000_0_0_000_0_00_0; // ???
        endcase
    end
    
    always_comb
    begin
        case(aluop)
         2'b00: alucontrol=4'b0000;                 //add   addi
         2'b01: alucontrol=4'b0001;                 //sub
         default:   
            case(funct3)
                3'b000: 
                    if(opcode[5]&funct7b5)
                        alucontrol=4'b0001;         //sub
                    else
                        alucontrol=4'b0000;        //add
               3'b001:  alucontrol=4'b0101;         //sll   slli
               3'b010:  alucontrol=4'b1000;        //slt    slti
               3'b011:  alucontrol=4'b1001;         //sltu  sltiu
               3'b100:  alucontrol=4'b0010;        //xor    xori
               3'b101:  
                    if(funct7b5)
                        alucontrol=4'b0111;         //sra   srai
                    else
                        alucontrol=4'b1010;         //srl   srli
               3'b110:  alucontrol=4'b0011;        //or     ori
               3'b111:  alucontrol=4'b0100;        //and    andi
               default: alucontrol=4'b0000;        
                        
            endcase
        endcase
    end
endmodule
