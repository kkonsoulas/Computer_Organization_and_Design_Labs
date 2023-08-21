`include "constants.h"
`timescale 1ns/1ps

/************** Main control in ID pipe stage  *************/
module control_main(output reg RegDst,
                output reg Branch,  
                output reg MemRead,
                output reg MemWrite,  
                output reg MemToReg,  
                output reg ALUSrc,  
                output reg RegWrite,  
                output reg [1:0] ALUcntrl,  
                input [5:0] opcode);

  always @(*) 
   begin
     case (opcode)
      `R_FORMAT: 
          begin 
            RegDst = 1'b1;
            MemRead = 1'b0;
            MemWrite = 1'b0;
            MemToReg = 1'b0;
            ALUSrc = 1'b0;
            RegWrite = 1'b1;
            Branch = 1'b0;         
            ALUcntrl  = 2'b10; // R             
          end
       `LW :   
           begin
            RegDst = 1'b0;
            MemRead = 1'b1;
            MemWrite = 1'b0;
            MemToReg = 1'b1;
            ALUSrc = 1'b1;
            RegWrite = 1'b1;
            Branch = 1'b0;
            ALUcntrl  = 2'b00; // add
           end
        `SW :   
           begin 
            RegDst = 1'b0;
            MemRead = 1'b0;
            MemWrite = 1'b1;
            MemToReg = 1'b0;
            ALUSrc = 1'b1;
            RegWrite = 1'b0;
            Branch = 1'b0;
            ALUcntrl  = 2'b00; // add
           end
       `BEQ:  
           begin 
            RegDst = 1'b0;
            MemRead = 1'b0;
            MemWrite = 1'b0;
            MemToReg = 1'b0;
            ALUSrc = 1'b0;
            RegWrite = 1'b0;
            Branch = 1'b1;
            ALUcntrl = 2'b01; // sub
           end
        `ADDI:
            begin
              RegDst = 1'b0;
              MemRead = 1'b0;
              MemWrite = 1'b0;
              MemToReg = 1'b0;
              ALUSrc = 1'b1;
              RegWrite = 1'b1;
              Branch = 1'b0;
              ALUcntrl  = 2'b00; // add
              
            end
       default:
           begin
            RegDst = 1'b0;
            MemRead = 1'b0;
            MemWrite = 1'b0;
            MemToReg = 1'b0;
            ALUSrc = 1'b0;
            RegWrite = 1'b0;
            ALUcntrl = 2'b00; 
         end
      endcase
    end // always
endmodule


/**************** Module for Bypass Detection in EX pipe stage goes here  *********/
/*
 module  control_bypass_ex(output reg [1:0] bypassA,
                       output reg [1:0] bypassB,
                       input [4:0] idex_rs,
                       input [4:0] idex_rt,
                       input [4:0] exmem_rd,
                       input [4:0] memwb_rd,
                       input       exmem_regwrite,
                       input       memwb_regwrite);

                      always @(*) begin
                        if (exmem_rd != 5'b0 && exmem_regwrite == 1'b1) begin
                          if (idex_rs == exmem_rd && idex_rt == exmem_rd) begin
                            bypassA = 2'b10;
                            bypassB = 2'b10;
                            
                          end
                          else if (idex_rs == exmem_rd) begin
                            bypassA = 2'b10;
                            bypassB = 2'b00;
                          end
                          else if (idex_rt == exmem_rd) begin
                            bypassA = 2'b00;
                            bypassB = 2'b10;
                          end
                          else if(memwb_rd != 5'b0 && memwb_regwrite == 1'b1) begin
                            if (idex_rs == memwb_rd && idex_rt == memwb_rd) begin
                              bypassA = 2'b01;
                              bypassB = 2'b01;

                            end
                            else if (idex_rs == memwb_rd) begin
                              bypassA = 2'b01;
                              bypassB = 2'b00;
                            end
                            else if (idex_rt == memwb_rd) begin
                              bypassA = 2'b00;
                              bypassB = 2'b01;  
                            end
                          else begin
                            bypassA = 2'b00;
                            bypassB = 2'b00;
                          end

                          end
                        end
                        else if (memwb_rd != 5'b0 && memwb_regwrite == 1'b1) begin

                            if (idex_rs == memwb_rd && idex_rt == memwb_rd) begin
                              bypassA = 2'b01;
                              bypassB = 2'b01;

                            end
                            else if (idex_rs == memwb_rd) begin
                              bypassA = 2'b01;
                              bypassB = 2'b00;
                            end
                            else if (idex_rt == memwb_rd) begin
                              bypassA = 2'b00;
                              bypassB = 2'b01;  
                            end
                          else begin
                            bypassA = 2'b00;
                            bypassB = 2'b00;
                          end

                        end
                        else begin
                            bypassA = 2'b00;
                            bypassB = 2'b00;                          
                        end
                        
                      
                    end
       
endmodule          
*/

/**************** Module for Bypass Detection in EX pipe stage goes here  *********/
 module  control_bypass_ex(output reg [1:0] bypassA,
                       output reg [1:0] bypassB,
                       input [4:0] idex_rs,
                       input [4:0] idex_rt,
                       input [4:0] exmem_rd,
                       input [4:0] memwb_rd,
                       input       exmem_regwrite,
                       input       memwb_regwrite);

                      always @(*) begin
                        if (idex_rs != 0) begin
                          if (exmem_regwrite == 1'b1 && idex_rs == exmem_rd) begin
                            bypassA = 2'b10;
                          end
                          else if (memwb_regwrite == 1'b1 && idex_rs == memwb_rd) begin
                            bypassA = 2'b01;
                          end
                          else begin
                            bypassA = 2'b00;
                          end
                        end
                        else begin
                          bypassA = 2'b00;
                        end

                        if (idex_rt != 0) begin
                          if (exmem_regwrite == 1'b1 && idex_rt == exmem_rd) begin
                            bypassB = 2'b10;
                          end
                          else if (memwb_regwrite == 1'b1 && idex_rt == memwb_rd) begin
                            bypassB = 2'b01;
                          end
                          else begin
                            bypassB = 2'b00;
                          end
                        end
                        else begin
                          bypassB = 2'b00;
                        end

                      end
endmodule                           

/**************** Module for Stall Detection in ID pipe stage goes here  *********/
module hazard_detection(IFID_rs ,IFID_rt ,IDEX_rt ,IDEX_MemRead ,IF_DWrite, PCWrite,IF_CTRL_MUX);
  input [4:0] IFID_rs, IFID_rt, IDEX_rt;
  input IDEX_MemRead;
  output reg IF_DWrite, PCWrite,IF_CTRL_MUX;

  always @(IFID_rs or IFID_rt or IDEX_rt or IDEX_MemRead) begin
    if (IDEX_rt != 5'b0 && IDEX_MemRead == 1'b1) begin
      if (IFID_rs == IDEX_rt || IFID_rt == IDEX_rt) begin
        IF_DWrite = 1;
        PCWrite = 1;
        IF_CTRL_MUX = 1;        
      end
      else begin
        IF_DWrite = 0;
        PCWrite = 0; 
        IF_CTRL_MUX= 0;       
      end
    end
    else begin
      IF_DWrite = 0;
      PCWrite = 0;
      IF_CTRL_MUX = 0;
    end
  end

endmodule 
                       
/************** control for ALU control in EX pipe stage  *************/
module control_alu(output reg [3:0] ALUOp,                  
               input [1:0] ALUcntrl,
               input [5:0] func ,output reg sll_sig);

  always @(ALUcntrl or func)  
    begin
      case (ALUcntrl)
        2'b10: 
           begin
             sll_sig =  ~|func;
             case (func)
              6'b100000: ALUOp  = 4'b0010; // add
              6'b100010: ALUOp = 4'b0110; // sub
              6'b100100: ALUOp = 4'b0000; // and
              6'b100101: ALUOp = 4'b0001; // or
              6'b100111: ALUOp = 4'b1100; // nor
              6'b101010: ALUOp = 4'b0111; // slt
              6'b000000: ALUOp = 4'b0100; // sll
              6'b000100: ALUOp = 4'b0100; // sllv
              default: ALUOp = 4'b0000;       
             endcase 
          end   
        2'b00: 
            begin
              sll_sig = 1'b0;
              ALUOp  = 4'b0010; // add
            end
        2'b01: 
            begin
              sll_sig = 1'b0;
              ALUOp = 4'b0110; // sub
            end
        default:
            begin
              sll_sig = 1'b0;
              ALUOp = 4'b0000;
            end
     endcase
    end
endmodule
