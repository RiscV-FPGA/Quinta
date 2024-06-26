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
    output logic [31:0] pc_branch,
    output logic insert_bubble
);

  logic [31:0] left_operand;
  logic [31:0] right_operand;

  logic [31:0] alu_res_internal;

  assign mem_data = fw_data_2_valid ? fw_data_2 : data2;
  assign branch_taken = (alu_res[0] & control.is_branch) | control.alu_jump;

  always_comb begin
    if (control.is_branch == 1) begin
      pc_branch = immediate_data * 2 + pc_execute;
    end else begin
      pc_branch = left_operand + right_operand;
    end
  end

  // input mux
  always_comb begin : alu_mux_in
    if (control.alu_pc == 1) begin
      left_operand = pc_execute;
    end else if (fw_data_1_valid == 1) begin
      left_operand = fw_data_1;
    end else begin
      left_operand = data1;
    end

    if (control.alu_src == 1) begin
      right_operand = immediate_data;
    end else if (fw_data_2_valid == 1) begin
      right_operand = fw_data_2;
    end else begin
      right_operand = data2;
    end
  end

  // output mux
  always_comb begin : alu_mux_out
    if (control.alu_bypass == 1) begin  // bypass on I-type?
      alu_res = immediate_data;
    end else begin
      if (control.alu_inv_res == 1) begin
        alu_res = ~alu_res_internal;
      end else begin
        alu_res = alu_res_internal;
      end
    end
  end

  alu alu_inst (
      .clk(clk),
      .rst(rst),
      .left_operand(left_operand),
      .right_operand(right_operand),
      .alu_op(control.alu_op),
      .alu_res(alu_res_internal),
      .insert_bubble(insert_bubble)
      //.zero_flag(zero_flag)
  );

endmodule
