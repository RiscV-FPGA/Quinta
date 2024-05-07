import common_pkg::*;

module alu (
    input logic clk,
    input logic rst,
    input logic [31:0] left_operand,
    input logic [31:0] right_operand,
    input alu_op_t alu_op,
    input logic alu_inv_res,
    output logic [31:0] alu_res,
    output logic insert_bubble
    //output logic zero_flag
);

  logic [31:0] internal_alu_res;

  logic [31:0] left_operand_d;
  logic [31:0] right_operand_d;
  logic [63:0] mul_res;
  logic [63:0] mul_res_d;  //m-reg
  logic [63:0] mul_res_dd;  // p-reg
  logic [63:0] mul_res_ddd;  // p-reg
  logic [ 1:0] mul_bubble;

  always_comb begin
    case (alu_op)
      ALU_AND: internal_alu_res = left_operand & right_operand;

      ALU_OR: internal_alu_res = left_operand | right_operand;

      ALU_XOR: internal_alu_res = left_operand ^ right_operand;

      ALU_ADD: internal_alu_res = left_operand + right_operand;

      ALU_SUB: internal_alu_res = left_operand - right_operand;

      ALU_SHIFT_LEFT: internal_alu_res = left_operand << right_operand;

      ALU_SHIFT_RIGHT: internal_alu_res = left_operand >> right_operand;

      ALU_SHIFT_RIGHT_AR: internal_alu_res = $signed(left_operand) >>> right_operand;

      ALU_SHIFT_RIGHT_AR_IMM: internal_alu_res = $signed(left_operand) >>> right_operand[4:0];

      ALU_LESS_THAN_UNSIGNED: internal_alu_res = {31'b0, left_operand < right_operand};

      ALU_LESS_THAN_SIGNED:
      internal_alu_res = {31'b0, $signed(left_operand) < $signed(right_operand)};

      ALU_EQUAL: internal_alu_res = {31'b0, left_operand == right_operand};

      ALU_MUL: internal_alu_res = mul_res_ddd[31:0];

      ALU_DIV: internal_alu_res = left_operand + right_operand;
      //  internal_alu_res = left_operand / right_operand;

      default: begin
        internal_alu_res = left_operand + right_operand;
      end
    endcase
  end

  always_ff @(posedge clk) begin
    if (alu_op == ALU_MUL) begin
      left_operand_d <= left_operand;
      right_operand_d <= right_operand;
      mul_res_d <= 'b0;
      mul_res_dd <= 'b0;
      mul_res_ddd <= 'b0;
    end else begin
      left_operand_d <= left_operand;
      right_operand_d <= right_operand;
      mul_res_d <= mul_res;
      mul_res_dd <= mul_res_d;
      mul_res_ddd <= mul_res_dd;
    end
  end

  assign mul_res = left_operand_d * right_operand_d;

  always_ff @(posedge clk) begin
    if (rst == 1) begin
      mul_bubble <= 'b0;
    end else begin
      if (alu_op == ALU_MUL && mul_bubble == 0) begin
        mul_bubble <= 1;
      end

      if (mul_bubble == 3) begin
        mul_bubble <= 0;
      end else if (mul_bubble > 0) begin
        mul_bubble <= mul_bubble + 1;
      end
    end
  end

  always_comb begin
    if ((alu_op == ALU_MUL && mul_bubble == 0) || (mul_bubble > 0 && mul_bubble < 3)) begin
      insert_bubble = 1;
    end else begin
      insert_bubble = 0;
    end
  end

  always_comb begin : out_mux
    if (alu_inv_res == 1) begin
      alu_res = ~internal_alu_res;
    end else begin
      alu_res = internal_alu_res;
    end

    //if (alu_res == 0) begin
    //  zero_flag = 1;
    //end else begin
    //  zero_flag = 0;
    //end
  end

endmodule
