`define MON_IF vif.mon_cb

class my_monitor extends uvm_monitor;
  
  //factory reg
  `uvm_component_utils(my_monitor)

  //analysis port
  uvm_analysis_port #(trans) aport;

  //interface
  virtual intf vif;

  //new constructor
  function new (string name,uvm_component parent);
    super.new(name,parent);
  endfunction

  //build_phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    aport=new("aport",this);
    if(!uvm_config_db#(virtual intf)::get(this, "", "dut_vi", vif))
       `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
  endfunction

  //run_phase
  task run_phase(uvm_phase phase);
    forever begin
      trans tx;
  
      @(`MON_IF);    
      tx= trans :: type_id :: create ("tx");
     
      tx.wr=`MON_IF.wr;
      tx.rd=`MON_IF.rd;
      if (`MON_IF.wr)
      begin
        tx.wr_addr = `MON_IF.addr_wr;
	tx.data_in = `MON_IF.data_wr;
      end
      if(`MON_IF.rd)
      begin
        tx.rd_addr = `MON_IF.addr_rd;
	@(`MON_IF);
	tx.data_out = `MON_IF.data_rd;
      end
      aport.write(tx);
    end
  endtask

endclass
