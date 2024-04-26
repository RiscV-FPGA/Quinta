
module instruction_memory (
    input logic clk,
    input logic [31:0] byte_address,
    input logic write_enable,
    input logic [31:0] write_data,
    output logic [31:0] read_data,
    input logic start  //temp for tb
);

  logic [31:0] instr_ram[1024];  // 512 compact or 256 32-bit instructions

  //initial begin
  //$readmemb("src/instruction_mem_temp.mem", instr_ram);
  //$readmemb("instruction_mem_temp.mem", instr_ram);
  //end

  always @(posedge clk) begin
    if (write_enable) begin
      instr_ram[byte_address[31:2]] <= write_data;
      //$display("write %032b, @%d", write_data, byte_address);
      //$display("---------------------------------");
    end
  end

  always_comb begin : blockName
    if (byte_address[1] == 0) begin  // standard 32 bit slot
      read_data = instr_ram[byte_address[31:2]];

    end else begin  // half slot :(
      read_data[15:0]  = instr_ram[byte_address[31:2]][31:16];
      read_data[31:16] = instr_ram[byte_address[31:2]+1][15:0];
    end
  end

  logic temp = 0;
  always @(posedge clk) begin
    if (start == 1 && temp == 0) begin
      temp = 1;
      for (int i = 0; i < 25; i++) begin
        if (i < 10) begin
          $display("inst_addr__%0d: %032b", i, instr_ram[i]);
        end else begin
          $display("inst_addr_%0d: %032b", i, instr_ram[i]);
        end
      end
    end
  end

endmodule
