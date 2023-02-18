class trans extends uvm_sequence_item;
  
  //all_signals
  rand bit wr;
  rand bit rd;
  randc bit [3:0] wr_addr;
  randc bit [3:0] rd_addr;
  randc bit [31:0] data_in;
  reg [31:0] data_out;

  
  //factory_registration
  `uvm_object_utils_begin(trans);
    `uvm_field_int(wr, UVM_ALL_ON);
    `uvm_field_int(rd, UVM_ALL_ON);
    `uvm_field_int(wr_addr, UVM_ALL_ON);
    `uvm_field_int(rd_addr,UVM_ALL_ON);
    `uvm_field_int(data_in,UVM_ALL_ON);
  `uvm_object_utils_end
  
  //default_constructor_override
  function new (string name = "trans");
    super.new(name);
  endfunction
  
endclass : trans

