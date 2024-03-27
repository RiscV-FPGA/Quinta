import common_pkg::*;

module alu (
    input [31:0] left_operand,
    input [31:0] right_operand,
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
