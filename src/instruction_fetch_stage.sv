import common_pkg::*;

module instruction_fetch_stage (
    input  logic                clk,
    input  logic                rst,
    input  logic                start,
    input  logic         [31:0] write_byte_address,
    input  logic         [31:0] write_instr_data,
    input  logic                write_instr_valid,
    input  logic                branch_taken,
    input  logic         [31:0] pc_branch,
    input  logic                hazard_detected,
    output logic         [31:0] pc,
    output instruction_t        instruction
);

  logic [31:0] byte_address;
  logic [31:0] write_data;
  logic [31:0] instruction_internal;

  always_ff @(posedge clk) begin
    if (rst == 1) begin
      pc <= 0;
    end else begin
      if (start == 1) begin
        if (branch_taken == 1) begin
          pc <= pc_branch;
        end else if (hazard_detected == 1 || instruction_internal[6:0] == 7'b1111111) begin
          pc <= pc;
        end else begin
          if (instruction_internal[1:0] == 2'b11) begin
            pc <= pc + 4;  // 32 bit instruction
            //$display("isntr_32%032b, @%d", instruction_internal, pc);
          end else begin
            pc <= pc + 2;  // 16 bit instruction
            //$display("isntr_16 %032b, @%d", instruction_internal, pc);
          end
        end
      end else begin
        pc <= 0;  // start == 0
      end
    end
  end

  always_comb begin
    if (start == 1) begin
      byte_address = pc;
    end else begin
      // inst from uart
      byte_address = write_byte_address;
    end
  end

  instruction_memory instruction_memory_inst (
      .clk(clk),
      .byte_address(byte_address),
      .write_data(write_instr_data),
      .write_enable(write_instr_valid),
      .read_data(instruction_internal)
      //.start(start)
  );

  decompressor decompressor_inst (
      .instruction_in (instruction_internal),
      .instruction_out(instruction)
  );

endmodule
