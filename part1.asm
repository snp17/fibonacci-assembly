.data
input_n: .word 12
fib_num: .word

.text
.globl main

main:
lw $a0, input_n # Load input_n from memory
or $s0, $a0, $zero # Save input in $s0

jal fibonacci # Call Fibonacci function

or $t0, $v0, $zero # Save returned value
sw $t0, fib_num # Store result in memory

li $v0, 10 # Exit syscall
syscall

# a0 = n
# v0 = nth Fibonacci number
fibonacci:
li $t1, 0 # a = 0
li $t2, 1 # b = 1
or $t3, $a0, $zero # Load n into $t3

ori $t0, $zero, 1
bgt $a0, $t0, loop # If n > 1, go to loop

or $v0, $a0, $zero # Return a0 directly
jr $ra

loop:
or $t4, $t2, $zero # temp = b
add $t2, $t1, $t2 # b = a + b
or $t1, $t4, $zero # a = temp

addi $t3, $t3, -1 # Decrement n
bgtz $t3, loop # Repeat loop if n > 0

or $v0, $zero, $t2 # Return b
jr $ra
