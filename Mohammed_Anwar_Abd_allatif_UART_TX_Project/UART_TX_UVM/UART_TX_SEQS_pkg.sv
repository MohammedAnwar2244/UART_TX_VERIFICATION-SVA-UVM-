package pack_seqs;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import pack_seq_item::*;

  ////////////////////////////////////////////////////////////////////////////////
  // Sequence 1: Reset Sequence (active-low)
  ////////////////////////////////////////////////////////////////////////////////
  class uart_reset_sequence extends uvm_sequence #(shift_reg_seq_item);
    `uvm_object_utils(uart_reset_sequence)
    shift_reg_seq_item seq_item;

    function new(string name = "uart_reset_sequence");
      super.new(name);
    endfunction

    task body();
      seq_item = shift_reg_seq_item::type_id::create("seq_item");
      start_item(seq_item);
      seq_item.reset = 0; // active-low
      finish_item(seq_item);
    endtask
  endclass

  ////////////////////////////////////////////////////////////////////////////////
  // Sequence 2: Send data with parity disabled
  ////////////////////////////////////////////////////////////////////////////////
  class uart_tx_noparity_sequence extends uvm_sequence #(shift_reg_seq_item);
    `uvm_object_utils(uart_tx_noparity_sequence)
    shift_reg_seq_item seq_item;

    function new(string name = "uart_tx_noparity_sequence");
      super.new(name);
    endfunction

    task body();
      seq_item = shift_reg_seq_item::type_id::create("seq_item");
      start_item(seq_item);
      seq_item.reset       = 1;
      seq_item.DATA_VALID  = 1;
      seq_item.PAR_EN      = 0;
      seq_item.PAR_TYP     = 0;
      seq_item.P_DATA      = 8'hA5; 
      finish_item(seq_item);
    endtask
  endclass

  ////////////////////////////////////////////////////////////////////////////////
  // Sequence 3: Send data with parity enabled (even or odd)
  ////////////////////////////////////////////////////////////////////////////////
  class uart_tx_parity_sequence extends uvm_sequence #(shift_reg_seq_item);
    `uvm_object_utils(uart_tx_parity_sequence)
    shift_reg_seq_item seq_item;

    function new(string name = "uart_tx_parity_sequence");
      super.new(name);
    endfunction

    task body();
      seq_item = shift_reg_seq_item::type_id::create("seq_item");
      start_item(seq_item);
      seq_item.reset       = 1;
      seq_item.DATA_VALID  = 1;
      seq_item.PAR_EN      = 1;
      seq_item.PAR_TYP     = $urandom_range(0,1); // even or odd
      seq_item.P_DATA      = 8'h3C;
      finish_item(seq_item);
    endtask
  endclass

  ////////////////////////////////////////////////////////////////////////////////
  // Sequence 4: Send random legal stimulus (fully randomized)
  ////////////////////////////////////////////////////////////////////////////////
  class uart_tx_random_sequence extends uvm_sequence #(shift_reg_seq_item);
    `uvm_object_utils(uart_tx_random_sequence)
    shift_reg_seq_item seq_item;

    function new(string name = "uart_tx_random_sequence");
      super.new(name);
    endfunction

    task body();
      repeat (999) begin
        seq_item = shift_reg_seq_item::type_id::create("seq_item");
        start_item(seq_item);
        assert(seq_item.randomize());
        finish_item(seq_item);
      end
    endtask
  endclass

endpackage
