`timescale 1ns / 1ps

import common_pkg::*;

module tb_instruction_decode_stage;

  logic clk = 0;
  logic rst = 1;

  integer cycle = 0;
  int test_length = 100;
  int clk_period = 10;

  instruction_decode_stage instruction_decode_stage_uut (
      .clk(clk),
      .rst(rst),
      .instruction(instruction),
      .pc(pc),
      .immediate_data(immediate_data),
      .control_signals(control_signals)
  );

  always #(clk_period / 2) clk = ~clk;
  always #clk_period cycle++;

  initial begin

    #(clk_period * 2);
    rst <= 0;

  end

  initial begin
    $dumpfile("waveform.vcd");
    $dumpvars(0, tb_instruction_decode_stage);
    $display("Done!");

    #test_length;  //test length

    $finish();
  end

endmodule
