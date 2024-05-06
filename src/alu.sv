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

  logic [64:0] mul_shift_0;
  //logic [64:0] mul_add_0;
  logic [64:0] mul_shift_1;
  logic [64:0] mul_add_1;
  logic [64:0] mul_shift_2;
  logic [64:0] mul_add_2;
  logic [64:0] mul_shift_3;
  logic [64:0] mul_add_3;
  logic [64:0] mul_shift_4;
  logic [64:0] mul_add_4;

  logic [ 4:0] alu_cnt;


  always_comb begin
    if (mul_shift_0[0] == 1) begin  // 1
      mul_add_1 = mul_shift_0 + {left_operand, 32'h00_00_00_00};
    end else begin
      mul_add_1 = mul_shift_0;
    end
    mul_shift_1 = mul_add_1 >> 1;

    if (mul_shift_1[0] == 1) begin  // 2
      mul_add_2 = mul_shift_1 + {left_operand, 32'h00_00_00_00};
    end else begin
      mul_add_2 = mul_shift_1;
    end
    mul_shift_2 = mul_add_2 >> 1;

    if (mul_shift_2[0] == 1) begin  // 3
      mul_add_3 = mul_shift_2 + {left_operand, 32'h00_00_00_00};
    end else begin
      mul_add_3 = mul_shift_2;
    end
    mul_shift_3 = mul_add_3 >> 1;

    if (mul_shift_3[0] == 1) begin  // 4
      mul_add_4 = mul_shift_3 + {left_operand, 32'h00_00_00_00};
    end else begin
      mul_add_4 = mul_shift_3;
    end
    mul_shift_4 = mul_add_4 >> 1;

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
        internal_alu_res = mul_shift_4[31:0];
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
      alu_cnt <= 0;
    end else begin
      if (alu_cnt == 0 && alu_op == ALU_MUL) begin
        alu_cnt <= alu_cnt + 1;
        mul_shift_0 <= {1'b0, 32'h00_00_00_00, right_operand};
      end else if (alu_cnt > 0 && alu_cnt < 8) begin
        alu_cnt <= alu_cnt + 1;
        mul_shift_0 <= mul_shift_4;
      end else begin
        alu_cnt <= 0;
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
