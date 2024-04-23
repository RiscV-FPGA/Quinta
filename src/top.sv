`timescale 1ns / 1ps

import common_pkg::*;

module top (
    input logic sys_clk,
    input logic rst,
    input logic finish,  // for tb (read registers at end)
    input logic rx_serial,
    output logic [3:0] vga_r,
    output logic [3:0] vga_g,
    output logic [3:0] vga_b,
    output logic vga_hsync,
    output logic vga_vsync
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
  logic         [ 4:0] rs1_decode;
  logic         [ 4:0] rs2_decode;
  logic                hazard_detected_decode;


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
  logic         [ 4:0] rs1_execute;
  logic         [ 4:0] rs2_execute;


  control_t            control_mem;
  logic         [31:0] alu_res_in_mem;
  logic         [31:0] mem_data_in_mem;
  logic         [31:0] mem_data_out_mem;

  logic         [31:0] forwarding_data_1;
  logic         [31:0] forwarding_data_2;
  logic                forwarding_data_1_valid;
  logic                forwarding_data_2_valid;


  control_t            control_wb;
  logic         [31:0] alu_res_wb;
  logic         [31:0] mem_data_wb;
  logic         [31:0] wb_data_wb;  // to decode for saving

  // ONLY FOR TB
  logic         [ 7:0] sdl_r;
  logic         [ 7:0] sdl_g;
  logic         [ 7:0] sdl_b;
  logic         [31:0] sdl_sx;
  logic         [31:0] sdl_sy;
  logic                sdl_de;

  assign led = pc_fetch[15:0];

  always_ff @(posedge clk) begin
    if (rst == 1) begin

    end else begin
      //id_reg <= if_reg
      if (hazard_detected_decode == 1) begin
        instruction_decode <= instruction_decode;
        pc_decode          <= pc_decode;
      end else begin
        instruction_decode <= instruction_fetch;
        pc_decode <= pc_fetch;
      end


      //ex_reg <= id_reg
      if (hazard_detected_decode == 1) begin
        // nop
        pc_execute <= 0;
        data1_execute <= 0;
        data2_execute <= 0;
        immediate_data_execute <= 0;
        rs1_execute <= 0;
        rs2_execute <= 0;
        control_execute <= '0;
      end else begin
        pc_execute <= pc_decode;
        data1_execute <= read1_data_decode;
        data2_execute <= read2_data_decode;
        immediate_data_execute <= immediate_data_decode;
        rs1_execute <= rs1_decode;
        rs2_execute <= rs2_decode;
        if (is_branch_execute == 1 & branch_taken_execute == 1) begin
          control_execute <= '0;
          rs1_execute <= 0;
          rs2_execute <= 0;
        end else begin
          control_execute <= control_decode;
        end
      end

      //mem_reg <= ex_reg
      alu_res_in_mem  <= alu_res_execute;
      mem_data_in_mem <= mem_data_execute;
      if (is_branch_execute == 1 & branch_taken_execute == 1) begin
        control_mem <= '0;
      end else begin
        control_mem <= control_execute;
      end

      //wb_reg <= mem_reg
      control_wb  <= control_mem;
      alu_res_wb  <= alu_res_in_mem;
      mem_data_wb <= mem_data_out_mem;

    end
  end

  assign clk = sys_clk;

  instruction_fetch_stage instruction_fetch_stage_inst (
      .clk(clk),
      .rst(rst),
      .is_branch(is_branch_execute),
      .branch_taken(branch_taken_execute),
      .pc_branch(pc_branch_execute),
      .hazard_detected(hazard_detected_decode),
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
      .rs1(rs1_decode),
      .rs2(rs2_decode),
      .finish(finish)  // for tb print
  );

  hazard_detection_unit hazard_detection_unit_inst (
      .clk(clk),
      .rst(rst),
      .rs1(rs1_decode),
      .rs2(rs2_decode),
      .control_ex(control_execute),
      .hazard_detected(hazard_detected_decode)
  );

  execute_stage execute_stage_inst (
      .clk(clk),
      .rst(rst),
      .data1(data1_execute),
      .data2(data2_execute),
      .immediate_data(immediate_data_execute),
      .control(control_execute),
      .pc_execute(pc_execute),
      .fw_data_1(forwarding_data_1),
      .fw_data_2(forwarding_data_2),
      .fw_data_1_valid(forwarding_data_1_valid),
      .fw_data_2_valid(forwarding_data_2_valid),
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

  forwarding_unit forwarding_unit_inst (
      .clk(clk),
      .rst(rst),
      .control_mem(control_mem),
      .control_wb(control_wb),
      .alu_res_mem(alu_res_in_mem),
      .alu_res_wb(alu_res_wb),
      .mem_data_wb(mem_data_wb),
      .rs_1(rs1_execute),
      .rs_2(rs2_execute),
      .data_1(forwarding_data_1),
      .data_2(forwarding_data_2),
      .data_1_valid(forwarding_data_1_valid),
      .data_2_valid(forwarding_data_2_valid)
  );

  writeback_stage writeback_stage_inst (
      .clk(clk),
      .rst(rst),
      .control(control_wb),
      .alu_res(alu_res_wb),
      .mem_data(mem_data_wb),
      .wb_data(wb_data_wb)
  );

  vga vga_inst (
      .clk(clk),
      .rst(rst),
      .vga_vsync(vga_vsync),
      .vga_hsync(vga_hsync),
      .vga_r(vga_r),
      .vga_g(vga_g),
      .vga_b(vga_b),
      .sdl_r(sdl_r),
      .sdl_g(sdl_g),
      .sdl_b(sdl_b),
      .sdl_sx(sdl_sx),
      .sdl_sy(sdl_sy),
      .sdl_de(sdl_de)
  );

endmodule
