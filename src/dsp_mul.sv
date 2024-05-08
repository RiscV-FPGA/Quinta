(* use_dsp = "yes" *)
module dsp_mul (
    input logic clk,
    input logic [31:0] left_operand,
    input logic [31:0] right_operand,
    output logic [63:0] mul_res

);

  logic [31:0] left_operand_d;
  logic [31:0] right_operand_d;
  logic [63:0] mul_res_internal;
  logic [63:0] mul_res_internal_d;
  logic [63:0] mul_res_internal_dd;
  logic [63:0] mul_res_internal_ddd;
  logic [63:0] mul_res_internal_dddd;
  logic [63:0] mul_res_internal_ddddd;


  assign mul_res_internal = $signed(left_operand_d) * $signed(right_operand_d);

  always_ff @(posedge clk) begin
    left_operand_d         <= left_operand;
    right_operand_d        <= right_operand;
    mul_res_internal_d     <= mul_res_internal;
    mul_res_internal_dd    <= mul_res_internal_d;
    mul_res_internal_ddd   <= mul_res_internal_dd;
    mul_res_internal_dddd  <= mul_res_internal_ddd;
    mul_res_internal_ddddd <= mul_res_internal_dddd;
  end

  assign mul_res = mul_res_internal_ddddd;

endmodule
