module uart_tx_assertions (uart_tx_if.DUT vif);

// Final reset checks after reset is deasserted
always_comb begin 
  if (!vif.reset) begin
    a_assert: assert final(uart_tx.state == vif.IDLE);
    b_assert: assert final(vif.TX_OUT == 1'b1);
    c_assert: assert final(vif.Busy == 1'b0);
    d_assert: assert final(uart_tx.counter == 0);
  end 
end

// 1. TX_OUT should be high and Busy low in IDLE state
property idle_behavior;
  @(posedge vif.clk) disable iff (!vif.reset)
  (uart_tx.state == vif.IDLE && vif.DATA_VALID == 1'b0) |=> 
  (vif.TX_OUT == 1'b1 && vif.Busy == 1'b0 && uart_tx.counter == 0);
endproperty
p1: assert property(idle_behavior) else $error("TX_OUT should be 1 and Busy 0 in IDLE state.");
c1: cover property(idle_behavior);

// 2. FSM should remain in IDLE when DATA_VALID = 0
property idle_2;
  @(posedge vif.clk) disable iff (!vif.reset)
  (uart_tx.state == vif.IDLE && vif.DATA_VALID == 1'b0) |=> (uart_tx.state == vif.IDLE);
endproperty
p2: assert property(idle_2) else $error("State should remain IDLE when DATA_VALID is 0.");
c2: cover property(idle_2);

// 3. START state: TX_OUT should be 0 and counter = 0
property start_bit_low;
  @(posedge vif.clk) disable iff (!vif.reset)
  (uart_tx.state == vif.START) |=> (vif.TX_OUT == 1'b0 && uart_tx.counter == 0);
endproperty
p3: assert property(start_bit_low) else $error("TX_OUT should be 0 and counter 0 in START state.");
c3: cover property(start_bit_low);

// 4. DATA state continues when counter != 7
property data_bit_1;
  @(posedge vif.clk) disable iff (!vif.reset)
  (uart_tx.state == vif.DATA && uart_tx.counter != 7) |=> (uart_tx.state == vif.DATA);
endproperty
p4: assert property(data_bit_1) else $error("FSM should stay in DATA state while counter != 7.");
c4: cover property(data_bit_1);

// 5. TX_OUT should match data_reg[counter] and counter must increment
property data_bit_match;
  @(posedge vif.clk) disable iff (!vif.reset)
  (uart_tx.state == vif.DATA && uart_tx.counter != 7) |=> 
  (vif.TX_OUT == uart_tx.data_reg[$past(uart_tx.counter)] &&
   uart_tx.counter == $past(uart_tx.counter) + 1);
endproperty
p5: assert property(data_bit_match) else $error("TX_OUT mismatch or counter didn't increment in DATA state.");
c5: cover property(data_bit_match);

// 6. PARITY state: TX_OUT should match calculated parity bit
property parity_correct;
  @(posedge vif.clk) disable iff (!vif.reset)
  (uart_tx.state == vif.PARITY) |=> (vif.TX_OUT == uart_tx.parity_bit);
endproperty
p6: assert property(parity_correct) else $error("TX_OUT does not match expected parity bit.");
c6: cover property(parity_correct);

// 7. STOP state: TX_OUT should be high
property stop_bit_high;
  @(posedge vif.clk) disable iff (!vif.reset)
  (uart_tx.state == vif.STOP) |=> (vif.TX_OUT == 1'b1);
endproperty
p7: assert property(stop_bit_high) else $error("TX_OUT must be high in STOP state.");
c7: cover property(stop_bit_high);

// 8. No transition from IDLE if DATA_VALID is not asserted
property no_start_without_valid;
  @(posedge vif.clk) disable iff (!vif.reset)
  (uart_tx.state == vif.IDLE && vif.DATA_VALID == 0) |=> (uart_tx.state == vif.IDLE);
endproperty
p8: assert property(no_start_without_valid) else $error("FSM left IDLE without DATA_VALID = 1.");
c8: cover property(no_start_without_valid);

// 9. Even parity logic from IDLE
property idle_even_parity;
  @(posedge vif.clk) disable iff (!vif.reset)
  (uart_tx.state == vif.IDLE && vif.DATA_VALID == 1 && vif.PAR_TYP == 0) |=>
  (uart_tx.parity_bit == ~^$past(vif.P_DATA) &&
   vif.Busy == 1'b1 &&
   uart_tx.data_reg == $past(vif.P_DATA));
endproperty
p9: assert property(idle_even_parity) else $error("Even parity incorrect after IDLE.");
c9: cover property(idle_even_parity);

// 10. Odd parity logic from IDLE
property idle_odd_parity;
  @(posedge vif.clk) disable iff (!vif.reset)
  (uart_tx.state == vif.IDLE && vif.DATA_VALID == 1 && vif.PAR_TYP == 1) |=>
  (uart_tx.parity_bit == ^$past(vif.P_DATA) &&
   vif.Busy == 1'b1 &&
   uart_tx.data_reg == $past(vif.P_DATA));
endproperty
p10: assert property(idle_odd_parity) else $error("Odd parity incorrect after IDLE.");
c10: cover property(idle_odd_parity);

// 11. Transition from IDLE to START when DATA_VALID = 1
property idle_to_start;
  @(posedge vif.clk) disable iff (!vif.reset)
  (uart_tx.state == vif.IDLE && vif.DATA_VALID == 1) |=> (uart_tx.state == vif.START);
endproperty
p11: assert property(idle_to_start) else $error("Should move from IDLE to START when DATA_VALID = 1.");
c11: cover property(idle_to_start);

// 12. DATA to PARITY transition when counter==7 and PAR_EN==1
property data_to_parity;
  @(posedge vif.clk) disable iff (!vif.reset)
  (uart_tx.state == vif.DATA && uart_tx.counter == 7 && vif.PAR_EN == 1) |=>
  (uart_tx.state == vif.PARITY);
endproperty
p12: assert property(data_to_parity) else $error("Should go to PARITY after DATA if PAR_EN == 1.");
c12: cover property(data_to_parity);

// 13. DATA to STOP transition when counter==7 and PAR_EN==0
property data_to_stop;
  @(posedge vif.clk) disable iff (!vif.reset)
  (uart_tx.state == vif.DATA && uart_tx.counter == 7 && vif.PAR_EN == 0) |=>
  (uart_tx.state == vif.STOP);
endproperty
p13: assert property(data_to_stop) else $error("Should go to STOP after DATA if PAR_EN == 0.");
c13: cover property(data_to_stop);

// 14. PARITY to STOP transition
property parity_to_stop;
  @(posedge vif.clk) disable iff (!vif.reset)
  (uart_tx.state == vif.PARITY) |=>
  (vif.TX_OUT == $past(uart_tx.parity_bit) && uart_tx.state == vif.STOP);
endproperty
p14: assert property(parity_to_stop) else $error("Should go to STOP after PARITY.");
c14: cover property(parity_to_stop);

// 15. STOP to IDLE transition
property stop_to_idle;
  @(posedge vif.clk) disable iff (!vif.reset)
  (uart_tx.state == vif.STOP) |=>
  (vif.TX_OUT == 1 && uart_tx.state == vif.IDLE);
endproperty
p15: assert property(stop_to_idle) else $error("Should go to IDLE after STOP.");
c15: cover property(stop_to_idle);

endmodule
