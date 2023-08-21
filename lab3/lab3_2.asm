.data
input_str: .asciiz "Please Give n and m: "

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
    #$s0 =n ,$s1 = m
    print_str(input_str)
    read_int($s0)
    read_int($s1)

    move $a0, $s0
    move $a1, $s1
    jal Pow
    move $s0, $v0
    print_int($s0)

Exit:
    li $v0, 10
    syscall



    # $a0 = n, $a1 = m
Pow:
    #load stack
    addi $sp, $sp, -12
    sw $a0, 8($sp)
    sw $a1, 4($sp)
    sw $ra, 0($sp)

    #li $t0, 1
    bne $a1, 1,Exit_if #if m == 1 return n
    move $v0, $a0
    addi $sp, $sp, 12 #Restore Stack
    jr $ra
Exit_if:
    addi $a1, $a1, -1 # m = m - 1 
    jal Pow
    mul $v0, $a0, $v0 # n * mypow(n, m-1);

Unload_and_Return:
    lw $a0, 8($sp)
    lw $a1, 4($sp)
    lw $ra, 0($sp)
    addi $sp, $sp, 12
    jr $ra