.data
str1: .asciiz "PLease give a number: "
str2: .asciiz "Number "
str3: .asciiz " has "
str4: .asciiz " ones and "
str5: .asciiz " zeros."

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

.text
    #print message
    print_str(str1)

    #Read Number
    li $v0, 5
    syscall
    move $s0, $v0
    # $s0 = number 
    
    #init 0s and 1s variables
    move $s3, $zero #0s
    move $s4, $zero #1s

    #loop init 
    li $s1, 1 #mask
    li $s2, 0 #i
    li $t1, 32 #escape value
    #
#loop to find 1s and 0s    
for:
    #condition
    slt $t0, $s2, $t1
    beqz $t0, ExitFor

    #Check Digit
    and $t0, $s1, $s0
    beqz $t0, DigitIsZero
DigitIsOne:
    addi $s4, $s4, 1
    j Endif

DigitIsZero:    
    addi $s3, $s3, 1

Endif:
    #End Of Check

    #step
    sll $s1, $s1, 1 # mask = mask << 1
    addi $s2, $s2, 1 #i++
    
    j for
ExitFor:

    #Print Result
    print_str(str2)
    print_int($s0)  #print number
    print_str(str3)
    print_int($s4) #print 1s
    print_str(str4)
    print_int($s3) #print 0s
    print_str(str5)

    #End
    li $v0 10
    syscall