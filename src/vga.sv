module vga #(
    parameter logic TB_MODE = 0
) (
    input  logic        clk,               // pixel clock
    input  logic        rst,               // sim reset
    input  logic [31:0] reg_mem_data,
    input  logic [ 4:0] reg_mem_addr,
    input  logic        reg_mem_enable,
    input  logic [31:0] instr_mem_data,
    input  logic [31:0] instr_mem_addr,
    input  logic        instr_mem_enable,
    input  logic [31:0] data_mem_data,
    input  logic [31:0] data_mem_addr,
    input  logic        data_mem_enable,
    output logic        vga_vsync,
    output logic        vga_hsync,
    output logic [ 3:0] vga_r,
    output logic [ 3:0] vga_g,
    output logic [ 3:0] vga_b,
    // FOR TB ONLY
    output logic [31:0] sdl_sx,            // horizontal SDL position
    output logic [31:0] sdl_sy,            // vertical SDL position
    output logic        sdl_de             // data enable (low in blanking interval)
);

  // -----------------SYNC------------------------
  // horizontal timings
  integer HA_END = 1368 - 1;  // end of active pixels
  integer HS_STA = HA_END + 72;  // sync starts after front porch
  integer HS_END = HS_STA + 144;  // sync ends
  integer LINE = 1800 - 1;  // last pixel on line (after back porch)

  // vertical timings
  integer VA_END = 768 - 1;  // end of active pixels
  integer VS_STA = VA_END + 1;  // sync starts after front porch
  integer VS_END = VS_STA + 3;  // sync ends
  integer SCREEN = 795 - 1;  // last line on screen (after back porch)

  logic [31:0] sx;
  logic [31:0] sy;
  logic de;

  logic [5:0] ram_y_address;
  //logic [31:0] ram_x_address;
  logic [31:0] write_address;
  logic [7:0] ram_in;
  logic [159:0] ram_out;
  logic we;

  logic [7:0] one[16];
  logic [7:0] zero[16];

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

  initial begin
    if (TB_MODE == 1) begin
      $readmemb("src/vga_one.mem", one);
      $readmemb("src/vga_zero.mem", zero);
    end else begin
      $readmemb("vga_one.mem", one);
      $readmemb("vga_zero.mem", zero);
    end


  end

  vga_ram vga_ram_inst (
      .clk(clk),
      .read_address(ram_y_address),
      .reg_mem_data(reg_mem_data),
      .reg_mem_addr(reg_mem_addr),
      .reg_mem_enable(reg_mem_enable),
      .instr_mem_data(instr_mem_data),
      .instr_mem_addr(instr_mem_addr),
      .instr_mem_enable(instr_mem_enable),
      .data_mem_data(data_mem_data),
      .data_mem_addr(data_mem_addr),
      .data_mem_enable(data_mem_enable),
      .ram_out(ram_out)
  );

  assign ram_y_address = {sy[9:4]};  // = sy/16

  // num
  logic one_in_ram;
  always_comb begin
    if (sx < 272) begin
      one_in_ram = ram_out[160-{3'b000, sx[31:3]}+1];  //instr1
    end else if (sx < 536) begin
      one_in_ram = ram_out[160-{3'b000, sx[31:3]}+2];  //instr2
    end else if (sx < 808) begin
      one_in_ram = ram_out[160-{3'b000, sx[31:3]}+4];  //reg
    end else if (sx < 1080) begin
      one_in_ram = ram_out[160-{3'b000, sx[31:3]}+6];  //mem1
    end else if (sx < 1344) begin
      one_in_ram = ram_out[160-{3'b000, sx[31:3]}+7];  //mem2
    end else begin
      one_in_ram = 0;
    end
  end

  // create one or zero
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

  // background
  logic background_on;
  always_comb begin
    if (sy > 736) begin
      background_on = 1;
    end else begin
      if (sx < 16 || (sx > 271 && sx < 280) || (sx > 535 && sx < 552)) begin
        background_on = 1;  // two else if becose they got so long :)
      end else if ((sx > 807 && sx < 824) || (sx > 1079 && sx < 1088) || sx > 1343) begin
        background_on = 1;  // two else if becose they got so long :)
      end else if (sx > 551 && sx < 808 && sy > 511) begin
        background_on = 1;
      end else if (sy > 735) begin
        background_on = 1;
      end else begin
        background_on = 0;
      end
    end
  end

  always_comb begin
    if (background_on == 1) begin
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

  // SDL output FOR TB
  always_ff @(posedge clk) begin
    sdl_sx <= sx;
    sdl_sy <= sy;
    sdl_de <= de;
  end
endmodule
