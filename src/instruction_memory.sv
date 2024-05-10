
module instruction_memory (
    input logic clk,
    input logic [31:0] byte_address,
    input logic write_enable,
    input logic [31:0] write_data,
    output logic [31:0] read_data
    //input logic start  //temp for tb
);

  logic [31:0] instr_ram[1024];  // 512 compact or 256 32-bit instructions

  always_ff @(posedge clk) begin
    if (write_enable) begin
      instr_ram[byte_address[11:2]] <= write_data;
    end
  end

  always_comb begin : blockName
    if (byte_address[1] == 0) begin  // standard 32 bit slot
      read_data = instr_ram[byte_address[11:2]];
      // read_data = instr_ram[byte_address[31:2]];

    end else begin  // half slot :(
      read_data[15:0]  = instr_ram[byte_address[11:2]][31:16];
      read_data[31:16] = instr_ram[byte_address[11:2]+1][15:0];
    end
  end

endmodule
