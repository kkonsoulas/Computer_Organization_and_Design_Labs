/***********************************************************************************************/
/*********************************  MIPS 5-stage pipeline implementation ***********************/
/***********************************************************************************************/
`timescale 1ns/1ps

module cpu(input clock, input reset);
 reg [31:0] PC ,IDEX_PCplus4; 
 reg [31:0] IFID_PCplus4;
 reg [31:0] IFID_instr;
 //reg [31:0] IDEX_rdA, IDEX_rdB, IDEX_signExtend;
 reg [31:0] IDEX_signExtend;
 wire [31:0] IDEX_rdA, IDEX_rdB;
 reg [4:0]  IDEX_instr_rt, IDEX_instr_rs, IDEX_instr_rd;                            
 reg        IDEX_RegDst, IDEX_ALUSrc;
 reg [1:0]  IDEX_ALUcntrl;
 reg        IDEX_Branch, IDEX_MemRead, IDEX_MemWrite; 
 reg        IDEX_MemToReg, IDEX_RegWrite;                
 reg [4:0]  EXMEM_RegWriteAddr, EXMEM_instr_rd; 
 reg [31:0] EXMEM_ALUOut;
 reg        EXMEM_Zero;
 reg [31:0] EXMEM_MemWriteData;
 reg        EXMEM_Branch, EXMEM_MemRead, EXMEM_MemWrite, EXMEM_RegWrite, EXMEM_MemToReg ,EXMEM_BranchSwitch;
 reg [31:0] MEMWB_DMemOut;
 reg [4:0]  MEMWB_RegWriteAddr, MEMWB_instr_rd; 
 reg [31:0] MEMWB_ALUOut;
 reg        MEMWB_MemToReg, MEMWB_RegWrite;               
 reg [31:0] EXMEM_NewAddress;
 wire [31:0] instr, ALUInA, ALUInB, ALUOut, rdA, rdB, signExtend, DMemOut, wRegData, PCIncr;
 wire Zero, RegDst, MemRead, MemWrite, MemToReg, ALUSrc, RegWrite, Branch;
 wire [5:0] opcode, func;
 wire [4:0] instr_rs, instr_rt, instr_rd, RegWriteAddr;
 wire [3:0] ALUOp;
 wire [1:0] ALUcntrl;
 wire [15:0] imm;
 wire PCSrc;
reg IDEX_BranchSwitch;
 
 

/***************** Instruction Fetch Unit (IF)  ****************/
 always @(posedge clock or negedge reset)
  begin 
    
    if (reset == 1'b0)     
       PC <= -1;     
    else if (PC == -1)
       PC <= 0;
    else if (PCWrite == 1'b1) begin
      PC <= PC;
    end
    else 
      PC <= (PCSrc == 1'b1) ? EXMEM_NewAddress : (Jump == 1'b1)? jump_address : PC + 32'd4 ;
    /*
    if (reset == 1'b0)     
       PC <= 0;     
    else if (PCWrite == 1'b1) begin
      PC <= PC;
    end
    else 
       PC <= PC + 4;
    */
  end
  
  // IFID pipeline register
 always @(posedge clock or negedge reset)
  begin 
    if (reset == 1'b0)     
      begin
       IFID_PCplus4 <= 32'b0;    
       IFID_instr <= 32'b0;
    end
    else if(IF_DWrite == 1'b1) begin
        IFID_PCplus4 <= IFID_PCplus4; 
        IFID_instr <= IFID_instr;
    end 
    else 
      begin
       IFID_PCplus4 <= PC + 32'd4;
       IFID_instr <= (PCSrc | Jump)? 32'b0: instr;
    end
  end
  
// Instruction memory 1KB
Memory cpu_IMem(clock, reset, 1'b1, 1'b0, PC>>2, 32'b0, instr);
  
  
  
  
  
/***************** Instruction Decode Unit (ID)  ****************/
assign opcode = IFID_instr[31:26];
assign func = IFID_instr[5:0];
assign instr_rs = IFID_instr[25:21];
assign instr_rt = IFID_instr[20:16];
assign instr_rd = IFID_instr[15:11];
assign imm = IFID_instr[15:0];
assign signExtend = {{16{imm[15]}}, imm};
//wire [31:0] jump_immediate =  {{6{IFID_instr[25]}} , IFID_instr[25:0]};
//wire [31:0]jump_immediate_ext2 = jump_immediate << 2;
//wire [31:0]jump_address = IFID_PCplus4 + jump_immediate_ext2;
wire [27:0] jump_immediate = IFID_instr[25:0] << 2;
wire [31:0]jump_address = {IFID_PCplus4[31:28],jump_immediate[27:0]};


// Register file
RegFile cpu_regs(clock, reset, instr_rs, instr_rt, MEMWB_RegWriteAddr, MEMWB_RegWrite, wRegData, IDEX_rdA, IDEX_rdB);

  // IDEX pipeline register
 always @(posedge clock or negedge reset)
  begin 
    if (reset == 1'b0)
      begin
       //IDEX_rdA <= 32'b0;    
       //IDEX_rdB <= 32'b0;
       IDEX_signExtend <= 32'b0;
       IDEX_instr_rd <= 5'b0;
       IDEX_instr_rs <= 5'b0;
       IDEX_instr_rt <= 5'b0;
       IDEX_RegDst <= 1'b0;
       IDEX_ALUcntrl <= 2'b0;
       IDEX_ALUSrc <= 1'b0;
       IDEX_Branch <= 1'b0;
       IDEX_MemRead <= 1'b0;
       IDEX_MemWrite <= 1'b0;
       IDEX_MemToReg <= 1'b0;                  
       IDEX_RegWrite <= 1'b0;

       IDEX_PCplus4 <= 32'b0;
       IDEX_BranchSwitch <= 0;
    end 
    else 
      begin
       //IDEX_rdA <= rdA;
       //IDEX_rdB <= rdB;
       IDEX_signExtend <= signExtend;
       IDEX_instr_rd <= instr_rd;
       IDEX_instr_rs <= instr_rs;
       IDEX_instr_rt <= instr_rt;
       IDEX_RegDst <= RegDst;
       IDEX_ALUcntrl <= ALUcntrl;
       IDEX_ALUSrc <= ALUSrc;
       IDEX_Branch <= Branch;
       IDEX_MemRead <= MemRead;
       IDEX_MemWrite <= MemWrite;
       IDEX_MemToReg <= MemToReg;                  
       IDEX_RegWrite <= RegWrite;

       IDEX_PCplus4 <= IFID_PCplus4;
       IDEX_BranchSwitch <= BranchSwitch;
    end
  end

wire IF_DWrite, PCWrite,IF_CTRL_MUX;
wire temp_RegWrite, temp_MemWrite ,temp_MemRead ,temp_Branch;
wire BranchSwitch , Jump;


// Main Control Unit 
control_main control_main (RegDst,
                  temp_Branch,
                  temp_MemRead,
                  temp_MemWrite,
                  MemToReg,
                  ALUSrc,
                  temp_RegWrite,
                  ALUcntrl,
                  BranchSwitch,
                  Jump,
                  opcode);
                  
// Instantiation of Control Unit that generates stalls goes here
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
hazard_detection hazard_detection(.IFID_rs(instr_rs) ,.IFID_rt(instr_rt) ,.IDEX_rt(IDEX_instr_rt) ,.IDEX_MemRead(IDEX_MemRead) ,.IF_DWrite(IF_DWrite) ,.PCWrite(PCWrite), .IF_CTRL_MUX(IF_CTRL_MUX));
wire bubble_idex = IF_CTRL_MUX | PCSrc;
assign RegWrite = (bubble_idex) ? 1'b0 : temp_RegWrite;
assign MemWrite = (bubble_idex) ? 1'b0 : temp_MemWrite; 
assign MemRead = (bubble_idex) ? 1'b0 : temp_MemRead; 
assign Branch = (bubble_idex) ? 1'b0 : temp_Branch; 



//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                           
/***************** Execution Unit (EX)  ****************/
                 
wire sll_sig;
wire [4:0]Shmt = IDEX_signExtend[10:6];
wire [31:0]ShmtExtend = {{27'b0},Shmt};

//assign ALUInA = IDEX_rdA;
assign ALUInA = 
(sll_sig == 1) ? ShmtExtend : 
(bypassA == 2'b10) ? EXMEM_ALUOut : 
(bypassA == 2'b01) ? wRegData: IDEX_rdA;

//assign ALUInB = (IDEX_ALUSrc == 1'b0) ? IDEX_rdB : IDEX_signExtend;                  

wire [31:0] Valid_rdB;
assign Valid_rdB = 
(bypassB == 2'b10) ? EXMEM_ALUOut : 
(bypassB == 2'b01) ? wRegData : IDEX_rdB;

assign ALUInB = 
(IDEX_ALUSrc == 1'b1) ? IDEX_signExtend : Valid_rdB; 

//  ALU
ALU  #(32) cpu_alu(ALUOut, Zero, ALUInA, ALUInB, ALUOp);

assign RegWriteAddr = (IDEX_RegDst==1'b0) ? IDEX_instr_rt : IDEX_instr_rd;


wire [31:0] IDEX_signExtend_ShiftedBy2 = IDEX_signExtend << 2;
wire [31:0] NewAddress = IDEX_signExtend_ShiftedBy2 + IDEX_PCplus4;


 // EXMEM pipeline register
 always @(posedge clock or negedge reset)
  begin 
    if (reset == 1'b0)     
      begin
       EXMEM_ALUOut <= 32'b0;    
       EXMEM_RegWriteAddr <= 5'b0;
       EXMEM_MemWriteData <= 32'b0;
       EXMEM_Zero <= 1'b0;
       EXMEM_Branch <= 1'b0;
       EXMEM_MemRead <= 1'b0;
       EXMEM_MemWrite <= 1'b0;
       EXMEM_MemToReg <= 1'b0;                  
       EXMEM_RegWrite <= 1'b0;

       EXMEM_NewAddress <= 32'b0;
       EXMEM_BranchSwitch <= 1'b0;
      end 
    else 
      begin
       EXMEM_ALUOut <= ALUOut;    
       EXMEM_RegWriteAddr <= RegWriteAddr;
       //EXMEM_MemWriteData <= IDEX_rdB;
       EXMEM_MemWriteData <= Valid_rdB;
       EXMEM_Zero <= Zero;
       EXMEM_Branch <= IDEX_Valid_Branch;
       EXMEM_MemRead <= IDEX_Valid_MemRead;
       EXMEM_MemWrite <= IDEX_Valid_MemWrite;
       EXMEM_MemToReg <= IDEX_MemToReg;                  
       EXMEM_RegWrite <= IDEX_Valid_RegWrite;

       EXMEM_NewAddress <= NewAddress;
       EXMEM_BranchSwitch <= IDEX_BranchSwitch;
      end
  end
  
  // ALU control
  control_alu control_alu(ALUOp, IDEX_ALUcntrl, IDEX_signExtend[5:0],sll_sig);

  //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
   // Instantiation of control logic for Forwarding goes here
  wire [1:0] bypassA, bypassB;

  control_bypass_ex ctrl_bypass_ex(.bypassA(bypassA), .bypassB(bypassB), .idex_rs(IDEX_instr_rs), .idex_rt(IDEX_instr_rt) ,.exmem_rd(EXMEM_RegWriteAddr) ,.memwb_rd(MEMWB_RegWriteAddr) ,.exmem_regwrite(EXMEM_RegWrite) ,.memwb_regwrite(MEMWB_RegWrite));
  //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!  

wire IDEX_Valid_Branch = (PCSrc == 1'b1)? 1'b0 : IDEX_Branch; 
wire IDEX_Valid_MemRead = (PCSrc == 1'b1)? 1'b0 : IDEX_MemRead; 
wire IDEX_Valid_MemWrite = (PCSrc == 1'b1)? 1'b0 : IDEX_MemWrite; 
wire IDEX_Valid_RegWrite = (PCSrc == 1'b1)? 1'b0 : IDEX_RegWrite; 




/***************** Memory Unit (MEM)  ****************/  

// Data memory 1KB
Memory cpu_DMem(clock, reset, EXMEM_MemRead, EXMEM_MemWrite, EXMEM_ALUOut, EXMEM_MemWriteData, DMemOut);

wire BranchCalc = (EXMEM_BranchSwitch == 1'b1) ? ~EXMEM_Zero : EXMEM_Zero;
assign PCSrc = EXMEM_Branch & BranchCalc;


// MEMWB pipeline register
 always @(posedge clock or negedge reset)
  begin 
    if (reset == 1'b0)     
      begin
       MEMWB_DMemOut <= 32'b0;    
       MEMWB_ALUOut <= 32'b0;
       MEMWB_RegWriteAddr <= 5'b0;
       MEMWB_MemToReg <= 1'b0;                  
       MEMWB_RegWrite <= 1'b0;
      end 
    else 
      begin
       MEMWB_DMemOut <= DMemOut;
       MEMWB_ALUOut <= EXMEM_ALUOut;
       MEMWB_RegWriteAddr <= EXMEM_RegWriteAddr;
       MEMWB_MemToReg <= EXMEM_MemToReg;                  
       MEMWB_RegWrite <= EXMEM_RegWrite;
      end
  end

  
  
  

/***************** WriteBack Unit (WB)  ****************/  
assign wRegData = (MEMWB_MemToReg == 1'b0) ? MEMWB_ALUOut : MEMWB_DMemOut;


endmodule
