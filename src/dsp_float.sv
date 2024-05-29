import common_pkg::*;

module dsp_float (
    input logic clk,
    input logic rst,
    input alu_op_t alu_op,
    input logic [31:0] left_operand,
    input logic [31:0] right_operand,
    output logic [31:0] int_float_res,
    output logic [31:0] float_int_res,
    output logic [31:0] float_add_res,
    output logic [31:0] float_sub_res,
    output logic float_eq_res,
    output logic float_lt_res,
    output logic float_lte_res,
    output logic [31:0] float_mul_res,
    output logic [31:0] float_div_res,
    output logic [31:0] float_sqrt_res
);

  logic [31:0] left_operand_d;
  logic [31:0] left_operand_dd;
  logic [31:0] right_operand_d;
  logic [31:0] right_operand_dd;

  logic run;
  logic [7:0] i;  // iteration counter
  logic sign;

  logic [31:0] left_operand_unsigned_d;
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
  assign mantissa_long = {left_operand_unsigned_d, 23'b00000000_00000000_0000000};
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
        if (left_operand[31] == 1) begin
          sign <= 1;
          left_operand_unsigned_d <= left_operand_unsigned;
          left_operand_shift <= left_operand_unsigned;
        end else begin
          sign <= 0;
          left_operand_unsigned_d <= left_operand;
          left_operand_shift <= left_operand;
        end
      end else begin
        sign <= sign;
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

  assign float_int_exponent = left_operand_dd[30:23];
  assign float_int_shift = float_int_exponent - 127;
  assign float_int_martisa = {1'b1, left_operand_dd[22:0]};
  assign float_int_martisa_shifted = float_int_martisa >> (23 - float_int_shift);
  assign float_int_martisa_shifted_unsigned = ~float_int_martisa_shifted + 1;

  always_comb begin
    if (left_operand_dd[31] == 1) begin
      float_int_res = {8'b11111111, float_int_martisa_shifted_unsigned};
    end else begin
      float_int_res = {8'b00000000, float_int_martisa_shifted};
    end
  end

  // Float LESS THAN & LESS THAN EQUAL & EQUAL
  always_comb begin
    if (left_operand[31] == 0 && right_operand[31] == 0) begin
      float_lt_res  = left_operand[30:0] < right_operand[30:0];
      float_lte_res = left_operand[30:0] <= right_operand[30:0];
      float_eq_res  = left_operand[30:0] == right_operand[30:0];
    end else if (left_operand[31] == 1 && right_operand[31] == 0) begin
      if (left_operand[30:0] == 0 && right_operand[31] == 0) begin
        float_lt_res = 0;  // negative and possitive zero
        float_eq_res = 1;
      end else begin
        float_lt_res = 1;
        float_eq_res = 0;
      end
      float_lte_res = 1;
    end else if (left_operand[31] == 0 && right_operand[31] == 1) begin
      if (left_operand[30:0] == 0 && right_operand[31] == 0) begin
        float_lte_res = 1;  // negative and possitive zero
        float_eq_res  = 1;
      end else begin
        float_lte_res = 0;
        float_eq_res  = 0;
      end
      float_lt_res = 0;
    end else begin
      float_lt_res  = right_operand[30:0] < left_operand[30:0];
      float_lte_res = right_operand[30:0] <= left_operand[30:0];
      float_eq_res  = left_operand[30:0] == right_operand[30:0];
    end
  end

  // FLOAT ADD & SUB
  logic [31:0] add_left_right;
  logic [30:0] sub_left_right;
  logic [30:0] sub_right_left;

  logic [23:0] right_matrissa_shifted;
  logic [23:0] left_matrissa_shifted;
  logic [ 7:0] exponent_shifted;
  logic [23:0] right_matrissa_shifted_d;
  logic [23:0] left_matrissa_shifted_d;
  logic [ 7:0] exponent_shifted_d;
  logic [23:0] right_matrissa_shifted_dd;
  logic [23:0] left_matrissa_shifted_dd;
  logic [ 7:0] exponent_shifted_dd;

  logic [24:0] add_martisa_unshifted;
  logic [22:0] add_martisa;
  logic [ 7:0] add_exponent;

  logic [23:0] sub_left_right_martisa_unshifted;
  logic [22:0] sub_left_right_martisa;
  logic [ 7:0] sub_left_right_exponent;

  logic [24:0] sub_right_left_martisa_unshifted;
  logic [22:0] sub_right_left_martisa;
  logic [ 7:0] sub_right_left_exponent;

  always_comb begin
    if (left_operand[30:23] > right_operand[30:23]) begin
      right_matrissa_shifted = {1'b1,right_operand[22:0]} >> (left_operand[30:23] - right_operand[30:23]); // verilog_lint:
      exponent_shifted = left_operand[30:23];
      left_matrissa_shifted = {1'b1, left_operand[22:0]};
    end else begin
      left_matrissa_shifted = {1'b1,left_operand[22:0]} >> (right_operand[30:23] - left_operand[30:23]); // verilog_lint:
      exponent_shifted = right_operand[30:23];
      right_matrissa_shifted = {1'b1, right_operand[22:0]};
    end

  end

  always_ff @(posedge clk) begin
    right_matrissa_shifted_d  <= right_matrissa_shifted;
    left_matrissa_shifted_d   <= left_matrissa_shifted;
    exponent_shifted_d        <= exponent_shifted;
    right_matrissa_shifted_dd <= right_matrissa_shifted_d;
    left_matrissa_shifted_dd  <= left_matrissa_shifted_d;
    exponent_shifted_dd       <= exponent_shifted_d;
  end

  // ADD
  assign add_martisa_unshifted = left_matrissa_shifted_dd + right_matrissa_shifted_dd;
  always_comb begin
    if (add_martisa_unshifted[24] == 1) begin
      add_martisa  = add_martisa_unshifted[23:1];
      add_exponent = exponent_shifted_dd + 1;
    end else begin
      add_martisa  = add_martisa_unshifted[22:0];
      add_exponent = exponent_shifted_dd;
    end
  end
  assign add_left_right = {(left_operand_dd[31] & right_operand_dd[31]), add_exponent, add_martisa};

  // SUB LEFT-RIGHT
  assign sub_left_right_martisa_unshifted = left_matrissa_shifted_dd - right_matrissa_shifted_dd;
  always_comb begin
    if (sub_left_right_martisa_unshifted[23] == 0) begin
      sub_left_right_martisa  = {sub_left_right_martisa_unshifted[21:0], 1'b0};  // some rounding?
      sub_left_right_exponent = exponent_shifted_dd - 1;
    end else begin
      sub_left_right_martisa  = sub_left_right_martisa_unshifted[22:0];
      sub_left_right_exponent = exponent_shifted_dd;
    end
  end
  assign sub_left_right = {sub_left_right_exponent, sub_left_right_martisa};

  // SUB RIGHT-LEFT
  assign sub_right_left_martisa_unshifted = right_matrissa_shifted_dd - left_matrissa_shifted_dd;
  always_comb begin
    if (sub_right_left_martisa_unshifted[23] == 0) begin
      sub_right_left_martisa  = {sub_right_left_martisa_unshifted[21:0], 1'b0};
      sub_right_left_exponent = exponent_shifted_dd - 1;
    end else begin
      sub_right_left_martisa  = sub_right_left_martisa_unshifted[22:0];
      sub_right_left_exponent = exponent_shifted_dd;
    end
  end
  assign sub_right_left = {sub_right_left_exponent, sub_right_left_martisa};

  always_comb begin
    if (left_operand_dd[31] == 0 && right_operand_dd[31] == 0) begin  // fix to use _dd
      float_add_res = add_left_right;  //  A+B=A+B
      if (left_operand_dd[30:0] > right_operand_dd[30:0]) begin
        float_sub_res = {1'b0, sub_left_right};
      end else begin
        float_sub_res = {1'b1, sub_right_left};
      end
    end else if (left_operand_dd[31] == 1 && right_operand_dd[31] == 0) begin
      if (left_operand_dd[30:0] > right_operand_dd[30:0]) begin
        float_add_res = {1'b1, sub_left_right};
      end else begin
        float_add_res = {1'b0, sub_right_left};
      end
      float_sub_res = add_left_right;  // -A-B=A+B
    end else if (left_operand_dd[31] == 0 && right_operand_dd[31] == 1) begin
      if (left_operand_dd[30:0] > right_operand_dd[30:0]) begin
        float_add_res = {1'b0, sub_left_right};
      end else begin
        float_add_res = {1'b1, sub_right_left};
      end
      float_sub_res = add_left_right;  //  A--B=A+B
    end else begin
      float_add_res = add_left_right;  // -A+-B=A+B
      if (left_operand_dd[30:0] > right_operand_dd[30:0]) begin
        float_sub_res = {1'b1, sub_left_right};  //  A-B=A-B
      end else begin
        float_sub_res = {1'b0, sub_right_left};  //  A-B=B-A (A<B)
      end
    end
  end

  // FLOAT MUL
  logic        mul_sign;
  logic        mul_sign_d;
  logic        mul_sign_dd;
  logic        mul_sign_ddd;

  logic [ 7:0] mul_exponent_unshifted;
  logic [ 7:0] mul_exponent_unshifted_d;
  logic [ 7:0] mul_exponent_unshifted_dd;
  logic [ 7:0] mul_exponent_unshifted_ddd;
  logic [ 7:0] mul_exponent;

  logic [47:0] mul_martisa_unshifted;
  logic [24:0] mul_martisa_unshifted_d;
  logic [24:0] mul_martisa_unshifted_dd;
  logic [24:0] mul_martisa_unshifted_ddd;
  logic [22:0] mul_martisa;

  assign mul_martisa_unshifted = $unsigned(
      {1'b1, left_matrissa_shifted_dd[22:0]}
  ) * $unsigned(
      {1'b1, right_matrissa_shifted_dd[22:0]}
  );
  assign mul_sign = left_operand_dd[31] ^ right_operand_dd[31];
  assign mul_exponent_unshifted = left_operand_dd[30:23] + right_operand_dd[30:23] - 127;

  always_comb begin
    if (mul_martisa_unshifted_ddd[24] == 1) begin
      mul_martisa  = mul_martisa_unshifted_ddd[23:1];
      mul_exponent = mul_exponent_unshifted_ddd + 1;
    end else begin
      mul_martisa  = mul_martisa_unshifted_ddd[22:0];
      mul_exponent = mul_exponent_unshifted_ddd;
    end
  end
  assign float_mul_res = {mul_sign_ddd, mul_exponent, mul_martisa};

  always_ff @(posedge clk) begin
    left_operand_d <= left_operand;
    left_operand_dd <= left_operand_d;

    right_operand_d <= right_operand;
    right_operand_dd <= right_operand_d;

    mul_sign_d <= mul_sign;
    mul_sign_dd <= mul_sign_d;
    mul_sign_ddd <= mul_sign_dd;

    mul_exponent_unshifted_d <= mul_exponent_unshifted;
    mul_exponent_unshifted_dd <= mul_exponent_unshifted_d;
    mul_exponent_unshifted_ddd <= mul_exponent_unshifted_dd;

    mul_martisa_unshifted_d <= mul_martisa_unshifted[47:23];
    mul_martisa_unshifted_dd <= mul_martisa_unshifted_d;
    mul_martisa_unshifted_ddd <= mul_martisa_unshifted_dd;
  end

  // FLOAT DIV
  logic        div_sign;
  logic [ 7:0] div_exponent_unshifted;
  logic [ 7:0] div_exponent;
  logic [22:0] div_mantissa_unshifted;
  logic [22:0] div_mantissa;

  logic [22:0] right_mantissa_div;
  logic [22:0] quo;
  logic [22:0] quo_next;  // intermediate quotient
  logic [23:0] acc;
  logic [23:0] acc_next;  // accumulator (1 bit wider)
  logic [ 7:0] i_div;  // iteration counter
  logic        run_div;

  // division unsigned algorithm iteration
  always_comb begin
    if (acc >= {1'b0, right_mantissa_div}) begin
      acc_next = (acc - right_mantissa_div) << 1;
      acc_next[0] = quo[22];
      quo_next = quo << 1;
      quo_next[0] = 1'b1;
    end else begin
      acc_next = acc << 1;
      acc_next[0] = quo[22];
      quo_next = quo << 1;
    end
  end

  // calculation control
  always_ff @(posedge clk) begin
    if (rst == 1) begin
      run_div <= 0;
      i_div   <= 0;
    end else begin
      if ((alu_op == ALU_F_DIV) && run_div == 0) begin
        run_div <= 1;
        i_div <= 0;
        right_mantissa_div <= right_operand[22:0];
        acc <= {{23{1'b0}}, left_operand[22]};
        quo <= {left_operand[21:0], 1'b0};

        div_sign <= left_operand[31] ^ right_operand[31];
        div_exponent_unshifted <= left_operand_dd[30:23] - right_operand_dd[30:23] + 127;

      end else begin
        if (i_div == 23 - 1) begin  //done
          run_div <= 0;
          i_div   <= 0;
        end else begin  // next iteration
          i_div <= i_div + 1;
          acc   <= acc_next;
          quo   <= quo_next;
        end
      end
    end
  end
  assign div_mantissa_unshifted = quo_next;

  always_comb begin
    if (div_mantissa_unshifted[22] == 0) begin
      div_mantissa = {div_mantissa_unshifted[21:0], 1'b0};  // some rounding?
      div_exponent = div_exponent_unshifted - 1;
    end else begin
      div_mantissa = div_mantissa_unshifted[22:0];
      div_exponent = div_exponent_unshifted;
    end
  end
  assign float_div_res = {div_sign, div_exponent, div_mantissa};

endmodule
