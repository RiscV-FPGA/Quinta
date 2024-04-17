`timescale 1ns / 1ps

import common_pkg::*;

module execute_stage (
    input logic clk,
    input logic rst,
    input [31:0] data1,
    input [31:0] data2,
    input [31:0] immediate_data,
    input control_t control,
    output logic [31:0] alu_res,
    output logic [31:0] mem_data
);

  logic [31:0] left_operand;
  logic [31:0] right_operand;

  logic [31:0] alu_res_internal;

  // forwarding unit



  assign mem_data = data1;

  // input mux
  always_comb begin : alu_mux_in
    if (control.encoding == S_TYPE) begin  // only on s type
      left_operand  = data2;
      right_operand = immediate_data;
    end else begin  // everything else
      if (control.alu_src == 1) begin
        left_operand  = data1;
        right_operand = immediate_data;
      end else begin
        left_operand  = data1;
        right_operand = data2;
      end

    end
  end

  // output mux
  always_comb begin : alu_mux_out
    if (control.encoding == U_TYPE) begin  // bypass on I-type?
      alu_res = immediate_data;
    end else begin
      alu_res = alu_res_internal;
    end
  end

  alu alu_inst (
      .left_operand(left_operand),
      .right_operand(right_operand),
      .alu_op(control.alu_op),
      .alu_res(alu_res_internal),
      .zero_flag(zero_flag)
  );


endmodule
