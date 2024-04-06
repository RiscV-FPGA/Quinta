module uart_top (
    input logic clk,
    input logic rst,

    output logic vga_vsync,
    output logic vga_hsync,
    output logic [3:0] vga_r,
    output logic [3:0] vga_g,
    output logic [3:0] vga_b
);

  wire [ 7:0] sdl_r;
  wire [ 7:0] sdl_g;
  wire [ 7:0] sdl_b;
  wire [31:0] sdl_sx;
  wire [31:0] sdl_sy;
  wire        sdl_de;

  //uart uart_inst (
  //    .clk(clk),
  //    .rst(rst)
  //);

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
