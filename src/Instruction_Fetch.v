module Instruction_Fetch(
        input clk, reset,
        input en,
        input [9:0] branch_address, 
        input [9:0] jump_address, 
        input branch_taken,
        input jump,
        output [9:0] pc_plus4, 
        output [31:0] instr);

    reg [9:0] pc;
    wire [9:0] branch_taken_mux_output, jump_mux_output;

    assign pc_plus4 = pc + 10'b0000000100;

    always @(posedge clk or posedge reset)
    begin
        if(reset)
            pc <= 10'b0000000000;
        else if(en) // active low
            pc <= jump_mux_output;
    end

    MUX_2 #(.mux_width(10)) branch_taken_mux (  
        .a(pc_plus4), // 0
        .b(branch_address), // 1
        .sel(branch_taken),
        .y(branch_taken_mux_output));

    MUX_2 #(.mux_width(10)) jump_mux (   
        .a(branch_taken_mux_output), // 0
        .b(jump_address), // 1
        .sel(jump),
        .y(jump_mux_output));

    Instruction_Memory inst_mem(
        .read_addr(pc),
        .data(instr));
               
endmodule