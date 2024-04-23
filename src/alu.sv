import common_pkg::*;

module alu (
    input logic [31:0] left_operand,
    input logic [31:0] right_operand,
    input alu_op_t alu_op,
    input logic alu_inv_res,
    output logic [31:0] alu_res,
    output logic zero_flag
);

  logic [31:0] internal_alu_res;

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

      ALU_LESS_THAN_UNSIGNED: internal_alu_res = left_operand < right_operand;

      ALU_LESS_THAN_SIGNED: internal_alu_res = $signed(left_operand) < $signed(right_operand);

      ALU_EQUAL: internal_alu_res = left_operand == right_operand;

      default: internal_alu_res = left_operand + right_operand;
    endcase
  end

  always_comb begin
    if (alu_inv_res == 1) begin
      alu_res = ~internal_alu_res;
    end else begin
      alu_res = internal_alu_res;
    end

    if (alu_res == 0) begin
      zero_flag = 1;
    end else begin
      zero_flag = 0;
    end
  end

endmodule
