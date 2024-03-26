package common_pkg;

  typedef enum logic [2:0] {
    ALU_AND = 3'b000,
    ALU_OR  = 3'b001,
    ALU_ADD = 3'b010,
    ALU_SUB = 3'b011
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
    logic mem_read;  // mem read
    logic mem_write;  // mem write
    logic is_branch;  // is branch
    logic reg_write;  // write back to reg

    logic [4:0] write_back_id;
    //logic mem_to_reg;
  } control_t;

  /*
  typedef struct packed {
    logic [31:0]  pc;
    instruction_t instruction;
  } if_id_t;


  typedef struct packed {
    logic [5:0] reg_rd_id;
    logic [31:0] data1;
    logic [31:0] data2;
    logic [31:0] immediate_data;
    control_t control;
  } id_ex_t;


  typedef struct packed {
    logic [5:0] reg_rd_id;
    control_t control;
    logic [31:0] alu_data;
    logic [31:0] memory_data;
  } ex_mem_t;


  typedef struct packed {
    logic [5:0] reg_rd_id;
    logic [31:0] memory_data;
    logic [31:0] alu_data;
    control_t control;
  } mem_wb_t;
*/


endpackage
