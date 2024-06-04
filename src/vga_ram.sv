module vga_ram (
    input  logic            clk,
    input  mem_op_t         mem_op,
    input  logic    [  5:0] read_address,          // max addr = 63
    input  logic    [ 31:0] reg_mem_data,
    input  logic    [  4:0] reg_mem_addr,
    input  logic            reg_mem_enable,
    input  logic    [ 31:0] float_reg_mem_data,
    input  logic    [  4:0] float_reg_mem_addr,
    input  logic            float_reg_mem_enable,
    input  logic    [ 31:0] instr_mem_data,
    input  logic    [ 31:0] instr_mem_addr,
    input  logic            instr_mem_enable,
    input  logic    [ 31:0] data_mem_data,
    input  logic    [ 31:0] data_mem_addr,
    input  logic            data_mem_enable,
    output logic    [127:0] ram_out
);

  logic [31:0] reg_mem[32];
  logic [31:0] float_reg_mem[32];
  logic [31:0] instr_mem[46];
  //logic [31:0] data_mem[46];
  logic [7:0] data_mem_0[46];
  logic [7:0] data_mem_1[46];
  logic [7:0] data_mem_2[46];
  logic [7:0] data_mem_3[46];


  logic [5:0] word_address;
  logic [1:0] byte_offset;
  logic [31:0] write_data_mem_processed;

  logic [5:0] word_address_d;
  logic [31:0] write_data_mem_processed_d;
  logic [1:0] byte_offset_d;
  mem_op_t mem_op_d;
  logic data_mem_enable_d;

  assign word_address = data_mem_addr[7:2];
  assign byte_offset  = data_mem_addr[1:0];

  always_comb begin
    write_data_mem_processed = data_mem_data << byte_offset * 8;
  end

  always_ff @(posedge clk) begin
    word_address_d <= word_address;
    write_data_mem_processed_d <= write_data_mem_processed;
    byte_offset_d <= byte_offset;
    mem_op_d <= mem_op;
    data_mem_enable_d <= data_mem_enable;

    if (reg_mem_enable == 1) begin
      reg_mem[reg_mem_addr] <= reg_mem_data;
    end

    if (instr_mem_enable == 1) begin
      instr_mem[instr_mem_addr][31:0] <= instr_mem_data;
    end

    if (data_mem_enable_d == 1) begin
      if (mem_op_d == MEM_BYTE) begin
        case (byte_offset_d)
          2'b00:   data_mem_0[word_address_d] <= write_data_mem_processed_d[7:0];
          2'b01:   data_mem_1[word_address_d] <= write_data_mem_processed_d[15:8];
          2'b10:   data_mem_2[word_address_d] <= write_data_mem_processed_d[23:16];
          2'b11:   data_mem_3[word_address_d] <= write_data_mem_processed_d[31:24];
          default: ;
        endcase
      end else if (mem_op_d == MEM_HALF_WORD) begin
        case (byte_offset_d)
          2'b00: begin
            data_mem_0[word_address_d] <= write_data_mem_processed_d[7:0];
            data_mem_1[word_address_d] <= write_data_mem_processed_d[15:8];
          end
          2'b01: begin
            data_mem_1[word_address_d] <= write_data_mem_processed_d[15:8];
            data_mem_2[word_address_d] <= write_data_mem_processed_d[23:16];
          end
          2'b10: begin
            data_mem_2[word_address_d] <= write_data_mem_processed_d[23:16];
            data_mem_3[word_address_d] <= write_data_mem_processed_d[31:24];
          end
          2'b11: begin
            data_mem_3[word_address_d] <= write_data_mem_processed_d[31:24];
            //data_ram_1[word_address] <= write_data_mem_processed[15:8]; // dont suport mem wraping yet :(
          end
          default: ;
        endcase
      end else begin
        data_mem_0[word_address_d] <= write_data_mem_processed_d[7:0];
        data_mem_1[word_address_d] <= write_data_mem_processed_d[15:8];
        data_mem_2[word_address_d] <= write_data_mem_processed_d[23:16];
        data_mem_3[word_address_d] <= write_data_mem_processed_d[31:24];
      end
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
      data_mem_3[read_address],
      data_mem_2[read_address],
      data_mem_1[read_address],
      data_mem_0[read_address]
    };

  end

endmodule
