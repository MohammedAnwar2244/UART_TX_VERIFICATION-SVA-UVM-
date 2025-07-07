package pack_agent;
  `include "uvm_macros.svh"
  import uvm_pkg::*; 
  import pack_driver::*;  
  import pack_sequencer::*; 
  import pack_seq_item::*; 
  import pack_mon::*; 
  import pack_config::*; 
  import pack_seqs::*;

  class uart_agent extends uvm_agent; 
    `uvm_component_utils(uart_agent); 

    uart_config uart_config_obj_driver;   // ✅ Correct type
    uart_driver uart_dr; 
    uart_sequencer sqr; 
    uart_monitor mon; 
    uvm_analysis_port #(shift_reg_seq_item) agt_ap; 

    function new(string name = "uart_agent", uvm_component parent = null); // updated name
      super.new(name, parent); 
    endfunction

    function void build_phase(uvm_phase phase); 
      super.build_phase(phase); 
      
      if (!uvm_config_db #(uart_config)::get(this, "", "CGO", uart_config_obj_driver)) begin 
        `uvm_fatal("build_phase", "DRIVER − unable to get the virtual interface"); 
      end  

      uart_dr = uart_driver::type_id::create("uart_dr", this); 
      sqr = uart_sequencer::type_id::create("sqr", this);   
      mon = uart_monitor::type_id::create("mon", this); 
      agt_ap = new("agt_ap", this); 
    endfunction

    function void connect_phase(uvm_phase phase); 
      super.connect_phase(phase); 

     
        uart_dr.seq_item_port.connect(sqr.seq_item_export); 
        uart_dr.sh_vif = uart_config_obj_driver.uart_vif; 
      

      mon.sh_vif = uart_config_obj_driver.uart_vif; 
      mon.mon_ap.connect(agt_ap); 
    endfunction 
  endclass
endpackage
