module Execute(
    input [31:0] id_ex_instr,
    input [31:0] reg1, reg2,
    input [31:0] id_ex_imm_value,
    input [31:0] ex_mem_alu_result,
    input [31:0] mem_wb_write_back_result, 
    input id_ex_alu_src,
    input [1:0] id_ex_alu_op,
    input [1:0] Forward_A, Forward_B, 
    output [31:0] alu_in2_out,
    output [31:0] alu_result);
    
    wire [3:0] ALU_Control;
    wire [31:0] ALU_input_a, ALU_input_b;
    wire [31:0] b_temp;
    wire zero;

    ALUControl ALU_Control_Unit(
        .ALUOp(id_ex_alu_op),
        .Function(id_ex_instr[5:0]),
        .ALU_Control(ALU_Control));

    MUX_4 #(.mux_width(32)) MUX_A(
        .a(reg1),
        .b(mem_wb_write_back_result),
        .c(ex_mem_alu_result),
        .d(32'b0),
        .sel(Forward_A),
        .y(ALU_input_a));

    MUX_4 #(.mux_width(32)) MUX_B(
        .a(reg2),
        .b(mem_wb_write_back_result),
        .c(ex_mem_alu_result),
        .d(32'b0),
        .sel(Forward_B),
        .y(b_temp));

    assign alu_in2_out = b_temp;

    MUX_2 #(.mux_width(32)) MUX_C(
        .a(b_temp),
        .b(id_ex_imm_value),
        .sel(id_ex_alu_src),
        .y(ALU_input_b));

    ALU ALU_Instance(
        .a(ALU_input_a),
        .b(ALU_input_b),
        .alu_control(ALU_Control),
        .zero(zero),
        .alu_result(alu_result));
    
    
endmodule