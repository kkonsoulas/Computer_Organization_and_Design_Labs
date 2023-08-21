.data
Input_size_msg: .asciiz "Please give the size Size of the square matrix: "
Input_array_msg: .asciiz "Please give the elements row-wise: "
Result_msg: .asciiz "Issymetric: "
newline: .asciiz "\n"

.macro print_int (%x)
	move $a0, %x
	li $v0, 1
	syscall
.end_macro

.text
	#Give Size
	la $a0, Input_size_msg
	jal Print_str

	#Read Size
	jal Read_int
	move $s0, $v0 # $s0 = Size
	#sll $s0, $s0, 2 # $s0 = 4*Size

	#if 0 >= Size then Exit
	slt $t0, $zero, $s0
	beqz $t0, Exit

	move $s3, $sp #Store old $sp

	#Make Array
	mul $s1, $s0, $s0 
	sll $s1, $s1, 2 # $s1 = 4 * Size^2
	sub $sp, $sp, $s1

	move $s2, $zero #s2 = i = 0

#Read Elements
Loop:
	beq $s1, $s2, Exit_Loop
	jal Read_int
	move $t0, $v0

	addi $s2, $s2, 4 # i = i + 4

	sub $t1, $s3, $s2 # $t1 = old_sp - i 
	sw $t0, 0($t1)
	j Loop
Exit_Loop:


	move $a0, $s3
	move $a1, $s0
	jal IsSymetric # $a0 = start of array and $a1 = Size
	move $s3, $v0

	la $a0, Result_msg
	jal Print_str
	
	print_int($s3)

	la $a0, newline
	jal Print_str


Exit:
	li $v0, 10
	syscall

	





.macro print_int (%x)
	move $a0, %x
	li $v0, 1
	syscall
.end_macro

Print_str:
	li $v0, 4
	syscall
	jr $ra

Read_int:
	li $v0, 5
	syscall
	jr $ra



IsSymetric:
	#Adjust Stack
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	
	li $v0, 1 #if symetric value will remain

	move $s0, $zero # $s0 = j = 0
IsSymetric_Outer_Loop:
	#if j>=Size then Exit
	slt $t1, $s0, $a1
	beqz $t1, IsSymetric_Outer_Loop_Exit

	addi $t1, $s0, 1 # i = j+1
	mul $t3, $s0, $a1 # j * Size
IsSymetric_Inner_Loop:
	#if i>=Size then Exit
	slt $t2, $t1, $a1
	beqz $t2, IsSymetric_Inner_Loop_Exit

	add $t4, $t3, $t1 # pos1 = j*Size + i
	sll $t4, $t4, 2 # 4*pos1
	
	# pos2 = 4*(i * Size + j)
	mul $t2, $t1, $a1
	add $t2, $t2, $s0
	sll $t2, $t2, 2

	addi $t4, $t4, 4 #Line it up
	sub $t4, $a0, $t4
	lw $t4, 0($t4) #get array[pos1]

	addi $t2, $t2, 4 #Line it up
	sub $t2, $a0, $t2 
	lw $t2, 0($t2) #get array[pos2]

	#if array[pos1] != array[pos2] then Exit
	bne $t4, $t2, Asymetric

	addi $t1, $t1, 1 #i++
IsSymetric_Inner_Loop_Exit:
	addi $s0, $s0, 1 #j++
	j IsSymetric_Outer_Loop
IsSymetric_Outer_Loop_Exit:
	j Not_Asymetric
Asymetric:
	move $v0, $zero
Not_Asymetric:	

	lw $s0, 0($sp)
	addi $sp, $sp, 4
	jr $ra