`define DRV_IF vif.drv_cb
class my_driver extends uvm_driver #(trans);

  //data
  int trans_cnt;

  //factory_reg
  `uvm_component_utils (my_driver);

  //virtual interface
  virtual intf vif;
 
  //new constructor
  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction

  //build_phase
  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual intf)::get(this, "", "dut_vi",vif))
       `uvm_fatal("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
  endfunction

  //run_phase
  task run_phase (uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(req);
      drive();
      seq_item_port.item_done();
    end
  endtask
  
  //drive
  virtual task drive();
    
    @(`DRV_IF);
    `DRV_IF.wr <= req.wr;
    `DRV_IF.rd <= req.rd;
    if(req.wr)
      begin
        `DRV_IF.addr_wr <= req.wr_addr;
        `DRV_IF.data_wr <= req.data_in;
        $display("%0t: DRIVER write operation",$time);
	$display("-----------------------------------------");
      end
      
    if(req.rd)
      begin
        `DRV_IF.addr_rd <= req.rd_addr;
        $display("%0t: DRIVER read operation",$time);
	@(`DRV_IF);
      end
      
      $display("%0t:DRIVER ended with transaction id:%0d",$time,trans_cnt);
      $display("------------------------------------------");
    trans_cnt++;
   endtask : drive
endclass
