module vga_ram (
    input  logic         clk,
    input  logic [  5:0] read_address,      // max addr = 63
    input  logic [ 31:0] reg_mem_data,
    input  logic [  4:0] reg_mem_addr,
    input  logic         reg_mem_enable,
    input  logic [ 31:0] instr_mem_data,
    input  logic [ 31:0] instr_mem_addr,
    input  logic         instr_mem_enable,
    input  logic [ 31:0] data_mem_data,
    input  logic [ 31:0] data_mem_addr,
    input  logic         data_mem_enable,
    output logic [159:0] ram_out
);

  //logic [159:0] mem[48];  //1280 = 160*64/8
  logic [31:0] reg_mem[32];
  logic [63:0] instr_mem[46];
  logic [63:0] data_mem[46];


  logic [5:0] word_address;
  logic [1:0] byte_offset;
  logic [31:0] write_data_processed;

  assign word_address = data_mem_addr[7:2];
  assign byte_offset  = data_mem_addr[1:0];

  always_comb begin
    write_data_processed = data_mem_data << byte_offset * 8;
  end


  always_ff @(posedge clk) begin
    if (reg_mem_enable == 1) begin
      reg_mem[reg_mem_addr] <= reg_mem_data;
    end

    if (instr_mem_enable == 1) begin
      if (instr_mem_addr < 46) begin
        instr_mem[instr_mem_addr][63:32] <= instr_mem_data;
      end else begin
        instr_mem[instr_mem_addr-46][31:0] <= instr_mem_data;
      end
    end

    if (data_mem_enable) begin
      if (word_address < 46) begin
        //        data_mem[data_mem_addr][63:32] <= data_mem_data;
        data_mem[word_address][39:32] <= write_data_processed[7:0];
        data_mem[word_address][47:40] <= write_data_processed[15:8];
        data_mem[word_address][55:48] <= write_data_processed[23:16];
        data_mem[word_address][63:56] <= write_data_processed[31:24];
      end else begin
        //        data_mem[data_mem_addr-46][31:0] <= data_mem_data;
        data_mem[word_address-46][7:0]   <= write_data_processed[7:0];
        data_mem[word_address-46][15:8]  <= write_data_processed[15:8];
        data_mem[word_address-46][23:16] <= write_data_processed[23:16];
        data_mem[word_address-46][31:24] <= write_data_processed[31:24];
      end
    end
  end

  always_comb begin
    ram_out = {instr_mem[read_address], reg_mem[read_address[4:0]], data_mem[read_address]};
  end

endmodule
