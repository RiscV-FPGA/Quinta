
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
  //shortreal float;
  logic [31:0] float_bits;
  logic [5:0] shift_point;
  logic [7:0] shift_point_biased;
  logic [31:0] left_operand_unsigned;
  logic [22:0] mantissa_long;

  //assign float_bits = $shortrealtobits(float);

  assign float_int_res = float_bits;

  assign float_long = left_operand;
  assign float_long_bits = $realtobits(float_long);
  //assign float_bits = $shortrealtobits(shortreal'(float_long));
  //assign int_float_res = float_bits;
  //assign int_float_res = {float_long_bits[63],float_long_bits[59:52],};

  assign left_operand_unsigned = ~left_operand + 1;
  assign shift_point_biased = shift_point + 127; // exponen
  assign mantissa = {left_operand,32'h00_00_00_00};
  assign int_float_res[31] = {left_operand[31],shift_point_biased[7:0],mantissa};

  always_comb begin
    if (left_operand[31] == 1) begin

    end else begin
      for (i = 0; i < 31; i++) begin
        if (left_operand[i] == 1) begin
          shift_point = i;
          break;
        end
      end
    end

  end


endmodule
