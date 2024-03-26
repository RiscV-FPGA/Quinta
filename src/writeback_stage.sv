module writeback_stage (
    input logic clk,
    input logic rst,
    input control_t control,
    input logic [31:0] alu_res,
    input logic [31:0] mem_data,
    output logic [31:0] wb_data
);

  always_comb begin
    if (control.mem_read == 1) begin
      wb_data = mem_data;
    end else begin
      wb_data = alu_res;
    end
  end

endmodule
