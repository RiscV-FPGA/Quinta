`timescale 1ns / 1ps

import common_pkg::*;
import common_instructions_pkg::*;

module tb_instruction_fetch_stage;

  logic clk = 0;
  logic rst = 1;

  integer cycle = 0;
  int test_length = 200;
  int clk_period = 10;

  instruction_t instruction;
  wire [31:0] pc;

  instruction_fetch_stage instruction_fetch_stage_uut (
      .clk(clk),
      .rst(rst),
      .pc(pc),
      .instruction(instruction)
  );

  always #(clk_period / 2) clk = ~clk;
  always #clk_period cycle++;

  initial begin
    #(clk_period * 2);  //rst signal
    rst <= 0;
  end

  initial begin
    $dumpfile("waveform.vcd");
    $dumpvars(0, tb_instruction_fetch_stage);
    $display("Done!");

    #test_length;  //test length

    $finish();
  end

endmodule
