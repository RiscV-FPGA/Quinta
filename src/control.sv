import common_pkg::*;
import common_instructions_pkg::*;

module control (
    input instruction_t instruction,
    output control_t control
);

  always_comb begin : control_main_comb
    control = '0;

    // CHECK OP CODE
    case (instruction.opcode)
      7'b0110011: begin
        control.encoding = R_TYPE;
      end
      7'b0010011: begin
        control.encoding = I_TYPE;
      end
      7'b0100011: begin
        control.encoding = S_TYPE;
      end
      7'b1100011: begin
        control.encoding = B_TYPE;
      end
      7'b0110111: begin
        control.encoding = U_TYPE;
      end
      7'b1101111: begin
        control.encoding = J_TYPE;
      end
      default: begin
        // NOP (ADDI x0 x0 0)
        control.encoding = R_TYPE;
      end
    endcase

    // CHECK INSTR
    case (instruction)
      INSTR_LUI: begin

      end
      INSTR_AUIPC: begin

      end
      INSTR_JAL: begin

      end
      INSTR_JALR: begin

      end
      INSTR_BEQ: begin

      end
      INSTR_BNE: begin

      end
      INSTR_BLT: begin

      end
      INSTR_BGE: begin

      end
      INSTR_BLTU: begin

      end
      INSTR_BGEU: begin

      end
      INSTR_LB: begin

      end
      INSTR_LH: begin

      end
      INSTR_LW: begin

      end
      INSTR_LBU: begin

      end
      INSTR_LHU: begin

      end
      INSTR_SB: begin

      end
      INSTR_SH: begin

      end
      INSTR_SW: begin

      end
      INSTR_ADDI: begin

      end
      INSTR_SLTI: begin

      end
      INSTR_SLTIU: begin

      end
      INSTR_XORI: begin

      end
      INSTR_ORI: begin

      end
      INSTR_ANDI: begin

      end
      INSTR_SLLI: begin

      end
      INSTR_SRLI: begin

      end
      INSTR_SRAI: begin

      end
      INSTR_ADD: begin

      end
      INSTR_SUB: begin

      end
      INSTR_SLL: begin

      end
      INSTR_SLT: begin

      end
      INSTR_SLTU: begin

      end
      INSTR_XOR: begin

      end
      INSTR_SRL: begin

      end
      INSTR_SRA: begin

      end
      INSTR_OR: begin

      end
      INSTR_AND: begin

      end
      INSTR_MUL: begin

      end
      INSTR_MULH: begin

      end
      INSTR_DIV: begin

      end
      INSTR_DIVU: begin

      end
      INSTR_REM: begin

      end
      INSTR_REMU: begin

      end
      INSTR_FLW: begin

      end
      INSTR_FSW: begin

      end
      INSTR_FADD_S: begin

      end
      INSTR_FSUB_S: begin

      end
      INSTR_FMUL_S: begin

      end
      INSTR_FDIV_S: begin

      end
      INSTR_FSQRT_S: begin

      end
      INSTR_FMV_X_W: begin

      end
      INSTR_FEQ_S: begin

      end
      INSTR_FLT_S: begin

      end
      INSTR_FLE_S: begin

      end
      INSTR_FMV_W_X: begin

      end
      default: begin
        // NOP (ADDI x0 x0 0)
      end
    endcase

  end

endmodule
