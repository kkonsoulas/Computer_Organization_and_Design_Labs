.data

str0: .asciiz "Please enter the size of the vectors: "
str1: .asciiz "Enter element "
str2: .asciiz " of vector x: "
str3: .asciiz " of vector y: "
str4: .asciiz "x = ["
str5: .asciiz "]\n\n"
str6: .asciiz "y = ["
spacechar: .asciiz " "
newline: .asciiz "\n"
result: .asciiz "The inner product of x*y is: "
.align 2
x: .space 20
y: .space 20

#$s0 = size , $s1 = i ,$s2 = total

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
	#Read size
	print_str(str0)
	read_int($s0) # $s0 = size

	#init i=0
	move $s1, $zero # $s1 = i

#Read x Elements
Read_v1:
	#if i == size then Exit
	beq $s0, $s1, Exit_Read_v1
	
	#print message
	print_str(str1)
	print_int($s1)
	print_str(str2)
	
	read_int($t0)
	
	#store input to vector
	sll $t1, $s1, 2 # i = i * 4
	sw $t0, x($t1) # x[i] = $t0 

	addi $s1, $s1, 1 #i++
	j Read_v1
Exit_Read_v1:

#START OF PRINT x
	print_str(str4)
	move $s1, $zero # $s1 = i = 0
	addi $t2, $s0, -1 # $t2 = size - 1 
	bgt $s1, $t2, End_Of_Print_v1 
	
	sll $t3, $t2, 2 # 4*(size-1)
#Print x Elements
Print_v1:
	#if i > size -1 then Exit Print_v1
	beq $t3 ,$s1 ,Exit_Print_v1

	#Fetch Element
	lw $t0 , x($s1) # $t0 = x[i]

	print_int($t0)
	print_str(spacechar)

	addi $s1, $s1, 4 #i = i + 4
	j Print_v1

Exit_Print_v1:
	#Print last Element with ]\n\n
	lw $t0 , x($s1)
	print_int($t0)

End_Of_Print_v1:
	print_str(str5)

	#init i=0
	move $s1, $zero # $s1 = i = 0

#Read y Elements
Read_v2:
	#if i == size then Exit
	beq $s0, $s1, Exit_Read_v2
	
	#print message
	print_str(str1)
	print_int($s1)
	print_str(str3)
	
	read_int($t0) 
	
	#store input to vector
	sll $t1, $s1, 2 # i = i * 4
	sw $t0, y($t1) # y[i] = $t0 

	addi $s1, $s1, 1 #i++
	j Read_v2
Exit_Read_v2:

#START OF PRINT y 
	print_str(str6)
	move $s1, $zero # $s1 = i = 0
	addi $t2, $s0, -1 # $t2 = size - 1 
	bgt $s1, $t2  ,End_Of_Print_v2

	sll $t3, $t2, 2 # $t3 = 4*(size-1)
#Print y Elements
Print_v2:
	#if i > size -1 the Exit Print_v2
	beq $t3 ,$s1 ,Exit_Print_v2

	#Fetch Element
	lw $t0 , y($s1) 

	print_int($t0)
	print_str(spacechar)

	addi $s1, $s1, 4 #i = i + 4
	j Print_v2

Exit_Print_v2:
	#Print last Element with ]\n\n
	lw $t0 , y($s1)
	print_int($t0)

End_Of_Print_v2:
	print_str(str5)

	move $s2, $zero # $s2 = total = 0
	move $s1, $zero # $s1 = i = 0
	sll $t4, $s0, 2 # $t4 = 4*size
Calc:
	#if 4*size == 4*i then Exit_Calc
	beq $s1, $t4, Exit_Calc

	lw $t1, x($s1) # $t1 = x[i] 
	lw $t2, y($s1) # $t2 = y[i]
	
	# total = total + x[i] * y[i]
	mul $t3, $t1, $t2  
	add $s2, $s2, $t3 
	
	addi $s1, $s1, 4 # i = i + 4
	j Calc
Exit_Calc:

Print:
	print_str(result)
	print_int($s2)
	print_str(newline)

Exit:
	li $v0, 10
	syscall