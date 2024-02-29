`timescale 1ns / 1ns

module tb_first_test;

  logic clk = 0;
  logic rst = 1;

  logic a_in = 0;
  logic b_in = 0;
  wire c_out;
  wire [7:0] counter;

  integer cycle = 0;

  int test_length = 100;
  int clk_period = 10;


  first_test uut (
      .clk(clk),
      .rst(rst),
      .a_in(a_in),
      .b_in(b_in),
      .c_out(c_out),
      .counter(counter)
  );

  always #(clk_period / 2) clk = ~clk;
  always #clk_period cycle++;

  initial begin

    #(clk_period * 2);
    rst <= 0;

    #clk_period;
    a_in <= 1;
    b_in <= 1;

    #clk_period;
    a_in <= 0;
    b_in <= 0;

    #clk_period;
    a_in <= 1;
    b_in <= 1;

  end

  initial begin
    $dumpfile("waveform.vcd");
    $dumpvars(0, tb_first_test);
    $display("Done!");

    #test_length;  //test length

    $finish();
  end

endmodule
