// Project F: FPGA Graphics - Square (Verilator SDL)
// (C)2023 Will Green, open source hardware released under the MIT License
// Learn more at https://projectf.io/posts/fpga-graphics/

module uart_vga (  // coordinate width
    input  wire logic       clk,        // pixel clock
    input  wire logic       rst,        // sim reset
    output logic            vga_vsync,
    output logic            vga_hsync,
    output logic      [3:0] vga_r,      // 8-bit red
    output logic      [3:0] vga_g,      // 8-bit green
    output logic      [3:0] vga_b,      // 8-bit blue

    output logic [ 7:0] sdl_r,   // 8-bit red
    output logic [ 7:0] sdl_g,   // 8-bit green
    output logic [ 7:0] sdl_b,   // 8-bit blue
    output logic [31:0] sdl_sx,  // horizontal SDL position
    output logic [31:0] sdl_sy,  // vertical SDL position
    output logic        sdl_de   // data enable (low in blanking interval)

);

  // display sync signals and coordinates

  // -----------------SYNC------------------------
  // horizontal timings
  parameter integer HA_END = 1279;  // end of active pixels
  parameter integer HS_STA = HA_END + 48;  // sync starts after front porch
  parameter integer HS_END = HS_STA + 112;  // sync ends
  parameter integer LINE = 1687;  // last pixel on line (after back porch)

  // vertical timings
  parameter integer VA_END = 1023;  // end of active pixels
  parameter integer VS_STA = VA_END + 1;  // sync starts after front porch
  parameter integer VS_END = VS_STA + 3;  // sync ends
  parameter integer SCREEN = 1065;  // last line on screen (after back porch)

  always_comb begin
    vga_hsync = ~(sx >= HS_STA && sx < HS_END);  // invert: negative polarity
    vga_vsync = ~(sy >= VS_STA && sy < VS_END);  // invert: negative polarity
    de = (sx <= HA_END && sy <= VA_END);
  end

  // calculate horizontal and vertical screen position
  always_ff @(posedge clk) begin
    if (rst == 1) begin
      sx <= 0;
      sy <= 0;
    end else begin
      if (sx == LINE) begin  // last pixel on line?
        sx <= 0;
        sy <= (sy == SCREEN) ? 0 : sy + 1;  // last line on screen?
      end else begin
        sx <= sx + 1;
      end
    end
  end
  // -----------------SYNC------------------------

  logic [31:0] sx, sy;
  logic de;

  logic [31:0] ram_y_address;
  logic [31:0] ram_x_address;
  logic [31:0] write_address;
  logic [7:0] ram_in;
  logic [159:0] ram_out;
  logic we;

  logic [7:0] one[16];
  logic [7:0] zero[16];

  initial begin
    $readmemb("src/uart_vga_one.mem", one);
    $readmemb("src/uart_vga_zero.mem", zero);
    //$readmemb("uart_vga_ram.mem", mem);
  end


  uart_vga_ram uart_vga_ram_inst (
      .clk(clk),
      .read_address(ram_y_address),
      .ram_in(ram_in),
      .write_address(write_address),
      .we(we),
      .ram_out(ram_out)
  );


  assign ram_y_address = {4'b0000, sy[31:4]};  // = sy/16
  assign ram_x_address = 160 - {3'b000, sx[31:3]};  // = sx/8

  // num
  logic one_in_ram;
  always_comb begin
    one_in_ram = ram_out[ram_x_address];
  end

  // create one ore zero
  logic num_on;
  logic [7:0] temp_row;
  always_comb begin
    if (one_in_ram) begin
      temp_row = one[sy[3:0]];
      num_on   = temp_row[sx[2:0]];
    end else begin
      temp_row = zero[sy[3:0]];
      num_on   = temp_row[sx[2:0]];
    end
  end

  // grid
  logic grid_on;
  always_comb begin
    if (sx < 24 || (sx > 423 && sx < 440) || (sx > 839 && sx < 856) || sx > 1255) begin
      grid_on = 1;
    end else begin
      grid_on = 0;
    end
  end

  // background
  logic background_on;
  always_comb begin
    if (sx < 96 || (sx > 351 && sx < 424) || (sx > 439 && sx < 512)) begin
      background_on = 1;  // two else if becose they got so long :)
    end else if ((sx > 767 && sx < 840) || (sx > 855 && sx < 928) || sx > 1183) begin
      background_on = 1;  // two else if becose they got so long :)
    end else begin
      background_on = 0;
    end
  end

  always_comb begin
    if (grid_on == 1) begin
      vga_r = 4'h3;
      vga_g = 4'h3;
      vga_b = 4'h3;
    end else if (background_on == 1) begin
      vga_r = 4'h5;
      vga_g = 4'h3;
      vga_b = 4'h7;
    end else if (num_on == 1) begin
      vga_r = 4'hF;
      vga_g = 4'hF;
      vga_b = 4'hF;
    end else begin
      vga_r = 4'h5;
      vga_g = 4'h3;
      vga_b = 4'h7;
    end
  end






  // display colour: paint colour but black in blanking interval
  /* always_comb begin
    vga_r = (de) ? paint_r : 4'h0;
    vga_g = (de) ? paint_g : 4'h0;
    vga_b = (de) ? paint_b : 4'h0;
  end
*/

  // SDL output (8 bits per colour channel)
  always_ff @(posedge clk) begin
    sdl_sx <= sx;
    sdl_sy <= sy;
    sdl_de <= de;
    sdl_r  <= {2{vga_r}};  // double signal width from 4 to 8 bits
    sdl_g  <= {2{vga_g}};
    sdl_b  <= {2{vga_b}};
  end
endmodule
