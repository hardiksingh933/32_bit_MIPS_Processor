module Instruction_Decode(
    input clk, reset,
    input [9:0] pc_plus4,
    input [31:0] instr,
    input mem_wb_reg_write,
    input [4:0] mem_wb_write_reg_addr,
    input [31:0] mem_wb_write_back_data, 
    input Data_Hazard,
    input Control_Hazard, 
    output [31:0] reg1, reg2, 
    output [31:0] imm_value, 
    output [9:0] branch_address, 
    output [9:0] jump_address, 
    output [4:0] destination_reg,
    // Following are the control unit outputs. 
    output branch_taken,
    output mem_to_reg,
    output [1:0] alu_op,
    output mem_read,
    output mem_write, 
    output alu_src,
    output reg_write, 
    output jump);

    wire branch, reg_dst, zero;
    wire mem_to_reg_temp, mem_read_temp, mem_write_temp, alu_src_temp, reg_write_temp, jump_temp, reg_dst_temp;
    wire [6:0] hazard_mux_out;
    wire [1:0] alu_op_temp;
    wire hazard_mux_sel;

    assign hazard_mux_sel = ~Data_Hazard | Control_Hazard;
    assign jump_address = (instr[25:0] << 2);
    assign zero = ((reg1 ^ reg2)==32'd0) ? 1'b1: 1'b0;
    assign branch_taken = zero & branch;
    assign branch_address = pc_plus4 + (imm_value << 2);

    control control_unit(
        .reset(reset),
        .opcode(instr[31:26]),
        .reg_dst(reg_dst), 
        .mem_to_reg(mem_to_reg_temp),
        .alu_op(alu_op_temp), // 2 bit
        .mem_read(mem_read_temp),  
        .mem_write(mem_write_temp),
        .alu_src(alu_src_temp),
        .reg_write(reg_write_temp),
        .jump(jump),
        .branch(branch));

    MUX_2 #(.mux_width(7)) hazard_mux(
        .a({mem_to_reg_temp, alu_op_temp, mem_read_temp, mem_write_temp, alu_src_temp, reg_write_temp}),
        .b(7'b0),
        .sel(hazard_mux_sel),
        .y(hazard_mux_out));

    assign mem_to_reg = hazard_mux_out[6];
    assign alu_op = hazard_mux_out[5:4];
    assign mem_read = hazard_mux_out[3];
    assign mem_write = hazard_mux_out[2];
    assign alu_src = hazard_mux_out[1];
    assign reg_write = hazard_mux_out[0];

    MUX_2 #(.mux_width(5)) dest_reg_mux(
        .a(instr[20:16]),
        .b(instr[15:11]),
        .sel(reg_dst),
        .y(destination_reg));

    sign_extend sign_ex_inst (
        .sign_ex_in(instr[15:0]),
        .sign_ex_out(imm_value));

    register_file reg_file (
        .clk(clk),  
        .reset(reset),  
        .reg_write_en(mem_wb_reg_write),  
        .reg_write_dest(mem_wb_write_reg_addr),  
        .reg_write_data(mem_wb_write_back_data),  
        .reg_read_addr_1(instr[25:21]), 
        .reg_read_addr_2(instr[20:16]), 
        .reg_read_data_1(reg1),
        .reg_read_data_2(reg2));  

endmodule