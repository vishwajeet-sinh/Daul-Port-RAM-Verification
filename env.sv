  `include "scoreboard.sv"
  `include "coverage.sv"
class my_env extends uvm_env;
  
  //factory registration
  `uvm_component_utils(my_env)

  //handles
  my_agent        my_agent_h;
  my_scoreboard   my_scoreboard_h;
  my_coverage        my_conv_h;
  //new constructor
  function new (string name,uvm_component parent);
    super.new(name,parent);
  endfunction

  //build_phase
  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    my_agent_h        = my_agent        :: type_id  ::  create("my_agent_h",this);
    my_scoreboard_h   = my_scoreboard   :: type_id  ::  create("my_scoreboard_h",this);
    my_conv_h         = my_coverage     :: type_id  ::  create("my_conv_h",this);
  endfunction

  //connect_phase
  function void connect_phase(uvm_phase phase);
    my_agent_h.my_monitor_h.aport.connect(my_conv_h.analysis_export);
    my_agent_h.my_monitor_h.aport.connect(my_scoreboard_h.analysis_export);
   endfunction

endclass


