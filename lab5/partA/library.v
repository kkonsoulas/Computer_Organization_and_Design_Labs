`include "constants.h"
`timescale 1ns/1ps

// Small ALU. 
//     Inputs: inA, inB, op. 
//     Output: out, zero
// Operations: bitwise and (op = 0)
//             bitwise or  (op = 1)
//             addition (op = 2)
//             subtraction (op = 6)
//             slt  (op = 7)
//             nor (op = 12)

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


// Memory (active 1024 words, from 10 address lsbs).
// Read : enable ren, address addr, data dout
// Write: enable wen, address addr, data din.
module Memory (ren, wen, addr, din, dout);
  input         ren, wen;
  input  [31:0] addr, din;
  output [31:0] dout;

  reg [31:0] data[4095:0];
  wire [31:0] dout;

  always @(ren or wen)
    if (ren & wen)
      $display ("\nMemory ERROR (time %0d): ren and wen both active!\n", $time);

  always @(posedge ren or posedge wen) begin
    if (addr[31:12] != 0)
      $display("Memory WARNING (time %0d): address msbs are not zero\n", $time);
  end  

  assign dout = ((wen==1'b0) && (ren==1'b1)) ? data[addr[11:0]] : 32'bx;
  
  always @(din or wen or ren or addr)
   begin
    if ((wen == 1'b1) && (ren==1'b0))
        data[addr[11:0]] = din;
   end

endmodule


// Register File. Input ports: address raA, data rdA
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


