
module data_memory (
    input logic clk,
    input logic [31:0] byte_address,
    input logic write_enable,
    input logic [31:0] write_data,
    output logic [31:0] read_data
);

  logic [31:0] data_ram[256];
  logic [7:0] word_address;

  assign word_address = byte_address[9:2];

  always @(posedge clk) begin
    if (write_enable == 1) begin
      data_ram[word_address] <= write_data;
    end
  end

  assign read_data = data_ram[word_address];

endmodule
