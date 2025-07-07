module uart_golden_model(uart_tx_if.GOLD u_if);
    reg [3:0] counter = 0;
    reg [7:0] DATA_reg;
    reg PARITY_bit; 
    reg [3:0] cs, ns;
    
    // State memory
    always @(posedge u_if.clk or negedge u_if.reset) begin
        if (!u_if.reset) begin
            cs <= u_if.IDLE;
        end
        else begin
            cs <= ns;
        end
    end

    // Next state Logic
    always @(*) begin
        case(cs)
            u_if.IDLE: begin
                if (u_if.DATA_VALID ) begin
                    ns = u_if.START;
                end
            end
            u_if.START: ns = u_if.DATA;
            u_if.DATA: begin
                if (counter == 7) begin
                    ns = (u_if.PAR_EN) ? u_if.PARITY : u_if.STOP;
                end
            end
            u_if.PARITY: ns = u_if.STOP;
            u_if.STOP: ns = u_if.IDLE;
            default: ns = u_if.IDLE;
        endcase
    end

    // Output logic
    always @(posedge u_if.clk or negedge u_if.reset) begin
        if (!u_if.reset) begin
            u_if.TX_OUT_ex <= 1'b1;
            u_if.Busy_ex <= 1'b0;
            counter <= 0;
        end
        else begin
            case (cs)
                u_if.IDLE: begin
                    u_if.TX_OUT_ex <= 1'b1;
                    u_if.Busy_ex <= 1'b0;
                    counter <= 0;
                    if (u_if.DATA_VALID) begin
                        DATA_reg <= u_if.P_DATA;
                        PARITY_bit <= (u_if.PAR_TYP == 0) ? ~^u_if.P_DATA : ^u_if.P_DATA;
                        u_if.Busy_ex <= 1'b1;
                    end
                end
                u_if.START: begin
                    u_if.TX_OUT_ex <= 1'b0;
                    counter <= 0;
                end
                u_if.DATA: begin
                    u_if.TX_OUT_ex <= DATA_reg[counter];
                    counter <= counter + 1;
                end
                u_if.PARITY: begin
                    u_if.TX_OUT_ex <= PARITY_bit;
                end
                u_if.STOP: begin
                    u_if.TX_OUT_ex <= 1'b1;
                end
            endcase
        end
    end
endmodule