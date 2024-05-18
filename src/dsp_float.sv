
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

  always_ff @(posedge clk) begin
    left_operand_d   <= left_operand;
    left_operand_dd  <= left_operand_d;
    right_operand_d  <= right_operand;
    right_operand_dd <= right_operand_d;
  end

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

  // FLOAT ADD
  logic [31:0] add_left_right;
  logic [30:0] sub_left_right;
  logic [30:0] sub_right_left;

  logic [23:0] right_operand_add;
  logic [23:0] left_operand_add;
  logic [ 7:0] exponent_add;
  logic [23:0] right_operand_add_d;
  logic [23:0] left_operand_add_d;
  logic [ 7:0] exponent_add_d;

  logic [24:0] add_martisa_unshifted;
  logic [22:0] add_martisa;
  logic [ 7:0] add_exponent;

  logic [23:0] sub_left_right_martisa_unshifted;
  logic [22:0] sub_left_right_martisa;
  logic [ 7:0] sub_left_right_exponent;

  logic [24:0] sub_right_left_martisa_unshifted;
  logic [22:0] sub_right_left_martisa;
  logic [ 7:0] sub_right_left_exponent;

  always_ff @(posedge clk) begin
    if (left_operand[30:23] > right_operand[30:23]) begin
      right_operand_add <= {1'b1,right_operand[22:0]} >> (left_operand[30:23] - right_operand[30:23]); // verilog_lint:
      exponent_add <= left_operand[30:23];
      left_operand_add <= {1'b1, left_operand[22:0]};
    end else begin
      left_operand_add <= {1'b1,left_operand[22:0]} >> (right_operand[30:23] - left_operand[30:23]); // verilog_lint:
      exponent_add <= right_operand[30:23];
      right_operand_add <= {1'b1, right_operand[22:0]};
    end

    right_operand_add_d <= right_operand_add;
    left_operand_add_d  <= left_operand_add;
    exponent_add_d      <= exponent_add;
  end

  // ADD
  assign add_martisa_unshifted = left_operand_add_d[23:0] + right_operand_add_d[23:0];
  always_comb begin
    if (add_martisa_unshifted[24] == 1) begin
      add_martisa  = add_martisa_unshifted[23:1];
      add_exponent = exponent_add_d + 1;
    end else begin
      add_martisa  = add_martisa_unshifted[22:0];
      add_exponent = exponent_add_d;
    end
  end
  assign add_left_right = {(left_operand_dd[31] & right_operand_dd[31]), add_exponent, add_martisa};

  // SUB LEFT-RIGHT
  assign sub_left_right_martisa_unshifted = left_operand_add_d[23:0] - right_operand_add_d[23:0];
  always_comb begin
    if (sub_left_right_martisa_unshifted[23] == 0) begin
      sub_left_right_martisa  = {sub_left_right_martisa_unshifted[21:0], 1'b0};  // some rounding?
      sub_left_right_exponent = exponent_add_d - 1;
    end else begin
      sub_left_right_martisa  = sub_left_right_martisa_unshifted[22:0];
      sub_left_right_exponent = exponent_add_d;
    end
  end
  assign sub_left_right = {sub_left_right_exponent, sub_left_right_martisa};

  // SUB RIGHT-LEFT
  assign sub_right_left_martisa_unshifted = right_operand_add_d[23:0] - left_operand_add_d[23:0];
  always_comb begin
    if (sub_right_left_martisa_unshifted[23] == 0) begin
      sub_right_left_martisa  = {sub_right_left_martisa_unshifted[21:0], 1'b0};
      sub_right_left_exponent = exponent_add_d - 1;
    end else begin
      sub_right_left_martisa  = sub_right_left_martisa_unshifted[22:0];
      sub_right_left_exponent = exponent_add_d;
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

endmodule
