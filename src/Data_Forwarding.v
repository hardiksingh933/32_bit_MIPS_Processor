`timescale 1ns / 1ps

module Data_Forwarding(
    input ex_mem_reg_write,
    input [4:0] ex_mem_write_reg_addr, // EX MEM Register Rd
    input [4:0] id_ex_instr_rs, 
    input [4:0] id_ex_instr_rt,
    input mem_wb_reg_write,
    input [4:0] mem_wb_write_reg_addr,  // Mem WB Register Rd
    output reg [1:0] Forward_A,
    output reg [1:0] Forward_B);
    
    always @(*)
    begin
        // initializations
        Forward_A = 2'b00; 
        Forward_B = 2'b00;
        if(ex_mem_reg_write && (ex_mem_write_reg_addr != 5'b0) && (ex_mem_write_reg_addr == id_ex_instr_rs))
            Forward_A = 2'b10;
        else if(mem_wb_reg_write && (mem_wb_write_reg_addr != 5'b0) && !(ex_mem_reg_write && (ex_mem_write_reg_addr != 0) && (ex_mem_write_reg_addr == id_ex_instr_rs)) && (mem_wb_write_reg_addr == id_ex_instr_rs))
            Forward_A = 2'b01;     
        if(ex_mem_reg_write && (ex_mem_write_reg_addr != 5'b0) && (ex_mem_write_reg_addr == id_ex_instr_rt))
            Forward_B = 2'b10;
        else if(mem_wb_reg_write && (mem_wb_write_reg_addr != 5'b0) && !(ex_mem_reg_write && (ex_mem_write_reg_addr != 0) && (ex_mem_write_reg_addr == id_ex_instr_rt)) && (mem_wb_write_reg_addr == id_ex_instr_rt))
            Forward_B = 2'b01;
    end

endmodule