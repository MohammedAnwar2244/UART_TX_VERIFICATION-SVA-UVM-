package scoreboard;
 `include "uvm_macros.svh"
  import uvm_pkg::*;
  import pack_seq_item::*;  // Using RAM-specific sequence item

  class uart_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(uart_scoreboard)

    // Analysis ports and FIFO
    uvm_analysis_export #(shift_reg_seq_item) sb_export;
    uvm_tlm_analysis_fifo #(shift_reg_seq_item) sb_fifo;
    shift_reg_seq_item seq_item_sb;

 
    // Statistics
    int error_count = 0;
    int correct_count = 0;
    // CONSTRACTOR
    function new(string name = "uart_scoreboard", uvm_component parent = null);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      sb_export = new("sb_export", this);
      sb_fifo   = new("sb_fifo", this);
    endfunction

    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      sb_export.connect(sb_fifo.analysis_export);
    endfunction




    task run_phase(uvm_phase phase);
      super.run_phase(phase);
      forever 
      begin
        sb_fifo.get(seq_item_sb);
        if ((seq_item_sb.TX_OUT != seq_item_sb.TX_OUT_EXP) && (seq_item_sb.Busy != seq_item_sb.Busy_exp)) begin
          `uvm_error("run_phase",$sformatf("compartion failled at referance = %0d and %0d", seq_item_sb.TX_OUT_EXP , seq_item_sb.Busy_exp))
          error_count++;
        end
        else 
        correct_count++;
      end 
    endtask

    function void report_phase(uvm_phase phase);
      super.report_phase(phase);
      `uvm_info("SB_REPORT", 
        $sformatf("\n--- UART_TX Scoreboard Report ---\n" +
                  "Mismatches:       %0d\n" +
                  "Match             %0d\n" +
                  "----------------------------",
                  error_count,
                  correct_count), 
        UVM_LOW)
    endfunction
 endclass
endpackage