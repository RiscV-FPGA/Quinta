module uart (
    input logic clk,
    input logic rst

);

  always_ff @(posedge clk) begin
    if (rst == 1) begin

    end else begin

    end
  end

endmodule
