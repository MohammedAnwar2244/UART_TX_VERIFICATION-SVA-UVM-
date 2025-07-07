package pack_sequencer;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import pack_seq_item::*;

  class uart_sequencer extends uvm_sequencer #(shift_reg_seq_item);// calss name of seq_item
    `uvm_component_utils(uart_sequencer);

    function new(string name = "uart_sequencer", uvm_component parent = null);
      super.new(name, parent);
    endfunction
  endclass
endpackage
