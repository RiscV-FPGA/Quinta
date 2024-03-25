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


  // forwarding unit


  alu alu_inst (
      .left_operand(data1),
      .right_operand(data2),
      .alu_op(control.alu_op),
      .alu_res(alu_res),
      .zero_flag(zero_flag)
  );


endmodule
