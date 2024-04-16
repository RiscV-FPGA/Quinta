`timescale 1ns / 1ps

module tb_uart ();

  // Testbench uses a 100 MHz clock
  // Want to interface to 115200 baud UART
  // 100000000 / 115200 = 868 Clocks Per Bit.

  // 11.7ns
  parameter integer CLK_PERIOD = 11.7;
  parameter integer CLKS_PER_BIT = 745;
  parameter integer BIT_PERIOD = 8600;

  logic clk = 0;
  logic rx_serial = 1;

  wire [7:0] rx_byte;
  wire rx_byte_valid;


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


  uart uart_inst (
      .clk(clk),
      .rx_serial(rx_serial),
      .rx_byte(rx_byte),
      .rx_byte_valid(rx_byte_valid)
  );


  always #(CLK_PERIOD / 2) clk <= !clk;


  // Main Testing:
  initial begin
    $dumpfile("waveform.vcd");
    $dumpvars(0, tb_uart);
    $display("Done!");


    // Send a command to the UART (exercise Rx)
    @(posedge clk);
    UART_WRITE_BYTE(8'h3F);
    @(posedge clk);

    // Check that the correct command was received
    if (rx_byte == 8'h3F) $display("Test Passed - Correct Byte Received");
    else $display("Test Failed - Incorrect Byte Received");

    #(CLK_PERIOD * 10);

    // Send a command to the UART (exercise Rx)
    @(posedge clk);
    UART_WRITE_BYTE(8'hFF);
    @(posedge clk);

    // Check that the correct command was received
    if (rx_byte == 8'hFF) $display("Test Passed - Correct Byte Received");
    else $display("Test Failed - Incorrect Byte Received");


    $finish();

  end

endmodule
