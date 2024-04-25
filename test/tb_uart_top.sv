`timescale 1ns / 1ps

module tb_uart_top ();

  parameter integer CLK_PERIOD = 10;  // 10ns = 100MHz
  parameter integer BIT_PERIOD = 8680;  // 115200 bist/s @ 100MHz -> 8680ns per bit

  logic clk = 0;
  logic rst = 1;
  logic rx_serial = 1;

  wire [31:0] write_instr_data;
  wire write_instr_valid;
  wire [31:0] write_byte_address;
  wire start;

  // Takes in input byte and serializes it
  task static UART_WRITE_BYTE;
    input [7:0] i_Data;
    integer ii;
    begin

      // Send Start Bit
      rx_serial <= 1'b0;
      #(BIT_PERIOD);
      #1000;


      // Send Data Byte
      for (ii = 0; ii < 8; ii = ii + 1) begin
        rx_serial <= i_Data[ii];
        #(BIT_PERIOD);
      end

      // Send Stop Bit
      rx_serial <= 1'b1;
      #(BIT_PERIOD);
    end
  endtask  // UART_WRITE_BYTE


  uart_collector uart_collector_inst (
      .clk(clk),
      .rst(rst),
      .rx_serial(rx_serial),
      .write_instr_data(write_instr_data),
      .write_instr_valid(write_instr_valid),
      .write_byte_address(write_byte_address),
      .start(start)
  );

  logic [7:0] ram[1024];  // 512 compact or 256 32-bit instructions
  always @(posedge clk) begin
    if (write_instr_valid) begin
      ram[write_byte_address]   <= write_instr_data[31:24];
      ram[write_byte_address+1] <= write_instr_data[23:16];
      ram[write_byte_address+2] <= write_instr_data[15:8];
      ram[write_byte_address+3] <= write_instr_data[7:0];
    end
  end

  always #(CLK_PERIOD / 2) clk <= !clk;

  always_ff @(posedge clk) begin
    if (write_instr_valid) begin
      $display("Writing instruction: %032b, at addr: %032b", write_instr_data, write_byte_address);
    end
  end
  // Main Testing:
  initial begin
    $dumpfile("waveform.vcd");
    $dumpvars(0, tb_uart_top);
    $display("Done!");

    #(CLK_PERIOD * 2);
    rst = 0;
    #(CLK_PERIOD * 2);

    // instr 1
    @(posedge clk);
    UART_WRITE_BYTE(8'b00000000);
    @(posedge clk);
    #(CLK_PERIOD * 10);

    @(posedge clk);
    UART_WRITE_BYTE(8'b00000000);
    @(posedge clk);
    #(CLK_PERIOD * 10);

    @(posedge clk);
    UART_WRITE_BYTE(8'b00000000);
    @(posedge clk);
    #(CLK_PERIOD * 10);

    @(posedge clk);
    UART_WRITE_BYTE(8'b00010011);
    @(posedge clk);
    #(CLK_PERIOD * 10);

    // instr 2
    @(posedge clk);
    UART_WRITE_BYTE(8'b10101010);
    @(posedge clk);
    #(CLK_PERIOD * 10);

    @(posedge clk);
    UART_WRITE_BYTE(8'b10101010);
    @(posedge clk);
    #(CLK_PERIOD * 10);

    @(posedge clk);
    UART_WRITE_BYTE(8'b10101010);
    @(posedge clk);
    #(CLK_PERIOD * 10);

    @(posedge clk);
    UART_WRITE_BYTE(8'b10101010);
    @(posedge clk);
    #(CLK_PERIOD * 10);

    // instr 3
    @(posedge clk);
    UART_WRITE_BYTE(8'b11001100);
    @(posedge clk);
    #(CLK_PERIOD * 10);

    @(posedge clk);
    UART_WRITE_BYTE(8'b11001100);
    @(posedge clk);
    #(CLK_PERIOD * 10);

    @(posedge clk);
    UART_WRITE_BYTE(8'b11001100);
    @(posedge clk);
    #(CLK_PERIOD * 10);

    @(posedge clk);
    UART_WRITE_BYTE(8'b11001100);
    @(posedge clk);
    #(CLK_PERIOD * 10);

    // compact instr 4
    @(posedge clk);
    UART_WRITE_BYTE(8'b11110000);
    @(posedge clk);
    #(CLK_PERIOD * 10);

    @(posedge clk);
    UART_WRITE_BYTE(8'b00001111);
    @(posedge clk);
    #(CLK_PERIOD * 10);

    // instr 5 (halt)
    @(posedge clk);
    UART_WRITE_BYTE(8'b11111111);
    @(posedge clk);
    #(CLK_PERIOD * 10);

    @(posedge clk);
    UART_WRITE_BYTE(8'b11111111);
    @(posedge clk);
    #(CLK_PERIOD * 10);

    @(posedge clk);
    UART_WRITE_BYTE(8'b11111111);
    @(posedge clk);
    #(CLK_PERIOD * 10);

    @(posedge clk);
    UART_WRITE_BYTE(8'b11111111);
    @(posedge clk);
    #(CLK_PERIOD * 10);

    #(CLK_PERIOD * 200);

    for (int i = 0; i < 25; i++) begin
      if (i < 10) begin
        $display("inst_addr__%0d: %08b_%08b_%08b_%08b", i, ram[4*i], ram[4*i+1], ram[4*i+2],
                 ram[4*i+3]);
      end else begin
        $display("inst_addr_%0d: %08b_%08b_%08b_%08b", i, ram[4*i], ram[4*i+1], ram[4*i+2],
                 ram[4*i+3]);
      end
    end
    #(CLK_PERIOD * 10);

    $finish();



  end

endmodule
