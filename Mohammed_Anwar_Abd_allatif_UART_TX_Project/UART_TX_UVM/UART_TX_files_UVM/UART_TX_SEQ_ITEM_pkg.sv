package pack_seq_item;

import uvm_pkg::*;
`include "uvm_macros.svh"

class shift_reg_seq_item extends uvm_sequence_item;

  // FSM state encoding (for future use or ref)
  parameter IDLE   = 0;
  parameter START  = 1;
  parameter DATA   = 2;
  parameter PARITY = 3;
  parameter STOP   = 4;

  `uvm_object_utils(shift_reg_seq_item)

  // Control signals
  rand logic reset;                     // Active-low reset
  rand logic PAR_EN;                   // 0: disable parity, 1: enable parity
  rand logic PAR_TYP;                  // 0: even, 1: odd
  rand logic DATA_VALID;
  logic clk;

  // Data
  rand logic [7:0] P_DATA;

  // DUT outputs
  logic TX_OUT, TX_OUT_EXP;
  logic Busy, Busy_exp;

  // Constructor
  function new(string name = "shift_reg_seq_item");
    super.new(name);
  endfunction

  ////////////////////////////////////////////////////////////////////////////////////////
  // Constraints - Functional Coverage Related
  ////////////////////////////////////////////////////////////////////////////////////////

  // I- Reset active for ~3% of simulation time
  constraint c_reset_active {
    reset dist {0 := 3, 1 := 97}; // Active-low reset
  }

  // II- PAR_TYP toggle: 50% even, 50% odd
  constraint c_par_typ_toggle {
    PAR_TYP dist {0 := 50, 1 := 50};
  }

  // III- PAR_EN enabled 25% of time
  constraint c_par_en {
    PAR_EN dist {1 := 25, 0 := 75};
  }

  // IV- DATA_VALID active most of simulation time
  constraint c_data_valid {
    DATA_VALID dist {1 := 85, 0 := 15};
  }

  // V- P_DATA specs:
  // a. LSB = 1 in 80% of cases
  constraint c_lsb_one {
    (P_DATA[0] == 1) dist {1 := 80, 0 := 20};
  }

  // b. Specific patterns (11111111, 00000000, 10101010) appear 4% of time
  constraint c_specific_patterns {
    P_DATA dist {
      8'b11111111 := 1,
      8'b00000000 := 1,
      8'b10101010 := 1,
      [8'b00000001:8'b11111110] := 96
    };
  }

  ////////////////////////////////////////////////////////////////////////////////////////
  // Utility methods
  ////////////////////////////////////////////////////////////////////////////////////////

  function string convert2string();
    return $sformatf(" %s :reset=%0b, PAR_EN=%0b, PAR_TYP=%0b, DATA_VALID=%0b, P_DATA=0x%0h, TX_OUT=%0b, Busy=%0b , TX_OUT_EXP=%0b , Busy_exp=%0b ",
      super.convert2string() ,reset, PAR_EN, PAR_TYP, DATA_VALID, P_DATA, TX_OUT, Busy , TX_OUT_EXP , Busy_exp );
  endfunction

  function string convert2string_stimulus();
    return $sformatf("%s reset=%0b, PAR_EN=%0b, PAR_TYP=%0b, DATA_VALID=%0b, P_DATA=%0h",
      super.convert2string(),  reset, PAR_EN, PAR_TYP, DATA_VALID, P_DATA);
  endfunction

endclass

endpackage
