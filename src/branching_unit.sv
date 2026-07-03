`timescale 1ns / 1ps

module branching_unit(
    input logic [2:0] funct3,
    input logic [31:0] srca,
    input logic [31:0] srcb,
    input logic branch,
    input logic jump,           
    output logic pcsrc
    );
    logic takebranch;
    assign pcsrc=(takebranch&branch)|jump;
    always_comb begin
        case(funct3)
            3'b000:takebranch=(srca==srcb);                     //beq
            3'b001:takebranch=(srca!=srcb);                     //bne
            3'b100:takebranch=($signed(srca)<$signed(srcb));    //blt
            3'b101:takebranch=($signed(srca)>=$signed(srcb));    //bge
            3'b110:takebranch=(srca<srcb);                      //bltu
            3'b111:takebranch=(srca>=srcb);                      //bgeu
            default:takebranch=1'b0;  
        endcase
    end
endmodule
