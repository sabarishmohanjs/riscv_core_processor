`timescale 1ns / 1ps

module tb();

logic clk;
logic rst;

riscv rv32(clk,rst);

//clock generation
initial begin
    clk=0;
    forever#5 clk=~clk;
end


//expected register values
logic [31:0] exp_reg [0:31];
task expected;
    begin
    integer  i;
    for(int i=0;i<32;i=i+1)
        exp_reg[i]=0;
        exp_reg[0]=32'd0;
        exp_reg[1]=32'd5;
        exp_reg[2]=32'd5;
        exp_reg[3]=32'd0;
        exp_reg[4]=32'd0;
        exp_reg[5]=32'd3;
//        exp_reg[6]=32'd0;
//        exp_reg[7]=32'd99;
//    exp_reg[8]=999;
//    exp_reg[9]=25;
//    exp_reg[10]=-5;
//    exp_reg[11]=0;
//    exp_reg[12]=999;
//    exp_reg[13]=-50;
//    exp_reg[14]=-25;
//    exp_reg[15]=0;
//    exp_reg[16]=999;
//    exp_reg[17]=77;
//    exp_reg[18]=88;
//    exp_reg[19]=0;
//    exp_reg[20]=999;
//    exp_reg[21]=100;
//    exp_reg[22]=100;
//    exp_reg[23]=0;
//    exp_reg[24]=999;
    end
endtask

integer pass_cnt;
integer fail_cnt;
integer test_cnt;

task check;
    input string label;
    input logic [31:0] got;
    input logic [31:0] expected;
    begin
        test_cnt=test_cnt+1;
        if (got===expected)     //even if we get x --> it performs exact comparison
        begin
            pass_cnt=pass_cnt+1;
            $display(" PASS %-25s GOT=%0d EXPECTED=%0d" ,label,got,expected);
        end
        else
        begin
            fail_cnt=fail_cnt+1;
            $display("FAIL %-25s GOT=%0d EXPECTED=%0d" ,label,got,expected);
        end
    end
endtask
always @(negedge clk)
begin
      // Wait for all nonblocking assignments to update

    if(!rst)
    begin
        $display("\n========================================================");
        $display("TIME = %0t",$time);
//        $display("\nRegister Contents");
//        $display("x0=%0d x1=%0d x2=%0d x3=%0d x4=%0d",
//                  rv32.rf.register[0],
//                  rv32.rf.register[1],
//                  rv32.rf.register[2],
//                  rv32.rf.register[3],
//                  rv32.rf.register[4]);
//        $display("ALU Inputs");
//        $display("srcA=%0d srcB=%0d",
//                  rv32.out_fae,
//                  rv32.srcb_e);
//        $display("\nForwarding Mux Inputs");
//        $display("rd1_e=%0d",rv32.rd1_e);
//        $display("result_w=%0d",rv32.result_w);
//        $display("aluresult_m=%0d",rv32.aluresult_m);
        
//        $display("ForwardA=%b",rv32.forward_ae);
//        $display("out_fae=%0d",rv32.out_fae);
        
//        $display("rd2_e=%0d",rv32.rd2_e);
//        $display("ForwardB=%b",rv32.forward_be);
//        $display("out_fbe=%0d",rv32.out_fbe);
        
//        $display("ALUControl=%b",
//                  rv32.alucontrol_e);
        
//        $display("ALUResult=%0d",
//                  rv32.aluresult_e);
//        $display("\nID/EX Register");
//        $display("rd1_e=%0d",rv32.rd1_e);
//        $display("rd2_e=%0d",rv32.rd2_e);
//        $display("immext_e=%0d",rv32.immext_e);
//        $display("a3_e=%0d",rv32.a3_e);
//        $display("\nRegister Write");
//        $display("WE=%b",rv32.regwrite_w);
//        $display("Write Addr=%0d",rv32.a3_w);
//        $display("Write Data=%0d",rv32.result_w);
//        $display("\nControl Signals");
//        $display("ALUSrc=%b",rv32.alusrc_e);
//        $display("ALUControl=%b",rv32.alucontrol_e);
//        $display("ResultSrc=%b",rv32.resultsrc_e);
//        $display("Read Addr1=%0d Data1=%0d",
//                  rv32.rs1_d,
//                  rv32.rd1_d);
        
//        $display("Read Addr2=%0d Data2=%0d",
//                  rv32.rs2_d,
//                  rv32.rd2_d);
        // ---------------- Pipeline ----------------
        $display("IF  : PC=%0d  INSTR=%h",
                  rv32.pc_f,
                  rv32.instr_f);

//        $display("ID  : PC=%0d  INSTR=%h",
//                  rv32.pc_d,
//                  rv32.instr_d);

//        $display("EX  : rd=%0d  ALU=%0d",
//                  rv32.a3_e,
//                  rv32.aluresult_e);

//        $display("MEM : rd=%0d  ALU=%0d",
//                  rv32.a3_m,
//                  rv32.aluresult_m);

//        $display("WB  : rd=%0d  RESULT=%0d",
//                  rv32.a3_w,
//                  rv32.result_w);

//        // ---------------- Decode ----------------
//        $display("\nDecode Stage");
//        $display("rs1=%0d rs2=%0d rd=%0d",
//                  rv32.rs1_d,
//                  rv32.rs2_d,
//                  rv32.a3_d);

//        $display("rd1_d=%0d rd2_d=%0d",
//                  rv32.rd1_d,
//                  rv32.rd2_d);

//        // ---------------- Execute ----------------
//        $display("\nExecute Stage");

//        $display("rs1E=%0d rs2E=%0d rdE=%0d",
//                  rv32.rs1_e,
//                  rv32.rs2_e,
//                  rv32.a3_e);

//        $display("rd1E=%0d rd2E=%0d",
//                  rv32.rd1_e,
//                  rv32.rd2_e);

//        // ---------------- Forwarding ----------------
//        $display("\nForwarding");

//        $display("ForwardA=%b ForwardB=%b",
//                  rv32.forward_ae,
//                  rv32.forward_be);

//        $display("out_fae=%0d out_fbe=%0d",
//                  rv32.out_fae,
//                  rv32.out_fbe);

//        $display("srcb_e=%0d",
//                  rv32.srcb_e);

//        // ---------------- Hazard Inputs ----------------
//        $display("\nHazard Inputs");

//        $display("rs1E=%0d rs2E=%0d",
//                  rv32.rs1_e,
//                  rv32.rs2_e);

//        $display("rdM=%0d RegWriteM=%b",
//                  rv32.a3_m,
//                  rv32.regwrite_m);

//        $display("rdW=%0d RegWriteW=%b",
//                  rv32.a3_w,
//                  rv32.regwrite_w);

//        // ---------------- Register File ----------------
//        $display("\nRegister File");

//        $display("Read Addr1=%0d Data1=%0d",
//                  rv32.instr_d[19:15],
//                  rv32.rd1_d);

//        $display("Read Addr2=%0d Data2=%0d",
//                  rv32.instr_d[24:20],
//                  rv32.rd2_d);

//        $display("Write Addr=%0d Data=%0d WE=%b",
//                  rv32.a3_w,
//                  rv32.result_w,
//                  rv32.regwrite_w);

        $display("========================================================");
        $display("stall_f=%b stall_d=%b flush_e=%b",
                 rv32.stall_f,
                 rv32.stall_d,
                 rv32.flush_e);
        
        $display("PCF=%0d PCD=%0d PCE=%0d",
                 rv32.pc_f,
                 rv32.pc_d,
                 rv32.pc_e);
        
        $display("IF=%h", rv32.instr_f);
        $display("ID=%h", rv32.instr_d);
        $display("EX rd=%0d", rv32.a3_e);
        $display("\nBranch");

        $display("branch_e=%b jump_e=%b",
                  rv32.branch_e,
                  rv32.jump_e);
        
        $display("pcsrc_e=%b",
                  rv32.pcsrc_e);
        
        $display("pctarget=%0d",
                  rv32.pctarget_e);
        $display("\nHazard");

        $display("stall_f=%b stall_d=%b",
                  rv32.stall_f,
                  rv32.stall_d);
        
        $display("flush_d=%b flush_e=%b",
                  rv32.flush_d,
                  rv32.flush_e);
    end
end

initial begin
    pass_cnt=0;
    fail_cnt=0;
    test_cnt=0;
    
    expected();
    
    //reset
    rst=1;
    repeat(3) @(posedge clk);
    #1;
    rst=0;
    
    $display("----------------------------------------------");
    $display("RISCV PIPELINE PROCESSOR TESTBENCH");
    $display("----------------------------------------------");
    
    repeat(15)@(posedge clk);
    #1;
    $display("REGISTER FILE CHECK");
    
    check("x0", rv32.rf.register[0], exp_reg[0]);
    
    check("x1 ", rv32.rf.register[1], exp_reg[1]);
    check("x2 ", rv32.rf.register[2], exp_reg[2]);
    
    check("x3 ", rv32.rf.register[3], exp_reg[3]);
    check("x4 ", rv32.rf.register[4], exp_reg[4]);
    check("x5 ", rv32.rf.register[5], exp_reg[5]);      
//    check("x6 ", rv32.rf.register[6], exp_reg[6]);  
//    check("x7 ", rv32.rf.register[7], exp_reg[7]);  
    //SUMMARY
    $display("----------------------------------------------");
    $display("TEST SUMMARY");
    $display("----------------------------------------------");
    $display("TOTAL TESTS = %0d",test_cnt);
    $display("PASSED COUNT= %0d",pass_cnt);
    $display("FAILED COUNT= %0d",fail_cnt);
    $display("FINAL x5 = %0d", rv32.rf.register[5]);
    if(fail_cnt==0)
    begin
        $display("ALL TESTS PASSED");
    end
    else
    begin
        $display("TEST FAILED");    
    end
    $finish;
end
endmodule