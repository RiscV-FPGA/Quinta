`timescale 1ns / 1ps

import common_pkg::*;

module instruction_fetch_stage (
    input  logic                clk,
    input  logic                rst,
    input  logic                start,
    input  logic         [31:0] write_byte_address,
    input  logic         [31:0] write_instr_data,
    input  logic                write_instr_valid,
    input  logic                is_branch,
    input  logic                branch_taken,
    input  logic         [31:0] pc_branch,
    input  logic                hazard_detected,
    output logic         [31:0] pc,
    output instruction_t        instruction
);

  logic [31:0] byte_address;
  logic [31:0] write_data;
  logic [31:0] instruction_internal;

  always_ff @(posedge clk) begin
    if (rst == 1) begin
      pc <= 0;
    end else begin
      if (instruction_internal == 32'b11111111_11111111_11111111_11111111) begin
        pc <= pc;
      end else begin
        if (start == 1) begin
          if (is_branch == 1 & branch_taken == 1) begin
            pc <= pc_branch;
          end else if (hazard_detected == 1) begin
            pc <= pc;
          end else begin
            if (instruction_internal[1:0] == 2'b11) begin
              pc <= pc + 4;  // 32 bit instruction
            end else begin
              pc <= pc + 2;  // 16 bit instruction
            end
          end
        end else begin
          pc <= 0;
        end
      end
    end
  end

  always_comb begin
    if (start == 1) begin
      byte_address = pc;
    end else begin
      // inst from uart
      byte_address = write_byte_address;
    end
  end

  instruction_memory instruction_memory_inst (
      .clk(clk),
      .byte_address(write_byte_address),
      .write_enable(write_enable),
      .write_data(write_instr_data),
      .read_data(instruction_internal)
  );

  decompressor decompressor_inst (
      .instruction_raw(instruction_internal),
      .instruction_out(instruction)
  );

endmodule
