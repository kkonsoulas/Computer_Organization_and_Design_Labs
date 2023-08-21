.data
.align 0
str0: .space 20
str1: .space 20
str2: .space 39
prompt1: .asciiz "Please enter the first string: "
prompt2: .asciiz "Please enter the second string: "
prompt3: .asciiz "Merged string: "
result1: .asciiz "String 1: "
result2: .asciiz "String 2: "

.macro print_str(%str)
	la $a0, %str
	li $v0, 4
	syscall
.end_macro

.macro read_str(%str,%N)
	la $a0, %str
	li $a1, %N
	li $v0, 8
	syscall
.end_macro


.text

	#Read Strings
	print_str(prompt1)
	read_str(str0,20)
	print_str(prompt2)
	read_str(str1,20)

	#Init the loop
	la $s0, str0
	la $s1, str1
	la $s2, str2
	move $s3, $zero #i
	move $s4, $zero #j
	move $s5, $zero #k

	lb $t0, str0($s3) #str0[i]
	lb $t1, str1($s4) #str1[j]
	li $t3, 10

loop:
	#Loop Exit Condition (str0[i] && str1[j])
	#and $t2, $t0, $t1
	#beqz $t2, Exit_loop
	beq $t0, $t3, Exit_loop
	beq $t1, $t3, Exit_loop


if: #if str0[i] < str1[j] then str2[k] = str0[i]
	slt $t2, $t0, $t1
	beqz $t2, Else 

	sb $t0, str2($s5) # str2[k] = str0[i]
	addi $s3, $s3, 1 # i++
	addi $s5, $s5, 1 # k++
	lb $t0, str0($s3) # load new str0[i]
	j loop

Else: #str2[k] = str1[j]
	sb $t1, str2($s5) # str2[k] = str1[j]
	addi $s4, $s4, 1 # j++
	addi $s5, $s5, 1 # k++
	lb $t1, str1($s4) # load new str1[j]
	j loop

Exit_loop:

if1:
	beq $t0, $t3, Else1
	#beqz $t0, Else1
loop1:	
	sb $t0, str2($s5) # str2[k] = str0[i]
	addi $s3, $s3, 1 # i++
	addi $s5, $s5, 1 # k++
	lb $t0, str0($s3) # load new str0[i]
	#bnez $t0, loop1
	bne $t0, $t3, loop1
	j Print

Else1:
	sb $t1, str2($s5) # str2[k] = str1[j]
	addi $s4, $s4, 1 # j++
	addi $s5, $s5, 1 # k++
	lb $t1, str1($s4) # load new str1[j]
	#bnez $t1, Else1
	bne $t1, $t3, Else1

Print:
	print_str(result1)
	print_str(str0)
	print_str(result2)
	print_str(str1)
	print_str(prompt3)
	print_str(str2)


Exit:
	li $v0, 10
	syscall

