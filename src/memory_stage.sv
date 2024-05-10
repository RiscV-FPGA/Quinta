import common_pkg::*;

module memory_stage (
    input logic clk,
    input logic rst,
    input logic [31:0] alu_res_in,
    input logic [31:0] mem_data_in,
    input control_t control,
    output logic [31:0] mem_data_out,
    output logic [31:0] mem_data_in_vga
);

  logic [31:0] mem_data_internal_in;
  logic [31:0] mem_data_internal_out;

  logic mem_data_valid;
  assign mem_data_valid  = (control.mem_write == 2'b00) ? 1'b0 : 1'b1;
  assign mem_data_in_vga = mem_data_internal_in;

  always_comb begin : IN_MUX
    if (control.mem_write == MEM_HALF_WORD) begin
      mem_data_internal_in = {16'b00000000_00000000, mem_data_in[15:0]};
    end else if (control.mem_write == MEM_BYTE) begin
      mem_data_internal_in = {24'b00000000_00000000_00000000, mem_data_in[7:0]};
    end else begin
      mem_data_internal_in = mem_data_in;
    end
  end

  data_memory data_memory_inst (
      .clk(clk),
      .byte_address(alu_res_in),
      .write_enable(mem_data_valid),
      .write_data(mem_data_internal_in),
      .read_data(mem_data_internal_out)
  );

  always_comb begin : OUT_MUX
    if (control.mem_read == MEM_HALF_WORD) begin
      mem_data_out = {16'b00000000_00000000, mem_data_internal_out[15:0]};
    end else if (control.mem_read == MEM_BYTE) begin
      mem_data_out = {24'b00000000_00000000_00000000, mem_data_internal_out[7:0]};
    end else begin
      mem_data_out = mem_data_internal_out;
    end
  end

endmodule
