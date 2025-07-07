package pack_config;
import uvm_pkg::*;
`include "uvm_macros.svh"
class uart_config extends uvm_object;
`uvm_object_utils(uart_config);
virtual uart_tx_if uart_vif;

    function new(string name = "uart_config");
    super.new(name);
        
    endfunction 
endclass 


endpackage