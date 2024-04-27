import common_pkg::*;

module execute_stage (
    input logic clk,
    input logic rst,
    input logic [31:0] pc_execute,
    input logic [31:0] data1,
    input logic [31:0] data2,
    input logic [31:0] immediate_data,
    input control_t control,
    input logic fw_data_1_valid,
    input logic fw_data_2_valid,
    input logic [31:0] fw_data_1,
    input logic [31:0] fw_data_2,
    output logic [31:0] alu_res,
    output logic [31:0] mem_data,
    output logic branch_taken,
    output logic [31:0] pc_branch
);

  logic [31:0] left_operand;
  logic [31:0] right_operand;

  logic [31:0] alu_res_internal;

  logic [31:0] data1_internal;
  logic [31:0] data2_internal;

  // forwarding unit


  assign mem_data = data2_internal;
  assign branch_taken = alu_res[0] & control.is_branch;
  assign pc_branch = immediate_data * 2 + pc_execute + 4;

  //select forwarded value if fw valid
  assign data1_internal = fw_data_1_valid ? fw_data_1 : data1;
  assign data2_internal = fw_data_2_valid ? fw_data_2 : data2;

  // input mux
  always_comb begin : alu_mux_in
    if (control.alu_src == 1) begin
      left_operand  = data1_internal;
      right_operand = immediate_data;
    end else begin
      left_operand  = data1_internal;
      right_operand = data2_internal;
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
      .alu_inv_res(control.alu_inv_res),
      .alu_res(alu_res_internal)
      //.zero_flag(zero_flag)
  );

endmodule
