import common_pkg::*;

module registers_float (
    input logic clk,
    input logic rst,
    input logic [4:0] read1_id,
    input logic [4:0] read2_id,
    input logic write_en,
    input logic [4:0] write_id,
    input logic [31:0] write_data,
    output logic [31:0] read1_data,
    output logic [31:0] read2_data
);

  logic [31:0] int_register[32];

  always_ff @(posedge clk) begin
      if (write_en == 1) begin
        int_register[write_id] <= write_data;
    end
  end

  assign read1_data = int_register[read1_id];
  assign read2_data = int_register[read2_id];

endmodule
