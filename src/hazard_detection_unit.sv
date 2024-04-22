`timescale 1ns / 1ps
import common_pkg::*;

module hazard_detection_unit (
    input logic clk,
    input logic rst,
    input logic [4:0] rs1,
    input logic [4:0] rs2,
    input control_t control_ex,
    output logic hazard_detected
);

  always_comb begin
    if (control_ex.mem_read == 1) begin  // load value instruction
      if (control_ex.write_back_id == rs1 || control_ex.write_back_id == rs2) begin
        hazard_detected = 1;
      end else begin
        hazard_detected = 0;
      end
    end else begin
      hazard_detected = 0;
    end
  end
endmodule
