module vga_ram (
    input  logic         clk,
    input  logic [  5:0] read_address,          // max addr = 63
    input  logic [ 31:0] reg_mem_data,
    input  logic [  4:0] reg_mem_addr,
    input  logic         reg_mem_enable,
    input  logic [ 31:0] float_reg_mem_data,
    input  logic [  4:0] float_reg_mem_addr,
    input  logic         float_reg_mem_enable,
    input  logic [ 31:0] instr_mem_data,
    input  logic [ 31:0] instr_mem_addr,
    input  logic         instr_mem_enable,
    input  logic [ 31:0] data_mem_data,
    input  logic [ 31:0] data_mem_addr,
    input  logic         data_mem_enable,
    output logic [127:0] ram_out
);

  //logic [159:0] mem[48];  //1280 = 160*64/8
  logic [31:0] reg_mem[32];
  logic [31:0] float_reg_mem[32];
  logic [31:0] instr_mem[46];
  logic [31:0] data_mem[46];


  logic [5:0] word_address;
  logic [1:0] byte_offset;
  logic [31:0] write_data_mem_processed;

  assign word_address = data_mem_addr[7:2];
  assign byte_offset  = data_mem_addr[1:0];

  always_comb begin
    write_data_mem_processed = data_mem_data << byte_offset * 8;
  end


  always_ff @(posedge clk) begin
    if (reg_mem_enable == 1) begin
      reg_mem[reg_mem_addr] <= reg_mem_data;
    end

    if (instr_mem_enable == 1) begin
      instr_mem[instr_mem_addr][31:0] <= instr_mem_data;
    end

    if (data_mem_enable) begin
      data_mem[word_address] <= write_data_mem_processed;
    end

    if (float_reg_mem_enable == 1) begin
      float_reg_mem[float_reg_mem_addr] <= float_reg_mem_data;
    end
  end

  always_comb begin
    ram_out = {
      instr_mem[read_address],
      reg_mem[read_address[4:0]],
      float_reg_mem[read_address[4:0]],
      data_mem[read_address]
    };

  end

endmodule
