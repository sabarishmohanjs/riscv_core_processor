`timescale 1ns / 1ps

module hazard_unit(
    input logic [4:0] rs1_e,
    input logic [4:0] rs2_e,
    input logic [4:0] rd_m,
    input logic [4:0] rd_w,
    input logic regwrite_m,
    input logic regwrite_w,
    output logic [1:0] forward_ae,
    output logic [1:0] forward_be
    );
    logic lw_stall;
     
    always_comb begin
        //raw - read after write hazard 
        //forwarding
        if (((rs1_e==rd_m)&& (regwrite_m))&&(rs1_e!=0))
        begin
            forward_ae=2'b10;
        end
        else if (((rs1_e==rd_w)&& (regwrite_w))&&(rs1_e!=0))
        begin
            forward_ae=2'b01;
        end
        else
            forward_ae=2'b00;
            
        if (((rs2_e==rd_m)&& (regwrite_m))&(rs2_e!=0))
        begin
            forward_be=2'b10;
        end
        else if (((rs2_e==rd_w)&& (regwrite_w))&(rs2_e!=0))
        begin
            forward_be=2'b01;
        end
        else
            forward_be=2'b00;
               
    end
    
endmodule
