
module dsp_float (
    input logic clk,
    input logic rst,
    input alu_op_t alu_op,
    input logic [31:0] left_operand,
    input logic [31:0] right_operand,
    output logic [31:0] int_float_res,
    output logic [31:0] float_int_res
);

  real float_long;
  logic [63:0] float_long_bits;
  shortreal float;
  logic [31:0] float_bits;

  assign float_long_bits = $realtobits(float_long);
  //assign float_bits = $shortrealtobits(float);

  //assign int_float_res =

  always_comb begin
    float_long = $itor(left_operand);
    float = shortreal'(float_long);
  end

endmodule
