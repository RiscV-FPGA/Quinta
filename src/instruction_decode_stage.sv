import common_pkg::*;

module instruction_decode_stage (
    input logic clk,
    input logic rst,
    input instruction_t instruction,
    input logic [31:0] pc,
    input logic reg_write,
    input logic [4:0] write_id,
    input logic [31:0] write_data,
    output logic [31:0] immediate_data,
    output control_t control,
    output logic [31:0] read1_data,
    output logic [31:0] read2_data,
    output logic [4:0] rs1,
    output logic [4:0] rs2,
    input logic finish
);

  //  control_t control_internal;
  //  logic [31:0] immediate_data_internal;
  logic [ 4:0] rs1_internal;
  logic [ 4:0] rs2_internal;

  logic [31:0] read1_data_regs;
  logic [31:0] read2_data_regs;

  always_comb begin : register_forwarding
    if (write_id == rs1 && reg_write == 1) begin
      read1_data = write_data;
    end else begin
      read1_data = read1_data_regs;
    end

    if (write_id == rs2 && reg_write == 1) begin
      read2_data = write_data;
    end else begin
      read2_data = read2_data_regs;
    end
  end

  /*logic TB_ALU_AND;
  logic TB_ALU_OR;
  logic TB_ALU_XOR;
  logic TB_ALU_ADD;
  logic TB_ALU_SUB;
  logic TB_ALU_SHIFT_LEFT;
  logic TB_ALU_SHIFT_RIGHT;
  logic TB_ALU_SHIFT_RIGHT_AR;
  logic TB_ALU_LESS_THAN_UNSIGNED;
  logic TB_ALU_LESS_THAN_SIGNED;
  logic TB_R_TYPE;
  logic TB_I_TYPE;
  logic TB_S_TYPE;
  logic TB_B_TYPE;
  logic TB_U_TYPE;
  logic TB_J_TYPE;
  logic TB_alu_src;
  logic TB_mem_read;
  logic TB_mem_write;
  logic TB_mem_to_reg;
  logic TB_is_branch;
  logic TB_reg_write;
  logic [4:0] TB_write_back_id;
*/

  assign rs1_internal = instruction.block3;
  assign rs2_internal = instruction.block4;
  assign rs1 = rs1_internal;
  assign rs2 = rs2_internal;

  control control_inst (
      .instruction(instruction),
      .control(control)
  );

  registers registers_inst (
      .clk(clk),
      .rst(rst),
      .read1_id(rs1),
      .read2_id(rs2),
      .write_en(reg_write),  // reg_write
      .write_id(write_id),
      .write_data(write_data),
      .read1_data(read1_data_regs),
      .read2_data(read2_data_regs),
      .finish(finish)
  );

  imm_gen imm_gen_inst (
      .instruction(instruction),
      .control_encoding(control.encoding),
      .immediate_data(immediate_data)
  );

  //assign immediate_data = immediate_data_internal;
  //assign control = control_internal;


  // FOR TB
  /*always_comb begin
    TB_R_TYPE = 0;
    TB_I_TYPE = 0;
    TB_S_TYPE = 0;
    TB_B_TYPE = 0;
    TB_U_TYPE = 0;
    TB_J_TYPE = 0;
    case (control.encoding)
      R_TYPE:  TB_R_TYPE = 1;
      I_TYPE:  TB_I_TYPE = 1;
      S_TYPE:  TB_S_TYPE = 1;
      B_TYPE:  TB_B_TYPE = 1;
      U_TYPE:  TB_U_TYPE = 1;
      J_TYPE:  TB_J_TYPE = 1;
      default: TB_R_TYPE = 1;
    endcase

    TB_ALU_AND = 0;
    TB_ALU_OR = 0;
    TB_ALU_XOR = 0;
    TB_ALU_ADD = 0;
    TB_ALU_SUB = 0;
    TB_ALU_SHIFT_LEFT = 0;
    TB_ALU_SHIFT_RIGHT = 0;
    TB_ALU_SHIFT_RIGHT_AR = 0;
    TB_ALU_LESS_THAN_UNSIGNED = 0;
    TB_ALU_LESS_THAN_SIGNED = 0;
    case (control.alu_op)
      ALU_AND:                TB_ALU_AND = 1;
      ALU_OR:                 TB_ALU_OR = 1;
      ALU_XOR:                TB_ALU_XOR = 1;
      ALU_ADD:                TB_ALU_ADD = 1;
      ALU_SUB:                TB_ALU_SUB = 1;
      ALU_SHIFT_LEFT:         TB_ALU_SHIFT_LEFT = 1;
      ALU_SHIFT_RIGHT:        TB_ALU_SHIFT_RIGHT = 1;
      ALU_SHIFT_RIGHT_AR:     TB_ALU_SHIFT_RIGHT_AR = 1;
      ALU_LESS_THAN_UNSIGNED: TB_ALU_LESS_THAN_UNSIGNED = 1;
      ALU_LESS_THAN_SIGNED:   TB_ALU_LESS_THAN_SIGNED = 1;
      default:                TB_ALU_ADD = 1;
    endcase

    TB_alu_src = control.alu_src;
    TB_mem_read = control.mem_read;
    TB_mem_write = control.mem_write;
    TB_mem_to_reg = control.mem_to_reg;
    TB_is_branch = control.is_branch;
    TB_reg_write = control.reg_write;

    TB_write_back_id = control.write_back_id;
  end
*/
endmodule
