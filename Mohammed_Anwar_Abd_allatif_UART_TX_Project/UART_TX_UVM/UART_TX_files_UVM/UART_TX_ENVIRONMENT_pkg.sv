package pack_env;
import pack_seq_item::*;
import pack_agent::*;
import pack_coverage::*;
import scoreboard::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class uart_env extends uvm_env;
`uvm_component_utils(uart_env);
uart_agent agt;
uart_scoreboard sb;
uart_coverage cov;
uvm_analysis_port #(shift_reg_seq_item)agt_ap;

    function new(string name="uart_env" , uvm_component parent = null);
    super.new(name,parent);
        endfunction 
/************** BUILD PHASE ***********************/
        function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    agt=uart_agent::type_id::create("agt",this);
    sb=uart_scoreboard::type_id::create("sb",this);
    cov=uart_coverage::type_id::create("cov",this);
    agt_ap=new("agt_ap",this); 
        endfunction 
/******************* CONNECTED PHASE  *************/
 function void connect_phase(uvm_phase phase); 
            super.connect_phase(phase); 
            agt.agt_ap.connect(sb.sb_export); 
            agt.agt_ap.connect (cov.cov_export); 
        endfunction 

endclass 
    
endpackage