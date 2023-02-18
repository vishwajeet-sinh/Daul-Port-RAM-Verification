class my_sequencer extends uvm_sequencer #(trans);

  //factory regt
  `uvm_component_utils(my_sequencer);

  //new constructor
  function new (string name,uvm_component parent);
    super.new(name,parent);
  endfunction

endclass

