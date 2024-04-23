`timescale 1ns / 1ps
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
    output logic [31:0] data_1,
    output logic [31:0] data_2,
    output logic data_1_valid,
    output logic data_2_valid
);

  always_comb begin
    if (control_mem.write_back_id == rs_1 & control_mem.mem_read == 0) begin
      data_1 = alu_res_mem;
      data_1_valid = 1;
    end else if (control_wb.write_back_id == rs_1) begin
      if (control_wb.mem_read == 1) begin
        data_1 = mem_data_wb;
        data_1_valid = 1;
      end else begin
        data_1 = alu_res_wb;
        data_1_valid = 1;
      end
    end else begin
      data_1 = 0;  // otherwise will create latch
      data_1_valid = 0;
    end

    if (control_mem.write_back_id == rs_2 & control_mem.mem_read == 0) begin
      data_2 = alu_res_mem;
      data_2_valid = 1;
    end else if (control_wb.write_back_id == rs_2) begin
      if (control_wb.mem_read == 1) begin
        data_2 = mem_data_wb;
        data_2_valid = 1;
      end else begin
        data_2 = alu_res_wb;
        data_2_valid = 1;
      end
    end else begin
      data_2 = 0;
      data_2_valid = 0;
    end

  end
endmodule