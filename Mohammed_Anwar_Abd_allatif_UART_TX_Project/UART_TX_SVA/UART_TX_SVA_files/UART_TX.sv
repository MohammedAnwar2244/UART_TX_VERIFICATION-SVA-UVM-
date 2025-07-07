module uart_tx (uart_tx_if.DUT R_if);
  

  reg [3:0] state = R_if.IDLE;
  reg [3:0] counter = 0;
  reg [7:0] data_reg;
  reg parity_bit;

  always @(posedge R_if.clk or negedge R_if.reset) begin
    if (!R_if.reset) begin
      state <= R_if.IDLE;
      R_if.P_DATA <= 8'b0;
      R_if.DATA_VALID <= 0;
      counter <= 0;
    end else begin
      case (state)
        R_if.IDLE: begin
          R_if.TX_OUT <= 1'b1;
          R_if.Busy <= 1'b0;
        counter <=0 ;
        if (R_if.DATA_VALID) begin
            data_reg <= R_if.P_DATA;
            parity_bit <= (R_if.PAR_TYP == 0 ) ? ~^R_if.P_DATA : ^R_if.P_DATA ; 
            state <= R_if.START;
            R_if.Busy <= 1'b1;
            R_if.TX_OUT <= 1'b0;
        end
          end
        R_if.START: begin
         R_if.TX_OUT <= 1'b0;
         state <= R_if.DATA;
         counter <= 0 ;
         R_if.Busy <= 1'b1;
        end

        R_if.DATA: begin
          R_if.TX_OUT <= data_reg[counter];
          R_if.Busy <= 1'b1;
          counter <= counter + 1 ;
          if (counter == 7) begin
            state <= (R_if.PAR_EN) ? R_if.PARITY : R_if.STOP ; 
            end
        end

        R_if.PARITY: begin
          R_if.TX_OUT <= parity_bit ;
          R_if.Busy <= 1'b1;
          state <= R_if.STOP;
        end

        R_if.STOP: begin
          R_if.TX_OUT <= 1'b1;
          R_if.Busy <= 1'b1;
          state <= R_if.IDLE;
        end
      endcase
    end
  end

endmodule
