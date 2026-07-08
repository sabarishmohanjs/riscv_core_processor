`timescale 1ns / 1ps

module hazard_unit(
    input logic [4:0] rs1_e,
    input logic [4:0] rs2_e,
    input logic [4:0] rd_m,
    input logic [4:0] rd_w,
    input logic [4:0] rs1_d,
    input logic [4:0] rs2_d,
    input logic [4:0] rd_e,
    input logic regwrite_m,
    input logic regwrite_w,
    input logic resultsrc_e0,
    input logic pcsrc_e,
    output logic [1:0] forward_ae,
    output logic [1:0] forward_be,
    output logic stall_f,
    output logic stall_d,
    output logic flush_e,
    output logic flush_d
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
            
        if (((rs2_e==rd_m)&& (regwrite_m))&&(rs2_e!=0))
        begin
            forward_be=2'b10;
        end
        else if (((rs2_e==rd_w)&& (regwrite_w))&&(rs2_e!=0))
        begin
            forward_be=2'b01;
        end
        else
            forward_be=2'b00;
        
        //load instruction
        //stalling
        //bubble
        lw_stall=(resultsrc_e0)&&((rs1_d==rd_e)||(rs2_d==rd_e));
        stall_f=lw_stall;
        stall_d=lw_stall; 
        
        //control hazard  
        flush_d=pcsrc_e;
        flush_e=lw_stall|pcsrc_e;
    end
    
endmodule
