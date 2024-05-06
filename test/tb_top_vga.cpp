// Project F: FPGA Graphics - Square Verilator C++
// (C)2023 Will Green, open source software released under the MIT License
// Learn more at https://projectf.io/posts/fpga-graphics/

#include "Vcommon_pkg.h"
#include <SDL2/SDL.h>
#include <array>
#include <stdio.h>
#include <verilated.h>
#include <verilated_vcd_c.h>

#include <fstream>
#include <iostream>
#include <sstream>
#include <string>

// screen dimensions
const int H_RES = 1368;
const int V_RES = 768;

#define MAX_SIM_TIME 200000
vluint64_t sim_time = 0;
int clk_per_rx_serial_bit = 868;

typedef struct Pixel { // for SDL texture
  uint8_t a;           // transparency
  uint8_t b;           // blue
  uint8_t g;           // green
  uint8_t r;           // red
} Pixel;

void delay_clk(Vcommon_pkg *top, VerilatedVcdC *m_trace, int num_cycles) {
  for (int i = 0; i < num_cycles * 2; i++) {
    top->sys_clk ^= 1; // Toggle clock
    top->eval();
    m_trace->dump(sim_time);
    sim_time++;
  }
}

void send_uart_byte(Vcommon_pkg *top, VerilatedVcdC *m_trace,
                    std::array<char, 8> serial_data) {
  top->rx_serial = 0; // start bit
  delay_clk(top, m_trace, clk_per_rx_serial_bit);
  for (int i = 0; i < 8; i++) {
    top->rx_serial = serial_data[7 - i];
    delay_clk(top, m_trace, clk_per_rx_serial_bit);
  }
  top->rx_serial = 1; // stop bit
  delay_clk(top, m_trace, clk_per_rx_serial_bit);
}

void open_send_file(Vcommon_pkg *top, VerilatedVcdC *m_trace,
                    std::string file_name) {
  std::ifstream file(file_name);
  std::string line;

  if (!file.is_open()) {
    std::cerr << "Error opening file" << std::endl;
  }

  // Read file line by line
  while (std::getline(file, line)) {
    // Convert line to std::array<char, 8>
    std::array<char, 8> serial_data;
    for (size_t i = 0; i < 8; ++i) {
      serial_data[i] = line[i];
    }
    // std::cout << "Serial data array: ";
    // for (const auto &bit : serial_data) {
    //   std::cout << bit;
    // }
    // std::cout << std::endl;

    send_uart_byte(top, m_trace, serial_data);
  }
  file.close();
}

int main(int argc, char *argv[]) {
  Verilated::commandArgs(argc, argv);

  if (SDL_Init(SDL_INIT_VIDEO) < 0) {
    printf("SDL init failed.\n");
    return 1;
  }

  Pixel screenbuffer[H_RES * V_RES];

  SDL_Window *sdl_window = NULL;
  SDL_Renderer *sdl_renderer = NULL;
  SDL_Texture *sdl_texture = NULL;

  sdl_window =
      SDL_CreateWindow("vga_top", SDL_WINDOWPOS_CENTERED,
                       SDL_WINDOWPOS_CENTERED, H_RES, V_RES, SDL_WINDOW_SHOWN);
  if (!sdl_window) {
    printf("Window creation failed: %s\n", SDL_GetError());
    return 1;
  }

  sdl_renderer = SDL_CreateRenderer(
      sdl_window, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC);
  if (!sdl_renderer) {
    printf("Renderer creation failed: %s\n", SDL_GetError());
    return 1;
  }

  sdl_texture = SDL_CreateTexture(sdl_renderer, SDL_PIXELFORMAT_RGBA8888,
                                  SDL_TEXTUREACCESS_TARGET, H_RES, V_RES);
  if (!sdl_texture) {
    printf("Texture creation failed: %s\n", SDL_GetError());
    return 1;
  }

  // reference SDL keyboard state array:
  // https://wiki.libsdl.org/SDL_GetKeyboardState
  const Uint8 *keyb_state = SDL_GetKeyboardState(NULL);

  printf("Simulation running. Press 'Q' in simulation window to quit.\n\n");

  // initialize Verilog module
  Vcommon_pkg *top = new Vcommon_pkg;

  Verilated::traceEverOn(true);
  VerilatedVcdC *m_trace = new VerilatedVcdC;
  top->trace(m_trace, 5);
  m_trace->open("waveform.vcd");

  // start values:
  top->sys_clk = 0;
  top->rst = 1;
  top->rx_serial = 1;

  top->eval();
  m_trace->dump(sim_time);
  sim_time++;
  delay_clk(top, m_trace, 1);
  top->rst = 0;
  delay_clk(top, m_trace, 1);

  // open instruction file and send it over uart
  open_send_file(top, m_trace, "src/instruction_mem_temp.mem");
  delay_clk(top, m_trace, 200);

  // main gtk end
  delay_clk(top, m_trace, 10);
  top->finish = 1;
  delay_clk(top, m_trace, 1);
  top->finish = 0;
  delay_clk(top, m_trace, 10);
  printf("number of clk cycles: %" PRIu64 "\n", sim_time);
  m_trace->close();

  // loop to show the vga
  while (true) {
    if (keyb_state[SDL_SCANCODE_Q]) {
      break; // quit if user presses 'Q'
    }

    // cycle the clock
    top->sys_clk = 1;
    top->eval();
    top->sys_clk = 0;
    top->eval();
    // update pixel if not in blanking interval
    if (top->sdl_de) {
      Pixel *p = &screenbuffer[top->sdl_sy * H_RES + top->sdl_sx];
      p->a = 0xFF; // transparency
      p->b = top->vga_b * 16;
      p->g = top->vga_g * 16;
      p->r = top->vga_r * 16;
    }

    // update texture once per frame (in blanking)
    if (top->sdl_sy == 0 && top->sdl_sx == 0) {
      // check for quit event
      SDL_Event e;
      if (SDL_PollEvent(&e)) {
        if (e.type == SDL_QUIT) {
          break;
        }
      }
      SDL_UpdateTexture(sdl_texture, NULL, screenbuffer, H_RES * sizeof(Pixel));
      SDL_RenderClear(sdl_renderer);
      SDL_RenderCopy(sdl_renderer, sdl_texture, NULL, NULL);
      SDL_RenderPresent(sdl_renderer);
    }
    top->eval();
  }

  top->final(); // simulation done
  delete top;
  exit(EXIT_SUCCESS);

  SDL_DestroyTexture(sdl_texture);
  SDL_DestroyRenderer(sdl_renderer);
  SDL_DestroyWindow(sdl_window);
  SDL_Quit();
  return 0;
}
