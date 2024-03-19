import common_pkg::*;

module imm_gen (
    input instruction_t instruction,
    input encoding_t control_encoding,
    output logic [31:0] immediate_data
);

  always_comb begin : comb_imm_gen
    case (control_encoding)
      I_TYPE: begin
        immediate_data = {{20{instruction.block5[6]}}, {instruction.block5, instruction.block4}};
      end
      S_TYPE: begin
        immediate_data = {{20{instruction.block5[6]}}, {instruction.block5, instruction.block1}};
      end
      B_TYPE: begin
        immediate_data = {{20{instruction.block5[6]}}, {instruction.block5[6], instruction.block1[0], instruction.block5[5:0], instruction.block1[4:1]}};
      end
      U_TYPE: begin
        immediate_data = {{instruction.block5, instruction.block4, instruction.block3, instruction.block2}, {12'b000000000000}};
      end
      J_TYPE: begin
        immediate_data = {{12{instruction.block5[6]}}, {instruction.block3, instruction.block2, instruction.block4[0], instruction.block5[5:0], instruction.block4[4:1]}};
      end
      default: begin
        immediate_data = 0;
      end
    endcase
  end

endmodule
