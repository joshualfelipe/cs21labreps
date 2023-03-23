# CS 21 LAB3 -- S2 AY 2022-2023
# Joshua Felipe -- 03/21/2023
# cs21le5b.asm -- Modified Fibonacci Generator Program

.eqv x $a0
.eqv y $a1
.eqv n $a2
.eqv counter $a3
.eqv sum $v1

.text
main:	
	li	$v0, 5
	syscall
	move	x, $v0			# Ask for input of x
	
	li	$v0, 5
	syscall
	move	y, $v0			# Ask for input of y
	
	li	$v0, 5
	syscall
	move	n, $v0			# Ask for input of n
	
	addi	counter, $0, 2		# counter = 2
	
	jal	fib
	
	move	$a0, sum		# store final value of fib to a0 for printing
	li	$v0, 1
	syscall				# print out final value of fib()
	
	li	$v0, 10			# Stop the program from running
	syscall

fib:
	###### PREAMBLE ######	
	subu	$sp, $sp, 4		# Allocate memory for storing ra
	sw	$ra, 0($sp)		# store ra in memory
	
	beq	counter, n, base	# Check if base case: n = counter
	
	addi	$t0, $0, 2
	div	$t1, counter, $t0
	mfhi	$t2
	beqz	$t2, even		# Check if counter is even. If even store result on x register
	
	add	y, x, y			# Else, store result on y register
	j	recurse			# Proceed on recursive call
even:
	add	x, x, y			# Store result on x register
	j	recurse			# jump to recursion call
	
recurse:
	addi	counter, counter, 1	# increment counter
	jal	fib			# recursive step
	j	end			# skip base case since recursive call is done
	
base:					# base case
	add	sum, x, y		# store result to sum, and return it as final value

end:
	lw	$ra, 0($sp)		# load memory address to ra
	addu	$sp, $sp, 4		# move up sp
	jr	$ra			# go back to main
	
# Found limitation is n = 50 because there is overflow when adding x and y
