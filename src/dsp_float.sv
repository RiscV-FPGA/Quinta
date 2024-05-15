
module dsp_float (
    input logic clk,
    input logic rst,
    input alu_op_t alu_op,
    input logic [31:0] left_operand,
    input logic [31:0] right_operand,
    output logic [31:0] int_float_res,
    output logic [31:0] float_int_res,
    output logic [31:0] float_add_res
);

  logic run;
  logic [7:0] i;  // iteration counter
  logic sign;

  logic [31:0] right_operand_d;
  logic [31:0] left_operand_d;
  logic [31:0] left_operand_shift;
  logic [31:0] left_operand_shift_next;

  logic [7:0] shift_point;
  logic [7:0] shift_point_biased;
  logic [31:0] left_operand_unsigned;
  logic [54:0] mantissa_long;
  logic [54:0] mantissa_long_shifted;
  logic [22:0] mantissa;

  assign left_operand_unsigned = ~left_operand + 1;

  assign shift_point_biased = shift_point + 127;  // exponen
  assign mantissa_long = {left_operand_d, 23'b00000000_00000000_0000000};
  assign mantissa_long_shifted = mantissa_long >> shift_point;
  assign mantissa = mantissa_long_shifted[22:0];
  assign int_float_res = {sign, shift_point_biased[7:0], mantissa};

  always_ff @(posedge clk) begin
    if (rst == 1) begin
      run  <= 0;
      i    <= 0;
      sign <= 0;
    end else begin
      if ((alu_op == ALU_F_INT_FLOAT) && run == 0) begin
        run <= 1;
        i   <= 0;
        //right_operand_d <= right_operand;
        if (left_operand[31] == 1) begin
          sign <= 1;
          left_operand_d <= left_operand_unsigned;
          left_operand_shift <= left_operand_unsigned;
        end else begin
          sign <= 0;
          left_operand_d <= left_operand;
          left_operand_shift <= left_operand;
        end
      end else begin
        if (i == 32 - 1) begin  //done
          run <= 0;
          i   <= 0;
        end else begin  // next iteration
          i <= i + 1;
          left_operand_shift <= left_operand_shift >> 1;
          if (left_operand_shift[0] == 1) begin
            shift_point <= i;
          end else begin
            shift_point <= shift_point;
          end
        end
      end
    end
  end

  logic [ 7:0] float_int_exponent;
  logic [ 7:0] float_int_shift;
  logic [23:0] float_int_martisa;
  logic [23:0] float_int_martisa_shifted;
  logic [23:0] float_int_martisa_shifted_unsigned;

  assign float_int_exponent = left_operand[30:23];
  assign float_int_shift = float_int_exponent - 127;
  assign float_int_martisa = {1'b1, left_operand[22:0]};
  assign float_int_martisa_shifted = float_int_martisa >> (23 - float_int_shift);
  assign float_int_martisa_shifted_unsigned = ~float_int_martisa_shifted + 1;

  always_comb begin
    if (left_operand[31] == 1) begin
      float_int_res = {8'b11111111, float_int_martisa_shifted_unsigned};
    end else begin
      float_int_res = {8'b00000000, float_int_martisa_shifted};
    end
  end

  // FLOAT ADD
  /* verilator lint_off UNOPTFLAT */ // FIX THIS!
/*  logic [32:0] right_operand_add;
  logic [32:0] left_operand_add;

  logic [24:0] add_martisa;
  logic [ 7:0] add_exponent;

  always_comb begin
    if (left_operand[30:23] > right_operand[30:23]) begin
      right_operand_add[23:0] = {1'b1,right_operand[22:0]} >> (left_operand[30:23] - right_operand[30:23]);
      right_operand_add[31:24] = left_operand[30:23];
      right_operand_add[32] = right_operand[31];
      left_operand_add = {left_operand[31], left_operand[30:23], 1'b1, left_operand[22:0]};
    end else begin
      left_operand_add[23:0] = {1'b1,left_operand[22:0]} >> (right_operand[30:23] - left_operand[30:23]);
      left_operand_add[31:24] = right_operand[30:23];
      left_operand_add[32] = left_operand[31];
      right_operand_add = {right_operand[31], right_operand[30:23], 1'b1, right_operand[22:0]};
    end

    if (add_martisa[24] == 1) begin
      float_add_res = {(left_operand[31] & right_operand[31]), add_exponent, add_martisa[23:1]};
    end else begin
      float_add_res = {
        (left_operand[31] & right_operand[31]), left_operand_add[31:24], add_martisa[22:0]
      };
    end
  end

  assign add_martisa  = left_operand_add[23:0] + right_operand[23:0];
  assign add_exponent = left_operand_add[31:24] + 1;
  /* verilator lint_on UNOPTFLAT */

endmodule
