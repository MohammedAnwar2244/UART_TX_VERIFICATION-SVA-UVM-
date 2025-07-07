package UART_TX_pkg;
    
    class uart_tx_pkg;

// FSM state encoding (for future use or ref)
  parameter IDLE   = 0;
  parameter START  = 1;
  parameter DATA   = 2;
  parameter PARITY = 3;
  parameter STOP   = 4;



  // Control signals
  rand logic reset;                     // Active-low reset
  rand logic PAR_EN;                   // 0: disable parity, 1: enable parity
  rand logic PAR_TYP;                  // 0: even, 1: odd
  rand logic DATA_VALID;
  logic clk;

  // Data
  rand logic [7:0] P_DATA;

  // DUT outputs
  logic TX_OUT;
  logic Busy;

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
  covergroup uart_cg ;

  RST_cp : coverpoint reset { 
    bins zero = {0} ;
    bins one = {1} ;
  }
  PAR_TYP_cp : coverpoint PAR_TYP { 
    bins zero = {0} ;
    bins one = {1} ;
  }
  PAR_EN_cp : coverpoint PAR_EN { 
    bins zero = {0} ;
    bins one = {1} ;
  }
  P_DATA_cp : coverpoint P_DATA {
    bins all_values = {[0:255]};
  } 
  DATA_VALID_cp : coverpoint DATA_VALID { 
    bins zero = {0} ;
    bins one = {1} ;
  }
  TX_OUT_cp : coverpoint TX_OUT {
    bins zero = {0} ;
    bins one = {1} ;
  }
  Busy_cp : coverpoint Busy {
    bins zero = {0} ;
    bins one = {1} ;
  }

  PAR_EN_cross_TYPE : cross PAR_EN_cp , PAR_TYP_cp ;
  P_DATA_cross_DATA_VALID : cross P_DATA_cp , DATA_VALID_cp ;
  TX_OUT_cross_Busy : cross TX_OUT_cp , Busy_cp ;

  endgroup

function new();
    uart_cg = new();
    
endfunction
    
            
        
    endclass 
endpackage