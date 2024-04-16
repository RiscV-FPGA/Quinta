`timescale 1ns / 1ps

module tb_top;

  logic clk = 0;
  logic rst = 1;

  integer cycle = 0;
  int test_length = 500;
  int clk_period = 10;

  logic finish = 0;

  top top_inst (
      .sys_clk(clk),
      .rst(rst),
      .finish(finish)
  );

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

    #test_length;  //test length
    finish = 1;
    #clk_period;
    $finish();
  end

endmodule
