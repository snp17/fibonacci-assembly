.data
input_n: .word 12
result: .word

.text
.globl main

main:
    lw $a0, input_n       # Load input_n from memory
    or $s0, $a0, $zero    # Save n to $s0

    jal fibonacci         # Call Fibonacci function

    or $t0, $v0, $zero    # Save return value
    or $a0, $t0, $zero    # Move result to $a0 for odd check
    jal odd_check         # Call odd_check

    or $t1, $v0, $zero    # Save result (1 if odd, 0 if even)
    sw $t1, result        # Store result in memory

    li $v0, 10            # Exit syscall
    syscall

# a0 = n
# v0 = nth Fibonacci number
fibonacci:
    li $t1, 0             # a = 0
    li $t2, 1             # b = 1
    or $t3, $a0, $zero    # n

    ori $t0, $zero, 1
    bgt $a0, $t0, loop_fib

    or $v0, $a0, $zero    # Return if n <= 1
    jr $ra

loop_fib:
    or $t4, $t2, $zero    # temp = b
    add $t2, $t1, $t2     # b = a + b
    or $t1, $t4, $zero    # a = temp

    addi $t3, $t3, -1     # n--
    bgtz $t3, loop_fib

    or $v0, $zero, $t2    # Return b
    jr $ra

# a0 = x
# a1 = y
# v0 = remainder
# v1 = quotient
div_sub:
    or $t0, $zero, $a0
    or $t1, $zero, $a1
    li $t2, 0             # quotient = 0

loop_div:
    bge $t0, $t1, subtract
    or $v0, $zero, $t0    # remainder
    or $v1, $zero, $t2    # quotient
    jr $ra

subtract:
    sub $t0, $t0, $t1     # x = x - y
    addi $t2, $t2, 1      # quotient++
    j loop_div

# a0 = m
# v0 = 1 if odd, 0 if even
odd_check:
    or $s3, $ra, $zero    # Save return address

    li $a1, 2             # divisor = 2
    jal div_sub

    li $t0, 0             # remainder = 0
    beq $v0, $t0, FALSE
    b TRUE

TRUE:
    li $v0, 1
    j return_check

FALSE:
    li $v0, 0
    j return_check

return_check:
    or $ra, $s3, $zero    # Restore return address
    jr $ra
