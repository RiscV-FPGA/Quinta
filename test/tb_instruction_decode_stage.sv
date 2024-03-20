`timescale 1ns / 1ps

import common_pkg::*;
import common_instructions_pkg::*;

module tb_instruction_decode_stage;

  logic clk = 0;
  logic rst = 1;

  integer cycle = 0;
  int test_length = 200;
  int clk_period = 10;

  instruction_t instruction = '0;
  logic [31:0] pc = 0;
  wire [31:0] immediate_data;
  control_t control;


  instruction_decode_stage instruction_decode_stage_uut (
      .clk(clk),
      .rst(rst),
      .instruction(instruction),
      .pc(pc),
      .immediate_data(immediate_data),
      .control(control)
  );

  always #(clk_period / 2) clk = ~clk;
  always #clk_period cycle++;

  always_comb begin : set_instructions_comb
    case (cycle)
      4: begin
        instruction = INSTR_LUI;
      end
      5: begin
        instruction = INSTR_ADD;
      end
      6: begin
        instruction = INSTR_ADDI;
      end
      7: begin
        instruction = INSTR_BEQ;
      end
      default: begin
        instruction = '0;
      end
    endcase
  end

  initial begin
    #(clk_period * 2);  //rst signal
    rst <= 0;
  end

  initial begin
    $dumpfile("waveform.vcd");
    $dumpvars(0, tb_instruction_decode_stage);
    $display("Done!");

    #test_length;  //test length

    $finish();
  end

endmodule
