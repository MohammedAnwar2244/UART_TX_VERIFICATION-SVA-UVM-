package pack_seqs;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import pack_seq_item::*;

  /////////////////////////////////////////////////////////////////////////////
  // Sequence 1: Reset Sequence (active-low)
  /////////////////////////////////////////////////////////////////////////////
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
      seq_item.P_DATA = 8'b0;
      seq_item.PAR_EN = 0;
      seq_item.PAR_TYP = 0;
      finish_item(seq_item);
    endtask
  endclass

  /////////////////////////////////////////////////////////////////////////////
  // Sequence 2: Send data with parity disabled
  /////////////////////////////////////////////////////////////////////////////
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

  /////////////////////////////////////////////////////////////////////////////
  // Sequence 3: Send data with parity enabled (even or odd)
  /////////////////////////////////////////////////////////////////////////////
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

  /////////////////////////////////////////////////////////////////////////////
  // Sequence 4: Send random legal stimulus (fully randomized)
  /////////////////////////////////////////////////////////////////////////////
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
        assert(seq_item.randomize() with {
          DATA_VALID == 1'b0;
        });
        finish_item(seq_item);
      end
    endtask
  endclass

  /////////////////////////////////////////////////////////////////////////////
  // Sequence 5: Coverage-oriented sequence
  /////////////////////////////////////////////////////////////////////////////
  class uart_tx_coverage_sequence extends uvm_sequence #(shift_reg_seq_item);
    `uvm_object_utils(uart_tx_coverage_sequence)
    shift_reg_seq_item seq_item;

    function new(string name = "uart_tx_coverage_sequence");
      super.new(name);
    endfunction

    task body();
      int data_val;
      int valid;
      int par_typ;

      // Test all data values from 0 to 7 with DATA_VALID = 0 and 1, PAR_EN = 0
      for (data_val = 0; data_val <= 7; data_val++) begin
        for (valid = 0; valid <= 1; valid++) begin
          seq_item = shift_reg_seq_item::type_id::create("seq_item");
          start_item(seq_item);
          seq_item.reset       = 1;
          seq_item.DATA_VALID  = valid;
          seq_item.PAR_EN      = 0;
          seq_item.PAR_TYP     = 0;
          seq_item.P_DATA      = data_val;
          finish_item(seq_item);
        end
      end

      // Check both parity types with PAR_EN = 1
      for (par_typ = 0; par_typ <= 1; par_typ++) begin
        seq_item = shift_reg_seq_item::type_id::create("seq_item");
        start_item(seq_item);
        seq_item.reset       = 1;
        seq_item.DATA_VALID  = 1;
        seq_item.PAR_EN      = 1;
        seq_item.PAR_TYP     = par_typ;
        seq_item.P_DATA      = 5;
        finish_item(seq_item);
      end

      // Generate additional randomized valid stimuli for coverage
      repeat (200) begin
        seq_item = shift_reg_seq_item::type_id::create("seq_item");
        start_item(seq_item);
        assert(seq_item.randomize() with {
          P_DATA inside {[0:7]};
          DATA_VALID == 1;
          PAR_EN inside {0,1};
          PAR_TYP inside {0,1};
        });
        finish_item(seq_item);
      end
    endtask
  endclass

endpackage
