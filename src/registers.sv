import common_pkg::*;

module registers (
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

  logic [31:0] register[32];

  always_ff @(posedge clk) begin
    if (rst == 1) begin
      for (int i = 0; i < 32; i++) begin
        register[i] <= 0;
      end

    end else begin
      if (write_en == 1) begin
        register[write_id] <= write_data;
      end
    end
  end


  always_comb begin
    if (read1_id == 0) begin
      read1_data = 0;
    end else begin
      read1_data = register[read1_id];
    end

    if (read2_id == 0) begin
      read2_data = 0;
    end else begin
      read2_data = register[read2_id];
    end
  end

endmodule
