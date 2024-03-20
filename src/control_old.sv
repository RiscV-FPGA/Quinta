import common_pkg::*;

module control_old (
    input instruction_t instruction,
    output control_t control
);

  always_comb begin : control_main_comb
    control = '0;

    case (instruction.opcode)
      7'b0110111: begin  //LUI = Load Upper Imm
        control.encoding = U_TYPE;

      end

      7'b0010111: begin  // AUIPC = Add Upper Imm to PC
        control.encoding = U_TYPE;

      end

      7'b1101111: begin  // JAL = Jump & Link
        control.encoding = J_TYPE;

      end

      7'b1100111: begin  // JALR
        if (instruction.block2 == 3'b000) begin  // JALR = Jump & Link Regiser
          control.encoding = I_TYPE;

        end else begin
          $display("wrong instruction:%b", instruction);

        end
      end

      7'b1100011: begin  // Branch
        control.encoding = B_TYPE;

        case (instruction.block2)
          3'b000: begin  // BEQ, Branch =

          end
          3'b001: begin  // BNE, Branch ≠

          end
          3'b100: begin  // BLT, Branch <

          end
          3'b101: begin  // BGE, Branch ≥

          end
          3'b110: begin  // BLTU, Branch < Unsigned

          end
          3'b111: begin  // BGEU, Branch ≥ Unsigned

          end
          default: begin
            $display("wrong instruction:%b", instruction);
          end
        endcase
      end

      7'b0000011: begin
        control.encoding = I_TYPE;

        case (instruction.block2)
          3'b000: begin  // LB = Load Byte

          end
          3'b001: begin  // LH = Load Halfword

          end
          3'b010: begin  // LW = Load Word

          end
          3'b100: begin  // LBU = Load Byte Unsigned

          end
          3'b101: begin  // LHU = Load Half Unsigned

          end

          default: begin
            $display("wrong instruction:%b", instruction);
          end
        endcase
      end

      7'b0100011: begin
        control.encoding = S_TYPE;

        case (instruction.block2)
          3'b000: begin  // SB = Store Byte

          end
          3'b001: begin  // SH = Store Halfword

          end
          3'b010: begin  // SW = Store Word

          end
          default: begin
            $display("wrong instruction:%b", instruction);
          end
        endcase
      end

      7'b0010011: begin
        control.encoding = I_TYPE;

        case (instruction.block2)
          3'b000: begin  // ADDI = ADD Immediate

          end
          3'b010: begin  // SLTI = Set < Immediate

          end
          3'b011: begin  // SLTIU = Set < Imm Unsigned

          end
          3'b100: begin  // XORI = XOR Immediate

          end
          3'b110: begin  // ORI = OR Immediate

          end
          3'b111: begin  // ANDI = AND Immediate

          end
          3'b001: begin
            case (instruction.block5)
              7'b0000000: begin  // SLLI = Shift Left Log. Imm.

              end
              default: begin
                $display("wrong instruction:%b", instruction);
              end
            endcase
          end
          3'b101: begin
            case (instruction.block5)
              7'b0000000: begin  // SRLI = Shift Right Log. Imm.

              end
              7'b0100000: begin  // SRAI = Shift Right Arith. Imm.
                // FIX IMM

              end
              default: begin
                $display("wrong instruction:%b", instruction);
              end
            endcase
          end
          default: begin
            $display("wrong instruction:%b", instruction);
          end
        endcase
      end

      7'b0110011: begin
        control.encoding = R_TYPE;

        case (instruction.block2)
          3'b000: begin
            case (instruction.block5)
              7'b0000000: begin  // ADD

              end
              7'b0100000: begin  // SUB

              end
              7'b0000001: begin  // MUL = MULtiply

              end
              default: begin
                $display("wrong instruction:%b", instruction);
              end
            endcase
          end
          3'b001: begin
            case (instruction.block5)
              7'b0000000: begin  // SLL = Shift Left Logical

              end
              7'b0000001: begin  // MULH = MULtiply High

              end
              default: begin
                $display("wrong instruction:%b", instruction);
              end
            endcase
          end
          3'b010: begin
            case (instruction.block5)
              7'b0000000: begin  // SLT = Set <

              end
              default: begin
                $display("wrong instruction:%b", instruction);
              end
            endcase
          end
          3'b011: begin
            case (instruction.block5)
              7'b0000000: begin  // SLTU = Set < Unsigned

              end
              default: begin
                $display("wrong instruction:%b", instruction);
              end
            endcase
          end
          3'b100: begin
            case (instruction.block5)
              7'b0000000: begin  // XOR

              end
              7'b0000001: begin  // DIV = DIVide

              end
              default: begin
                $display("wrong instruction:%b", instruction);
              end
            endcase
          end
          3'b101: begin
            case (instruction.block5)
              7'b0000000: begin  // SRL = Shift Right Logical

              end
              7'b0100000: begin  // SRA = Shift Right Arithmetic

              end
              7'b0000001: begin  // DIVU = DIVide Unsigned

              end
              default: begin
                $display("wrong instruction:%b", instruction);
              end
            endcase
          end
          3'b110: begin
            case (instruction.block5)
              7'b0000000: begin  // OR

              end
              7'b0000001: begin  // REM = REMainder

              end
              default: begin
                $display("wrong instruction:%b", instruction);
              end
            endcase
          end
          3'b111: begin
            case (instruction.block5)
              7'b0000000: begin  // AND

              end
              7'b0000001: begin  // REMU = REMainder Unsigned

              end
              default: begin
                $display("wrong instruction:%b", instruction);
              end
            endcase
          end
          default: begin
            $display("wrong instruction:%b", instruction);
          end
        endcase
      end

      // floating point
      7'b0000111: begin  // FLW
        if (instruction.block2 == 3'b010) begin
          control.encoding = I_TYPE;

        end else begin
          $display("wrong instruction:%b", instruction);
        end
      end

      7'b0100111: begin  // FSW
        if (instruction.block2 == 3'b010) begin  // FSW
          control.encoding = S_TYPE;

        end else begin
          $display("wrong instruction:%b", instruction);
        end
      end

      7'b1010011: begin  // floating point operations
        control.encoding = R_TYPE;

        case (instruction.block5)
          7'b0000000: begin  // FADD.S

          end
          7'b0000100: begin  // FSUB.S

          end
          7'b0001000: begin  // FMUL.S

          end
          7'b0001100: begin  // FDIV.S

          end
          7'b0101100: begin  // FSQRT.S
            if (instruction.block4 == 5'b00000) begin  // FSQRT.S

            end else begin
              $display("wrong instruction:%b", instruction);
            end
          end

          7'b1110000: begin  // FMX.X.W
            if (instruction.block4 == 5'b00000 & instruction.block2 == 3'b000) begin  // FMX.X.W

            end else begin
              $display("wrong instruction:%b", instruction);
            end
          end

          7'b1010000: begin
            case (instruction.block2)
              3'b010: begin  // FRQ.S

              end
              3'b001: begin  // FLT.S

              end
              3'b000: begin  // FLE.S

              end
              default: begin
                $display("wrong instruction:%b", instruction);
              end
            endcase
          end

          7'b1111000: begin  // FMV.W.X
            if (instruction.block4 == 5'b00000 & instruction.block2 == 3'b000) begin  // FMX.X.W

            end else begin
              $display("wrong instruction:%b", instruction);
            end
          end
          default: begin
            $display("wrong instruction:%b", instruction);
          end
        endcase
      end

      default: begin  // default for big case statment
        $display("wrong instruction:%b", instruction);
      end
    endcase
  end  // en always comb

endmodule
