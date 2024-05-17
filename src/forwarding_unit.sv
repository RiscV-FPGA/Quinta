import common_pkg::*;

module forwarding_unit (
    input logic clk,
    input logic rst,
    input control_t control_mem,
    input control_t control_wb,
    input logic [31:0] alu_res_mem,
    input logic [31:0] alu_res_wb,
    input logic [31:0] mem_data_wb,
    input logic [4:0] rs_1,
    input logic [4:0] rs_2,
    input logic reg_read_float,
    output logic [31:0] data_1,
    output logic [31:0] data_2,
    output logic data_1_valid,
    output logic data_2_valid
);

  logic mem_rs_1;
  logic mem_rs_2;
  logic wb_rs_1;
  logic wb_rs_2;

  logic mem_forward;
  logic mem_forward_float;
  logic wb_forward_alu_res;
  logic wb_forward_alu_res_float;
  logic wb_forward_mem_res;
  logic wb_forward_mem_res_float;

  assign mem_rs_1 = control_mem.write_back_id == rs_1;
  assign mem_rs_2 = control_mem.write_back_id == rs_2;
  assign wb_rs_1 = control_wb.write_back_id == rs_1;
  assign wb_rs_2 = control_wb.write_back_id == rs_2;

  assign mem_forward = control_mem.mem_read == MEM_NO_OP && control_mem.reg_write && reg_read_float == 0; // verilog_lint:
  assign mem_forward_float = control_mem.mem_read == MEM_NO_OP && control_mem.reg_write_float && reg_read_float == 1; // verilog_lint:

  assign wb_forward_alu_res = control_wb.mem_read == MEM_NO_OP && control_wb.reg_write && reg_read_float == 0; // verilog_lint:
  assign wb_forward_alu_res_float = control_wb.mem_read == MEM_NO_OP && control_wb.reg_write && reg_read_float == 1; // verilog_lint:
  assign wb_forward_mem_res =  control_wb.mem_read != MEM_NO_OP && control_wb.reg_write && reg_read_float == 0; // verilog_lint:
  assign wb_forward_mem_res_float = control_wb.mem_read != MEM_NO_OP && control_wb.reg_write && reg_read_float == 1; // verilog_lint:

  always_comb begin
    if (mem_rs_1 && mem_forward) begin
      data_1 = alu_res_mem;
      data_1_valid = 1;
    end else if (mem_rs_1 && mem_forward_float) begin
      data_1 = alu_res_mem;
      data_1_valid = 1;
    end else if (wb_rs_1 && wb_forward_alu_res) begin
      data_1 = alu_res_wb;
      data_1_valid = 1;
    end else if (wb_rs_1 && wb_forward_mem_res) begin
      data_1 = mem_data_wb;
      data_1_valid = 1;
    end else if (wb_rs_1 && wb_forward_alu_res_float) begin
      data_1 = alu_res_wb;
      data_1_valid = 1;
    end else if (wb_rs_1 && wb_forward_mem_res_float) begin
      data_1 = mem_data_wb;
      data_1_valid = 1;
    end else begin
      data_1 = 0;  // otherwise will create latch
      data_1_valid = 0;
    end

    if (mem_rs_2 && mem_forward) begin
      data_2 = alu_res_mem;
      data_2_valid = 1;
    end else if (mem_rs_2 && mem_forward_float) begin
      data_2 = alu_res_mem;
      data_2_valid = 1;
    end else if (wb_rs_2 && wb_forward_alu_res) begin
      data_2 = alu_res_wb;
      data_2_valid = 1;
    end else if (wb_rs_2 && wb_forward_mem_res) begin
      data_2 = mem_data_wb;
      data_2_valid = 1;
    end else if (wb_rs_2 && wb_forward_alu_res_float) begin
      data_2 = alu_res_wb;
      data_2_valid = 1;
    end else if (wb_rs_2 && wb_forward_mem_res_float) begin
      data_2 = mem_data_wb;
      data_2_valid = 1;
    end else begin
      data_2 = 0;
      data_2_valid = 0;
    end

  end
endmodule
