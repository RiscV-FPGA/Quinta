
module dsp_div (
    input logic clk,
    input logic rst,
    input alu_op_t alu_op,
    input logic signed [31:0] left_operand,
    input logic signed [31:0] right_operand,
    output logic [31:0] div_res_unsigned,
    output logic [31:0] rem_res_unsigned,
    output logic [31:0] div_res_signed,
    output logic [31:0] rem_res_signed
);

  logic [31:0] right_operand_d_sigend;
  logic [31:0] left_operand_d_sigend;
  logic [31:0] right_operand_d;
  logic [31:0] right_operand_unsigned;
  logic [31:0] left_operand_unsigned;

  logic signed_division;
  logic [31:0] quo;
  logic [31:0] quo_next;  // intermediate quotient
  logic [32:0] acc;
  logic [32:0] acc_sub;
  logic [32:0] acc_next;  // accumulator (1 bit wider)
  logic [7:0] i;  // iteration counter

  logic run;

  // division unsigned algorithm iteration
  always_comb begin
    if (acc >= {1'b0, right_operand_d}) begin
      acc_next = (acc - right_operand_d) << 1;
      acc_next[0] = quo[31];
      quo_next = quo << 1;
      quo_next[0] = 1'b1;
    end else begin
      acc_next = acc << 1;
      acc_next[0] = quo[31];
      quo_next = quo << 1;
    end
  end

  // calculation control
  always_ff @(posedge clk) begin
    if (rst == 1) begin
      run <= 0;
      signed_division <= 0;
      i <= 0;
    end else begin
      if ((alu_op == ALU_DIVU || alu_op == ALU_REMU) && run == 0) begin
        run <= 1;
        i <= 0;
        right_operand_d <= right_operand;
        acc <= {{32{1'b0}}, left_operand[31]};
        quo <= {left_operand[30:0], 1'b0};
      end else if ((alu_op == ALU_DIV || alu_op == ALU_REM) && run == 0) begin
        run <= 1;
        i <= 0;
        left_operand_d_sigend <= left_operand;
        right_operand_d_sigend <= right_operand;

        if (left_operand[31] == 1) begin
          acc <= {{32{1'b0}}, left_operand_unsigned[31]};
          quo <= {left_operand_unsigned[30:0], 1'b0};
        end else begin
          acc <= {{32{1'b0}}, left_operand[31]};
          quo <= {left_operand[30:0], 1'b0};
        end

        if (right_operand[31] == 1) begin
          right_operand_d <= right_operand_unsigned;
        end else begin
          right_operand_d <= right_operand;
        end

      end else begin
        if (i == 32 - 1) begin  //done
          run <= 0;
          i   <= 0;
        end else begin  // next iteration
          i   <= i + 1;
          acc <= acc_next;
          quo <= quo_next;
        end
      end
    end
  end

  always_comb begin
    left_operand_unsigned  = ~left_operand + 1;
    right_operand_unsigned = ~right_operand + 1;
  end

  assign div_res_unsigned = quo_next;
  assign rem_res_unsigned = acc_next[32:1];  //32 - 1 to undo last shift

  always_comb begin
    if (left_operand_d_sigend[31] == 0 && right_operand_d_sigend[31] == 0) begin  //+ + = + +
      div_res_signed = quo_next;
      rem_res_signed = acc_next[32:1];
    end else if (left_operand_d_sigend[31] == 1 && right_operand_d_sigend[31] == 0) begin//- + = - -
      div_res_signed = ~(quo_next) + 1;
      rem_res_signed = ~(acc_next[32:1]) + 1;
    end else if (left_operand_d_sigend[31] == 0 && right_operand_d_sigend[31] == 1) begin//+ - = - +
      div_res_signed = -quo_next;
      rem_res_signed = acc_next[32:1];
    end else begin  // - - = + -
      div_res_signed = quo_next;
      rem_res_signed = -acc_next[32:1];
    end
  end

endmodule
