package pack_coverage;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import pack_seq_item::*;

  class uart_coverage extends uvm_component;
    `uvm_component_utils(uart_coverage)

    uvm_analysis_export #(shift_reg_seq_item) cov_export;
    uvm_tlm_analysis_fifo #(shift_reg_seq_item) cov_fifo;
    shift_reg_seq_item seq_item_cov;

    localparam int MEM_DEPTH = 256;
    localparam int ADDR_SIZE = $clog2(MEM_DEPTH);
    localparam int MEM_WIDTH = 8;

   covergroup UART_CG;

  cp_PAR_EN   : coverpoint seq_item_cov.PAR_EN;
  cp_PAR_TYPE : coverpoint seq_item_cov.PAR_TYP;
  cp_P_VALID  : coverpoint seq_item_cov.DATA_VALID;
  cp_P_DATA   : coverpoint seq_item_cov.P_DATA {
    bins low_vals[] = {[0:7]}; // smaller set
    ignore_bins u = {[8:255]};
  }

  // Cross coverpoints
  cross_PAR_EN_PAR_TYPE : cross cp_PAR_EN, cp_PAR_TYPE {
    ignore_bins invalid = binsof(cp_PAR_EN) intersect {0} &&
                          binsof(cp_PAR_TYPE) intersect {1};
  }

  cross_P_DATA_P_VALID  : cross cp_P_DATA, cp_P_VALID;
  cross_TX_OUT_BUSY     : cross seq_item_cov.TX_OUT, seq_item_cov.Busy;

endgroup




  function new(string name = " uart_coverage", uvm_component parent = null);
      super.new(name, parent);
      UART_CG= new;
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      cov_export = new("cov_export", this);
      cov_fifo = new("cov_fifo", this);
    endfunction

    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      cov_export.connect(cov_fifo.analysis_export);
    endfunction

    task run_phase(uvm_phase phase);
      super.run_phase(phase);
      forever begin
        cov_fifo.get(seq_item_cov);
        UART_CG.sample();
      end
    endtask

  endclass
endpackage
