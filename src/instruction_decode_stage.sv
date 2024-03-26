import common_pkg::*;

module instruction_decode_stage (
    input logic clk,
    input logic rst,
    input instruction_t instruction,
    input logic [31:0] pc,
    input logic reg_write,
    input logic [4:0] write_id,
    input logic [31:0] write_data,
    output logic [31:0] immediate_data,
    output control_t control,
    output logic [31:0] read1_data,
    output logic [31:0] read2_data
);

  //  control_t control_internal;
  //  logic [31:0] immediate_data_internal;

  control control_inst (
      .instruction(instruction),
      .control(control)
  );

  registers registers_inst (
      .clk(clk),
      .rst(rst),
      .read1_id(instruction.block3),
      .read2_id(instruction.block4),
      .write_en(reg_write),  // reg_write
      .write_id(write_id),
      .write_data(write_data),
      .read1_data(read1_data),
      .read2_data(read2_data)
  );

  imm_gen imm_gen_inst (
      .instruction(instruction),
      .control_encoding(control.encoding),
      .immediate_data(immediate_data)
  );

  //assign immediate_data = immediate_data_internal;
  //assign control = control_internal;

endmodule
