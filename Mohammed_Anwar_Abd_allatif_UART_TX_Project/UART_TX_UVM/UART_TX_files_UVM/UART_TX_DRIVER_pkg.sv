package pack_driver;
import pack_config::*;
import uvm_pkg::*;
import pack_seq_item::*;
`include "uvm_macros.svh"
class uart_driver extends uvm_driver #(shift_reg_seq_item);
`uvm_component_utils(uart_driver);
//ram_config ram_cfg;
virtual uart_tx_if sh_vif;
shift_reg_seq_item stim_seq_item;
/********** COSTRACTOR *************/
    function new(string name ="uart_driver", uvm_component parent = null);
    super.new(name,parent);
    endfunction
    //***************RUN_PHASE*****************//

 task run_phase(uvm_phase phase);
      super.run_phase(phase);
      forever
       begin
        // Create a new sequence item
        stim_seq_item = shift_reg_seq_item::type_id::create("stim_seq_item");

        // Get transaction from sequencer
        seq_item_port.get_next_item(stim_seq_item);

        // Drive stimulus to DUT interface
        sh_vif.reset        = stim_seq_item.reset;
        sh_vif.PAR_EN        = stim_seq_item.PAR_EN;
        sh_vif.PAR_TYP        = stim_seq_item.PAR_TYP; 
        sh_vif.P_DATA      = stim_seq_item.P_DATA;
         sh_vif.DATA_VALID      = stim_seq_item.DATA_VALID;
        
        // Wait for one negative clock edge
        @(negedge sh_vif.clk); 

        // Capture DUT output
        stim_seq_item.TX_OUT = sh_vif.TX_OUT;
         stim_seq_item.Busy = sh_vif.Busy;

        
        // Complete transaction
        seq_item_port.item_done();

        `uvm_info("run_phase", stim_seq_item.convert2string_stimulus(), UVM_HIGH) 
      end
    endtask

 endclass
 endpackage 