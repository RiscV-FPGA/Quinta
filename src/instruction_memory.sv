
module instruction_memory (
    input logic clk,
    input logic [31:0] byte_address,
    input logic write_enable,
    input logic [31:0] write_data,
    output logic [31:0] read_data
);

  //logic [31:0] temp_sim_ram[256];
  //logic [31:0] temp_sim_ram_row;

  logic [7:0] ram[1024];  // 512 compact or 256 32-bit instructions

  // 1023 = 10 bits
  logic [9:0] word_address;
  assign word_address = byte_address[9:0];

  initial begin
    //$readmemb("src/instruction_mem_temp.mem", ram);
    $readmemb("instruction_mem_temp.mem", ram);
  end

  always @(posedge clk) begin
    if (write_enable) begin
      ram[word_address]   <= write_data[7:0];
      ram[word_address+1] <= write_data[15:8];
      ram[word_address+2] <= write_data[23:16];
      ram[word_address+3] <= write_data[31:24];
    end
  end

  assign read_data = {
    ram[word_address], ram[word_address+1], ram[word_address+2], ram[word_address+3]
  };

endmodule
