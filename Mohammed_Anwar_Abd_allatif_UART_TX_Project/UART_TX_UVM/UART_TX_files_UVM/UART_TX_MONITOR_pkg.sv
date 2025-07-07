package pack_mon;

  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import pack_seq_item::*;

  class uart_monitor extends uvm_monitor;
    `uvm_component_utils(uart_monitor)

    virtual uart_tx_if sh_vif;
    shift_reg_seq_item rsp_seq_item;
    uvm_analysis_port #(shift_reg_seq_item) mon_ap;

    function new(string name = "uart_monitor", uvm_component parent = null);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      mon_ap = new("mon_ap", this);
    endfunction

    task run_phase(uvm_phase phase);
      super.run_phase(phase);
      forever begin
        rsp_seq_item = shift_reg_seq_item::type_id::create("rsp_seq_item");

        @(negedge sh_vif.clk);

        rsp_seq_item.reset   = sh_vif.reset;
        rsp_seq_item.PAR_TYP = sh_vif.PAR_TYP;
        rsp_seq_item.PAR_EN = sh_vif.PAR_EN;
        rsp_seq_item.DATA_VALID   = sh_vif.DATA_VALID;
        rsp_seq_item.P_DATA   = sh_vif.P_DATA;
        rsp_seq_item.TX_OUT     = sh_vif.TX_OUT;
        rsp_seq_item.Busy    = sh_vif.Busy;
        rsp_seq_item.TX_OUT_EXP     = sh_vif.TX_OUT_EXP;
        rsp_seq_item.Busy_exp    = sh_vif.Busy_exp;
        
        mon_ap.write(rsp_seq_item);

        `uvm_info("run_phase", rsp_seq_item.convert2string(), UVM_HIGH);
      end
    endtask

  endclass

endpackage
