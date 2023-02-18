import my_pkg ::*;
import uvm_pkg ::*;
`include "uvm_macros.svh"

class wr_rd_test extends uvm_test;

  //factory registration
  `uvm_component_utils(wr_rd_test)

  //instants
  my_env my_env_h;

  //new constructor
  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction

  //build_phase
  function void build_phase(uvm_phase phase);
    //creating env object
    my_env_h= my_env :: type_id :: create("my_env_h",this);
    
  endfunction

  task run_phase(uvm_phase phase);
    wr_rd_sequence seq;
    seq = wr_rd_sequence :: type_id :: create("seq");
    phase.raise_objection(this);
    seq.start(my_env_h.my_agent_h.my_sequencer_h);
    #200;
    phase.drop_objection(this);
  endtask
 
endclass
