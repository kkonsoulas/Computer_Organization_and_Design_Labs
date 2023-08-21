.data
str1: .asciiz "Please give N1: "
str2: .asciiz "Please give N2: "
str3: .asciiz "Iteration "
str4: .asciiz "\n"
str5: .asciiz "The max final union of ranges is ["
str6: .asciiz ","
str7: .asciiz "]"


.macro print_str(%str)
	la $a0, %str
	li $v0, 4
	syscall
.end_macro

.macro print_int(%int)
	move $a0, %int
	li $v0, 1
	syscall
.end_macro

.macro read_int(%int)
	li $v0, 5
	syscall
	move %int, $v0
.end_macro

.text
	#Init and Print iteration Counter
	move $s0, $zero
	print_str(str3)
	print_int($s0)
	print_str(str4)

	#Read N1 = $s1
	print_str(str1)
	read_int($s1)
	
	#if N1<0 Exit
	slt $t0, $s1, $zero
	bnez $t0, Exit
	
N2:	
	#Read N2 = $s2
	print_str(str2)
	read_int($s2)

	#if N2<N1 Reread N2
	sgt $t0, $s2, $s1
	beqz $t0, N2

Loop:

	#Increase by 1 and Print iteration Counter
	addi $s0, $s0, 1
	print_str(str3)
	print_int($s0)
	print_str(str4)
N1_:
	#Read N1' = $s3
	print_str(str1)
	read_int($s3)
	
	#if N1'<0 Print_and_Exit
	slt $t0, $s3, $zero
	bnez $t0, Print_and_Exit	
N2_:	
	#Read N2' = $s4
	print_str(str2)
	read_int($s4)

	#if N2'<N1' Reread N2'
	sgt $t0, $s4, $s3
	beqz $t0, N2_

	#if N2'< N1 then No Collapse
	slt $t0, $s4, $s1
	bnez $t0, No_Collapse
	#if N2 < N1' then No Collapse
	slt $t0, $s2, $s3
	bnez $t0, No_Collapse

Collapse:
	#if N1'< N1 then N1 = N1'
	slt $t0, $s3, $s1
	beqz $t0 Continue #Condition False ==> Continue
	move $s1, $s3
Continue:
	#if N2'> N2 then N2 = N2'
	sgt $t0, $s4, $s2
	beqz $t0 Loop #Condition False ==> Loop
	move $s2, $s4
	j Loop

No_Collapse:
	#if (N2' - N1') > (N2 - N1) then N2 = N2' , N1 = N1' 
	sub $t0, $s4, $s3 #(N2' - N1')
	sub $t1, $s2, $s1 #(N2 - N1)
	sgt $t3, $t0, $t1 # (N2' - N1') > (N2 - N1)
	beqz $t3, Loop # Statement False
	#Statement True
	move $s1, $s3 #N1 = N1'
	move $s2, $s4 #N2 = N2'
	j Loop

Print_and_Exit:
	print_str(str5)
	print_int($s1)
	print_str(str6)
	print_int($s2)
	print_str(str7)

Exit:
	li $v0 10
	syscall