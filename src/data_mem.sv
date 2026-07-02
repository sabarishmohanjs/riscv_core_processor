`timescale 1ns / 1ps

module data_mem(
    input logic clk,
    input logic [31:0] a,
    input logic we,
    input logic [31:0] wd,
    output logic [31:0] rd
    );

reg [31:0] data[0:63];
initial begin
    $readmemh("data_mem.mem",data);
end

assign rd=data[a[7:2]];

always_ff@(posedge clk)begin
    if(we)
        data[a[7:2]]<=wd;
end
endmodule
