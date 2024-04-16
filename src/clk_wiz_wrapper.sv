module clk_wiz_wrapper (
    input  logic clk_100,
    input  logic rst,
    output logic clk_85
);


  clk_wiz clk_wiz_inst (
      .clk_100(clk_100),
      .rst(rst),
      .clk_85(clk_85)
  );

endmodule
