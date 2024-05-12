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
    //input logic finish
);

  logic [31:0] int_register[32];

  always_ff @(posedge clk) begin
    if (rst == 1) begin
      for (int i = 0; i < 32; i++) begin
        int_register[i] <= 32'b00000000_00000000_00000000_00000000;
      end

    end else begin
      if (write_en == 1) begin
        int_register[write_id] <= write_data;
      end
    end
  end


  always_comb begin
    if (read1_id == 0) begin
      read1_data = 0;
    end else begin
      read1_data = int_register[read1_id];
    end

    if (read2_id == 0) begin
      read2_data = 0;
    end else begin
      read2_data = int_register[read2_id];
    end
  end

  // always_ff @(posedge clk) begin
  //   if (finish == 1) begin
  //     for (int i = 0; i < 32; i++) begin
  //       if (i < 10) begin
  //         $display("register_addr__%0d: %d", i, $signed(register[i]));
  //       end else begin
  //         $display("register_addr_%0d: %d", i, $signed(register[i]));
  //       end
  //     end
  //   end
  // end

endmodule
