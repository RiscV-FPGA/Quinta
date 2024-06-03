import common_pkg::*;

module decompressor (
    input logic [31:0] instruction_in,
    output instruction_t instruction_out
);

  always_comb begin : decompressor_main_comb
    instruction_out = '0;

    casez (instruction_in[15:0])
      COMPACT_LW: begin
        instruction_out.opcode = 7'b0000011;
        instruction_out.block1 = {2'b01, instruction_in[4:2]};
        instruction_out.block2 = 3'b010;
        instruction_out.block3 = {2'b01, instruction_in[9:7]};
        instruction_out.block4 = {instruction_in[11:10], instruction_in[6], 2'b00};
        instruction_out.block5 = {{6{instruction_in[5]}}, instruction_in[12]};
      end
      COMPACT_SW: begin
        instruction_out.opcode = 7'b0100011;
        instruction_out.block1 = {instruction_in[11:10], instruction_in[6], 2'b00};
        instruction_out.block2 = 3'b010;
        instruction_out.block3 = {2'b01, instruction_in[9:7]};
        instruction_out.block4 = {2'b01, instruction_in[4:2]};
        instruction_out.block5 = {{6{instruction_in[5]}}, instruction_in[12]};
      end
      COMPACT_ADDI: begin
        instruction_out.opcode = 7'b0010011;
        instruction_out.block1 = instruction_in[11:7];
        instruction_out.block2 = 3'b000;
        instruction_out.block3 = instruction_in[11:7];
        instruction_out.block4 = instruction_in[6:2];
        instruction_out.block5 = {7{instruction_in[12]}};
      end
      COMPACT_JAL: begin
        instruction_out.opcode = 7'b1101111;
        instruction_out.block1 = 5'b00001;  // ra (return address = x1)

        instruction_out.block2 = {3{instruction_in[12]}};
        instruction_out.block3 = {5{instruction_in[12]}};
        instruction_out.block4 = {instruction_in[11], instruction_in[5:3], instruction_in[12]};
        instruction_out.block5 = {
          instruction_in[12],
          instruction_in[8],
          instruction_in[10:9],
          instruction_in[6],
          instruction_in[7],
          instruction_in[2]
        };
      end
      COMPACT_LI: begin
        //C_LI -> ADDI x0
        instruction_out.opcode = 7'b0010011;
        instruction_out.block1 = instruction_in[11:7];
        instruction_out.block2 = 3'b000;
        instruction_out.block3 = 5'b00000;

        instruction_out.block4 = instruction_in[6:2];
        instruction_out.block5 = {7{instruction_in[12]}};
      end
      COMPACT_LUI: begin
        instruction_out.opcode = 7'b0110111;
        instruction_out.block1 = instruction_in[11:7];
        instruction_out.block2 = instruction_in[4:2];
        instruction_out.block3 = {{3{instruction_in[12]}}, instruction_in[6:5]};
        instruction_out.block4 = {5{instruction_in[12]}};
        instruction_out.block5 = {7{instruction_in[12]}};
      end
      COMPACT_SRLI: begin
        instruction_out.opcode = 7'b0010011;
        instruction_out.block1 = {2'b01, instruction_in[9:7]};
        instruction_out.block2 = 3'b101;
        instruction_out.block3 = {2'b01, instruction_in[9:7]};
        instruction_out.block4 = instruction_in[6:2];
        instruction_out.block5 = 7'b0000000;
      end
      COMPACT_SRAI: begin
        instruction_out.opcode = 7'b0010011;
        instruction_out.block1 = {2'b01, instruction_in[9:7]};
        instruction_out.block2 = 3'b101;
        instruction_out.block3 = {2'b01, instruction_in[9:7]};
        instruction_out.block4 = instruction_in[6:2];
        instruction_out.block5 = 7'b0100000;
      end
      COMPACT_ANDI: begin
        instruction_out.opcode = 7'b0010011;
        instruction_out.block1 = {2'b01, instruction_in[9:7]};
        instruction_out.block2 = 3'b111;
        instruction_out.block3 = {2'b01, instruction_in[9:7]};
        instruction_out.block4 = instruction_in[6:2];
        instruction_out.block5 = {7{instruction_in[12]}};
      end
      COMPACT_SUB: begin
        instruction_out.opcode = 7'b0110011;
        instruction_out.block1 = {2'b01, instruction_in[9:7]};
        instruction_out.block2 = 3'b000;
        instruction_out.block3 = {2'b01, instruction_in[9:7]};
        instruction_out.block4 = {2'b01, instruction_in[4:2]};
        instruction_out.block5 = 7'b0100000;
      end
      COMPACT_XOR: begin
        instruction_out.opcode = 7'b0110011;
        instruction_out.block1 = {2'b01, instruction_in[9:7]};
        instruction_out.block2 = 3'b100;
        // instruction_out.block2 = instruction_in[15:13]; wierd fix
        instruction_out.block3 = {2'b01, instruction_in[9:7]};
        instruction_out.block4 = {2'b01, instruction_in[4:2]};
        instruction_out.block5 = 7'b0000000;
      end
      COMPACT_OR: begin
        instruction_out.opcode = 7'b0110011;
        instruction_out.block1 = {2'b01, instruction_in[9:7]};
        instruction_out.block2 = 3'b110;
        instruction_out.block3 = {2'b01, instruction_in[9:7]};
        instruction_out.block4 = {2'b01, instruction_in[4:2]};
        instruction_out.block5 = 7'b0000000;
      end
      COMPACT_AND: begin
        instruction_out.opcode = 7'b0110011;
        instruction_out.block1 = {2'b01, instruction_in[9:7]};
        instruction_out.block2 = 3'b111;
        instruction_out.block3 = {2'b01, instruction_in[9:7]};
        instruction_out.block4 = {2'b01, instruction_in[4:2]};
        instruction_out.block5 = 7'b0000000;
      end
      COMPACT_J: begin
        //J -> JAL
        instruction_out.opcode = 7'b1101111;
        instruction_out.block1 = 5'b00000;
        instruction_out.block2 = {3{instruction_in[12]}};
        instruction_out.block3 = {5{instruction_in[12]}};
        instruction_out.block4 = {instruction_in[11], instruction_in[5:3], instruction_in[12]};
        instruction_out.block5 = {
          instruction_in[12],
          instruction_in[8],
          instruction_in[10:9],
          instruction_in[6],
          instruction_in[7],
          instruction_in[2]
        };

      end
      COMPACT_BEQZ: begin
        instruction_out.opcode = 7'b1100011;
        instruction_out.block1 = {instruction_in[11:10], instruction_in[4:3], instruction_in[12]};
        instruction_out.block2 = 3'b000;
        instruction_out.block3 = {2'b01, instruction_in[9:7]};
        instruction_out.block4 = 5'b00000;
        instruction_out.block5 = {{4{instruction_in[12]}}, instruction_in[6:5], instruction_in[2]};
      end
      COMPACT_BNEZ: begin
        instruction_out.opcode = 7'b1100011;
        instruction_out.block1 = {instruction_in[11:10], instruction_in[4:3], instruction_in[12]};
        instruction_out.block2 = 3'b001;
        instruction_out.block3 = {2'b01, instruction_in[9:7]};
        instruction_out.block4 = 5'b00000;
        instruction_out.block5 = {{4{instruction_in[12]}}, instruction_in[6:5], instruction_in[2]};
      end
      COMPACT_SLLI: begin
        instruction_out.opcode = 7'b0010011;
        instruction_out.block1 = {2'b01, instruction_in[9:7]};
        instruction_out.block2 = 3'b001;
        instruction_out.block3 = {2'b01, instruction_in[9:7]};
        instruction_out.block4 = instruction_in[6:2];
        instruction_out.block5 = 7'b0000000;
      end
      COMPACT_JR_MV: begin
        if (instruction_in[6:2] == 5'b00000) begin
          //JR -> JALR
          instruction_out.opcode = 7'b1100111;
          instruction_out.block1 = 5'b00000;
          instruction_out.block2 = 3'b000;
          instruction_out.block3 = instruction_in[11:7];
          instruction_out.block4 = '0;
          instruction_out.block5 = '0;
        end else begin
          //MV -> ADD
          instruction_out.opcode = 7'b0110011;
          instruction_out.block1 = instruction_in[11:7];
          instruction_out.block2 = 3'b000;
          instruction_out.block3 = instruction_in[6:2];
          instruction_out.block4 = '0;
          instruction_out.block5 = 7'b0000000;
        end
      end
      COMPACT_JALR_ADD: begin
        if (instruction_in[6:2] == 5'b00000) begin
          // JALR
          instruction_out.opcode = 7'b1100111;
          instruction_out.block1 = 5'b00001;
          instruction_out.block2 = 3'b000;
          instruction_out.block3 = instruction_in[11:7];
          instruction_out.block4 = '0;
          instruction_out.block5 = '0;
        end else begin
          // ADD
          instruction_out.opcode = 7'b0110011;
          instruction_out.block1 = instruction_in[11:7];
          instruction_out.block2 = 3'b000;
          instruction_out.block3 = instruction_in[11:7];
          instruction_out.block4 = instruction_in[6:2];
          instruction_out.block5 = 7'b0000000;
        end
      end

      default: begin
        instruction_out = instruction_in;
      end
    endcase
  end
endmodule
