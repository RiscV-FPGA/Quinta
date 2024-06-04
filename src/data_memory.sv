
module data_memory (
    input logic clk,
    input logic [31:0] byte_address,
    input logic write_enable,
    input logic [31:0] write_data,
    input mem_op_t mem_op,
    output logic [31:0] read_data
);

  logic [7:0] data_ram_0[256];
  logic [7:0] data_ram_1[256];
  logic [7:0] data_ram_2[256];
  logic [7:0] data_ram_3[256];

  logic [7:0] word_address;
  logic [1:0] byte_offset;
  logic [31:0] write_data_processed;

  assign word_address = byte_address[9:2];
  assign byte_offset  = byte_address[1:0];

  always_comb begin
    write_data_processed = write_data << byte_offset * 8;
  end

  always_ff @(posedge clk) begin : WRITE
    if (write_enable == 1) begin
      if (mem_op == MEM_BYTE) begin
        case (byte_offset)
          2'b00:   data_ram_0[word_address] <= write_data_processed[7:0];
          2'b01:   data_ram_1[word_address] <= write_data_processed[15:8];
          2'b10:   data_ram_2[word_address] <= write_data_processed[23:16];
          2'b11:   data_ram_3[word_address] <= write_data_processed[31:24];
          default: ;
        endcase
      end else if (mem_op == MEM_HALF_WORD) begin
        case (byte_offset)
          2'b00: begin
            data_ram_0[word_address] <= write_data_processed[7:0];
            data_ram_1[word_address] <= write_data_processed[15:8];
          end
          2'b01: begin
            data_ram_1[word_address] <= write_data_processed[15:8];
            data_ram_2[word_address] <= write_data_processed[23:16];
          end
          2'b10: begin
            data_ram_2[word_address] <= write_data_processed[23:16];
            data_ram_3[word_address] <= write_data_processed[31:24];
          end
          2'b11: begin
            data_ram_3[word_address] <= write_data_processed[31:24];
            //data_ram_1[word_address] <= write_data_processed[15:8]; // dont suport mem wraping yet :(
          end
          default: ;
        endcase
      end else begin
        data_ram_0[word_address] <= write_data_processed[7:0];
        data_ram_1[word_address] <= write_data_processed[15:8];
        data_ram_2[word_address] <= write_data_processed[23:16];
        data_ram_3[word_address] <= write_data_processed[31:24];
      end
    end
  end

  always_comb begin : READ
    case (byte_offset)
      2'b00: begin
        read_data = {
          data_ram_3[word_address],
          data_ram_2[word_address],
          data_ram_1[word_address],
          data_ram_0[word_address]
        };
      end
      2'b01: begin
        read_data = {
          data_ram_0[word_address],
          data_ram_3[word_address],
          data_ram_2[word_address],
          data_ram_1[word_address]
        };
      end
      2'b10: begin
        read_data = {
          data_ram_1[word_address],
          data_ram_0[word_address],
          data_ram_3[word_address],
          data_ram_2[word_address]
        };
      end
      2'b11: begin
        read_data = {
          data_ram_2[word_address],
          data_ram_1[word_address],
          data_ram_0[word_address],
          data_ram_3[word_address]
        };
      end
      default: begin
        read_data = {
          data_ram_3[word_address],
          data_ram_2[word_address],
          data_ram_1[word_address],
          data_ram_0[word_address]
        };
      end
    endcase
  end



endmodule
