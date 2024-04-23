module vga_ram (
    input  logic         clk,
    input  logic [ 31:0] read_address,
    input  logic [ 31:0] reg_mem_data,
    input  logic [  4:0] reg_mem_addr,
    input  logic         reg_mem_enable,
    input  logic [ 31:0] instr_mem_data,
    input  logic [ 31:0] instr_mem_addr,    // more bits?
    input  logic         instr_mem_enable,
    input  logic [ 31:0] data_mem_data,
    input  logic [ 31:0] data_mem_addr,     // more bits?
    input  logic         data_mem_enable,
    output logic [159:0] ram_out
);

  //logic [159:0] mem[48];  //1280 = 160*64/8
  logic [31:0] reg_mem  [32];
  logic [63:0] instr_mem[46];
  logic [63:0] data_mem [46];


  initial begin
    //$readmemb("src/vga_ram_reg.mem", reg_mem);
    //$readmemb("src/vga_ram_instr.mem", instr_mem);
    //$readmemb("src/vga_ram_data.mem", data_mem);
    //$readmemb("vga_ram_reg.mem", reg_mem);
    //$readmemb("vga_ram_instr.mem", instr_mem);
    //$readmemb("vga_ram_data.mem", data_mem);

  end

  always @(posedge clk) begin
    if (reg_mem_enable == 1) begin
      reg_mem[reg_mem_addr] <= reg_mem_data;
    end

    if (instr_mem_enable == 1) begin
      if (instr_mem_addr < 46) begin
        instr_mem[instr_mem_addr][31:0] <= instr_mem_data;
      end else begin
        instr_mem[instr_mem_addr-46][63:32] <= instr_mem_data;
      end
    end

    if (data_mem_enable) begin
      if (data_mem_addr < 46) begin
        data_mem[data_mem_addr][31:0] <= data_mem_data;
      end else begin
        data_mem[data_mem_addr-46][63:32] <= data_mem_data;
      end
    end
  end

  always_comb begin
    ram_out = {instr_mem[read_address], reg_mem[read_address], data_mem[read_address]};
  end

endmodule
