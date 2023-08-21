.data
Input_str_msg: .asciiz "Please give string: "
Input_substr_msg: .asciiz "Please give substring: "
Result_msg: .asciiz "The max substring has length: "
Str: .space 100
Substr: .space 100


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

.macro read_str(%str,%N)
	la $a0, %str
	li $a1, %N
	li $v0, 8
	syscall
.end_macro

.text

    print_str(Input_str_msg)
    read_str(Str,100)
    print_str(Input_substr_msg)
    read_str(Substr,100)

    la $a0, Substr
    la $a1, Str
    jal Substring_foo

    move $t0, $v0
    print_int($t0)

Exit:
    li $v0, 10
    syscall

Substring_foo:
    #t0 = *substr, $t1 = counter, $t2 = search_pos , $t3 = 10 , $t4 = *substr_ptr, $t5 = *str
    #s0 = max, $s1 = substr_ptr, $a1 = str

	#Adjust Stack
	addi $sp, $sp, -8
	sw $s0, 4($sp)
	sw $s1, 0($sp)

    move $s0, $zero # $s0 = max = 0
    move $s1, $a0 # $s1 = Substr
    li $t3, 10 # newline value
    move $t2, $zero #search_pos = 0

    lb $t4, 0($s1)
    move $t0, $t4 #Save first char of substr
    beq $t3, $t4, Exit_Outer_Loop
Outer_Loop:
    lb $t5, 0($a1)
    beq $t3, $t5, Exit_Outer_Loop
    
    Inner_Loop:
        bne $t4, $t5, Exit_Inner_Loop
        
        addi $t1, $t1, 1 #counter++
        addi $s1, $s1, 1 #substr_ptr++
        addi $a1, $a1, 1 #str++
    
        lb $t4, 0($s1) # $t4 = *substr_ptr
        beq $t4, $t3, Found_Whole_Substr
        
        lb $t5, 0($a1) # $t5 = *str
    
        #if *str == *substring && search_pos == 0 then search_pos = str
        bnez $t2, Exit_if1
        bne $t5, $t0, Exit_if1  
    if1:
        move $t2, $a1
    Exit_if1:
    
        #if *str == '\n' then calc max and return
        bne $t5, $t3, Exit_if2
    if2:
        #if counter > max then max = counter
        sgt $t6 ,$t1, $s0
        beqz $t6, Not_Found_Whole_Substr
        move $s0, $t1
        j Not_Found_Whole_Substr
    Exit_if2:
    
        beq $t4, $t5, Inner_Loop
        sgt $t6 ,$t1, $s0
        beqz $t6, Not_new_max
        move $s0, $t1 # max = counter
    Not_new_max:
        move $t1, $zero #counter = 0
        move $s1, $a0 #substr_ptr = substr
        lb $t4, 0($a0) #Update *substr_ptr
    
    Exit_Inner_Loop:
    #if found search_pos
beqz $t2, Else3
if3:
    move $a1, $t2 #str = search_pos address
    move $t2, $zero #make address 0
    j Exit_if3
Else3:
    addi $a1, $a1, 1
Exit_if3:

    j Outer_Loop
Exit_Outer_Loop:

move $v0, $s0

j Not_Found_Whole_Substr
Found_Whole_Substr:
    move $v0, $t1
    j finish_foo
Not_Found_Whole_Substr:
    move $v0, $s0
finish_foo:
    #pop stack
	lw $s0, 4($sp)
	lw $s1, 0($sp)
	addi $sp, $sp, 8
    jr $ra