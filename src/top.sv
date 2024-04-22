`timescale 1ns / 1ps

import common_pkg::*;

module top (
    input logic sys_clk,
    input logic rst,
    input logic finish    // for tb (read registers at end)
);

  logic                clk;

  instruction_t        instruction_fetch;
  logic         [31:0] pc_fetch;


  instruction_t        instruction_decode;
  logic         [31:0] pc_decode;
  control_t            control_decode;
  logic         [31:0] read1_data_decode;
  logic         [31:0] read2_data_decode;
  logic         [31:0] immediate_data_decode;


  control_t            control_execute;
  logic         [31:0] data1_execute;
  logic         [31:0] data2_execute;
  logic         [31:0] immediate_data_execute;
  logic         [31:0] alu_res_execute;
  logic         [31:0] mem_data_execute;
  logic         [31:0] pc_execute;
  logic                is_branch_execute;
  logic                branch_taken_execute;
  logic         [31:0] pc_branch_execute;


  control_t            control_mem;
  logic         [31:0] alu_res_in_mem;
  logic         [31:0] mem_data_in_mem;
  logic         [31:0] mem_data_out_mem;


  control_t            control_wb;
  logic         [31:0] alu_res_wb;
  logic         [31:0] mem_data_wb;
  logic         [31:0] wb_data_wb;  // to decode for saving


  always_ff @(posedge clk) begin
    if (rst == 1) begin

    end else begin
      //id_reg <= if_reg
      instruction_decode <= instruction_fetch;
      pc_decode <= pc_fetch;

      if (is_branch_execute == 1 & branch_taken_execute == 1) begin
        control_execute <= '0;
        control_mem <= '0;
      end else begin
        control_execute <= control_decode;
        control_mem <= control_execute;
      end

      //ex_reg <= id_reg
      pc_execute <= pc_decode;
      data1_execute <= read1_data_decode;
      data2_execute <= read2_data_decode;
      immediate_data_execute <= immediate_data_decode;

      //mem_reg <= ex_reg
      alu_res_in_mem <= alu_res_execute;
      mem_data_in_mem <= mem_data_execute;

      //wb_reg <= mem_reg
      control_wb <= control_mem;
      alu_res_wb <= alu_res_in_mem;
      mem_data_wb <= mem_data_out_mem;

    end
  end

  assign clk = sys_clk;

  //clk_wiz_wrapper clk_wiz_wrapper_inst (
  //    .clk_100(sys_clk),
  //    .rst(rst),
  //    .clk_85(clk)
  //);

  instruction_fetch_stage instruction_fetch_stage_inst (
      .clk(clk),
      .rst(rst),
      .is_branch(is_branch_execute),
      .branch_taken(branch_taken_execute),
      .pc_branch(pc_branch_execute),
      .pc(pc_fetch),
      .instruction(instruction_fetch)
  );

  instruction_decode_stage instruction_decode_stage_inst (
      .clk(clk),
      .rst(rst),
      .instruction(instruction_decode),
      .pc(pc_decode),
      .reg_write(control_wb.reg_write),
      .write_id(control_wb.write_back_id),
      .write_data(wb_data_wb),
      .immediate_data(immediate_data_decode),
      .control(control_decode),
      .read1_data(read1_data_decode),
      .read2_data(read2_data_decode),
      .finish(finish)  // for tb print
  );

  execute_stage execute_stage_inst (
      .clk(clk),
      .rst(rst),
      .data1(data1_execute),
      .data2(data2_execute),
      .immediate_data(immediate_data_execute),
      .control(control_execute),
      .pc_execute(pc_execute),
      .alu_res(alu_res_execute),
      .mem_data(mem_data_execute),
      .is_branch(is_branch_execute),
      .branch_taken(branch_taken_execute),
      .pc_branch(pc_branch_execute)
  );

  memory_stage memory_stage_inst (
      .clk(clk),
      .rst(rst),
      .alu_res_in(alu_res_in_mem),
      .mem_data_in(mem_data_in_mem),
      .control(control_mem),
      .mem_data_out(mem_data_out_mem)
  );

  writeback_stage writeback_stage_inst (
      .clk(clk),
      .rst(rst),
      .control(control_wb),
      .alu_res(alu_res_wb),
      .mem_data(mem_data_wb),
      .wb_data(wb_data_wb)
  );


endmodule
