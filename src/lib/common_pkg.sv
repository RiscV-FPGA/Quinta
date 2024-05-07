package common_pkg;

  typedef enum logic [4:0] {
    ALU_AND                = 5'b00000,
    ALU_OR                 = 5'b00001,
    ALU_XOR                = 5'b00010,
    ALU_ADD                = 5'b00011,
    ALU_SUB                = 5'b00110,
    ALU_SHIFT_LEFT         = 5'b00111,
    ALU_SHIFT_RIGHT        = 5'b01000,
    ALU_SHIFT_RIGHT_AR     = 5'b01001,
    ALU_SHIFT_RIGHT_AR_IMM = 5'b01010,
    ALU_LESS_THAN_UNSIGNED = 5'b01011,
    ALU_LESS_THAN_SIGNED   = 5'b01100,
    ALU_EQUAL              = 5'b01101,
    ALU_MUL                = 5'b01110,
    ALU_MULH               = 5'b01111,
    ALU_DIV                = 5'b10000
  } alu_op_t;

  typedef struct packed {  //32 bit instruction
    logic [6:0] block5;
    logic [4:0] block4;
    logic [4:0] block3;
    logic [2:0] block2;
    logic [4:0] block1;
    logic [6:0] opcode;
  } instruction_t;

  typedef enum logic [2:0] {
    //block5=func7       ,  block4=rs2        , block3=rs1       , block2=func3     , block1=rd
    R_TYPE,

    //block5=func7       ,  block4=rs2        , block3=rs1       , block2=func3     , block1=rd
    I_TYPE,

    //block5=imm[11:5]   ,  block4=rs2        , block3=rs1       , block2=func3     , block1=imm[4:0]
    S_TYPE,

    //block5=imm[12|10:5],  block4=rs2        , block3=rs1       , block2=func3     , block1=imm[5:1|11]
    B_TYPE,

    //block5=imm[31:25]  ,  block4=imm[24:20] , block3=imm[19:15], block2=imm[14:12], block1=rd
    U_TYPE,

    //block5=imm[20|10:5],  block4=imm[5:1|11], block3=imm[19:15], block2=imm[14:12], block1=rd
    J_TYPE,

    HALT_TYPE
  } encoding_t;

  typedef struct packed {
    alu_op_t alu_op;
    encoding_t encoding;
    logic alu_src;  // alu mux control
    logic alu_inv_res;  // invert alu result
    logic mem_read;  // mem read
    logic mem_write;  // mem write
    //logic mem_to_reg;  // not in use yet dont know exatly what to do with
    logic is_branch;  // is branch
    logic reg_write;  // write back to reg

    logic [4:0] write_back_id;
    //logic mem_to_reg;
  } control_t;

  typedef enum logic [31:0] {
    // instr      =     func7____rs2___rs1_func3_rd___op_code,
    INSTR_LUI     = 32'b???????_?????_?????_???_?????_0110111,
    INSTR_AUIPC   = 32'b???????_?????_?????_???_?????_0010111,
    INSTR_JAL     = 32'b???????_?????_?????_???_?????_1101111,
    INSTR_JALR    = 32'b???????_?????_?????_000_?????_1100111,
    INSTR_BEQ     = 32'b???????_?????_?????_000_?????_1100011,
    INSTR_BNE     = 32'b???????_?????_?????_001_?????_1100011,
    INSTR_BLT     = 32'b???????_?????_?????_100_?????_1100011,
    INSTR_BGE     = 32'b???????_?????_?????_101_?????_1100011,
    INSTR_BLTU    = 32'b???????_?????_?????_110_?????_1100011,
    INSTR_BGEU    = 32'b???????_?????_?????_111_?????_1100011,
    INSTR_LB      = 32'b???????_?????_?????_000_?????_0000011,
    INSTR_LH      = 32'b???????_?????_?????_001_?????_0000011,
    INSTR_LW      = 32'b???????_?????_?????_010_?????_0000011,
    INSTR_LBU     = 32'b???????_?????_?????_100_?????_0000011,
    INSTR_LHU     = 32'b???????_?????_?????_101_?????_0000011,
    INSTR_SB      = 32'b???????_?????_?????_000_?????_0100011,
    INSTR_SH      = 32'b???????_?????_?????_001_?????_0100011,
    INSTR_SW      = 32'b???????_?????_?????_010_?????_0100011,
    INSTR_ADDI    = 32'b???????_?????_?????_000_?????_0010011,
    INSTR_SLTI    = 32'b???????_?????_?????_010_?????_0010011,
    INSTR_SLTIU   = 32'b???????_?????_?????_011_?????_0010011,
    INSTR_XORI    = 32'b???????_?????_?????_100_?????_0010011,
    INSTR_ORI     = 32'b???????_?????_?????_110_?????_0010011,
    INSTR_ANDI    = 32'b???????_?????_?????_111_?????_0010011,
    INSTR_SLLI    = 32'b0000000_?????_?????_001_?????_0010011,
    INSTR_SRLI    = 32'b0000000_?????_?????_101_?????_0010011,
    INSTR_SRAI    = 32'b0100000_?????_?????_101_?????_0010011,
    INSTR_ADD     = 32'b0000000_?????_?????_000_?????_0110011,
    INSTR_SUB     = 32'b0100000_?????_?????_000_?????_0110011,
    INSTR_SLL     = 32'b0000000_?????_?????_001_?????_0110011,
    INSTR_SLT     = 32'b0000000_?????_?????_010_?????_0110011,
    INSTR_SLTU    = 32'b0000000_?????_?????_011_?????_0110011,
    INSTR_XOR     = 32'b0000000_?????_?????_100_?????_0110011,
    INSTR_SRL     = 32'b0000000_?????_?????_101_?????_0110011,
    INSTR_SRA     = 32'b0100000_?????_?????_101_?????_0110011,
    INSTR_OR      = 32'b0000000_?????_?????_110_?????_0110011,
    INSTR_AND     = 32'b0000000_?????_?????_111_?????_0110011,
    INSTR_MUL     = 32'b0000001_?????_?????_000_?????_0110011,
    INSTR_MULH    = 32'b0000001_?????_?????_001_?????_0110011,
    INSTR_DIV     = 32'b0000001_?????_?????_100_?????_0110011,
    INSTR_DIVU    = 32'b0000001_?????_?????_101_?????_0110011,
    INSTR_REM     = 32'b0000001_?????_?????_110_?????_0110011,
    INSTR_REMU    = 32'b0000001_?????_?????_111_?????_0110011,
    INSTR_FLW     = 32'b???????_?????_?????_010_?????_0000111,
    INSTR_FSW     = 32'b???????_?????_?????_010_?????_0100111,
    INSTR_FADD_S  = 32'b0000000_?????_?????_???_?????_1010011,
    INSTR_FSUB_S  = 32'b0000100_?????_?????_???_?????_1010011,
    INSTR_FMUL_S  = 32'b0001000_?????_?????_???_?????_1010011,
    INSTR_FDIV_S  = 32'b0001100_?????_?????_???_?????_1010011,
    INSTR_FSQRT_S = 32'b0101100_00000_?????_???_?????_1010011,
    INSTR_FMV_X_W = 32'b1110000_00000_?????_000_?????_1010011,
    INSTR_FEQ_S   = 32'b1010000_?????_?????_010_?????_1010011,
    INSTR_FLT_S   = 32'b1010000_?????_?????_001_?????_1010011,
    INSTR_FLE_S   = 32'b1010000_?????_?????_000_?????_1010011,
    INSTR_FMV_W_X = 32'b1111000_00000_?????_000_?????_1010011,
    INSTR_HALT    = 32'b1111111_11111_11111_111_11111_1111111
  } normal_instructions_t;

  typedef enum logic [15:0] {
    COMPACT_LW       = 16'b010???????????00,
    COMPACT_SW       = 16'b110???????????00,
    COMPACT_ADDI     = 16'b000???????????01,
    COMPACT_JAL      = 16'b001???????????01,
    COMPACT_LI       = 16'b010???????????01,
    COMPACT_LUI      = 16'b011???????????01,
    COMPACT_SRLI     = 16'b100?00????????01,
    COMPACT_SRAI     = 16'b100?01????????01,
    COMPACT_ANDI     = 16'b100?10????????01,
    COMPACT_SUB      = 16'b100011???00???01,
    COMPACT_XOR      = 16'b100011???01???01,
    COMPACT_OR       = 16'b100011???10???01,
    COMPACT_AND      = 16'b100011???11???01,
    COMPACT_J        = 16'b101???????????01,
    COMPACT_BEQZ     = 16'b110???????????01,
    COMPACT_BNEZ     = 16'b111???????????01,
    COMPACT_SLLI     = 16'b000???????????10,
    COMPACT_JR_MV    = 16'b1000??????????10,
    COMPACT_JALR_ADD = 16'b1001??????????10

  } compact_instructions_t;


endpackage
