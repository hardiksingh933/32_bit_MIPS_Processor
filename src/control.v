`timescale 1ns / 1ps

module control(
    input reset,
    input[5:0] opcode,  
    output reg reg_dst, mem_to_reg, 
    output reg [1:0] alu_op,  
    output reg mem_read, mem_write, alu_src, reg_write, branch, jump);

    always @(*)  
    begin  
        if(reset == 1'b1) begin  
            reg_dst = 1'b0;  
            mem_to_reg = 1'b0;  
            alu_op = 2'b10;  
            mem_read = 1'b0;  
            mem_write = 1'b0;  
            alu_src = 1'b0;  
            reg_write = 1'b0;      
        end

    else begin  
        case(opcode)   
        6'b000000: begin // add, and, nor, or, slt, sub, xor, mult, div
            reg_dst = 1'b1;  // 1 for R-type, takes instruction[15:11] as write register
            mem_to_reg = 1'b0;  
            alu_op = 2'b10;  
            mem_read = 1'b0;  
            mem_write = 1'b0;  
            alu_src = 1'b0;  // 0 for R-type, does not take sign extend block
            reg_write = 1'b1;
            branch = 1'b0;
            jump = 1'b0;       
        end
                
        6'b001000: begin // addi 
            reg_dst = 1'b0;  // 0 for R-type, copies instruction[20:16] as "write" register
            mem_to_reg = 1'b0;  
            alu_op = 2'b00;  
            mem_read = 1'b0;  
            mem_write = 1'b0;  
            alu_src = 1'b1; // 1 for immediate (constant) instructions, takes sign extend block
            reg_write = 1'b1;
            branch = 1'b0;
            jump = 1'b0;      
        end 
                
        6'b001100: begin // andi 
            reg_dst = 1'b0;  
            mem_to_reg = 1'b0;  
            alu_op = 2'b11;  
            mem_read = 1'b0;  
            mem_write = 1'b0;  
            alu_src = 1'b1;  
            reg_write = 1'b1; 
            branch = 1'b0;
            jump = 1'b0;          
        end
                
        6'b110000: begin // sll, srl, sra 
            reg_dst = 1'b1;  
            mem_to_reg = 1'b0;  
            alu_op = 2'b10;  
            mem_read = 1'b0;  
            mem_write = 1'b0;  
            alu_src = 1'b1;  
            reg_write = 1'b1; 
            branch = 1'b0;
            jump = 1'b0;    
        end
                
        6'b000100: begin // beq 
            reg_dst = 1'b0;  
            mem_to_reg = 1'b0;  
            alu_op = 2'b01;  
            mem_read = 1'b0;  
            mem_write = 1'b0;  
            alu_src = 1'b0;  
            reg_write = 1'b0;
            branch = 1'b1;
            jump = 1'b0;
        end
  
        6'b000010: begin // jump 
            reg_dst = 1'b0;  
            mem_to_reg = 1'b0;  
            alu_op = 2'bxx;  
            mem_read = 1'b0;  
            mem_write = 1'b0;  
            alu_src = 1'b0;  
            reg_write = 1'b0; 
            branch = 1'b0;
            jump = 1'b1;
        end
        
        6'b100011: begin // lw  
            reg_dst = 1'b0;  
            mem_to_reg = 1'b1;  
            alu_op = 2'b00;    
            mem_read = 1'b1;  
            mem_write = 1'b0;  
            alu_src = 1'b1;  
            reg_write = 1'b1;
            branch = 1'b0;
            jump = 1'b0;     
        end  

        6'b101011: begin // sw  
            reg_dst = 1'b0;  
            mem_to_reg = 1'b0;  
            alu_op = 2'b00;    
            mem_read = 1'b0;  
            mem_write = 1'b1;  
            alu_src = 1'b1;  
            reg_write = 1'b0;
            branch = 1'b0;
            jump = 1'b0;    
        end  
        endcase  
        end  
    end

 endmodule