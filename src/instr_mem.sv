`timescale 1ns / 1ps

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
