package pack_test;
import pack_env::*;
import pack_config::*;
import pack_seqs::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class test extends uvm_test;
  `uvm_component_utils(test);

  virtual uart_tx_if uart_vif;
  uart_config uart_cfg;
  uart_env env;
  uart_reset_sequence                   seq_one;
  uart_tx_noparity_sequence             seq_two;
  uart_tx_parity_sequence               seq_three;
  uart_tx_random_sequence               seq_four;
  uart_tx_coverage_sequence             seq_five;
  

  // Constructor
  function new(string name="test", uvm_component parent = null);
    super.new(name, parent);
  endfunction 

  // Build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    uart_cfg = uart_config::type_id::create("uart_cfg");
    env     = uart_env::type_id::create("env", this);
    seq_one = uart_reset_sequence::type_id::create("seq_one");
    seq_two = uart_tx_noparity_sequence::type_id::create("seq_two");
    seq_three = uart_tx_parity_sequence::type_id::create("seq_three");
    seq_four = uart_tx_random_sequence::type_id::create("seq_four");
    seq_five = uart_tx_coverage_sequence::type_id::create("seq_five");
       

    uvm_config_db#(uart_config)::set(this, "*", "CGO", uart_cfg);

    if (!uvm_config_db#(virtual uart_tx_if)::get(this , "" , "UART_LL" , uart_cfg.uart_vif)) begin
      `uvm_fatal("build_phase" , "Unable to get virtual interface")
    end 
  endfunction

  // Run phase
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);

    `uvm_info("run_phase", "Reset sequence started", UVM_LOW);
    seq_one.start(env.agt.sqr);
    `uvm_info("run_phase", "Reset sequence finished", UVM_LOW);

    `uvm_info("run_phase", "noparity_sequence  started", UVM_LOW);
    seq_two.start(env.agt.sqr);
    `uvm_info("run_phase", "noparity_sequence  finished", UVM_LOW);

    `uvm_info("run_phase", "tx_parity_sequence  started", UVM_LOW);
    seq_three.start(env.agt.sqr);
    `uvm_info("run_phase", "tx_parity_sequence  finished", UVM_LOW);

    
    `uvm_info("run_phase", "Random  sequence started", UVM_LOW);
    seq_four.start(env.agt.sqr);
    `uvm_info("run_phase", "Random  sequence finished", UVM_LOW);

    
    `uvm_info("run_phase", "Random  sequence started", UVM_LOW);
    seq_five.start(env.agt.sqr);
    `uvm_info("run_phase", "Random  sequence finished", UVM_LOW);


    



    phase.drop_objection(this);
  endtask

endclass
endpackage 