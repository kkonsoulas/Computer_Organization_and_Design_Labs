// `include "constants.h"
`timescale 1ns/1ps
`define tpd 1

// Small ALU. Inputs: inA, inB. Output: out. 
// Operations: bitwise and (op = 0)
//             bitwise or  (op = 1)
//             addition (op = 2)
//             subtraction (op = 6)
//             slt  (op = 7)
//             nor (op = 12)
//
// ToDo: Complete the dots
//

module ALU #(parameter N=32) (out, zero, inA, inB, op);
  output [N-1:0] out;
  output zero;
  input  [N-1:0] inA, inB;
  input    [3:0] op;

  assign out = 
			(op == 4'b0000) ?  inA & inB :
			(op == 4'b0001) ?  inA | inB :
			(op == 4'b0010) ?  inA + inB : 
			(op == 4'b0110) ? inA - inB : 
			(op == 4'b0111) ? ((inA < inB) ? 1 : 0) : 
			(op == 4'b1100) ? ~( inA | inB) :
			'bx;

  assign zero = (out == 0); // This is used to make sure that the output is intentionally zero
							// and not that there is no power in the circuit
endmodule


// Register File. Read ports: address raA, data rdA
//                            address raB, data rdB
//                Write port: address wa, data wd, enable wen.
module RegFile (clock, reset, raA, raB, wa, wen, wd, rdA, rdB);
  input  clock, reset;
  input   [4:0] raA, raB, wa;
  input         wen;
  input  [31:0] wd;
  output [31:0] rdA, rdB;
  integer i;
  
  reg [31:0] data[31:0];
  
  wire [31:0] rdA =  data[raA];
  wire [31:0] rdB = data[raB];

  
  // Make sure  that register file is only written at the negative edge of the clock 
  always @(negedge clock or negedge reset) begin
	if (reset == 1'b0)
	  for (i = 0; i < 32; i = i+1)
		data[i] <= 0; 
	else if (wen == 1'b1 && wa != 5'b0)  // In MIPS, R0 should always remain 0
	  data[wa] <= wd;
  end

endmodule

/*
module ALU_RegFile #(parameter N=32) (zero, op ,clock, reset, raA, raB, wa, wen, wd);
	output zero;
	input    [3:0] op;

	input  clock, reset;
	input   [4:0] raA, raB, wa;
	input         wen;
	output wire  [31:0] wd;
	wire [31:0] rdA, rdB;

	RegFile MAIN_REGFILE(.clock(clock) ,.reset(reset) ,.raA(raA) ,.raB(raB) ,.wa(wa) ,.wen(wen), .wd(wd) ,.rdA(rdA) ,.rdB(rdB));
	ALU #(.N(32)) MAIN_ALU(.out(wd), .zero(zero), .inA(rdA), .inB(rdB), .op(op));



endmodule
*/
