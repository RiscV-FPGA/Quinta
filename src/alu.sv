import common_pkg::*;

module alu (
    input logic clk,
    input logic rst,
    input logic [31:0] left_operand,
    input logic [31:0] right_operand,
    input alu_op_t alu_op,
    output logic [31:0] alu_res,
    output logic insert_bubble
    //output logic zero_flag
);

  logic [63:0] mul_res;

  logic [31:0] div_res_unsigned;
  logic [31:0] rem_res_unsigned;
  logic [31:0] div_res_signed;
  logic [31:0] rem_res_signed;

  logic [31:0] int_float_res;
  logic [31:0] float_int_res;
  logic [31:0] float_add_res;
  logic [31:0] float_sub_res;

  logic [7:0] bubble_1;
  logic [7:0] bubble_2;
  logic [7:0] bubble_6;
  logic [7:0] bubble_32;


  logic alu_mul;
  logic alu_div;
  logic alu_float_32;
  logic alu_float_2;
  logic alu_float_1;


  always_comb begin
    case (alu_op)
      ALU_AND: alu_res = left_operand & right_operand;

      ALU_OR: alu_res = left_operand | right_operand;

      ALU_XOR: alu_res = left_operand ^ right_operand;

      ALU_ADD: alu_res = left_operand + right_operand;

      ALU_SUB: alu_res = left_operand - right_operand;

      ALU_SHIFT_LEFT: alu_res = left_operand << right_operand;

      ALU_SHIFT_RIGHT: alu_res = left_operand >> right_operand;

      ALU_SHIFT_RIGHT_AR: alu_res = $signed(left_operand) >>> right_operand;

      ALU_SHIFT_RIGHT_AR_IMM: alu_res = $signed(left_operand) >>> right_operand[4:0];

      ALU_LESS_THAN_UNSIGNED: alu_res = {31'b0, left_operand < right_operand};

      ALU_LESS_THAN_SIGNED: alu_res = {31'b0, $signed(left_operand) < $signed(right_operand)};

      ALU_EQUAL: alu_res = {31'b0, left_operand == right_operand};

      ALU_MUL: alu_res = mul_res[31:0];

      ALU_MULH: alu_res = mul_res[63:32];

      ALU_DIV: alu_res = div_res_signed;

      ALU_DIVU: alu_res = div_res_unsigned;

      ALU_REM: alu_res = rem_res_signed;

      ALU_REMU: alu_res = rem_res_unsigned;

      // float
      ALU_F_INT_FLOAT: alu_res = int_float_res;

      ALU_F_FLOAT_INT: alu_res = float_int_res;

      ALU_F_ADD: alu_res = float_add_res;

      ALU_F_SUB: alu_res = float_sub_res;

      default: begin
        alu_res = left_operand + right_operand;
      end
    endcase
  end

  assign alu_mul = (alu_op == ALU_MUL || alu_op == ALU_MULH) ? 1'b1 : 1'b0;

  assign alu_div = (alu_op == ALU_DIV || alu_op == ALU_DIVU
  || alu_op == ALU_REM || alu_op == ALU_REMU) ? 1'b1 : 1'b0; // long statement be careful :)

  assign alu_float_32 = (alu_op == ALU_F_INT_FLOAT) ? 1'b1 : 1'b0;
  assign alu_float_2 = (alu_op == ALU_F_ADD || alu_op == ALU_F_SUB) ? 1'b1 : 1'b0;
  assign alu_float_1 = (alu_op == ALU_F_FLOAT_INT) ? 1'b1 : 1'b0;

  dsp_mul dsp_mul_inst (  // MUL START
      .clk(clk),
      .left_operand(left_operand),
      .right_operand(right_operand),
      .mul_res(mul_res)
  );  // MUL END

  dsp_div dsp_div_inst (  // DIV REM START
      .clk(clk),
      .rst(rst),
      .alu_op(alu_op),
      .left_operand(left_operand),
      .right_operand(right_operand),
      .div_res_unsigned(div_res_unsigned),
      .rem_res_unsigned(rem_res_unsigned),
      .div_res_signed(div_res_signed),
      .rem_res_signed(rem_res_signed)
  );  // DIV REM END


  dsp_float dsp_float_inst (  // FLOAT START
      .clk(clk),
      .rst(rst),
      .alu_op(alu_op),
      .left_operand(left_operand),
      .right_operand(right_operand),
      .int_float_res(int_float_res),
      .float_int_res(float_int_res),
      .float_add_res(float_add_res),
      .float_sub_res(float_sub_res)
  );  // FLOAT END

  // BUBBLE START
  always_ff @(posedge clk) begin
    if (rst == 1) begin
      bubble_2  <= 0;
      bubble_2  <= 0;
      bubble_6  <= 0;
      bubble_32 <= 0;

    end else begin
      if (alu_float_1 && bubble_1 == 0) begin
        bubble_1 <= 1;
      end else if (alu_float_2 && bubble_2 == 0) begin
        bubble_2 <= 1;
      end else if (alu_mul && bubble_6 == 0) begin
        bubble_6 <= 1;
      end else if ((alu_float_32 || alu_div) && bubble_32 == 0) begin
        bubble_32 <= 1;
      end

      if (bubble_1 == 1) begin
        bubble_1 <= 0;
      end else if (bubble_1 > 0) begin
        bubble_1 <= bubble_1 + 1;
      end

      if (bubble_2 == 2) begin
        bubble_2 <= 0;
      end else if (bubble_2 > 0) begin
        bubble_2 <= bubble_2 + 1;
      end

      if (bubble_6 == 6) begin
        bubble_6 <= 0;
      end else if (bubble_6 > 0) begin
        bubble_6 <= bubble_6 + 1;
      end

      if (bubble_32 == 32) begin
        bubble_32 <= 0;
      end else if (bubble_32 > 0) begin
        bubble_32 <= bubble_32 + 1;
      end
    end
  end

  always_comb begin
    if ((alu_float_1 && bubble_1 == 0) || (bubble_1 > 0 && bubble_1 < 1)) begin
      insert_bubble = 1;
    end else if ((alu_float_2 && bubble_2 == 0) || (bubble_2 > 0 && bubble_2 < 2)) begin
      insert_bubble = 1;
    end else if ((alu_mul && bubble_6 == 0) || (bubble_6 > 0 && bubble_6 < 6)) begin
      insert_bubble = 1;
    end else if (((alu_float_32||alu_div)&& bubble_32 == 0)||(bubble_32 > 0 && bubble_32 < 32))begin
      insert_bubble = 1;
    end else begin
      insert_bubble = 0;
    end
  end
  //BUBBLE END

endmodule
