import common_pkg::*;

module top (
    input logic clk,
    input logic rst
);

  logic [31:0] pc_fetch;
  instruction_t instruction_fetch;


  logic [31:0] pc_decode;
  instruction_t instruction_decode;

  logic [31:0] read1_data_decode;
  logic [31:0] read2_data_decode;
  logic [31:0] immediate_data_decode;

  logic [31:0] data1_execute;
  logic [31:0] data2_execute;
  logic [31:0] immediate_data_execute;
  control_t control_execute;
  logic [31:0] alu_res_execute;
  logic [31:0] mem_data_execute;


  control_t control;
  logic [31:0] immediate_data;

  always_ff @(posedge clk) begin
    if (rst == 1) begin

    end else begin
      //id_reg <= if_reg


      //ex_reg <= id_reg


      //mem_reg <= ex_reg


      //wb_reg <= mem_reg


    end
  end

  instruction_fetch_stage instruction_fetch_stage_inst (
      .clk(clk),
      .rst(rst),
      .pc(pc_fetch),
      .instruction(instruction_fetch)
  );

  instruction_decode_stage instruction_decode_stage_inst (
      .clk(clk),
      .rst(rst),
      .instruction(instruction_decode),
      .pc(pc_decode),
      .reg_write(reg_write),  // fix
      .write_id(write_id),  // fix
      .write_data(write_data),  // fix
      .immediate_data(immediate_data_decode),
      .control(control_decode),
      .read1_data(read1_data_decode),
      .read2_data(read2_data_decode)
  );

  execute_stage execute_stage_inst (
      .clk(clk),
      .rst(rst),
      .data1(data1_execute),
      .data2(data2_execute),
      .immediate_data(immediate_data_execute),
      .control(control_execute),
      .alu_res(alu_res_execute),
      .mem_data(mem_data_execute)
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
