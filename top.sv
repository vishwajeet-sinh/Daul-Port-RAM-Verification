`include "pkg.sv"
`include "test.sv"
`include "interface.sv"
`include "dut.v"
`include "test1.sv"
`include "test2.sv"
`include "test3.sv"
`include "test4.sv"
`include "test6.sv"
`include "test5.sv"
`include "test8.sv"
`include "test9.sv"
`include "test10.sv"
module top;

  //package import
  import uvm_pkg::*;
  import my_pkg ::*;

  //data
  bit clk;
  bit rst;

  //clock
  always #5 clk=~clk;

  //reset
  initial begin
    rst=0;
    #6 rst=1;
    #2 rst=0;
  end

  //interface instance
  intf   #(.ADDR_SIZE(4),.DATA_SIZE(32),.DEPTH(2**4)) ifn(clk,rst);
 
  //dut instance
  dp_ram   #(.ADDR_SIZE(4),.DATA_SIZE(32),.DEPTH(2**4)) DUV (.clk(ifn.clk),.rst(ifn.rst),.rd_addr(ifn.addr_rd),.data_out(ifn.data_rd),.wr_addr(ifn.addr_wr),.data_in(ifn.data_wr),.wr(ifn.wr),.rd(ifn.rd));
  
  //operation 
  initial begin  
    
    //set_inf_in_uvm_config_db
    uvm_config_db #(virtual intf)::set(uvm_root::get(),"*","dut_vi",ifn);
    
    //enable wave dump
    $dumpfile("dump.vcd"); 
    $dumpvars;
    
    //run_test_method 
   run_test();
    /*run_test("wr_rd_test");
    run_test("wr_rd_rst_test");
    run_test("wr_rd_sameloc_test");
    run_test("wr_rd_randrst_test");
    run_test("wr_rd_alter_test");
    run_test("random_test");
    run_test("wr_rd_toggle_datain_test");
    run_test("wr_rd_walking_1_test");
    run_test("wr_rd_walking_0_test");
*/
  end

endmodule
   
