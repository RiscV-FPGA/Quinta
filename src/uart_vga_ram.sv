module uart_vga_ram (
    input logic clk,
    input logic [31:0] read_address,
    input logic [7:0] ram_in,
    input logic [31:0] write_address,
    input logic we,
    output logic [7:0] ram_out
);

  localparam integer ResolutionX = 640;
  localparam integer ResolutionY = 512;
  localparam integer RAMBits = 640 * 512 / 8;

  reg [7:0] mem[RAMBits];

  initial begin
    $readmemb("src/uart_vga_ram.mem", mem);
    //$readmemb("uart_vga_ram.mem", mem);
  end

  always @(posedge clk) begin
    if (we) begin
      mem[write_address] <= ram_in;
    end
    ram_out <= mem[read_address];
  end

endmodule
