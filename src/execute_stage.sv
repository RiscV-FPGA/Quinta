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

  // forwarding unit


  always_comb begin
    left_operand = data1;
    right_operand = data2;
    mem_data = data2;  // probebly not compleatly correct
    if (control.alu_src) begin
      right_operand = immediate_data;
      mem_data = immediate_data;  // probebly not compleatly correct
    end
  end

  alu alu_inst (
      .left_operand(left_operand),
      .right_operand(right_operand),
      .alu_op(control.alu_op),
      .alu_res(alu_res),
      .zero_flag(zero_flag)
  );


endmodule
