module uart_vga_ram (
    input logic clk,
    input logic [31:0] read_address,
    input logic [7:0] ram_in,
    input logic [31:0] write_address,
    input logic we,
    output logic [159:0] ram_out
);

  reg [159:0] mem[64]; //1280 = 160*64/8

  initial begin
    //$readmemb("src/uart_vga_ram.mem", mem);
    $readmemb("uart_vga_ram.mem", mem);
  end

  always @(posedge clk) begin
    if (we) begin
      //mem[write_address] <= ram_in;
    end
    ram_out <= mem[read_address];
  end

endmodule
