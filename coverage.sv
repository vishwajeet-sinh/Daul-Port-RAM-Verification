class my_coverage extends uvm_agent;

  //factory reg.
  `uvm_component_utils(my_coverage);
  
  //analysis port
  uvm_analysis_imp#(trans, my_coverage) analysis_export;

  //transaction instance
   trans tr;
  
  //covergroup for write
  covergroup cov_ram ;
    
    wr_addr:            coverpoint tr.wr_addr iff (tr.wr);
    rd_addr:            coverpoint tr.rd_addr iff  (tr.rd == 1);
    toggle_data_in:     coverpoint tr.data_in iff (tr.wr == 1)
                          {bins  datain_togl = ('h5555_5555 => 'haaaa_aaaa), ('haaaa_aaaa => 'h5555_5555);}

    toggle_data_out:    coverpoint tr.data_out iff (tr.rd == 1)
                          {bins  dataout_togl = ('h5555_5555 => 'haaaa_aaaa), ('haaaa_aaaa => 'h5555_5555);}
    
    walking_1_data_in:  coverpoint $clog2(tr.data_in) iff ($onehot(tr.data_in) && tr.wr==1)
                          {bins  datain_walking_1[]  = {[0:15]}; }
    walking_1_data_out: coverpoint $clog2(tr.data_out) iff ($onehot (tr.data_out) && tr.rd==1)
                          {bins  dataout_walking_1[] = {[0:15]}; }
    
    walking_0_data_in:  coverpoint $clog2(~tr.data_in)  iff ($onehot (~tr.data_in) && tr.wr==1)
                          {bins  datain_walking_0[]  = {[0:15]}; }
    walking_0_data_out: coverpoint $clog2(~tr.data_out) iff ($onehot (~tr.data_out)&& tr.rd==1)
                          {bins  dataout_walking_0[] = {[0:15]}; }
    random_data_in:     coverpoint tr.data_in iff (tr.wr ==1)
                          {option.auto_bin_max = 5; }
    random_data_out:    coverpoint tr.data_out iff (tr.rd ==1)
                          {option.auto_bin_max = 5; }
    rst            :    coverpoint tr.data_out iff (tr.rd ==1)
                          {bins zero ={0};}
    power_of_2_data_in: coverpoint ($clog2(tr.data_in + { {15{1'b0}}, 1'b1 }) - 1) iff (tr.data_in!= 0 && tr.wr==1)
                          {bins datain_power_2[] = { [0:15] }; }
    power_of_2_data_out:coverpoint ($clog2(tr.data_out + { {15{1'b0}}, 1'b1 }) - 1) iff (tr.data_out!= 0 && tr.rd==1)
                          {bins dataout_power_2[] = { [0:15] }; }
    same_addr          :coverpoint tr.rd_addr iff ((tr.wr_addr == tr.rd_addr) && tr.rd==1);
                          
  endgroup
 
  //new constructor
  function new (string name,uvm_component parent);
    super.new(name,parent);
    cov_ram=new();
    tr= new();
  endfunction

  //build_phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    analysis_export = new("analysis_export",this);
  endfunction
 
  //write method
  virtual function void write(trans tr);
    this.tr=tr;
   // tr.print();
    cov_ram.sample();
  endfunction

endclass
