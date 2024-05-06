`timescale 1ns / 1ps

module tb_top;

  logic clk = 0;
  logic rst = 1;

  integer cycle = 0;
  int test_length = 1000;
  int clk_period = 10;
  parameter integer BIT_PERIOD = 8680;  // 115200 bist/s @ 100MHz -> 8680ns per bit

  logic rx_serial;
  logic finish = 0;


  logic [7:0] tb_instr[1024];
  string filename = "src/instruction_mem_temp.mem";
  int row_count = 0;
  int file_handle;
  initial begin
    $readmemb(filename, tb_instr);

    file_handle = $fopen(filename, "r");
    if (file_handle == 0) begin
      $display("Error opening file '%s'", filename);
      $finish;
    end
    while (!$feof(
        file_handle
    )) begin
      string line;
      $fscanf(file_handle, "%s", line);
      row_count++;
    end
    row_count--;
    $fclose(file_handle);
    $display("Number of rows in file '%s': %d", filename, row_count);
  end

  top top_inst (
      .sys_clk(clk),
      .rst(rst),
      .rx_serial(rx_serial)
      //.finish(finish)
  );

  // Takes in input byte and serializes it
  task static UART_WRITE_BYTE;
    input [7:0] i_Data;
    integer ii;
    begin
      // Send Start Bit
      rx_serial <= 1'b0;
      #(BIT_PERIOD);
      //#1000;
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


  always #(clk_period / 2) clk = ~clk;
  always #clk_period cycle++;

  initial begin
    #(clk_period * 2);
    rst <= 0;
  end

  initial begin
    $dumpfile("waveform.vcd");
    $dumpvars(0, tb_top);
    $display("Done!");

    #(clk_period * 2);
    rst = 0;
    #(clk_period * 2);
    // b00000000 b00010000 b00000000 b10010011 //ADDI x1 = x0 + 1
    // b00000000 b00100000 b00000001 b00010011 //ADDI x2 = x0 + 2
    // b00000000 b00110000 b00000001 b10010011 //ADDI x3 = x0 + 3
    // b10101010 b11000001 // ADDI x16 = 31
    // b11110000 b11000101 // ADDI x17 = 31
    // b11001100 b11001101 // ADDI x18 = 31

    for (int i = 0; i < row_count; i++) begin
      @(posedge clk);
      UART_WRITE_BYTE(tb_instr[i]);
      #(clk_period * 2);
    end

    /*
    // instr 1
    // b10010011
    // b00000000
    // b00010000
    // b00000000
    @(posedge clk);
    UART_WRITE_BYTE(8'b10010011);
    #(clk_period * 10);
    @(posedge clk);
    UART_WRITE_BYTE(8'b00000000);
    #(clk_period * 10);
    @(posedge clk);
    UART_WRITE_BYTE(8'b00010000);
    #(clk_period * 10);
    @(posedge clk);
    UART_WRITE_BYTE(8'b00000000);
    #(clk_period * 10);

    // instr 2
    // b00010011
    // b00000001
    // b00100000
    // b00000000
    @(posedge clk);
    UART_WRITE_BYTE(8'b00010011);
    #(clk_period * 10);
    @(posedge clk);
    UART_WRITE_BYTE(8'b00000001);
    #(clk_period * 10);
    @(posedge clk);
    UART_WRITE_BYTE(8'b00100000);
    #(clk_period * 10);
    @(posedge clk);
    UART_WRITE_BYTE(8'b00000000);
    #(clk_period * 10);

    // instr 3
    // b10010011
    // b00000001
    // b00110000
    // b00000000
    @(posedge clk);
    UART_WRITE_BYTE(8'b10010011);
    #(clk_period * 10);
    @(posedge clk);
    UART_WRITE_BYTE(8'b00000001);
    #(clk_period * 10);
    @(posedge clk);
    UART_WRITE_BYTE(8'b00110000);
    #(clk_period * 10);
    @(posedge clk);
    UART_WRITE_BYTE(8'b00000000);
    @(posedge clk);
    #(clk_period * 10);

    // compact instr 4
    // b11110101
    // b00001110
    @(posedge clk);
    UART_WRITE_BYTE(8'b11110101);
    #(clk_period * 10);
    @(posedge clk);
    UART_WRITE_BYTE(8'b00001110);
    #(clk_period * 10);

    // compact instr 5
    // b01111001
    // b00001111
    @(posedge clk);
    UART_WRITE_BYTE(8'b01111001);
    #(clk_period * 10);
    @(posedge clk);
    UART_WRITE_BYTE(8'b00001111);
    #(clk_period * 10);

    // compact instr 6
    // b11111101
    // b00001111
    @(posedge clk);
    UART_WRITE_BYTE(8'b11111101);
    #(clk_period * 10);
    @(posedge clk);
    UART_WRITE_BYTE(8'b00001111);
    #(clk_period * 10);

    // instr 7 (halt)
    @(posedge clk);
    UART_WRITE_BYTE(8'b11111111);
    @(posedge clk);
    #(clk_period * 10);

    @(posedge clk);
    UART_WRITE_BYTE(8'b11111111);
    @(posedge clk);
    #(clk_period * 10);

    @(posedge clk);
    UART_WRITE_BYTE(8'b11111111);
    @(posedge clk);
    #(clk_period * 10);

    @(posedge clk);
    UART_WRITE_BYTE(8'b11111111);
    @(posedge clk);
    #(clk_period * 10);
*/

    #(clk_period * 200);

    //finish = 1;
    #clk_period;
    $finish();
  end

endmodule
