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

  logic [63:0] mul_res;
  logic [ 7:0] mul_bubble;

  logic [31:0] div_res_unsigned;
  logic [31:0] rem_res_unsigned;
  logic [31:0] div_res_signed;
  logic [31:0] rem_res_signed;
  logic [ 7:0] div_bubble;

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

      ALU_MUL: internal_alu_res = mul_res[31:0];

      ALU_MULH: internal_alu_res = mul_res[63:32];

      ALU_DIV: internal_alu_res = div_res_signed;

      ALU_DIVU: internal_alu_res = div_res_unsigned;

      ALU_REM: internal_alu_res = rem_res_signed;

      ALU_REMU: internal_alu_res = rem_res_unsigned;

      default: begin
        internal_alu_res = left_operand + right_operand;
      end
    endcase
  end

  dsp_mul dsp_mul_inst (  // MUL START
      .clk(clk),
      .left_operand(left_operand),
      .right_operand(right_operand),
      .mul_res(mul_res)
  );

  always_ff @(posedge clk) begin
    if (rst == 1) begin
      mul_bubble <= 'b0;
    end else begin
      if ((alu_op == ALU_MUL || alu_op == ALU_MULH) && mul_bubble == 0) begin
        mul_bubble <= 1;
      end

      if (mul_bubble == 6) begin
        mul_bubble <= 0;
      end else if (mul_bubble > 0) begin
        mul_bubble <= mul_bubble + 1;
      end
    end
  end  // MUL END

  dsp_div dsp_div_inst (  // DIV START
      .clk(clk),
      .rst(rst),
      .alu_op(alu_op),
      .left_operand(left_operand),
      .right_operand(right_operand),
      .div_res_unsigned(div_res_unsigned),
      .rem_res_unsigned(rem_res_unsigned),
      .div_res_signed(div_res_signed),
      .rem_res_signed(rem_res_signed)
  );

  always_ff @(posedge clk) begin
    if (rst == 1) begin
      div_bubble <= 'b0;
    end else begin
      if ((alu_op == ALU_DIV || alu_op == ALU_DIVU) && div_bubble == 0) begin
        div_bubble <= 1;
      end

      if (div_bubble == 32) begin
        div_bubble <= 0;
      end else if (div_bubble > 0) begin
        div_bubble <= div_bubble + 1;
      end
    end
  end  // DIV END


  // BUBBLE
  always_comb begin
    if (((alu_op == ALU_MUL ||alu_op == ALU_MULH)  && mul_bubble == 0)
    || (mul_bubble > 0 && mul_bubble < 6)) begin
      insert_bubble = 1;
    end else if(((alu_op == ALU_DIV ||alu_op == ALU_DIVU)  && div_bubble == 0)
    || (div_bubble > 0 && div_bubble < 32)) begin
      insert_bubble = 1;
    end else begin
      insert_bubble = 0;
    end
  end
  //BUBBLE END

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
