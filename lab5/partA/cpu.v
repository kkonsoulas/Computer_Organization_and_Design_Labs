`timescale 1ns/1ps

module cpu (input clock, input reset);
 reg [31:0] PC; 
 reg IMemRead;
 wire [31:0] instr, ALUInA, ALUInB, ALUOut, rdA, rdB, wRegData, DMemOut;
 wire [3:0] ALUOp;
 wire RegWrite;
 wire [5:0] opcode, func;
 wire [4:0] instr_rs, instr_rt, instr_rd;
 wire [4:0] wAddr;
 
 wire zero;

 always @(posedge clock or negedge reset)
  begin 
    if (reset == 1'b0)
      begin
       PC <= -4; // why is it negative?
      end
	else     
       PC <= PC + 4 ;      
  end
  
assign opcode = instr[31:26] ;
assign func = instr[5:0] ;
assign instr_rs = instr[25:21] ;
assign instr_rt = instr[20:16] ;
assign instr_rd = instr[15:11] ;

assign wAddr = instr_rd ;
assign ALUInA = rdA ;
assign ALUInB = rdB ;
assign wRegData = ALUOut ;
//assign wRegData = (MemToReg == 1'b0) ? ALUOut : DMemOut;

// MIPS ALU
// Instantiate 32-bit ALU
ALU #(.N(32)) ALUInst (.out(ALUOut), .zero(zero), .inA(rdA), .inB(rdB), .op(ALUOp));


// Register file
// Instantiate Register File
RegFile cpu_regs(clock, reset, instr_rs, instr_rt, instr_rd, RegWrite, ALUOut, rdA, rdB);

// Instruction memory 1KB
Memory cpu_IMem( 1'b1/**/ , 1'b0/**/ , PC>>2, 32'b0/**/, instr);

// Control Unit 
fsm cpu_fsm (RegWrite, ALUOp, opcode, func);
            

endmodule
