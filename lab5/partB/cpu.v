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
 wire MemWrite;
 wire MemRead;
 wire Branch;
 wire ALUSrc;
 wire MemToReg;
 wire RegDest;
 wire [15:0]immediate;
 wire [31:0]immediate_ext;
 wire [31:0]shifted_by2_immediate_ext;
 wire PCSrc;
 wire BranchCheck;

 always @(posedge clock or negedge reset)
  begin 
    if (reset == 1'b0)
      begin
       PC <= -4; // why is it negative?
      end
	else 
      if(PC == -4)
        PC <= 0;
      else
        PC <= (Branch == 1'b1 && PCSrc == 1'b1 ) ?  (PC + 4) +shifted_by2_immediate_ext : PC + 4;
      
      // PC <= PC + 4 ;      
  end
  
assign opcode = instr[31:26] ;
assign func = instr[5:0] ;
assign instr_rs = instr[25:21] ;
assign instr_rt = instr[20:16] ;
assign instr_rd = instr[15:11] ;

assign immediate = instr[15:0];
assign immediate_ext = {{16{immediate[15]}},immediate};
assign shifted_by2_immediate_ext = immediate_ext << 2;

//assign ALUInA = rdA ;
assign wAddr = (RegDest == 1'b1) ? instr_rd : instr_rt;
assign ALUInB = (ALUSrc == 1'b0) ? rdB : immediate_ext ;
assign wRegData = (MemToReg == 1'b0) ? ALUOut : DMemOut;
assign PCSrc = (BranchCheck == 1'b0) ? zero : ~zero; 
// MIPS ALU
// Instantiate 32-bit ALU
ALU #(.N(32)) ALUInst (.out(ALUOut), .zero(zero), .inA(rdA), .inB(ALUInB), .op(ALUOp));


// Register file
// Instantiate Register File
RegFile cpu_regs(clock, reset, instr_rs, instr_rt, wAddr, RegWrite, wRegData, rdA, rdB);

// Instruction memory 1KB
Memory cpu_IMem(clock,reset, 1'b1/**/ , 1'b0/**/ , PC>>2, 32'b0/**/, instr);

// Control Unit 
fsm cpu_fsm (.RegWrite(RegWrite), .ALUOp(ALUOp), .opcode(opcode), .func(func) , .MemWrite(MemWrite) , .MemRead(MemRead), .Branch(Branch), .ALUSrc(ALUSrc), .MemToReg(MemToReg), .RegDest(RegDest) , .BranchCheck(BranchCheck));
            
//Memory
Memory cpu_DMem(clock,reset, MemRead , MemWrite , ALUOut, rdB, DMemOut);


endmodule
