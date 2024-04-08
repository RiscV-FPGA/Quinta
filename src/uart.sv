module uart (
    input logic clk,
    input logic rx_serial,
    output logic [7:0] rx_byte,
    output logic rx_byte_valid
);

// clk=100 MHz, uart=115200 bits/s
// clk/uart = 868.0556
  parameter integer CLKS_PER_BIT = 868;

  logic       rx_serial_d;
  logic       rx_serial_dd;
  logic [9:0] clk_counter; // 10 bits max count 1023
  logic [2:0] bit_index_counter;  //8 bits total

  typedef enum {
    idle,
    rx_start_bit,
    rx_data_bits,
    rx_stop_bit
  } uart_state_t;

  uart_state_t uart_state;


  // dubble flip flop for input
  always @(posedge clk) begin
    rx_serial_d  <= rx_serial;
    rx_serial_dd <= rx_serial_d;
  end

  always @(posedge clk) begin
    rx_byte_valid <= 1'b0;

    case (uart_state)
      idle: begin
        clk_counter <= 0;
        bit_index_counter <= 0;

        if (rx_serial_dd == 1'b0)  // Start bit detected (zero)
          uart_state <= rx_start_bit;
        else uart_state <= idle;
      end

      // Check middle of start bit to make sure it's still low
      rx_start_bit: begin
        if (clk_counter == (CLKS_PER_BIT - 1) / 2) begin
          if (rx_serial_dd == 1'b0) begin
            clk_counter <= 0;  // reset counter, found the middle
            uart_state  <= rx_data_bits;
          end else uart_state <= idle;
        end else begin
          clk_counter <= clk_counter + 1;
          uart_state  <= rx_start_bit;
        end
      end


      // Wait CLKS_PER_BIT-1 clock cycles to sample serial data
      rx_data_bits: begin
        if (clk_counter < CLKS_PER_BIT - 1) begin
          clk_counter <= clk_counter + 1;
          uart_state  <= rx_data_bits;
        end else begin
          clk_counter                <= 0;
          rx_byte[bit_index_counter] <= rx_serial_dd;

          // Check if we have received all bits
          if (bit_index_counter < 7) begin
            bit_index_counter <= bit_index_counter + 1;
            uart_state <= rx_data_bits;
          end else begin
            bit_index_counter <= 0;
            uart_state <= rx_stop_bit;
          end
        end
      end

      // Receive Stop bit.  Stop bit = 1
      rx_stop_bit: begin
        // Wait CLKS_PER_BIT-1 clock cycles for Stop bit to finish
        if (clk_counter < CLKS_PER_BIT - 1) begin
          clk_counter <= clk_counter + 1;
          uart_state  <= rx_stop_bit;
        end else begin
          clk_counter <= 0;
          uart_state    <= idle;
          rx_byte_valid <= 1;
        end
      end

      default: uart_state <= idle;

    endcase
  end

endmodule
