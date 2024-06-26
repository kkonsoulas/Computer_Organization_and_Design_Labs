`define clock_period  10
`timescale 1ns/1ps

module lab6_tester;
  integer   i, test, fail;
  reg       clock, reset; 


  cpu cpu0(clock, reset);

     
  always 
     #(`clock_period / 2) clock = ~clock; 


  initial begin  
    clock = 1'b0;       
    reset = 1'b0;
    test  = 32'bz;
    fail  = 0;


    // 1.  NOTHING SPECIAL ( 5  ADD )
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00011_00001_00000_100000;  // add $1, $2, $3
    cpu0.cpu_IMem.data[1] = 32'b000000_00011_00100_00010_00000_100000;  // add $2, $3, $4
    cpu0.cpu_IMem.data[2] = 32'b000000_00100_00101_00011_00000_100000;  // add $3, $4, $5
    cpu0.cpu_IMem.data[3] = 32'b000000_00101_00110_00100_00000_100000;  // add $4, $5, $6
    cpu0.cpu_IMem.data[4] = 32'b000000_00110_00111_00101_00000_100000;  // add $5, $6, $7
    #(0.23*`clock_period) 
    reset = 1'b1;
    test = 1; 
    #(10*`clock_period)
    $display ("%2d  NOTHING SPECIAL ( 5  ADD )",test);   
    if (cpu0.cpu_regs.data[1] == 32'd5  && 
        cpu0.cpu_regs.data[2] == 32'd7  && 
        cpu0.cpu_regs.data[3] == 32'd9  && 
        cpu0.cpu_regs.data[4] == 32'd11 && 
        cpu0.cpu_regs.data[5] == 32'd13 )
                $display ("%2d :  PASS", test);
    else  begin $display ("%2d :  FAIL", test); fail = fail + 1; end  
    #(`clock_period) 
    reset = 1'b0; 



    // 2.  FORWARD A FROM EX
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00011_00001_00000_100000;  // add $1, $2, $3
    cpu0.cpu_IMem.data[1] = 32'b000000_00011_00100_00010_00000_100000;  // add $2, $3, $4 *
    cpu0.cpu_IMem.data[2] = 32'b000000_00010_00101_00011_00000_100000;  // add $3, $2, $5 forward $2
    cpu0.cpu_IMem.data[3] = 32'b000000_00101_00110_00100_00000_100000;  // add $4, $5, $6
    cpu0.cpu_IMem.data[4] = 32'b000000_00110_00111_00101_00000_100000;  // add $5, $6, $7
    #(0.23*`clock_period) 
    reset = 1'b1;
    test = test +1;
    #(10*`clock_period)
    $display ("%2d  FORWARD A FROM EX",test);      
    if (cpu0.cpu_regs.data[1] == 32'd5  && 
        cpu0.cpu_regs.data[2] == 32'd7  && 
        cpu0.cpu_regs.data[3] == 32'd12 && 
        cpu0.cpu_regs.data[4] == 32'd11 && 
        cpu0.cpu_regs.data[5] == 32'd13 )
                $display ("%2d :  PASS", test);
    else  begin $display ("%2d :  FAIL", test); fail = fail + 1; end  
    #(`clock_period) 
    reset = 1'b0; 



    // 3.  FORWARD B FROM EX 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00011_00001_00000_100000;  // add $1, $2, $3
    cpu0.cpu_IMem.data[1] = 32'b000000_00011_00100_00010_00000_100000;  // add $2, $3, $4 *
    cpu0.cpu_IMem.data[2] = 32'b000000_00100_00010_00011_00000_100000;  // add $3, $4, $2 forward $2
    cpu0.cpu_IMem.data[3] = 32'b000000_00101_00110_00100_00000_100000;  // add $4, $5, $6
    cpu0.cpu_IMem.data[4] = 32'b000000_00110_00111_00101_00000_100000;  // add $5, $6, $7
    #(0.23*`clock_period) 
    reset = 1'b1;
    test = test +1;
    #(10*`clock_period) 
    $display ("%2d  FORWARD B FROM EX",test);      
    if (cpu0.cpu_regs.data[1] == 32'd5  && 
        cpu0.cpu_regs.data[2] == 32'd7  && 
        cpu0.cpu_regs.data[3] == 32'd11 && 
        cpu0.cpu_regs.data[4] == 32'd11 && 
        cpu0.cpu_regs.data[5] == 32'd13 )
                $display ("%2d :  PASS", test);
    else  begin $display ("%2d :  FAIL", test); fail = fail + 1; end  
    #(`clock_period) 
    reset = 1'b0; 

    // 4.  FORWARD A & B FROM EX 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00011_00001_00000_100000;  // add $1, $2, $3
    cpu0.cpu_IMem.data[1] = 32'b000000_00011_00100_00010_00000_100000;  // add $2, $3, $4 *
    cpu0.cpu_IMem.data[2] = 32'b000000_00010_00010_00011_00000_100000;  // add $3, $2, $2 forward $2
    cpu0.cpu_IMem.data[3] = 32'b000000_00101_00110_00100_00000_100000;  // add $4, $5, $6
    cpu0.cpu_IMem.data[4] = 32'b000000_00110_00111_00101_00000_100000;  // add $5, $6, $7
    #(0.23*`clock_period) 
    reset = 1'b1;
    test = test +1;
    #(10*`clock_period)
    $display ("%2d FORWARD A & B FROM EX",test);      
    if (cpu0.cpu_regs.data[1] == 32'd5  && 
        cpu0.cpu_regs.data[2] == 32'd7  && 
        cpu0.cpu_regs.data[3] == 32'd14 && 
        cpu0.cpu_regs.data[4] == 32'd11 && 
        cpu0.cpu_regs.data[5] == 32'd13 )
                $display ("%2d :  PASS", test);
    else  begin $display ("%2d :  FAIL", test); fail = fail + 1; end  
    #(`clock_period) 
    reset = 1'b0; 



    
    // 5.  FORWARD A FROM MEM
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00011_00001_00000_100000;  // add $1, $2, $3
    cpu0.cpu_IMem.data[1] = 32'b000000_00011_00100_00010_00000_100000;  // add $2, $3, $4 * 
    cpu0.cpu_IMem.data[2] = 32'b000000_00100_00101_00011_00000_100000;  // add $3, $4, $5
    cpu0.cpu_IMem.data[3] = 32'b000000_00010_00110_00100_00000_100000;  // add $4, $2, $6 forward $2
    cpu0.cpu_IMem.data[4] = 32'b000000_00110_00111_00101_00000_100000;  // add $5, $6, $7
    #(0.23*`clock_period) 
    reset = 1'b1;
    test = test +1;
    #(10*`clock_period)
    $display ("%2d FORWARD A FROM MEM",test);      
    if (cpu0.cpu_regs.data[1] == 32'd5  && 
        cpu0.cpu_regs.data[2] == 32'd7  && 
        cpu0.cpu_regs.data[3] == 32'd9  && 
        cpu0.cpu_regs.data[4] == 32'd13 && 
        cpu0.cpu_regs.data[5] == 32'd13 )
                $display ("%2d :  PASS", test);
    else  begin $display ("%2d :  FAIL", test); fail = fail + 1; end  
    #(`clock_period) 
    reset = 1'b0; 



    // 6.  FORWARD B FROM MEM
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00011_00001_00000_100000;  // add $1, $2, $3
    cpu0.cpu_IMem.data[1] = 32'b000000_00011_00100_00010_00000_100000;  // add $2, $3, $4 * 
    cpu0.cpu_IMem.data[2] = 32'b000000_00100_00101_00011_00000_100000;  // add $3, $4, $5
    cpu0.cpu_IMem.data[3] = 32'b000000_00101_00010_00100_00000_100000;  // add $4, $5, $2 forward $2
    cpu0.cpu_IMem.data[4] = 32'b000000_00110_00111_00101_00000_100000;  // add $5, $6, $7
    #(0.23*`clock_period) 
    reset = 1'b1;
    test = test +1;
    #(10*`clock_period)
    $display ("%2d FORWARD B FROM MEM",test);   
    if (cpu0.cpu_regs.data[1] == 32'd5  && 
        cpu0.cpu_regs.data[2] == 32'd7  && 
        cpu0.cpu_regs.data[3] == 32'd9  && 
        cpu0.cpu_regs.data[4] == 32'd12 && 
        cpu0.cpu_regs.data[5] == 32'd13 )
                $display ("%2d :  PASS", test);
    else  begin $display ("%2d :  FAIL", test); fail = fail + 1; end  
    #(`clock_period) 
    reset = 1'b0; 



    // 7.  FORWARD A & B FROM MEM
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00011_00001_00000_100000;  // add $1, $2, $3
    cpu0.cpu_IMem.data[1] = 32'b000000_00011_00100_00010_00000_100000;  // add $2, $3, $4 *
    cpu0.cpu_IMem.data[2] = 32'b000000_00100_00101_00011_00000_100000;  // add $3, $4, $5
    cpu0.cpu_IMem.data[3] = 32'b000000_00010_00010_00100_00000_100000;  // add $4, $2, $2 forward $2
    cpu0.cpu_IMem.data[4] = 32'b000000_00110_00111_00101_00000_100000;  // add $5, $6, $7
    #(0.23*`clock_period) 
    reset = 1'b1;
    test = test +1;
    #(10*`clock_period)
    $display ("%2d FORWARD A & B FROM MEM",test);   
    if (cpu0.cpu_regs.data[1] == 32'd5  && 
        cpu0.cpu_regs.data[2] == 32'd7  && 
        cpu0.cpu_regs.data[3] == 32'd9  && 
        cpu0.cpu_regs.data[4] == 32'd14 && 
        cpu0.cpu_regs.data[5] == 32'd13 )
                $display ("%2d :  PASS", test);
    else  begin $display ("%2d :  FAIL", test); fail = fail + 1; end  
    #(`clock_period) 
    reset = 1'b0; 

    // 8.  FORWARD A FROM EX INSTEAD OF MEM
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00011_00001_00000_100000;  // add $1, $2, $3
    cpu0.cpu_IMem.data[1] = 32'b000000_00011_00100_00010_00000_100000;  // add $2, $3, $4 
    cpu0.cpu_IMem.data[2] = 32'b000000_00100_00101_00010_00000_100000;  // add $2, $4, $5 *
    cpu0.cpu_IMem.data[3] = 32'b000000_00010_00110_00100_00000_100000;  // add $4, $2, $6 forward $2
    cpu0.cpu_IMem.data[4] = 32'b000000_00110_00111_00101_00000_100000;  // add $5, $6, $7
    #(0.23*`clock_period) 
    reset = 1'b1;
    test = test +1;
    #(10*`clock_period)
    $display ("%2d FORWARD A FROM EX INSTEAD OF MEM",test);      
    if (cpu0.cpu_regs.data[1] == 32'd5  && 
        cpu0.cpu_regs.data[2] == 32'd9  && 
        cpu0.cpu_regs.data[4] == 32'd15 && 
        cpu0.cpu_regs.data[5] == 32'd13 )
                $display ("%2d :  PASS", test);
    else  begin $display ("%2d :  FAIL", test); fail = fail + 1; end  
    #(`clock_period) 
    reset = 1'b0; 



    // 9.  FORWARD B FROM EX INSTEAD OF MEM
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00011_00001_00000_100000;  // add $1, $2, $3
    cpu0.cpu_IMem.data[1] = 32'b000000_00011_00100_00010_00000_100000;  // add $2, $3, $4 
    cpu0.cpu_IMem.data[2] = 32'b000000_00100_00101_00010_00000_100000;  // add $2, $4, $5 *
    cpu0.cpu_IMem.data[3] = 32'b000000_00101_00010_00100_00000_100000;  // add $4, $5, $2 forward $2
    cpu0.cpu_IMem.data[4] = 32'b000000_00110_00111_00101_00000_100000;  // add $5, $6, $7
    #(0.23*`clock_period) 
    reset = 1'b1;
    test = test +1;
    #(10*`clock_period)
    $display ("%2d FORWARD B FROM EX INSTEAD OF MEM",test);   
    if (cpu0.cpu_regs.data[1] == 32'd5  && 
        cpu0.cpu_regs.data[2] == 32'd9  && 
        cpu0.cpu_regs.data[4] == 32'd14 && 
        cpu0.cpu_regs.data[5] == 32'd13 )
                $display ("%2d :  PASS", test);
    else  begin $display ("%2d :  FAIL", test); fail = fail + 1; end  
    #(`clock_period) 
    reset = 1'b0; 



    // 10. FORWARD A & B FROM EX INSTEAD OF MEM
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00011_00001_00000_100000;  // add $1, $2, $3
    cpu0.cpu_IMem.data[1] = 32'b000000_00011_00100_00010_00000_100000;  // add $2, $3, $4 
    cpu0.cpu_IMem.data[2] = 32'b000000_00100_00101_00010_00000_100000;  // add $2, $4, $5 *
    cpu0.cpu_IMem.data[3] = 32'b000000_00010_00010_00100_00000_100000;  // add $4, $2, $2 forward $2
    cpu0.cpu_IMem.data[4] = 32'b000000_00110_00111_00101_00000_100000;  // add $5, $6, $7
    #(0.23*`clock_period) 
    reset = 1'b1;
    test = test +1;
    #(10*`clock_period)
    $display ("%2d FORWARD A & B FROM EX INSTEAD OF MEM",test);    
    if (cpu0.cpu_regs.data[1] == 32'd5  && 
        cpu0.cpu_regs.data[2] == 32'd9  && 
        cpu0.cpu_regs.data[4] == 32'd18 && 
        cpu0.cpu_regs.data[5] == 32'd13 )
                $display ("%2d :  PASS", test);
    else  begin $display ("%2d :  FAIL", test); fail = fail + 1; end  
    #(`clock_period) 
    reset = 1'b0; 



    // 11. FORWARD MIX
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00011_00001_00000_100000;  // add $1, $2, $3
    cpu0.cpu_IMem.data[1] = 32'b000000_00011_00001_00010_00000_100000;  // add $2, $3, $1 forward $1
    cpu0.cpu_IMem.data[2] = 32'b000000_00010_00101_00011_00000_100000;  // add $3, $2, $5 forward $2
    cpu0.cpu_IMem.data[3] = 32'b000000_00010_00011_00100_00000_100000;  // add $4, $2, $3 forward $2, $3 
    cpu0.cpu_IMem.data[4] = 32'b000000_00110_00111_00101_00000_100000;  // add $5, $6, $7
    #(0.23*`clock_period) 
    reset = 1'b1;
    test = test +1;
    #(10*`clock_period)
    $display ("%2d FORWARD MIX",test);   
    if (cpu0.cpu_regs.data[1] == 32'd5  && 
        cpu0.cpu_regs.data[2] == 32'd8  && 
        cpu0.cpu_regs.data[3] == 32'd13 && 
        cpu0.cpu_regs.data[4] == 32'd21 && 
        cpu0.cpu_regs.data[5] == 32'd13 )
                $display ("%2d :  PASS", test);
    else  begin $display ("%2d :  FAIL", test); fail = fail + 1; end  
    #(`clock_period) 
    reset = 1'b0; 



    // 12. LW DO NOTHING
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    cpu0.cpu_DMem.data[10] = 10; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00011_00001_00000_100000;  // add $1, $2, $3
    cpu0.cpu_IMem.data[1] = 32'b100011_01010_00010_0000000000000000;    // lw  $2, 0($10)
    cpu0.cpu_IMem.data[2] = 32'b000000_00100_00101_00011_00000_100000;  // add $3, $4, $5
    cpu0.cpu_IMem.data[3] = 32'b000000_00101_00110_00100_00000_100000;  // add $4, $5, $6
    cpu0.cpu_IMem.data[4] = 32'b000000_00010_00111_00101_00000_100000;  // add $5, $2, $7
    #(0.23*`clock_period) 
    reset = 1'b1;
    test = test +1;
    #(10*`clock_period)
    $display ("%2d LW DO NOTHING",test);     
    if (cpu0.cpu_regs.data[1] == 32'd5  && 
        cpu0.cpu_regs.data[2] == 32'd10 && 
        cpu0.cpu_regs.data[3] == 32'd9  && 
        cpu0.cpu_regs.data[4] == 32'd11 && 
        cpu0.cpu_regs.data[5] == 32'd17 )
                $display ("%2d :  PASS", test);
    else  begin $display ("%2d :  FAIL", test); fail = fail + 1; end  
    #(`clock_period) 
    reset = 1'b0; 



    // 13.  LW FORWARD
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    cpu0.cpu_DMem.data[10] = 10; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00011_00001_00000_100000;  // add $1, $2, $3
    cpu0.cpu_IMem.data[1] = 32'b100011_01010_00010_0000000000000000;    // lw  $2, 0($10) *
    cpu0.cpu_IMem.data[2] = 32'b000000_00100_00101_00011_00000_100000;  // add $3, $4, $5
    cpu0.cpu_IMem.data[3] = 32'b000000_00101_00010_00100_00000_100000;  // add $4, $5, $2 forward $2
    cpu0.cpu_IMem.data[4] = 32'b000000_00110_00111_00101_00000_100000;  // add $5, $6, $7
    #(0.23*`clock_period) 
    reset = 1'b1;
    test = test +1;
    #(10*`clock_period)
    $display ("%2d LW FORWARD",test);   
    if (cpu0.cpu_regs.data[1] == 32'd5  && 
        cpu0.cpu_regs.data[2] == 32'd10 && 
        cpu0.cpu_regs.data[3] == 32'd9  && 
        cpu0.cpu_regs.data[4] == 32'd15 && 
        cpu0.cpu_regs.data[5] == 32'd13 )
                $display ("%2d :  PASS", test);
    else  begin $display ("%2d :  FAIL", test); fail = fail + 1; end  
    #(`clock_period) 
    reset = 1'b0; 



    // 14.  LW STALL
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    cpu0.cpu_DMem.data[10] = 10; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00011_00001_00000_100000;  // add $1, $2, $3
    cpu0.cpu_IMem.data[1] = 32'b100011_01010_00010_0000000000000000;    // lw  $2, 0($10) *
    cpu0.cpu_IMem.data[2] = 32'b000000_00010_00101_00011_00000_100000;  // add $3, $2, $5 Stall and forward
    cpu0.cpu_IMem.data[3] = 32'b000000_00101_00110_00100_00000_100000;  // add $4, $5, $6
    cpu0.cpu_IMem.data[4] = 32'b000000_00110_00111_00101_00000_100000;  // add $5, $6, $7
    #(0.23*`clock_period) 
    reset = 1'b1;
    test = test +1;
    #(10*`clock_period)
    $display("%2d LW STALL",test);   
    if (cpu0.cpu_regs.data[1] == 32'd5  && 
        cpu0.cpu_regs.data[2] == 32'd10 && 
        cpu0.cpu_regs.data[3] == 32'd15  && 
        cpu0.cpu_regs.data[4] == 32'd11 && 
        cpu0.cpu_regs.data[5] == 32'd13 )
                $display ("%2d :  PASS", test);
    else  begin $display ("%2d :  FAIL", test); fail = fail + 1; end  
    #(`clock_period) 
    reset = 1'b0; 



    // 15. LW STALL MIX
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    cpu0.cpu_DMem.data[10] = 10; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00011_00001_00000_100000;  // add $1, $2, $3
    cpu0.cpu_IMem.data[1] = 32'b100011_01010_00010_0000000000000000;    // lw  $2, 0($10) 
    cpu0.cpu_IMem.data[2] = 32'b100011_00010_00011_0000000000000000;    // lw  $3, 0($2)  
    cpu0.cpu_IMem.data[3] = 32'b000000_00010_00011_00100_00000_100000;  // add $4, $2, $3
    cpu0.cpu_IMem.data[4] = 32'b000000_00011_00100_00101_00000_100000;  // add $5, $3, $4
    #(0.23*`clock_period) 
    reset = 1'b1;
    test = test +1;
    #(13*`clock_period)
    $display ("%2d LW STALL MIX",test);   
    if (cpu0.cpu_regs.data[1] == 32'd5  && 
        cpu0.cpu_regs.data[2] == 32'd10 && 
        cpu0.cpu_regs.data[3] == 32'd10 && 
        cpu0.cpu_regs.data[4] == 32'd20 && 
        cpu0.cpu_regs.data[5] == 32'd30 )
                $display ("%2d :  PASS", test);
    else  begin $display ("%2d :  FAIL", test); fail = fail + 1; 
    $display("reg1 = %d\nreg2 = %d\nreg3 = %d\nreg4 = %d\nreg5 = %d",cpu0.cpu_regs.data[1],cpu0.cpu_regs.data[2],cpu0.cpu_regs.data[3],cpu0.cpu_regs.data[4],cpu0.cpu_regs.data[5]);end  
    #(`clock_period) 
    reset = 1'b0; 




    // 16. SW DO NOTHING
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00011_00001_00000_100000;  // add $1, $2, $3
    cpu0.cpu_IMem.data[1] = 32'b000000_00011_00100_00010_00000_100000;  // add $2, $3, $4
    cpu0.cpu_IMem.data[2] = 32'b000000_00100_00101_00011_00000_100000;  // add $3, $4, $5
    cpu0.cpu_IMem.data[3] = 32'b000000_00101_00110_00100_00000_100000;  // add $4, $5, $6
    cpu0.cpu_IMem.data[4] = 32'b101011_00001_00001_0000000000000000;    // sw  $1, 0($1) 
    #(0.23*`clock_period) 
    reset = 1'b1;
    test = test +1;
    #(10*`clock_period)
    $display ("%2d SW DO NOTHING",test);      
    if (cpu0.cpu_regs.data[1] == 32'd5  && 
        cpu0.cpu_regs.data[2] == 32'd7  && 
        cpu0.cpu_regs.data[3] == 32'd9  && 
        cpu0.cpu_regs.data[4] == 32'd11 && 
        cpu0.cpu_DMem.data[5] == 32'd5 )     // data memory
                $display ("%2d :  PASS", test);
    else  begin $display ("%2d :  FAIL", test); fail = fail + 1; end  
    #(`clock_period) 
    reset = 1'b0; 




    // 17. SW FORWARD EX OFFSET(MEM)
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00011_00001_00000_100000;  // add $1, $2, $3
    cpu0.cpu_IMem.data[1] = 32'b000000_00011_00100_00010_00000_100000;  // add $2, $3, $4
    cpu0.cpu_IMem.data[2] = 32'b000000_00100_00101_00011_00000_100000;  // add $3, $4, $5
    cpu0.cpu_IMem.data[3] = 32'b000000_00101_00110_00100_00000_100000;  // add $4, $5, $6
    cpu0.cpu_IMem.data[4] = 32'b101011_00100_00011_0000000000000000;    // sw  $3, 0($4) 
    #(0.23*`clock_period) 
    reset = 1'b1;
    test = test +1;
    #(10*`clock_period)
    $display ("%2d SW FORWARD EX OFFSET(MEM)",test);   
    if (cpu0.cpu_regs.data[1] == 32'd5  && 
        cpu0.cpu_regs.data[2] == 32'd7  && 
        cpu0.cpu_regs.data[3] == 32'd9  && 
        cpu0.cpu_regs.data[4] == 32'd11 && 
        cpu0.cpu_DMem.data[11]== 32'd9 )     // data memory
                $display ("%2d :  PASS", test);
    else  begin $display ("%2d :  FAIL", test); fail = fail + 1; end  
    #(`clock_period) 
    reset = 1'b0; 




    // 18. SW FORWARD MEM OFFSET(EX)
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00011_00001_00000_100000;  // add $1, $2, $3
    cpu0.cpu_IMem.data[1] = 32'b000000_00011_00100_00010_00000_100000;  // add $2, $3, $4
    cpu0.cpu_IMem.data[2] = 32'b000000_00100_00101_00011_00000_100000;  // add $3, $4, $5
    cpu0.cpu_IMem.data[3] = 32'b000000_00101_00110_00100_00000_100000;  // add $4, $5, $6
    cpu0.cpu_IMem.data[4] = 32'b101011_00011_00100_0000000000000000;    // sw  $4, 0($3) 
    #(0.23*`clock_period) 
    reset = 1'b1;
    test = test +1;
    #(10*`clock_period)
    $display ("%2d SW FORWARD MEM OFFSET(EX)",test);   
    if (cpu0.cpu_regs.data[1] == 32'd5  && 
        cpu0.cpu_regs.data[2] == 32'd7  && 
        cpu0.cpu_regs.data[3] == 32'd9  && 
        cpu0.cpu_regs.data[4] == 32'd11 && 
        cpu0.cpu_DMem.data[9] == 32'd11 )     // data memory
                $display ("%2d :  PASS", test);
    else  begin $display ("%2d :  FAIL", test); fail = fail + 1; end  
    #(`clock_period) 
    reset = 1'b0; 




    // 19.  ADDI
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00011_00001_00000_100000;  // add $1, $2, $3
    cpu0.cpu_IMem.data[1] = 32'b000000_00011_00100_00010_00000_100000;  // add $2, $3, $4
    cpu0.cpu_IMem.data[2] = 32'b001000_00100_00011_0000000000000001;    // addi $3, $4, 1 
    cpu0.cpu_IMem.data[3] = 32'b000000_00101_00110_00100_00000_100000;  // add $4, $5, $6
    cpu0.cpu_IMem.data[4] = 32'b000000_00110_00111_00101_00000_100000;  // add $5, $6, $7
    #(0.23*`clock_period) 
    reset = 1'b1;
    test = test +1;
    #(10*`clock_period)
    $display ("%2d ADDI",test);   
    if (cpu0.cpu_regs.data[1] == 32'd5  && 
        cpu0.cpu_regs.data[2] == 32'd7  && 
        cpu0.cpu_regs.data[3] == 32'd5  && 
        cpu0.cpu_regs.data[4] == 32'd11 && 
        cpu0.cpu_regs.data[5] == 32'd13 )
                $display ("%2d :  PASS", test);
    else  begin $display ("%2d :  FAIL", test); fail = fail + 1; end  
    #(`clock_period) 
    reset = 1'b0; 



    // 20.  ADDI +  SW (FORWARD)
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00011_00001_00000_100000;  // add $1, $2, $3
    cpu0.cpu_IMem.data[1] = 32'b000000_00011_00100_00010_00000_100000;  // add $2, $3, $4
    cpu0.cpu_IMem.data[2] = 32'b001000_00100_00011_0000000000000001;    // addi $3, $4, 1 
    cpu0.cpu_IMem.data[3] = 32'b101011_00010_00011_0000000000000000;    // sw  $3, 0($2) 
    cpu0.cpu_IMem.data[4] = 32'b000000_00110_00111_00101_00000_100000;  // add $5, $6, $7
    #(0.23*`clock_period) 
    reset = 1'b1;
    test = test +1;
    #(10*`clock_period)
    $display ("%2d ADDI +  SW (FORWARD)",test);      
    if (cpu0.cpu_regs.data[1] == 32'd5  && 
        cpu0.cpu_regs.data[2] == 32'd7  && 
        cpu0.cpu_regs.data[3] == 32'd5  &&  
        cpu0.cpu_regs.data[5] == 32'd13 &&
        cpu0.cpu_DMem.data[7] == 32'd5)
                $display ("%2d :  PASS", test);
    else  begin $display ("%2d :  FAIL", test); fail = fail + 1; end  
    #(`clock_period) 
    reset = 1'b0; 



    // 21.  SLL
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00011_00001_00000_100000;  // add $1, $2, $3
    cpu0.cpu_IMem.data[1] = 32'b000000_00011_00100_00010_00000_100000;  // add $2, $3, $4
    cpu0.cpu_IMem.data[2] = 32'b000000_00000_00100_00011_00010_000000;  // sll $3, $4, 2
    cpu0.cpu_IMem.data[3] = 32'b000000_00101_00110_00100_00000_100000;  // add $4, $5, $6
    cpu0.cpu_IMem.data[4] = 32'b000000_00110_00111_00101_00000_100000;  // add $5, $6, $7
    #(0.23*`clock_period) 
    reset = 1'b1;
    test = test +1;
    #(10*`clock_period)
    $display ("%2d SLL",test);   
    if (cpu0.cpu_regs.data[1] == 32'd5  && 
        cpu0.cpu_regs.data[2] == 32'd7  && 
        cpu0.cpu_regs.data[3] == 32'd16 && 
        cpu0.cpu_regs.data[4] == 32'd11 && 
        cpu0.cpu_regs.data[5] == 32'd13 )
                $display ("%2d :  PASS", test);
    else  begin $display ("%2d :  FAIL", test); fail = fail + 1; end  
    #(`clock_period) 
    reset = 1'b0; 



    // 22.  SLLV
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = 32'bx;
    for (i = 0; i < 32; i = i+1) cpu0.cpu_IMem.data[i] = 32'bx;     
    #(3*`clock_period) 
    for (i = 0; i < 32; i = i+1) cpu0.cpu_regs.data[i] = i; 
    //                         opcode    rs   rt    rd   shamt  func
    cpu0.cpu_IMem.data[0] = 32'b000000_00010_00011_00001_00000_100000;  // add $1, $2, $3
    cpu0.cpu_IMem.data[1] = 32'b000000_00011_00100_00010_00000_100000;  // add $2, $3, $4
    cpu0.cpu_IMem.data[2] = 32'b000000_00100_00101_00011_00000_100000;  // add $3, $4, $5
    cpu0.cpu_IMem.data[3] = 32'b000000_00001_00100_00100_00000_000100;  // sllv $4, $4, $1
    cpu0.cpu_IMem.data[4] = 32'b000000_00110_00111_00101_00000_100000;  // add $5, $6, $7
    #(0.23*`clock_period) 
    reset = 1'b1;
    test = test +1;
    #(10*`clock_period)
    $display ("%2d SLLV",test);     
    if (cpu0.cpu_regs.data[1] == 32'd5  && 
        cpu0.cpu_regs.data[2] == 32'd7  && 
        cpu0.cpu_regs.data[3] == 32'd9  && 
        cpu0.cpu_regs.data[4] == 32'd128&& 
        cpu0.cpu_regs.data[5] == 32'd13 )
                $display ("%2d :  PASS", test);
    else  begin $display ("%2d :  FAIL", test); fail = fail + 1; end  
    #(`clock_period) 
    reset = 1'b0; 


  $display ("Score = %2d / %2d ", test - fail, test);  

  #(`clock_period)  $finish;


 end 



endmodule
