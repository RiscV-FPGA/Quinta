import common_pkg::*;

module instruction_decode_stage (
    input logic clk,
    input logic rst,
    input instruction_t instruction,
    input logic [31:0] pc,
    input logic reg_write,
    input logic reg_write_float,
    input logic [4:0] write_id,
    input logic [31:0] write_data,
    output logic [31:0] immediate_data,
    output control_t control,
    output logic [31:0] read1_data,
    output logic [31:0] read2_data,
    output logic [4:0] rs1,
    output logic [4:0] rs2
);

  logic [31:0] read1_data_regs;
  logic [31:0] read2_data_regs;
  logic [31:0] read1_data_regs_float;
  logic [31:0] read2_data_regs_float;

  always_comb begin : register_forwarding
    if (write_id == rs1 && reg_write == 1 && control.reg_read_float == 0) begin
      read1_data = write_data;
    end else if (write_id == rs1 && reg_write_float == 1 && control.reg_read_float == 1) begin
      read1_data = write_data;
    end else begin
      if (control.reg_read_float == 1) begin
        read1_data = read1_data_regs_float;
      end else begin
        read1_data = read1_data_regs;
      end
    end

    if (write_id == rs2 && reg_write == 1 && control.reg_read_float == 0) begin
      read2_data = write_data;
    end else if (write_id == rs2 && reg_write_float == 1 && control.reg_read_float == 1) begin
      read2_data = write_data;
    end else begin
      if (control.reg_read_float == 1) begin
        read2_data = read2_data_regs_float;
      end else begin
        read2_data = read2_data_regs;
      end
    end
  end

  logic reg_read_float_t;
  assign reg_read_float_t = control.reg_read_float;

  assign rs1 = instruction.block3;
  assign rs2 = instruction.block4;

  control control_inst (
      .instruction(instruction),
      .control(control)
  );

  registers registers_normal_inst (
      .clk(clk),
      .rst(rst),
      .read1_id(rs1),
      .read2_id(rs2),
      .write_en(reg_write),
      .write_id(write_id),
      .write_data(write_data),
      .read1_data(read1_data_regs),
      .read2_data(read2_data_regs)
  );

  registers_float registers_float_inst (
      .clk(clk),
      .rst(rst),
      .read1_id(rs1),
      .read2_id(rs2),
      .write_en(reg_write_float),
      .write_id(write_id),
      .write_data(write_data),
      .read1_data(read1_data_regs_float),
      .read2_data(read2_data_regs_float)
  );

  imm_gen imm_gen_inst (
      .instruction(instruction),
      .control_encoding(control.encoding),
      .immediate_data(immediate_data)
  );
endmodule
