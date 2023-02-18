class my_sequence extends uvm_sequence #(trans);
  
  //factory_registration
  `uvm_object_utils(my_sequence);
  
   //default_constructor_override
  function new (string name = "my_sequence");
    super.new(name);
  endfunction
  
  //body_task
  virtual task body();
    repeat(200) begin
     //trans_handle
      trans trans_h;
      trans_h = trans::type_id::create("trans_h");
      start_item(trans_h);
      assert(trans_h.randomize());
      finish_item(trans_h);
    end
  endtask
  
endclass : my_sequence

class rd_sequence extends uvm_sequence #(trans);
  
  //factory_registration
  `uvm_object_utils(rd_sequence);
  
  //data
  bit [3:0] d;

   //default_constructor_override
  function new (string name = "rd_sequence");
    super.new(name);
  endfunction
  
  //body_task
  virtual task body();
    repeat(20) begin
     //trans_handle
      trans trans_h;
      trans_h = trans::type_id::create("trans_h");
      start_item(trans_h);
      assert(trans_h.randomize() with {wr==0;rd==1;rd_addr==d;}) ;
      d++;
      finish_item(trans_h);
    end
  endtask
  
endclass : rd_sequence

class wr_sequence extends uvm_sequence #(trans);
  
  //factory_registration
  `uvm_object_utils(wr_sequence);
  
  //data
  bit [3:0] d;

   //default_constructor_override
  function new (string name = "wr_sequence");
    super.new(name);
  endfunction
  
  //body_task
  virtual task body();
    repeat(20) begin
     //trans_handle
      trans trans_h;
      trans_h = trans::type_id::create("trans_h");
      start_item(trans_h);
      void'(trans_h.randomize() with {wr==1;rd==0;wr_addr==d;} );
      d++;
      finish_item(trans_h);
    end
  endtask
  
endclass : wr_sequence

class wr_rd_sequence extends uvm_sequence #(trans);
  
  //factory_registration
  `uvm_object_utils(wr_rd_sequence);
  
  //default_constructor_override
  function new (string name = "wr_rd_sequence");
    super.new(name);
  endfunction
  
  //sequences
  wr_sequence wr_seq;
  rd_sequence rd_seq;

  //body_task
  virtual task body();
     begin
      wr_seq = wr_sequence :: type_id :: create("wr_seq");
      rd_seq = rd_sequence :: type_id :: create("rd_seq");
      wr_seq.start(m_sequencer,this);
      rd_seq.start(m_sequencer,this);
    end
  endtask
  
endclass : wr_rd_sequence

class wr_rd_walking_1 extends uvm_sequence #(trans);
  
  //factory_registration
  `uvm_object_utils(wr_rd_walking_1);
  
  //data
  bit [3:0] d;
  bit [31:0] data=1;

  //read sequence
  rd_sequence rd_seq;

  //default_constructor_override
  function new (string name = "wr_rd_walking_1");
    super.new(name);
  endfunction
  
  //body_task
  virtual task body();

    //write opertion
    repeat(20) begin
     //trans_handle
      trans trans_h;
      trans_h = trans::type_id::create("trans_h");
      start_item(trans_h);
      void'(trans_h.randomize() with {wr==1;rd==0;wr_addr==d;data_in==data;} );
      d++;
      data= data << 1;
      finish_item(trans_h);
    end

    //read operation
    rd_seq = rd_sequence :: type_id :: create("rd_seq");
    rd_seq.start(m_sequencer,this);

  endtask

endclass :wr_rd_walking_1

class wr_rd_walking_0 extends uvm_sequence #(trans);
  
  //factory_registration
  `uvm_object_utils(wr_rd_walking_0);
  
  //data
  bit [3:0] d;
  bit [31:0] data='hfffffffe;
  
  //read sequence
  rd_sequence rd_seq;

  //default_constructor_override
  function new (string name = "wr_rd_walking_0");
    super.new(name);
  endfunction
  
  //body_task
  virtual task body();

    //write opertion
    repeat(20) begin
     //trans_handle
      trans trans_h;
      trans_h = trans::type_id::create("trans_h");
      start_item(trans_h);
      void'(trans_h.randomize() with {wr==1;rd==0;wr_addr==d;data_in==data;} );
      d++;
      data= data << 1;
      if(data[0] == 0)
        data[0] =1;
      finish_item(trans_h);
    end

    //read operation
    rd_seq = rd_sequence :: type_id :: create("rd_seq");
    rd_seq.start(m_sequencer,this);

  endtask

endclass :wr_rd_walking_0

class wr_rd_toggle_data_in extends uvm_sequence #(trans);
  
  //factory_registration
  `uvm_object_utils(wr_rd_toggle_data_in);
  
  //data
  bit [3:0] d;
  bit [31:0] data = 'h5555_5555;

  //read sequence
  rd_sequence rd_seq;

  //default_constructor_override
  function new (string name = "wr_rd_toggle_datain_sequence");
    super.new(name);
  endfunction
  
  //body_task
  virtual task body();

    //write opertion
    repeat(20) begin
     //trans_handle
      trans trans_h;
      trans_h = trans::type_id::create("trans_h");
      start_item(trans_h);
      void'(trans_h.randomize() with {wr==1;rd==0;wr_addr==d;data_in==data;} );
      d++;
      data=~data;
      finish_item(trans_h);
    end

    //read operation
    rd_seq = rd_sequence :: type_id :: create("rd_seq");
    rd_seq.start(m_sequencer,this);

  endtask

endclass :wr_rd_toggle_data_in

class wr_rd_sameloc extends uvm_sequence #(trans);
  
  //factory_registration
  `uvm_object_utils(wr_rd_sameloc);
  
  //default_constructor_override
  function new (string name = "wr_rd_sameloc");
    super.new(name);
  endfunction
  
  //data
  rd_sequence rd_seq;
  bit [3:0] d;

  //body_task
  virtual task body();
     begin
       //trans_handle
       trans trans_h;
       trans_h = trans::type_id::create("trans_h");
       rd_seq = rd_sequence :: type_id ::create("rd_seq");
       repeat(20)
       begin
       start_item(trans_h);
       void'(trans_h.randomize() with {wr==1;rd==1;wr_addr==d;rd_addr==d;});
       d++;
       finish_item(trans_h);
       end
       rd_seq.start(m_sequencer,this);
    end
  endtask
  
endclass : wr_rd_sameloc
