module dp_ram  #(parameter ADDR_SIZE=4,parameter DATA_SIZE=32,parameter DEPTH=(2**4)) (clk,rst,rd_addr,data_out,wr_addr,data_in,wr,rd);
  
  input clk;                            // Clock Input
  input rst;	                        // reset
  input wr ;                            // Write Enable
  input rd;                             // read Enable
  input [ADDR_SIZE-1:0] wr_addr;        // address_rd Input
  input [ADDR_SIZE-1:0] rd_addr;        // address_wr Input
  input [DATA_SIZE-1:0] data_in;        // data_wr input
  output reg [DATA_SIZE-1:0] data_out;  // data_rd output
  
  //MEMORY
  reg [DATA_SIZE-1:0] ram [0:DEPTH-1];
  integer i; 
  
  //write logic
  always@(posedge clk)
  begin
   
     if(wr && !rst)
       ram[wr_addr]<=data_in;
  end

  //read logic
  always@(posedge clk)
  begin
      if(rd && !rst)
        data_out<=ram[rd_addr];

  end

  //reset logic
  always@(posedge rst)
  begin
     if(rst)
     begin
       for(i=0;i<DEPTH;i=i+1)
         begin
           ram[i]<=0;
         end
       data_out<=0;
     end
  end

endmodule
