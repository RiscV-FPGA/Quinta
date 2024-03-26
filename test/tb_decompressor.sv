`timescale 1ns / 1ps

import common_pkg::*;

module tb_decompressor;

  logic clk = 0;
  logic rst = 1;

  integer cycle = 0;
  int test_length = 100;
  int clk_period = 10;

  logic [31:0] instruction_in;
  logic [31:0] instruction_out;


  decompressor decompressor_uut (
      .clk(clk),
      .rst(rst),
      .instruction_in(instruction_in),
      .instruction_out(instruction_out)
  );



  always #(clk_period / 2) clk = ~clk;
  always #clk_period cycle++;

  initial begin

    #(clk_period * 2);
    rst <= 0;
    instruction_in <= 0;
    #(clk_period * 4);
    instruction_in <= 32'b00000000_00000000_010_111_010_11_001_11;

  end

  /*always_comb begin
      if(cycle == 5)begin
        instruction_in <= 16'b010_111_010_10_001_00;
      end else begin
        instruction_in <= '0;
      end
  end */

  initial begin
    $dumpfile("waveform.vcd");
    $dumpvars(0, tb_decompressor);
    $display("Done!");

    #test_length;  //test length

    $finish();
  end

endmodule
