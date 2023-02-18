class my_scoreboard extends uvm_scoreboard;
  
  //factory reg.
  `uvm_component_utils(my_scoreboard);

  //memory
  reg [31:0] mem_expected [0:15];
  bit temp;
  //interface
  virtual intf vif;

  //analysis port
  uvm_analysis_imp#(trans, my_scoreboard) analysis_export;

  //new constructor
  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction

  //build_phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    analysis_export = new("analysis_export",this);
    if(!uvm_config_db#(virtual intf)::get(this, "", "dut_vi", vif))
       `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});

  endfunction

  //write method
  virtual function void write(trans tx);
  //  tx.print();
    scb_compare(tx);
  endfunction

 
  //scb_compare
  function void scb_compare(trans tx);
       if(vif.rst)
        begin
          foreach(mem_expected[i])
	  begin     
	    mem_expected[i] = 0;
	  end 
          tx.data_out =0;
        end
       else begin
	         
	 if(tx.rd && !vif.rst) 
	 begin
	     if(mem_expected[tx.rd_addr] === tx.data_out) 
	     begin
               `uvm_info(get_type_name(),$sformatf("------ :: READ DATA Match :: ------"),UVM_LOW)
               `uvm_info(get_type_name(),$sformatf("Addr: %0h",tx.rd_addr),UVM_LOW)
               `uvm_info(get_type_name(),$sformatf("Expected Data: %0h Actual Data: %0h",mem_expected[tx.rd_addr],tx.data_out),UVM_LOW)
               `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
             end
             
	     else
	     begin
               `uvm_error(get_type_name(),"------ :: READ DATA MisMatch :: ------")
               `uvm_info(get_type_name(),$sformatf("Addr: %0h",tx.rd_addr),UVM_LOW)
               `uvm_info(get_type_name(),$sformatf("Expected Data: %0h Actual Data: %0h",mem_expected[tx.rd_addr],tx.data_out),UVM_LOW)
               `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
             end
	 end
	 if(tx.wr && !vif.rst) 
	 begin
            mem_expected[tx.wr_addr] = tx.data_in;
           `uvm_info(get_type_name(),$sformatf("------ :: WRITE DATA       :: ------"),UVM_LOW)
           `uvm_info(get_type_name(),$sformatf("Addr: %0h",tx.wr_addr),UVM_LOW)
           `uvm_info(get_type_name(),$sformatf("Data: %0h",tx.data_in),UVM_LOW)
           `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)        
         end
       end
  endfunction : scb_compare

  //run_phase
  task run_phase(uvm_phase phase);
    forever begin
    @(vif.rst);
      if(vif.rst)
        begin
          foreach(mem_expected[i])
	  begin     
	    mem_expected[i] = 0;
	  end 
        end
    end
  endtask:run_phase

endclass : my_scoreboard
