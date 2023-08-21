`include "constants.h"
`timescale 1ns/1ps

module fsm(output reg RegWrite,
           output reg [3:0] ALUOp,  
           input [5:0] opcode, 
           input [5:0] func,
           output reg MemWrite,
           output reg MemRead,
           output reg Branch,
           output reg ALUSrc,
           output reg MemToReg,
           output reg RegDest,
           output reg BranchCheck

           );
           
  always @(opcode or func) 
   begin

     case (opcode)
      `R_FORMAT: 
          begin 
            MemRead = 1'b0; 
            MemWrite = 1'b0;
            RegDest = 1'b1;
            ALUSrc = 1'b0;
            MemToReg = 1'b0;
            Branch = 1'b0;
            RegWrite = 1'b1;
            
            case (func)
              6'b100_000: ALUOp = 4'b0010; // add
              6'b100_010: ALUOp = 4'b0110; // sub
              6'b100_100: ALUOp = 4'b0000; // and
              6'b100_101: ALUOp = 4'b0001 ; // or
              //... ; // nor
              6'b101_010: ALUOp = 4'b0111 ; // slt
              default: ALUOp = 4'b0000;           
            endcase
          end
        //lw
       6'b100011: 
        begin
          MemRead = 1'b1;
          MemWrite = 1'b0;

          RegDest = 1'b0;
          ALUSrc = 1'b1;
          
          MemToReg = 1'b1;
          Branch = 1'b0;
          
          RegWrite = 1'b1;
          //done
          ALUOp = 4'b0010; // add
        end
        //sw
       6'b101011: 
        begin
          MemRead = 1'b0; 
          MemWrite = 1'b1;

          //RegDest = 1'b0;
          ALUSrc = 1'b1;

          MemToReg = 1'b1;
          Branch = 1'b0;

          RegWrite = 1'b0;
          ALUOp = 4'b0010; // add
          //done
        end
        //addi
       6'b001000: 
        begin
          MemRead = 1'b0;
          MemWrite = 1'b0;

          RegDest = 1'b0;
          ALUSrc = 1'b1;
          
          MemToReg = 1'b0;
          Branch = 1'b0;
          
          RegWrite = 1'b1;
          //done
          ALUOp = 4'b0010; // add
        end

        //beq
        6'b000100:
        begin
          BranchCheck = 1'b0;
          MemRead = 1'b0;
          MemWrite = 1'b0;

          //RegDest = 1'b0;
          ALUSrc = 1'b0;
          
          //MemToReg = 1'b;
          Branch = 1'b1;
          
          
          RegWrite = 1'b0;
          ALUOp = 4'b0110; // sub
        end
        
        //bne
        6'b000101:
        begin
          BranchCheck = 1'b1;
          MemRead = 1'b0;
          MemWrite = 1'b0;

          //RegDest = 1'b0;
          ALUSrc = 1'b0;
          
          //MemToReg = 1'b1;
          Branch = 1'b1;
          
          
          RegWrite = 1'b0;
          ALUOp = 4'b0110; // sub
        end

       default:
           begin
            MemRead = 1'b0; 
            MemWrite = 1'b0;

            RegDest = 1'b0;
            ALUSrc = 1'b0;

            MemToReg = 1'b0;
            Branch = 1'b0;

            RegWrite = 1'b0;
            ALUOp = 4'b0000; 
           end
      endcase
    end // always
    
endmodule
