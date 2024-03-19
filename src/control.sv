import common_pkg::*;

module control (
    input instruction_t instruction,
    output control_t control
);

  always_comb begin : control_main_comb
    control = '0;

    case (instruction.opcode)
      7'b0110011: begin

      end
      default: begin

      end
    endcase

  end

endmodule
