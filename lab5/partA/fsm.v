`include "constants.h"
`timescale 1ns/1ps

module fsm(output reg RegWrite,  
           output reg [3:0] ALUOp,  
           input [5:0] opcode, 
           input [5:0] func);
           
  always @(opcode or func) 
   begin
     case (opcode)
      `R_FORMAT: 
          begin 
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
       default:
           begin
            RegWrite = 1'b0;
            ALUOp = 4'b0000; 
           end
      endcase
    end // always
    
endmodule
