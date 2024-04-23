module uart_collector (
    input  logic        clk,
    input  logic        rst,
    input  logic        rx_serial,
    output logic [31:0] write_instr_data,
    output logic        write_instr_valid,
    output logic [31:0] write_byte_address,
    output logic        start
);

  logic [7:0] rx_byte;
  logic rx_byte_valid;
  logic [31:0] byte_counter;

  logic [7:0] instr_fifo[4];
  logic [31:0] instr;
  logic [31:0] old_instr;

  logic start_soon;

  uart uart_inst (
      .clk(clk),
      .rx_serial(rx_serial),
      .rx_byte(rx_byte),
      .rx_byte_valid(rx_byte_valid)
  );

  assign instr = {instr_fifo[0], instr_fifo[1], instr_fifo[2], instr_fifo[3]};
  assign write_instr_data = instr;

  always_ff @(posedge clk) begin
    if (rst == 1) begin
      byte_counter <= 0;
      start <= 0;
    end else begin
      if (rx_byte_valid == 1) begin
        instr_fifo[0] <= instr_fifo[1];
        instr_fifo[1] <= instr_fifo[2];
        instr_fifo[2] <= instr_fifo[3];
        instr_fifo[3] <= rx_byte;
        byte_counter <= byte_counter + 1;
      end

      if ((byte_counter + 1) % 4 == 0 && byte_counter != 0 && rx_byte_valid == 1 && write_instr_valid == 0) begin
        write_instr_valid <= 1;
        write_byte_address <= byte_counter - 4;
        old_instr <= instr;
      end else begin
        write_instr_valid <= 0;
      end

      if (instr == 32'b11111111_11111111_11111111_11111111) begin
        start_soon <= 1;
        //if (byte_counter % 4 == 2) begin
        //  write_instr_valid  <= 1;
        //  write_byte_address <= byte_counter - 2;
        //end
      end else begin
        start_soon <= 0;
      end

      if (start_soon == 1) begin
        start <= 1;
      end  // else start<=start

    end
  end

endmodule
