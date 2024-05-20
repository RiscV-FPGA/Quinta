`timescale 1ns / 1ps

import common_pkg::*;

module tb_dsp_float;

  logic clk = 0;
  logic rst = 1;

  integer cycle = 0;
  int test_length = 100;
  int clk_period = 10;

  alu_op_t alu_op;
  logic [31:0] left_operand;
  logic [31:0] right_operand;

  wire [31:0] int_float_res;
  wire [31:0] float_int_res;
  wire [31:0] float_add_res;
  wire [31:0] float_sub_res;
  wire float_eq_res;
  wire float_lt_res;
  wire float_lte_res;
  wire [31:0] float_mul_res;
  wire [31:0] float_div_res;
  wire [31:0] float_sqrt_res;


  dsp_float dsp_float_inst (
      .clk(clk),
      .rst(rst),
      .alu_op(alu_op),
      .left_operand(left_operand),
      .right_operand(right_operand),
      .int_float_res(int_float_res),
      .float_int_res(float_int_res),
      .float_add_res(float_add_res),
      .float_sub_res(float_sub_res),
      .float_eq_res(float_eq_res),
      .float_lt_res(float_lt_res),
      .float_lte_res(float_lte_res),
      .float_mul_res(float_mul_res),
      .float_div_res(float_div_res),
      .float_sqrt_res(float_sqrt_res)
  );

  always #(clk_period / 2) clk = ~clk;
  always #clk_period cycle++;


  initial begin
    $dumpfile("waveform.vcd");
    $dumpvars(0, tb_dsp_float);
    $display("Done!");

    #(clk_period * 2);
    rst = 0;
    #(clk_period * 2);

    left_operand = 32'b01000001001000000000000000000000;

    #(clk_period * 2);


    #test_length;  //test length
    $finish();
  end

endmodule
