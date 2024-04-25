module uart_collector (
    input  logic        clk,
    input  logic        rst,
    input  logic        rx_serial,
    output logic [31:0] write_instr_data,
    output logic        write_instr_valid,
    output logic [31:0] write_byte_address,
    output logic        start
);

  typedef enum {
    idle,
    byte_1,
    byte_2,
    byte_3,
    byte_4,
    done
  } uart_collector_state_t;

  uart_collector_state_t uart_collector_state;

  logic [7:0] rx_byte;
  logic rx_byte_valid;
  logic [31:0] byte_counter;

  logic short_end;

  logic [31:0] instr_internal;
  // logic [31:0] old_instr_internal;
  logic [2:0] start_counter;

  uart uart_inst (
      .clk(clk),
      .rx_serial(rx_serial),
      .rx_byte(rx_byte),
      .rx_byte_valid(rx_byte_valid)
  );

  always_ff @(posedge clk) begin
    if (rst == 1) begin
      byte_counter <= 0;
      start <= 0;
      start_counter <= 0;
      uart_collector_state <= idle;
      write_instr_valid <= 0;
    end else begin
      write_instr_valid <= 0;
      //uart_collector_state <= uart_collector_state;

      case (uart_collector_state)
        idle: begin
          if (rx_byte_valid == 1) begin
            byte_counter <= byte_counter + 1;
            instr_internal[7:0] <= rx_byte;
            uart_collector_state <= byte_1;
          end
        end

        byte_1: begin
          if (rx_byte_valid == 1) begin
            byte_counter <= byte_counter + 1;
            instr_internal[15:8] <= rx_byte;
            uart_collector_state <= byte_2;
          end
        end

        byte_2: begin
          if (rx_byte_valid == 1) begin
            byte_counter <= byte_counter + 1;
            instr_internal[23:16] <= rx_byte;
            uart_collector_state <= byte_3;
          end
        end

        byte_3: begin
          if (rx_byte_valid == 1) begin
            byte_counter <= byte_counter + 1;
            instr_internal[31:24] <= rx_byte;
            uart_collector_state <= done;
          end
        end

        done: begin
          write_byte_address <= byte_counter - 4;
          write_instr_valid <= 1;
          //$display("data_instr: %032b", instr_internal);
          //old_instr_internal <= write_instr_data;
          write_instr_data <= instr_internal;
          uart_collector_state <= idle;
        end

        default: begin
          uart_collector_state <= idle;
        end
      endcase

      if (instr_internal == 32'b11111111_11111111_11111111_11111111 && start_counter == 0) begin
        if (write_instr_data[31:16] == 16'b11111111_11111111) begin
          //$display("short");
          write_instr_data[31:16] <= 16'b00000000_00010011;  // first half of nop
          write_byte_address <= byte_counter - 6;
          write_instr_valid <= 1;

          short_end <= 1;
        end else begin
          short_end <= 0;
          //$display("long");
        end
        start_counter <= 1;
      end

      if (start_counter == 3'b111 && start == 0) begin  // delay start abit to have time add nop
        start <= 1;
      end else if (start_counter == 3'b110 && start == 0 && short_end == 0) begin  //32 bit
        start_counter <= start_counter + 1;
        write_byte_address <= byte_counter - 8 + start_counter * 4;
        write_instr_valid <= 1;
        write_instr_data <= 32'b11111111_11111111_11111111_11111111;  // own instr HALT
      end else if (start_counter == 3'b110 && start == 0 && short_end == 1) begin  // 16 bit offset
        start_counter <= start_counter + 1;
        write_byte_address <= byte_counter - 6 + start_counter * 4;
        write_instr_valid <= 1;
        write_instr_data <= 32'b00000000_00000000_11111111_11111111;  // own instr HALT
      end else if (start_counter == 3'b101 && start == 0 && short_end == 1) begin  // 16 bit offset
        start_counter <= start_counter + 1;
        write_byte_address <= byte_counter - 6 + start_counter * 4;
        write_instr_valid <= 1;
        write_instr_data <= 32'b11111111_11111111_00000000_00000000;  // own instr HALT
      end else if (start_counter > 0 && start == 0 && short_end == 0) begin  // 32 bit
        start_counter <= start_counter + 1;
        write_byte_address <= byte_counter - 8 + start_counter * 4;
        write_instr_valid <= 1;
        write_instr_data <= 32'b00000000_00000000_00000000_00010011;  // NOP
      end else if (start_counter > 0 && start == 0 && short_end == 1) begin  // 16 bit offset
        start_counter <= start_counter + 1;
        write_byte_address <= byte_counter - 6 + start_counter * 4;
        write_instr_valid <= 1;
        write_instr_data <= 32'b00000000_00010011_00000000_00000000;  // NOP (offseted)
      end
    end
  end

endmodule
