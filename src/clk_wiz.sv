module clk_wiz (
    input  logic clk_100,
    input  logic rst,
    output logic clk_85
);

  assign clk_85 = clk_100;

endmodule
