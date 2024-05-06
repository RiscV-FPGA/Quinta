import common_pkg::*;

module alu (
    input logic clk,
    input logic rst,
    input logic [31:0] left_operand,
    input logic [31:0] right_operand,
    input alu_op_t alu_op,
    input logic alu_inv_res,
    output logic [31:0] alu_res
    //output logic zero_flag
);

  logic [31:0] internal_alu_res;

  logic state;
  logic [31:0] left_operand_1;
  logic [31:0] left_operand_2;
  logic [31:0] right_operand_1;
  logic [31:0] right_operand_2;

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

      ALU_MUL: begin
        if (state == 1) begin
          internal_alu_res = left_operand_1 * right_operand_1;
        end else begin
          internal_alu_res = left_operand_2 * right_operand_2;
        end
      end

      ALU_DIV: begin
        internal_alu_res = left_operand + right_operand;
        //  internal_alu_res = left_operand / right_operand;

      end

      default: begin
        internal_alu_res = left_operand + right_operand;
      end
    endcase
  end

  //always_comb begin : MUL_COMB

  //end

  always @(posedge clk) begin
    if (rst == 1) begin
      state <= 'b0;
    end else begin
      state <= ~state;


      if (state == 1) begin
        left_operand_1  <= left_operand;
        right_operand_1 <= right_operand;
      end else begin
        left_operand_2  <= left_operand;
        right_operand_2 <= right_operand;
      end
    end
  end

  always_comb begin
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
