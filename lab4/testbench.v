// Define top-level testbench
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Top level has no inputs or outputs
// It only needs to instantiate CPU, Drive the inputs to CPU (clock, reset)
// and monitor the outputs. This is what all testbenches do
//
//
// ToDo: Complete the dots
//

`timescale 1ns/1ps
`define clock_period 10

module cpu_tb;
parameter N = 32;

reg    clock, reset;    // Clock and reset signals
reg    [4:0] raA, raB, wa;
reg     wen;
reg    [3:0] op;
wire   [N-1:0] rdA, rdB;
wire   zero;
wire [N-1:0] ALUOut;
integer i, j;

// Instantiate ALU  module. Use connection-by-position
RegFile regs(clock, reset, raA, raB, wa, wen, ALUOut, rdA, rdB);

// Instantiate regfile module. Use connection-by-name
ALU #(.N(32)) ALUInst (.out(ALUOut), .zero(zero), .inA(rdA), .inB(rdB), .op(op));

initial begin  // Ta statements apo ayto to begin mexri to "end" einai seiriaka

  $dumpfile("tb_dumpfile.vcd");
  $dumpvars(0, cpu_tb);

  for (j = 0; j < 32; j = j + 1) begin
	$dumpvars(1, cpu_tb.regs.data[j]);
  end

  // Initialize the module 
  clock = 1;       
  reset = 0;  // Apply reset for a few cycles

  #(4*`clock_period);
  reset = 1; // Set reset so that the circuit can start functioning properly
  
  // Initialize registers so that they are not all zero
  for (i = 0; i < 32; i = i+1) begin
	regs.data[i] = i;
  end
  
  #(1*`clock_period);

  // Now apply some inputs. 

  // Testing ADD
  op = 4'b0010;   // ADD
  wen = 1;
  for (i = 0; i < 32; i = i+1) begin
	#(1*`clock_period) $display("Register %d", i);
	raA = i; raB = 31-i; 
	wa = i;
  end
  // Add your own tests here
  // Testing AND
	op = 4'b0000;
	wa = 0;
  for (i = 0; i < 32; i = i+1) begin
	#(1*`clock_period);
	raA = i; raB = 31-i; 
	wa = i;
  end

  // Testing OR
	op = 4'b0001;
	wa = 0;
  for (i = 0; i < 32; i = i+1) begin
	#(1*`clock_period);
	raA = i; raB = 31-i; 
	wa = i;
  end

  // Testing Sub
	op = 4'b0110;
	wa = 0;
  for (i = 0; i < 32; i = i+1) begin
	#(1*`clock_period);
	raA = i; raB = 31-i; 
	wa = i;
  end

  // Testing Slt
	op = 4'b0111;
	wa = 0;
  for (i = 0; i < 32; i = i+1) begin
	#(1*`clock_period);
	raA = i; raB = 31-i; 
	wa = i;
  end
  
    // Testing NOR
	op = 4'b1100;
	wa = 0;
  for (i = 0; i < 32; i = i+1) begin
	#(1*`clock_period);
	raA = i; raB = 31-i; 
	wa = i;
  end

  


  // Unlike Modelsim, Icarus needs $finish to terminate since there is a clock
  #(2*`clock_period) $finish;
end 

// Generate clock by inverting the signal every half of clock period
always 
  #(`clock_period / 2) clock = ~clock; 

endmodule
