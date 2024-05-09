import common_pkg::*;

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
      7'b1100111: begin  // I type JALR
        control.encoding = I_TYPE;
      end
      7'b0100011: begin
        control.encoding = S_TYPE;
      end
      7'b1100011: begin
        control.encoding = B_TYPE;
      end
      7'b0110111: begin  // U type LUI
        control.encoding = U_TYPE;
      end
      7'b0010111: begin  // U type AUIPC
        control.encoding = U_TYPE;
      end
      7'b1101111: begin
        control.encoding = J_TYPE;
      end
      7'b0000011: begin
        control.encoding = I_TYPE;  //load
      end
      7'b1111111: begin
        control.encoding = HALT_TYPE;
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
logic mem_to_reg // is this needed
logic is_branch
logic reg_write
    */

    // CHECK INSTR
    casez (instruction)
      INSTR_LUI: begin
        control.alu_src    = 1;
        control.reg_write  = 1;
        control.alu_bypass = 1;

      end
      INSTR_AUIPC: begin  // 4
        control.alu_src = 1;
        control.alu_pc = 1;
        control.reg_write = 1;
        control.alu_op = ALU_ADD;

      end
      INSTR_JAL: begin  // 4
        control.alu_src = 1;
        control.alu_pc = 1;
        control.reg_write = 1;
        control.alu_jump = 1;
        control.wb_pc = 1;
        control.alu_op = ALU_ADD;

      end
      INSTR_JALR: begin  // 4
        control.alu_src = 1;
        //control.alu_pc = 1;
        control.reg_write = 1;
        control.alu_jump = 1;
        control.wb_pc = 1;
        control.alu_op = ALU_ADD;

      end
      INSTR_BEQ: begin  // branch
        control.is_branch = 1;
        control.alu_op = ALU_EQUAL;

      end
      INSTR_BNE: begin  // branch
        control.is_branch = 1;
        control.alu_op = ALU_EQUAL;
        control.alu_inv_res = 1;

      end
      INSTR_BLT: begin  // branch
        control.is_branch = 1;
        control.alu_op = ALU_LESS_THAN_SIGNED;

      end
      INSTR_BGE: begin  // branch
        control.is_branch = 1;
        control.alu_op = ALU_LESS_THAN_SIGNED;
        control.alu_inv_res = 1;

      end
      INSTR_BLTU: begin  // branch
        control.is_branch = 1;
        control.alu_op = ALU_LESS_THAN_UNSIGNED;

      end
      INSTR_BGEU: begin  // branch
        control.is_branch = 1;
        control.alu_op = ALU_LESS_THAN_UNSIGNED;
        control.alu_inv_res = 1;

      end
      INSTR_LB: begin  // 4
        control.alu_op = ALU_ADD;
        control.alu_src = 1;
        control.mem_read = MEM_BYTE;
        control.reg_write = 1;

      end
      INSTR_LH: begin  // 4
        control.alu_op = ALU_ADD;
        control.alu_src = 1;
        control.mem_read = MEM_HALF_WORD;
        control.reg_write = 1;

      end
      INSTR_LW: begin
        control.alu_op = ALU_ADD;
        control.alu_src = 1;
        control.mem_read = MEM_FULL_WORD;
        control.reg_write = 1;

      end
      INSTR_LBU: begin  // 4

      end
      INSTR_LHU: begin  // 4

      end
      INSTR_SB: begin  // 4
        control.alu_op = ALU_ADD;
        control.alu_src = 1;
        control.mem_write = MEM_BYTE;

      end
      INSTR_SH: begin  // 4
        control.alu_op = ALU_ADD;
        control.alu_src = 1;
        control.mem_write = MEM_HALF_WORD;

      end
      INSTR_SW: begin
        control.alu_op = ALU_ADD;
        control.alu_src = 1;
        control.mem_write = MEM_FULL_WORD;

      end
      INSTR_ADDI: begin
        control.alu_op = ALU_ADD;
        control.alu_src = 1;  // imm to alu
        control.reg_write = 1;

      end
      INSTR_SLTI: begin
        control.alu_op = ALU_LESS_THAN_SIGNED;
        control.alu_src = 1;
        control.reg_write = 1;

      end
      INSTR_SLTIU: begin
        control.alu_op = ALU_LESS_THAN_UNSIGNED;
        control.alu_src = 1;
        control.reg_write = 1;

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
        control.alu_op = ALU_SHIFT_LEFT;
        control.reg_write = 1;
        control.alu_src = 1;

      end
      INSTR_SRLI: begin
        control.alu_op = ALU_SHIFT_RIGHT;
        control.reg_write = 1;
        control.alu_src = 1;

      end
      INSTR_SRAI: begin
        control.alu_op = ALU_SHIFT_RIGHT_AR_IMM;
        control.reg_write = 1;
        control.alu_src = 1;

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
        control.alu_op = ALU_SHIFT_LEFT;
        control.reg_write = 1;

      end
      INSTR_SLT: begin
        control.alu_op = ALU_LESS_THAN_SIGNED;
        control.reg_write = 1;

      end
      INSTR_SLTU: begin
        control.alu_op = ALU_LESS_THAN_UNSIGNED;
        control.reg_write = 1;

      end
      INSTR_XOR: begin
        control.alu_op = ALU_XOR;
        control.reg_write = 1;

      end
      INSTR_SRL: begin  // shift right
        control.alu_op = ALU_SHIFT_RIGHT;
        control.reg_write = 1;

      end
      INSTR_SRA: begin
        control.alu_op = ALU_SHIFT_RIGHT_AR;
        control.reg_write = 1;

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
        control.alu_op = ALU_MUL;
        control.reg_write = 1;
      end
      INSTR_MULH: begin  //4
        control.alu_op = ALU_MULH;
        control.reg_write = 1;
      end
      INSTR_DIV: begin  //4
        control.alu_op = ALU_DIV;
        control.reg_write = 1;
      end
      INSTR_DIVU: begin  //4
        control.alu_op = ALU_DIVU;
        control.reg_write = 1;

      end
      INSTR_REM: begin  //4
        control.alu_op = ALU_REM;
        control.reg_write = 1;

      end
      INSTR_REMU: begin  //4
        control.alu_op = ALU_REMU;
        control.reg_write = 1;

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
      INSTR_HALT: begin
        // control == 0 :)
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
