import common_pkg::*;
import common_instructions_pkg::*;

module control (
    input instruction_t instruction,
    output control_t control
);

  always_comb begin : control_main_comb
    control = '0;
    control.write_back_id = instruction.block1;


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

    /*
alu_op_t alu_op
encoding_t encoding
logic alu_src
logic mem_read
logic mem_write
logic mem_to_reg
logic is_branch
logic reg_write
    */

    // CHECK INSTR
    casez (instruction)
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
        control.alu_op = ALU_ADD;
        control.alu_src = 1;  // imm to alu
        control.reg_write = 1;

      end
      INSTR_SLTI: begin

      end
      INSTR_SLTIU: begin

      end
      INSTR_XORI: begin
        control.alu_op = ALU_XOR;
        control.alu_src = 1;  // imm to alu
        control.reg_write = 1;

      end
      INSTR_ORI: begin
        control.alu_op = ALU_OR;
        control.alu_src = 1;  // imm to alu
        control.reg_write = 1;

      end
      INSTR_ANDI: begin
        control.alu_op = ALU_AND;
        control.alu_src = 1;  // imm to alu
        control.reg_write = 1;

      end
      INSTR_SLLI: begin

      end
      INSTR_SRLI: begin

      end
      INSTR_SRAI: begin

      end
      INSTR_ADD: begin
        control.alu_op = ALU_ADD;
        control.reg_write = 1;

      end
      INSTR_SUB: begin
        control.alu_op = ALU_SUB;
        control.reg_write = 1;

      end
      INSTR_SLL: begin

      end
      INSTR_SLT: begin

      end
      INSTR_SLTU: begin

      end
      INSTR_XOR: begin
        control.alu_op = ALU_XOR;
        control.reg_write = 1;

      end
      INSTR_SRL: begin

      end
      INSTR_SRA: begin

      end
      INSTR_OR: begin
        control.alu_op = ALU_OR;
        control.reg_write = 1;

      end
      INSTR_AND: begin
        control.alu_op = ALU_AND;
        control.reg_write = 1;

      end
      INSTR_MUL: begin  //4

      end
      INSTR_MULH: begin  //4

      end
      INSTR_DIV: begin  //4

      end
      INSTR_DIVU: begin  //4

      end
      INSTR_REM: begin  //4

      end
      INSTR_REMU: begin  //4

      end
      INSTR_FLW: begin  //5

      end
      INSTR_FSW: begin  //5

      end
      INSTR_FADD_S: begin  //5

      end
      INSTR_FSUB_S: begin  //5

      end
      INSTR_FMUL_S: begin  //5

      end
      INSTR_FDIV_S: begin  //5

      end
      INSTR_FSQRT_S: begin  //5

      end
      INSTR_FMV_X_W: begin  //5

      end
      INSTR_FEQ_S: begin  //5

      end
      INSTR_FLT_S: begin  //5

      end
      INSTR_FLE_S: begin  //5

      end
      INSTR_FMV_W_X: begin  //5

      end
      default: begin
        // NOP (ADDI x0 x0 0)
        control.alu_op = ALU_AND;
        control.alu_src = 1;  // imm to alu
        control.reg_write = 1;
      end
    endcase

  end

endmodule
