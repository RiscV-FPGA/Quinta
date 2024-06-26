import common_pkg::*;

module top_build (
    input  logic       sys_clk,
    input  logic       rst,
    input  logic       rx_serial,
    output logic [3:0] vga_r,
    output logic [3:0] vga_g,
    output logic [3:0] vga_b,
    output logic       vga_hsync,
    output logic       vga_vsync
    // FOR TB START
    //input  logic        finish,
    //output logic [31:0] sdl_sx,
    //output logic [31:0] sdl_sy,
    //output logic        sdl_de
    // FOR TB END
);

  wire          [31:0] sdl_sx;
  wire          [31:0] sdl_sy;
  wire                 sdl_de;
  logic                mem_data_valid;
  logic         [31:0] mem_data_in_vga;

  logic                start;
  logic         [31:0] write_instr_data;
  logic                write_instr_valid;
  logic         [31:0] write_byte_address;
  logic         [31:0] write_word_address;

  instruction_t        instruction_fetch;
  logic         [31:0] pc_fetch;
  logic                pc_pause_fetch;


  instruction_t        instruction_decode;
  logic         [31:0] pc_decode;
  control_t            control_decode;
  logic         [31:0] read1_data_decode;
  logic         [31:0] read2_data_decode;
  logic         [31:0] immediate_data_decode;
  logic         [ 4:0] rs1_decode;
  logic         [ 4:0] rs2_decode;
  logic                hazard_detected_decode;


  control_t            control_execute;
  logic         [31:0] data1_execute;
  logic         [31:0] data2_execute;
  logic         [31:0] immediate_data_execute;
  logic         [31:0] alu_res_execute;
  logic         [31:0] mem_data_execute;
  logic         [31:0] pc_execute;
  logic                branch_taken_execute;
  logic         [31:0] pc_branch_execute;
  logic         [ 4:0] rs1_execute;
  logic         [ 4:0] rs2_execute;
  logic                insert_bubble_execute;


  control_t            control_mem;
  logic         [31:0] alu_res_in_mem;
  logic         [31:0] mem_data_in_mem;
  logic         [31:0] mem_data_out_mem;
  logic                branch_taken_mem;
  logic         [31:0] pc_branch_mem;
  logic         [31:0] pc_mem;

  logic         [31:0] forwarding_data_1;
  logic         [31:0] forwarding_data_2;
  logic                forwarding_data_1_valid;
  logic                forwarding_data_2_valid;


  control_t            control_wb;
  logic         [31:0] alu_res_wb;
  logic         [31:0] mem_data_wb;
  logic         [31:0] wb_data_wb;  // to decode for saving
  logic         [31:0] pc_wb;

  //assign clk = sys_clk;

  always_ff @(posedge sys_clk) begin
    if (rst == 1 || start == 0) begin

    end else begin
      //id_reg <= if_reg
      if (hazard_detected_decode == 1) begin
        instruction_decode <= instruction_decode;
        pc_decode          <= pc_decode;
      end else if (insert_bubble_execute == 1) begin
        instruction_decode <= instruction_decode;
        pc_decode          <= pc_decode;
      end else begin
        pc_decode <= pc_fetch;
        instruction_decode <= instruction_fetch;
        if (branch_taken_mem == 1) begin
          instruction_decode <= 'b0;  // nop
        end
      end

      //ex_reg <= id_reg
      pc_execute <= pc_decode;
      data1_execute <= read1_data_decode;
      data2_execute <= read2_data_decode;
      immediate_data_execute <= immediate_data_decode;
      rs1_execute <= rs1_decode;
      rs2_execute <= rs2_decode;
      control_execute <= control_decode;
      if (hazard_detected_decode == 1 || branch_taken_mem == 1) begin
        control_execute.reg_write <= 0;  // nop
        control_execute.mem_write <= MEM_NO_OP;  // nop
        control_execute.is_branch <= 0;  // nop
      end else if (insert_bubble_execute == 1) begin
        pc_execute <= pc_execute;  // paus stage
        data1_execute <= data1_execute;
        data2_execute <= data2_execute;
        immediate_data_execute <= immediate_data_execute;
        rs1_execute <= rs1_execute;
        rs2_execute <= rs2_execute;
        control_execute <= control_execute;
      end

      //mem_reg <= ex_reg
      alu_res_in_mem <= alu_res_execute;
      mem_data_in_mem <= mem_data_execute;  // added this to fix the critical path
      branch_taken_mem <= branch_taken_execute;  // added this to fix the critical path
      pc_branch_mem <= pc_branch_execute;
      control_mem <= control_execute;
      pc_mem <= pc_execute;
      if (branch_taken_mem == 1) begin
        control_mem.reg_write <= 0;  // nop
        control_mem.mem_write <= MEM_NO_OP;  // nop
        control_mem.is_branch <= 0;  // nop
      end

      //wb_reg <= mem_reg
      pc_wb <= pc_mem;
      control_wb <= control_mem;
      alu_res_wb <= alu_res_in_mem;
      mem_data_wb <= mem_data_out_mem;
    end
  end

  assign pc_pause_fetch = hazard_detected_decode | insert_bubble_execute;

  instruction_fetch_stage instruction_fetch_stage_inst (
      .clk(sys_clk),
      .rst(rst),
      .start(start),
      .write_byte_address(write_byte_address),
      .write_instr_data(write_instr_data),
      .write_instr_valid(write_instr_valid),
      .branch_taken(branch_taken_mem),
      .pc_branch(pc_branch_mem),
      .hazard_detected(pc_pause_fetch),
      .pc(pc_fetch),
      .instruction(instruction_fetch)
  );

  instruction_decode_stage instruction_decode_stage_inst (
      .clk(sys_clk),
      .rst(rst),
      .instruction(instruction_decode),
      .pc(pc_decode),
      .reg_write(control_wb.reg_write),
      .reg_write_float(control_wb.reg_write_float),
      .write_id(control_wb.write_back_id),
      .write_data(wb_data_wb),
      .immediate_data(immediate_data_decode),
      .control(control_decode),
      .read1_data(read1_data_decode),
      .read2_data(read2_data_decode),
      .rs1(rs1_decode),
      .rs2(rs2_decode)
      //.finish(finish)  // for tb print
  );

  hazard_detection_unit hazard_detection_unit_inst (
      .clk(sys_clk),
      .rst(rst),
      .rs1(rs1_decode),
      .rs2(rs2_decode),
      .control_ex(control_execute),
      .hazard_detected(hazard_detected_decode)
  );

  execute_stage execute_stage_inst (
      .clk(sys_clk),
      .rst(rst),
      .data1(data1_execute),
      .data2(data2_execute),
      .immediate_data(immediate_data_execute),
      .control(control_execute),
      .pc_execute(pc_execute),
      .fw_data_1(forwarding_data_1),
      .fw_data_2(forwarding_data_2),
      .fw_data_1_valid(forwarding_data_1_valid),
      .fw_data_2_valid(forwarding_data_2_valid),
      .alu_res(alu_res_execute),
      .mem_data(mem_data_execute),
      .branch_taken(branch_taken_execute),
      .pc_branch(pc_branch_execute),
      .insert_bubble(insert_bubble_execute)
  );

  memory_stage memory_stage_inst (
      .clk(sys_clk),
      .rst(rst),
      .alu_res_in(alu_res_in_mem),
      .mem_data_in(mem_data_in_mem),
      .control(control_mem),
      .mem_data_in_vga(mem_data_in_vga),
      .mem_data_out(mem_data_out_mem)
  );

  forwarding_unit forwarding_unit_inst (
      .clk(sys_clk),
      .rst(rst),
      .control_mem(control_mem),
      .control_wb(control_wb),
      .alu_res_mem(alu_res_in_mem),
      .alu_res_wb(alu_res_wb),
      .mem_data_wb(mem_data_wb),
      .rs_1(rs1_execute),
      .rs_2(rs2_execute),
      .reg_read_float(control_execute.reg_read_float),
      .data_1(forwarding_data_1),
      .data_2(forwarding_data_2),
      .data_1_valid(forwarding_data_1_valid),
      .data_2_valid(forwarding_data_2_valid)
  );

  writeback_stage writeback_stage_inst (
      .clk(sys_clk),
      .rst(rst),
      .control(control_wb),
      .pc_wb(pc_wb),
      .alu_res(alu_res_wb),
      .mem_data(mem_data_wb),
      .wb_data(wb_data_wb)
  );

  uart_collector uart_collector_inst (
      .clk(sys_clk),
      .rst(rst),
      .rx_serial(rx_serial),
      .write_instr_data(write_instr_data),
      .write_instr_valid(write_instr_valid),
      .write_byte_address(write_byte_address),
      .start(start)
  );

  assign write_word_address = {2'b00, write_byte_address[31:2]};
  assign mem_data_valid = (control_mem.mem_write == MEM_NO_OP) ? 1'b0 : 1'b1;

  vga #(
      .TB_MODE(0)
  ) vga_inst (
      .clk(sys_clk),
      .rst(rst),
      .mem_op(control_mem.mem_write),
      .reg_mem_data(wb_data_wb),
      .reg_mem_addr(control_wb.write_back_id),
      .reg_mem_enable(control_wb.reg_write),
      .float_reg_mem_data(wb_data_wb),
      .float_reg_mem_addr(control_wb.write_back_id),
      .float_reg_mem_enable(control_wb.reg_write_float),
      .instr_mem_data(write_instr_data),
      .instr_mem_addr(write_word_address),
      .instr_mem_enable(write_instr_valid),
      .data_mem_data(mem_data_in_vga),
      .data_mem_addr(alu_res_in_mem),
      .data_mem_enable(mem_data_valid),
      .vga_vsync(vga_vsync),
      .vga_hsync(vga_hsync),
      .vga_r(vga_r),
      .vga_g(vga_g),
      .vga_b(vga_b),
      .sdl_sx(sdl_sx),
      .sdl_sy(sdl_sy),
      .sdl_de(sdl_de)
  );

endmodule
