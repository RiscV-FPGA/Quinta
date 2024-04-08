module uart_top (
    input logic clk,
    input logic rst,
    input logic rx_serial,

    output logic vga_vsync,
    output logic vga_hsync,
    output logic [3:0] vga_r,
    output logic [3:0] vga_g,
    output logic [3:0] vga_b,

    output logic [7:0] led
);

  wire  [ 7:0] sdl_r;
  wire  [ 7:0] sdl_g;
  wire  [ 7:0] sdl_b;
  wire  [31:0] sdl_sx;
  wire  [31:0] sdl_sy;
  wire         sdl_de;

  logic [ 7:0] rx_byte;
  logic        rx_byte_valid;

  always_ff @(posedge clk) begin
    if (rst == 1) begin
      led <= 8'b10101010;
    end else if (rx_byte_valid == 1) begin
      led <= rx_byte;
    end
  end

  uart uart_inst (
      .clk(clk),
      .rx_serial(rx_serial),
      .rx_byte(rx_byte),
      .rx_byte_valid(rx_byte_valid)
  );

  uart_vga uart_vga_inst (
      .clk(clk),
      .rst(rst),
      .vga_vsync(vga_vsync),
      .vga_hsync(vga_hsync),
      .vga_r(vga_r),
      .vga_g(vga_g),
      .vga_b(vga_b),

      .sdl_r (sdl_r),
      .sdl_g (sdl_g),
      .sdl_b (sdl_b),
      .sdl_sx(sdl_sx),
      .sdl_sy(sdl_sy),
      .sdl_de(sdl_de)
  );

endmodule
