interface intf #( ADDR_SIZE=4,DATA_SIZE=32,DEPTH=(2**4))(input logic clk,rst);
 
  //signals
  logic wr,rd;
  logic [ADDR_SIZE-1:0] addr_wr,addr_rd;
  logic [DATA_SIZE-1:0] data_wr,data_rd;

  //clocking block for driver
  clocking drv_cb @(posedge clk);
    //default skew
    default input #1 output #1;
    output addr_wr,addr_rd,data_wr,wr,rd;
    input data_rd;
  endclocking


  //clocking block for monitor
  clocking mon_cb @(posedge clk);
    //default skew
    default input #1 output #1;
    input addr_wr,addr_rd,data_wr,wr,rd,data_rd;
  endclocking

  //modport for driver
  modport DRIVER(clocking drv_cb,input clk,rst);

  //modport for monitor
  modport MONITOR(clocking mon_cb,input clk,rst);
endinterface
