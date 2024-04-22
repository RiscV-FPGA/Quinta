`timescale 1ns / 1ps

import common_pkg::*;

module instruction_fetch_stage (
    input logic clk,
    input logic rst,
    input logic is_branch,
    input logic branch_taken,
    input logic [31:0] pc_branch,
    output logic [31:0] pc,
    output instruction_t instruction
);

  logic start;
  logic [31:0] byte_address;
  logic write_enable;
  logic [31:0] write_data;
  logic [31:0] instruction_internal;

  always_ff @(posedge clk) begin
    if (rst == 1) begin
      start <= 1;
      pc <= 0;
    end else begin
      if (is_branch == 1 & branch_taken == 1) begin
        pc <= pc_branch;
      end else begin
        if (instruction_internal[1:0] == 2'b11) begin
          pc <= pc + 4;  // 32 bit instruction
        end else begin
          pc <= pc + 2;  // 16 bit instruction
        end
      end
    end
  end

  always_comb begin
    if (start == 1) begin
      byte_address = pc;
    end else begin
      //byte_address = uart...
      byte_address = pc;
    end
  end

  instruction_memory instruction_memory_inst (
      .clk(clk),
      .byte_address(byte_address),
      .write_enable(write_enable),
      .write_data(write_data),
      .read_data(instruction_internal)
  );

  // include decompressor
  decompressor decompressor_inst (
      .instruction_raw(instruction_internal),
      .instruction_out(instruction)
  );

endmodule
