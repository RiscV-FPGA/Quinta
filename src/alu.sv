import common_pkg::*;

module alu (
    input logic [31:0] left_operand,
    input logic [31:0] right_operand,
    input alu_op_t alu_op,
    output logic [31:0] alu_res,
    output logic zero_flag
);

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

      ALU_LESS_THAN_UNSIGNED: alu_res = left_operand < right_operand;

      ALU_LESS_THAN_SIGNED: alu_res = $signed(left_operand) < $signed(right_operand);

      default: alu_res = left_operand + right_operand;
    endcase
  end

  always_comb begin
    if (alu_res == 0) begin
      zero_flag = 1;
    end else begin
      zero_flag = 0;
    end
  end

endmodule
