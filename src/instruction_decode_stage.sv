import common_pkg::*;

module instruction_decode_stage (
    input logic clk,
    input logic rst,
    input instruction_t instruction,
    input logic [31:0] pc,
    output logic [31:0] immediate_data,
    output control_t control
);

  //  control_t control_internal;
  //  logic [31:0] immediate_data_internal;

  control control_inst (
      .instruction(instruction),
      .control(control)
  );

  imm_gen imm_gen_inst (
      .instruction(instruction),
      .control_encoding(control.encoding),
      .immediate_data(immediate_data)
  );

  //assign immediate_data = immediate_data_internal;
  //assign control = control_internal;

endmodule
