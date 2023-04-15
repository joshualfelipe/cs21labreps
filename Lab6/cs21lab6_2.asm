# CS 21 LAB3 -- S2 AY 2022-2023
# Joshua Felipe -- 04/07/2023
# cs21lab6_1.asm -- IEEE-754 Addition Exercise

.eqv x $s0
.eqv x_s $s1
.eqv x_e $s2
.eqv x_m $s3
.eqv y $s4
.eqv y_s $s5
.eqv y_e $s6
.eqv y_m $s7
.eqv result_s $t1
.eqv result_e $t2
.eqv result_m $t3
.eqv temp $t6
.eqv final $t7


.macro exponent(%xe, %ye, %am)
	sub	$t0, %xe, %ye
	srlv	%am, %am, $t0
.end_macro


.text
main:	
	# Input1
	l.s	$f0, f_a
	mfc1	x, $f0			# copy float to a register

	# Input2
	l.s	$f0, f_b
	mfc1	y, $f0			# copy float to a register
	
	beq	x, y, possible0
	beqz	x, y_answer
	beq	x, 0x80000000, y_answer
	beqz	y, x_answer
	beq	y, 0x80000000, x_answer
	j	noZeros
	
possible0:
	beqz	x, EqualZero 
	beq	x, 0x80000000, EqualZero

noZeros:
	jal	func			# Function call
	j	end

y_answer:
	add	final, $0, y
	j 	end
	
x_answer:
	add	final, $0, x
	j	end
	
EqualZero:
	li	final, 0
	
end:
	sw	final, f_c		# Storing result into memory	
	li	$v0, 10			# End Program
	syscall

#############################################################################################################
	
func:
	# Extracting the Sign
	andi	x_s, x, 0x80000000		# Masks out the other bits
	rol	x_s, x_s, 1			# Gets the signed bit
	andi	y_s, y, 0x80000000		# Masks out the other bits
	rol	y_s, y_s, 1			# Gets the signed bit
	
	# Extracting the Mantissa
	andi	x_m, x, 0x00FFFFFF		# Masks out the other bits
	ori	x_m, x_m, 0x00800000		# Adds the implicit 1
	andi	y_m, y, 0x00FFFFFF		# Masks out the other bits
	ori	y_m, y_m, 0x00800000		# Adds the implicit 1
	
	# Extracting the Exponent
	andi	x_e, x, 0x7f800000		# Masks out the other values
	srl	x_e, x_e, 23			# Shifts right to get the decimal value
	andi	y_e, y, 0x7f800000		# Masks out the other values
	srl	y_e, y_e, 23			# Shifts right to get the decimal value

#############################################################################################################

	# Adjust the exponents
	slt	temp, x_e, y_e		
	beqz	temp, yIsLess			# If temp == 0, y_e is less than x_e thus manipulate y_e
	exponent(y_e, x_e, x_m)			# Manipulates x_e
	add	result_e, $0, y_e
	j	skipLess
	
 yIsLess:	
 	exponent(x_e, y_e, y_m)
 	add	result_e, $0, x_e
 	

	
#############################################################################################################

 	# Check signs
 skipLess:
 	bnez	x_s, xIsNeg
 	j	checkY
 	
 xIsNeg: neg	x_m, x_m
 
 checkY:
  	bnez	y_s, yIsNeg
 	j	skipNeg
 	
 yIsNeg: neg	y_m, y_m
 
 #############################################################################################################
 
 	# Add mantissa and Check if result is negative
 skipNeg:
  	add	result_m, x_m, y_m
 	
 	li	result_s, 0
 	bge	result_m, $0, resultIsPositive
 	neg	result_m, result_m
 	li	result_s, 1

 resultIsPositive:
 	# Shifting of mantissa starts here
 	li	$t4, 0

 loop:
 	# This code block isolates the mantissa.
 	blt	result_m, 0, done
 	sll	result_m, result_m, 1
 	addi	$t4, $t4, 1
 	j	loop
 
 done:
 	subi	temp, $t4, 8			# Determines the number of exponent bits used for mantissa
 	sll	result_m, result_m, 1
 	srl	result_m, result_m, 9		# Ensures that the implicit 1 is at bit 23
 	sub	result_e, result_e, temp	# Calculates the exponent	
 	
 	
 	# FINAL RESULT
 	add	final, final, result_s
 	sll	final, final, 8
 	add	final, final, result_e
 	sll	final, final, 23
 	add	final, final, result_m
 	
	jr	$ra				# Return to main


.data
# Change these values to test other inputs
f_a: .float 3.75
f_b: .float -5.125
f_c: .float
