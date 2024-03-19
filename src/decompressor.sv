import common_pkg::*;

module decompressor (
	input logic[33:0] instruction_in;
	output instruction_t instruction_out;
);

logic temp [31:0];
always_comb begin : decompressor_main_comb
  instruction_out = '0;
	temp = '0;
  case (instruction_in[1:0])
		2'b00: begin
			case (instruction_in[15:13])
				3'b010: begin //LW
					instruction_out.opcode = 7'b0000011;
					instruction_out.block1 = {5'b00, instruction_in[4:2]};
					instruction_out.block2 = 3'b010;
					instruction_out.block3 = {5'b00, instruction_in[9:7]};
					temp = {instruction_in[5], instruction_in[12:10], instruction_in[6]}*4;
					instruction_out.block4 = temp[4:0];
					instruction_out.block5 = {{5{temp[6]}}, temp[6:5]};
				end
				3'b110: begin //SW
					instruction_out.opcode = 7'b0100011;
					instruction_out.block1 =
					instruction_out.block2 = 3'b010;
					instruction_out.block3 = 
					instruction_out.block4 = 
					instruction_out.block5 =
				end
				default: begin

				end
			endcase
		end
		2'b01: begin
			case (instruction_in[15:13])
				3'b000: begin //ADDI
					instruction_out.opcode = 7'b0010011;
					instruction_out.block1 =
					instruction_out.block2 = 3'b000;
					instruction_out.block3 = 
					instruction_out.block4 = 
					instruction_out.block5 =
				end
				3'b001: begin //JAL
					instruction_out.opcode = 7'b1101111;
					instruction_out.block1 =
					instruction_out.block2 = 
					instruction_out.block3 = 
					instruction_out.block4 = 
					instruction_out.block5 =
				end
				3'b010: begin //LI -> ADDI
					instruction_out.opcode = 7'b0010011;
					instruction_out.block1 =
					instruction_out.block2 = 3'b000;
					instruction_out.block3 = 
					instruction_out.block4 = 
					instruction_out.block5 =
				end
				3'b011: begin //LUI
					instruction_out.opcode = 7'b0110111;
					instruction_out.block1 =
					instruction_out.block2 = 
					instruction_out.block3 = 
					instruction_out.block4 = 
					instruction_out.block5 =
				end
				3'b100: begin //MISC-ALU
					case (instruction_in[11:10])
						2'b00: begin //SRLI
							instruction_out.opcode = 7'b0010011;
							instruction_out.block1 =
							instruction_out.block2 = 3'b101;
							instruction_out.block3 = 
							instruction_out.block4 = 
							instruction_out.block5 = 7'b0000000;
						end
						2'b01: begin //SRAI
							instruction_out.opcode = 7'b0010011;
							instruction_out.block1 =
							instruction_out.block2 = 3'b101;
							instruction_out.block3 = 
							instruction_out.block4 = 
							instruction_out.block5 = 7'b0100000;
						end
						2'b10: begin //ANDI
							instruction_out.opcode = 7'b0010011;
							instruction_out.block1 =
							instruction_out.block2 = 3'b111;
							instruction_out.block3 = 
							instruction_out.block4 = 
							instruction_out.block5 =
						end
						2'b11: begin
							case (instruction_in[6:5])
								2'b00: begin //SUB
									instruction_out.opcode = 7'b0110011;
									instruction_out.block1 =
									instruction_out.block2 = 3'b000;
									instruction_out.block3 = 
									instruction_out.block4 = 
									instruction_out.block5 = 7'b0100000;
								end
								2'b01: begin //XOR -> AND
									instruction_out.opcode = 7'b0110011;
									instruction_out.block1 =
									instruction_out.block2 = 3'b111;
									instruction_out.block3 = 
									instruction_out.block4 = 
									instruction_out.block5 = 7'b0000000;
								end
								2'b10: begin //OR
									instruction_out.opcode = 7'b0110011;
									instruction_out.block1 =
									instruction_out.block2 = 3'b110;
									instruction_out.block3 = 
									instruction_out.block4 =
									instruction_out.block5 = 7'b0000000;
								end
								2'b11: begin //AND
									instruction_out.opcode = 7'b0110011;
									instruction_out.block1 =
									instruction_out.block2 = 3'b111;
									instruction_out.block3 = 
									instruction_out.block4 = 
									instruction_out.block5 = 7'b0000000;
								end
							endcase
						end
					endcase
				end
				3'b101: begin //J -> JAL
					instruction_out.opcode = 7'b1101111;
					instruction_out.block1 =
					instruction_out.block2 = 
					instruction_out.block3 = 
					instruction_out.block4 = 
					instruction_out.block5 =
				end
				3'b110: begin //BEQZ
					instruction_out.opcode = 7'b1100011;
					instruction_out.block1 =
					instruction_out.block2 = 3'b000;
					instruction_out.block3 = 
					instruction_out.block4 = 
					instruction_out.block5 =
				end
				3'b111: begin //BNEZ
					instruction_out.opcode = 7'b1100011;
					instruction_out.block1 =
					instruction_out.block2 = 3'b001;
					instruction_out.block3 = 
					instruction_out.block4 = 
					instruction_out.block5 =
				end
			endcase
		end
		2'b10: begin
			case (instruction_in[15:13])
				3'b000: begin //SLLI
					instruction_out.opcode = 7'b0010011;
					instruction_out.block1 =
					instruction_out.block2 = 3'b001;
					instruction_out.block3 = 
					instruction_out.block4 = 
					instruction_out.block5 = 7'b0000000;
				end
				3'b100: begin //JR/JALR/MV/ADD
					if(instruction_in[12] == 1'b0 && instruction_in[6:2] == 5'b00000) begin //JR -> JALR
						instruction_out.opcode = 7'b1100111;
						instruction_out.block1 =
						instruction_out.block2 = 3'b000;
						instruction_out.block3 = 
						instruction_out.block4 = 
						instruction_out.block5 =
					end else if(instruction_in[12] == 1'b0)begin //MV -> ADD
						instruction_out.opcode = 7'b0110011;
						instruction_out.block1 =
						instruction_out.block2 = 3'b000;
						instruction_out.block3 = 
						instruction_out.block4 = 	
						instruction_out.block5 = 7'b0000000;
					end else if(instruction_in[12] == 1'b1 && instruction_in[6:2] == 5'b00000) begin //JALR
						instruction_out.opcode = 7'b1100111;
						instruction_out.block1 =
						instruction_out.block2 = 3'b000;
						instruction_out.block3 = 
						instruction_out.block4 = 
						instruction_out.block5 =
					end else if(instruction_in[12] == 1'b1) begin //ADD
						instruction_out.opcode = 7'b0110011;
						instruction_out.block1 =
						instruction_out.block2 = 3'b000;
						instruction_out.block3 = 
						instruction_out.block4 = 
						instruction_out.block5 = 7'b0000000;
					end else begin
					end
				end
				default: begin

				end
			endcase
		end
		2'b11: begin
			instruction_out = instruction_in;
		end;
	endcase
end