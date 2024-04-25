
module instruction_memory (
    input logic clk,
    input logic [31:0] byte_address,
    input logic write_enable,
    input logic [31:0] write_data,
    output logic [31:0] read_data
);

  logic [7:0] ram[1024];  // 512 compact or 256 32-bit instructions

  //initial begin
  //$readmemb("src/instruction_mem_temp.mem", ram);
  //$readmemb("instruction_mem_temp.mem", ram);
  //end

  always @(posedge clk) begin
    if (write_enable) begin
      ram[byte_address]   <= write_data[31:24];
      ram[byte_address+1] <= write_data[23:16];
      ram[byte_address+2] <= write_data[15:8];
      ram[byte_address+3] <= write_data[7:0];
    end
  end

  assign read_data = {
    ram[byte_address], ram[byte_address+1], ram[byte_address+2], ram[byte_address+3]
  };

endmodule
