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
	clock = 1'b1;       
	reset = 1'b0;  // Apply reset for a few cyclesz
	#(4*`clock_period) reset = 1'b1;
  
  // arxikopoihsh mnimis kataxwitwn
	for (i = 0; i < 32; i = i+1) begin
		regs.data[i] = i;
	end
  
	#(1*`clock_period);

  // Now apply some inputs. Feel free to change this part of the code
	op = 4'b0010;   // ADD
	wen = 1;
	for (i = 0; i < 32; i = i+1) begin
		#(1*`clock_period);
		$display("Register %d", i);
		raA = i; raB = 31-i; 
		wa = i;
	end
	
	//Checking AND
	#(1*`clock_period);
	op = 4'b0000; 
	wen = 1;
	raA = 8;
	raB = 9;
	wa = 8; 
	
	//Checking OR (happening)
	#(1*`clock_period);
	op = 4'b0001;
	wen = 1;
	raA = 1;
	raB = 2;
	wa = 1;
	
	//Checking wen = 0 with addition (not happening)
	#(1*`clock_period);
	op = 4'b0010;   // ADD
	wen = 0;
	raA = 2;
	raB = 4;
	wa = 6;
	
	//Subtraction with wa = 0 (not happening)
	#(1*`clock_period);
	op = 4'b0110;
	wen = 1;
	raA = 3;
	raB = 23;
	wa = 0;

	//Checking unknwown command
	#(1*`clock_period);
	op = 4'b1110;
	wen = 1;
	raA = 3;
	raB = 8;
	wa = 3;
	
	//reseting
	#(4*`clock_period);
	wen = 0;
	reset = 1'b0;
	
	#(1*`clock_period);
	reset = 1'b1;
	

	//Initialize 2 regs for operations
	#(1*`clock_period);
	regs.data[1] = 2;
	regs.data[2] = 4;
	
	//Check slt
	#(1*`clock_period);
	op = 4'b0111;
	raA = 1;
	raB = 2;
	wa = 3;
	wen = 1;
	
	//Checking nor 1111_1111_1111_1111_1111_1111_1111_1001
	#(1*`clock_period);
	op = 4'b1100;
	wen = 1;
	raA = 1;
	raB = 2;
	wa = 4;



  // Unlike Modelsim, Icarus needs $finish to terminate since there is a clock
	#(2*`clock_period) $finish;
end 

// Generate clock by inverting the signal every half of clock period
always 
	#(`clock_period / 2) clock = ~clock;  

endmodule
