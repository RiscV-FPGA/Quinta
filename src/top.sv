import common_pkg::*;

module top (
    input logic clk,
    input logic rst

);

  logic [31:0] pc;
  instruction_t instruction;
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

  instruction_fetch_stage instruction_fetch_stage_inst ();

  instruction_decode_stage instruction_decode_stage_inst (
      .clk(clk),
      .rst(rst),
      .instruction(instruction),
      .pc(pc),
      .immediate_data(immediate_data),
      .control(control)
  );

  execute_stage execute_stage_inst ();

  memory_stage memory_stage_inst ();

  writeback_stage writeback_stage_inst ();


endmodule
