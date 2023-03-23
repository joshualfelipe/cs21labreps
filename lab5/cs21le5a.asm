# CS 21 LAB3 -- S2 AY 2022-2023
# Joshua Felipe -- 03/21/2023
# cs21le5a.asm -- Solve for the GCD of two inputs

.eqv x $a0
.eqv y $a1

.text
main:
	li	$v0, 5
	syscall				
	move	x, $v0			# Store x input
	
	li	$v0, 5
	syscall
	move	y, $v0			# Store y input
	
	jal	gcd			# Call GCD function
	
	move	$a0, $v1		# Store return value to a0 for printing
	li	$v0, 1
	syscall				# Print out value of GCD	
	
	li	$v0, 10			# End Program
	syscall

gcd:
	###### PREAMBLE ######
	subi	$sp, $sp, 4
	sw	$ra, 0($sp)
	
	beqz	y, base			# Check if y == 0 for base case
	
	# gcd(y, remainder(x,y))
	div	$t0, x, y
	mfhi	$t1			# Get the remainder of x / y
	move	x, y			# store y to x
	move	y, $t1			# Store remainder to y
	jal	gcd			# Recursive step
	j 	end			# Proceed to end since recursive step is done
	
base:
	move	$v1, x			# store x to v1
	
end:
	lw	$ra, 0($sp)		# load word address
	addi	$sp, $sp, 4		# increment sp
	jr	$ra			# Return to main