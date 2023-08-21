.data
.align 2
str0: .asciiz "give data: "
str1: .asciiz "List("
str2: .asciiz "\b)\n"
str3: .asciiz "Not Enough Memory\n"
whitespace: .asciiz " "




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
# $s0 = head , $s1 = data

	print_str(str0)
	read_int($s1)
	move $s0, $0
main_loop:
	beqz $s1, end_main_loop
	move $a0, $s0 #HEAD
	move $a1, $s1 #DATA
	jal InsertElement
	move $s0, $v0
	print_str(str0)
	read_int($s1)
	j main_loop
end_main_loop:

	print_str(str1)
	move $a0, $s0
	jal printList
	print_str(str2)
	j Exit	
Error:
	print_str(str3)
Exit:
	li $v0 10
	syscall

printList:
	addi $sp, $sp, -8
	sw $a0, 0($sp)
	sw $ra, 4($sp)

	beqz $a0, Reload_and_Return
	lw $t0, 0($a0)
	move $t1, $a0
	print_int($t0)
	print_str(whitespace)
	move $a0, $t1
	lw $a0, 4($a0)
	jal printList

Reload_and_Return:
	lw $a0, 0($sp)
	lw $ra, 4($sp)
	addi $sp, $sp, 8
	jr $ra

InsertElement:
	#Adjust Stack
	addi $sp, $sp, -8
	sw $s1, 4($sp)
	sw $s0, 0($sp)

	#store $a0
	move $t0, $a0
	#allocate memory
	li $v0, 9
	li $a0, 8
	syscall
	beqz $v0, Error #if $v0 == 0 then not enough memory

	#restore $a0
	move $a0, $t0

	#store data
	sw $a1, 0($v0)
	#if Head == NULL make new node head and return 
	bnez $a0, Head_Not_NULL
	sw $zero, 4($v0)
	j Recover_Stack_and_Return
Head_Not_NULL:


	lw $s1 0($a0)
	slt $t0, $s1, $a1
	#if new_node needs to become head
	bnez $t0, Not_New_Head
	sw $a0, 4($v0)
	j Recover_Stack_and_Return
Not_New_Head:


	move $s0, $a0 #$s0 = tmp = head
Find_New_Node_Position:	
	lw $t0, 4($s0) #$t0 = tmp->nxt
	beqz $t0, Found	
	lw $t1, 0($t0) #$t1 = temp->nxt->data
	slt $t2, $t1, $a1 #$t2 = (tmp->next->data < new_node->data)
	beqz $t2, Found
	
	#lw $s0, 4($s0)  #tmp = tmp->nxt
	move $s0, $t0
	j Find_New_Node_Position
Found:

	sw $t0, 4($v0)
	sw $v0, 4($s0)


	move $v0, $a0
Recover_Stack_and_Return:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	addi $sp, $sp, 8
	jr $ra