package common_instructions_pkg;

  typedef enum logic [31:0] {
    INSTR_LUI     = 32'bxxxxxxx_xxxxx_xxxxx_xxx_xxxxx_0110111,
    INSTR_AUIPC   = 32'bxxxxxxx_xxxxx_xxxxx_xxx_xxxxx_0010111,
    INSTR_JAL     = 32'bxxxxxxx_xxxxx_xxxxx_xxx_xxxxx_1101111,
    INSTR_JALR    = 32'bxxxxxxx_xxxxx_xxxxx_000_xxxxx_1100111,
    INSTR_BEQ     = 32'bxxxxxxx_xxxxx_xxxxx_000_xxxxx_1100011,
    INSTR_BNE     = 32'bxxxxxxx_xxxxx_xxxxx_001_xxxxx_1100011,
    INSTR_BLT     = 32'bxxxxxxx_xxxxx_xxxxx_100_xxxxx_1100011,
    INSTR_BGE     = 32'bxxxxxxx_xxxxx_xxxxx_101_xxxxx_1100011,
    INSTR_BLTU    = 32'bxxxxxxx_xxxxx_xxxxx_110_xxxxx_1100011,
    INSTR_BGEU    = 32'bxxxxxxx_xxxxx_xxxxx_111_xxxxx_1100011,
    INSTR_LB      = 32'bxxxxxxx_xxxxx_xxxxx_000_xxxxx_0000011,
    INSTR_LH      = 32'bxxxxxxx_xxxxx_xxxxx_001_xxxxx_0000011,
    INSTR_LW      = 32'bxxxxxxx_xxxxx_xxxxx_010_xxxxx_0000011,
    INSTR_LBU     = 32'bxxxxxxx_xxxxx_xxxxx_100_xxxxx_0000011,
    INSTR_LHU     = 32'bxxxxxxx_xxxxx_xxxxx_101_xxxxx_0000011,
    INSTR_SB      = 32'bxxxxxxx_xxxxx_xxxxx_000_xxxxx_0100011,
    INSTR_SH      = 32'bxxxxxxx_xxxxx_xxxxx_001_xxxxx_0100011,
    INSTR_SW      = 32'bxxxxxxx_xxxxx_xxxxx_010_xxxxx_0100011,
    INSTR_ADDI    = 32'bxxxxxxx_xxxxx_xxxxx_000_xxxxx_0010011,
    INSTR_SLTI    = 32'bxxxxxxx_xxxxx_xxxxx_010_xxxxx_0010011,
    INSTR_SLTIU   = 32'bxxxxxxx_xxxxx_xxxxx_011_xxxxx_0010011,
    INSTR_XORI    = 32'bxxxxxxx_xxxxx_xxxxx_100_xxxxx_0010011,
    INSTR_ORI     = 32'bxxxxxxx_xxxxx_xxxxx_110_xxxxx_0010011,
    INSTR_ANDI    = 32'bxxxxxxx_xxxxx_xxxxx_111_xxxxx_0010011,
    INSTR_SLLI    = 32'b0000000_xxxxx_xxxxx_001_xxxxx_0010011,
    INSTR_SRLI    = 32'b0000000_xxxxx_xxxxx_101_xxxxx_0010011,
    INSTR_SRAI    = 32'b0100000_xxxxx_xxxxx_101_xxxxx_0010011,
    INSTR_ADD     = 32'b0000000_xxxxx_xxxxx_000_xxxxx_0110011,
    INSTR_SUB     = 32'b0100000_xxxxx_xxxxx_000_xxxxx_0110011,
    INSTR_SLL     = 32'b0000000_xxxxx_xxxxx_001_xxxxx_0110011,
    INSTR_SLT     = 32'b0000000_xxxxx_xxxxx_010_xxxxx_0110011,
    INSTR_SLTU    = 32'b0000000_xxxxx_xxxxx_011_xxxxx_0110011,
    INSTR_XOR     = 32'b0000000_xxxxx_xxxxx_100_xxxxx_0110011,
    INSTR_SRL     = 32'b0000000_xxxxx_xxxxx_101_xxxxx_0110011,
    INSTR_SRA     = 32'b0100000_xxxxx_xxxxx_101_xxxxx_0110011,
    INSTR_OR      = 32'b0000000_xxxxx_xxxxx_110_xxxxx_0110011,
    INSTR_AND     = 32'b0000000_xxxxx_xxxxx_111_xxxxx_0110011,
    INSTR_MUL     = 32'b0000001_xxxxx_xxxxx_000_xxxxx_0110011,
    INSTR_MULH    = 32'b0000001_xxxxx_xxxxx_001_xxxxx_0110011,
    INSTR_DIV     = 32'b0000001_xxxxx_xxxxx_100_xxxxx_0110011,
    INSTR_DIVU    = 32'b0000001_xxxxx_xxxxx_101_xxxxx_0110011,
    INSTR_REM     = 32'b0000001_xxxxx_xxxxx_110_xxxxx_0110011,
    INSTR_REMU    = 32'b0000001_xxxxx_xxxxx_111_xxxxx_0110011,
    INSTR_FLW     = 32'bxxxxxxx_xxxxx_xxxxx_010_xxxxx_0000111,
    INSTR_FSW     = 32'bxxxxxxx_xxxxx_xxxxx_010_xxxxx_0100111,
    INSTR_FADD_S  = 32'b0000000_xxxxx_xxxxx_xxx_xxxxx_1010011,
    INSTR_FSUB_S  = 32'b0000100_xxxxx_xxxxx_xxx_xxxxx_1010011,
    INSTR_FMUL_S  = 32'b0001000_xxxxx_xxxxx_xxx_xxxxx_1010011,
    INSTR_FDIV_S  = 32'b0001100_xxxxx_xxxxx_xxx_xxxxx_1010011,
    INSTR_FSQRT_S = 32'b0101100_00000_xxxxx_xxx_xxxxx_1010011,
    INSTR_FMV_X_W = 32'b1110000_00000_xxxxx_000_xxxxx_1010011,
    INSTR_FEQ_S   = 32'b1010000_xxxxx_xxxxx_010_xxxxx_1010011,
    INSTR_FLT_S   = 32'b1010000_xxxxx_xxxxx_001_xxxxx_1010011,
    INSTR_FLE_S   = 32'b1010000_xxxxx_xxxxx_000_xxxxx_1010011,
    INSTR_FMV_W_X = 32'b1111000_00000_xxxxx_000_xxxxx_1010011
  } normal_instructions_t;

  typedef enum logic [15:0] {
    INSTR_C_NOP  = 16'b000_0_00000_00000_01,
    INSTR_C_ADDI = 16'b000_x_xxxxx_xxxxx_01
  } compressed_instructions_t;

endpackage


