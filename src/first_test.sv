module first_test (
    input logic clk,
    input logic rst,
    input logic a_in,
    input logic b_in,
    output logic c_out,
    output logic [7:0] counter
);

  assign c_out = a_in & b_in;

  always_ff @(posedge clk) begin : seq
    if (rst == 1) begin
      counter <= 0;
    end else begin
      counter <= counter + 1;
    end
  end

endmodule
