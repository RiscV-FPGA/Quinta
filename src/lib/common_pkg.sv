package common_pkg;

  typedef enum logic [3:0] {
    ALU_AND                = 4'b0000,
    ALU_OR                 = 4'b0001,
    ALU_XOR                = 4'b0010,
    ALU_ADD                = 4'b0011,
    ALU_SUB                = 4'b0110,
    ALU_SHIFT_LEFT         = 4'b0111,
    ALU_SHIFT_RIGHT        = 4'b1000,
    ALU_SHIFT_RIGHT_AR     = 4'b1001,
    ALU_SHIFT_RIGHT_AR_IMM = 4'b1010,
    ALU_LESS_THAN_UNSIGNED = 4'b1011,
    ALU_LESS_THAN_SIGNED   = 4'b1100,
    ALU_EQUAL              = 4'b1101
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
    J_TYPE
  } encoding_t;

  typedef struct packed {
    alu_op_t alu_op;
    encoding_t encoding;
    logic alu_src;  // alu mux control
    logic alu_inv_res;  // invert alu result
    logic mem_read;  // mem read
    logic mem_write;  // mem write
    logic mem_to_reg;  // not in use yet dont know exatly what to do with
    logic is_branch;  // is branch
    logic reg_write;  // write back to reg

    logic [4:0] write_back_id;
    //logic mem_to_reg;
  } control_t;

endpackage
