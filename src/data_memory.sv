
module data_memory (
    input logic clk,
    input logic [31:0] byte_address,
    input logic write_enable,
    input logic [31:0] write_data,
    output logic [31:0] read_data
);

  logic [31:0] data_ram[256];
  logic [7:0] word_address;

  always_ff @(posedge clk) begin
    if (write_enable == 1) begin
      data_ram[byte_address[9:2]] <= write_data;
    end

    //if (write_enable == 1) begin
    //  if (byte_address[1:0] == 2'b00) begin  // standard 32 bit slot
    //    data_ram[byte_address[9:2]] <= write_data;
    //  end else if (byte_address[1:0] == 2'b01) begin  // half half slot :((
    //    data_ram[byte_address[9:2]][31:8]  <= write_data[23:0];
    //    data_ram[byte_address[9:2]+1][7:0] <= write_data[31:24];
    //  end else if (byte_address[1:0] == 2'b10) begin  // half slot :(
    //    data_ram[byte_address[9:2]][31:16]  <= write_data[15:0];
    //    data_ram[byte_address[9:2]+1][15:0] <= write_data[31:16];
    //  end else begin  // half half slot :((
    //    data_ram[byte_address[9:2]][31:24]  <= write_data[7:0];
    //    data_ram[byte_address[9:2]+1][23:0] <= write_data[31:8];
    //  end
    //end
  end

  always_comb begin : blockName
    if (byte_address[1:0] == 2'b00) begin  // standard 32 bit slot
      read_data = data_ram[byte_address[9:2]];
    end else if (byte_address[1:0] == 2'b01) begin  // half half slot :((
      read_data[23:0]  = data_ram[byte_address[9:2]][31:8];
      read_data[31:24] = data_ram[byte_address[9:2]+1][7:0];
    end else if (byte_address[1:0] == 2'b10) begin  // half slot :(
      read_data[15:0]  = data_ram[byte_address[9:2]][31:16];
      read_data[31:16] = data_ram[byte_address[9:2]+1][15:0];
    end else begin  // half half slot :((
      read_data[7:0]  = data_ram[byte_address[9:2]][31:24];
      read_data[31:8] = data_ram[byte_address[9:2]+1][23:0];
    end
  end

endmodule
