.data
input_n: .word 14
odd_or_not: .word

.text
.globl main

main:
    lw $a0, input_n         # Load input value
    or $s0, $a0, $zero      # Save input in $s0

    jal odd_check           # Call odd check function

    or $t1, $v0, $zero      # Save result (1 = odd, 0 = even)
    sw $t1, odd_or_not      # Store in memory

    li $v0, 10              # Exit syscall
    syscall

# a0 = x
# a1 = y
# v0 = remainder
# v1 = quotient
div_sub:
    or $t0, $zero, $a0
    or $t1, $zero, $a1
    li $t2, 0               # quotient = 0

loop_div:
    bge $t0, $t1, subtract
    or $v0, $zero, $t0      # remainder
    or $v1, $zero, $t2      # quotient
    jr $ra

subtract:
    sub $t0, $t0, $t1       # x = x - y
    addi $t2, $t2, 1        # quotient++
    j loop_div

# a0 = input
# v0 = 1 if odd, 0 if even
odd_check:
    or $s3, $ra, $zero      # Save return address

    li $a1, 2               # divisor = 2
    jal div_sub

    li $t0, 0
    beq $v0, $t0, FALSE
    b TRUE

TRUE:
    li $v0, 1
    j return_check

FALSE:
    li $v0, 0
    j return_check

return_check:
    or $ra, $s3, $zero      # Restore return address
    jr $ra
