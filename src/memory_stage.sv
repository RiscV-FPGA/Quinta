import common_pkg::*;

module memory_stage (
    input clk,
    input rst,
    input [31:0] alu_res_in,
    input [31:0] mem_data_in,
    input control_t control,
    output logic [31:0] mem_data_out
);

  data_memory data_memory_inst (
      .clk(clk),
      .byte_address(alu_res_in),
      .write_enable(control.mem_write),
      .write_data(mem_data_in),
      .read_data(mem_data_out)
  );

endmodule
