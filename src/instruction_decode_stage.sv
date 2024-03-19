import common_pkg::*;

module instruction_decode_stage (
    input logic clk,
    input logic rst,
    input instruction_t instruction,
    input logic [31:0] pc,
    output logic [31:0] immediate_data,
    output control_t control_signals
);

  control control_inst (
      .instruction(instruction),
      .control(control)
  );


endmodule
