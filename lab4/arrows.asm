# CS 21 LAB3 -- S2 AY 2022-2023
# Joshua Felipe -- 03/16/2023
# arrows.asm -- Create Arrows from C code to MIPS

.text
main:	
	######### INITIALIZATION OF MAIN VARIABLES ######### 
	# $s0 = h | $s1 = n
	
	# Ask for user input
	li	$v0, 5			# Read integer syscall
	syscall				# Ask user input base
	move	$s0, $v0		# Store BASE to $s0
	li	$v0, 5			# Read integer syscall
	syscall				# Ask user input n (number of triangles)
	move	$s1, $v0		# Store N to $s1
	
	# Getting height of h
	addi	$s0, $s0, 1		# Base + 1
	div	$s0, $s0, 2		# h = floor((base+1)/2)
	
	# Initialize for loop variables
	# $t0 = i | $t1 = layer | $t2 = ast | $t3 = space
	addi	$t0, $0, 0		# i = 0 	-> will be used for forUpper1
	addi	$t1, $0, 0		# layer = 0 	-> will be used for forUpper2
	addi	$t2, $0, 0		# ast = 0 	-> will be used for forUpper3
	addi	$t3, $0, 0		# space = 0	-> will be used for forUpper4
	
######### UPPER TRIANGLE ######### 

forUpper1:				# First For Loop in C
	beq	$t0, $s0, exitUpper	# if i == h then break
	addi	$t4, $t0, 1		# $t4 = i + 1
	
forUpper2:				# Second For Loop in C
	beq	$t1, $s1, exit2		# if layer == n then break
	subi	$t3, $s0, 1		# space = h - 1
	sub	$t3, $t3, $t0		# space = (h - 1)- i 	-> will be used for forUpper4

forUpper3:				# Third For Loop in C
	beq	$t2, $t4, forUpper4	# if ast == i + 1 then break
	li 	$v0, 4			# Print string syscall
	la 	$a0, asterisk 		# Readies printing of asterisk
	syscall				# Print asterisk
	addi	$t2, $t2, 1		# ast++
	j 	forUpper3		# Go back to forUpper3
	
forUpper4: 				# Fourth For Loop in C
	beq	$t3, 0, exit3		# if space == 0 then break
	li 	$v0, 4			# Print string syscall
	la 	$a0, spaces 		# Readies printing of asterisk
	syscall				# Print spaces
	subi	$t3, $t3, 1		# spaces--
	j 	forUpper4		# loop back to forUpper4
	
exit3:
	srl	$t2, $t2, 6		# reset ast to 0
	srl	$t3, $t3, 6		# reset spaces to 0 
	addi	$t1, $t1, 1		# layer++
	j 	forUpper2		# loop back to forUpper2
	
exit2:
	li 	$v0, 4			# Print string syscall
	la 	$a0, newline 		# Readies printing of newline
	syscall				# Print newline
	addi	$t0, $t0, 1		# i++
	srl	$t1, $t1, 6		# return layer to 0
	j 	forUpper1		# loop back to forUpper1
	
	
######### LOWER TRIANGLE ######### 
	
exitUpper:
	# Reset Variables Needed
	# $t0 = i | $t1 = layer | $t2 = ast | $t3 = space
	srl	$t0, $t0, 6		# return i to 0
	srl	$t1, $t1, 6		# return layer to 0
	srl	$t2, $t2, 6		# return ast to 0
	srl	$t3, $t3, 6		# return space to 0
	srl	$t4, $t4, 6		# return t4 to 0
	
	subi	$t4, $s0, 1		# $t4 = (h - 1)	-> To be used as condition for forLower1
	
forLower1:				# First For Loop in C
	beq	$t0, $t4, end	# if i == h - 1 then break
	add	$t1, $0, $s1		# i = n		-> Initialization of layer
	
forLower2:				# Second For Loop in C
	beq	$t1, $0, exitL2		# if layer == 0 then break
		
	subi	$t2, $s0, 1		# ast = h - 1
	sub	$t2, $t2, $t0		# ast = (h - 1)- i	-> Initialization of ast
	
	addi	$t5, $t0, 1		# $t5 = i + 1	-> Condition for forLower4
	
forLower3:				# Third For Loop in C
	beq	$t2, $0, forLower4	# if ast == 0 then break
	li 	$v0, 4			# Print string syscall
	la 	$a0, asterisk 		# Readies printing of asterisk
	syscall				# Print asterisk
	subi	$t2, $t2, 1		# ast--
	j 	forLower3		# Go back to forLower3
	
forLower4:				# Fourth For Loop in C
	beq	$t3, $t5, exitL3	# if space == 0 then break
	li 	$v0, 4			# Print string syscall
	la 	$a0, spaces 		# Readies printing of asterisk
	syscall				# Print spaces
	addi	$t3, $t3, 1		# spaces++
	j 	forLower4		# loop back to forLower4
	
exitL3:
	srl	$t3, $t3, 6		# return spaces to 0 
	subi	$t1, $t1, 1		# layer--
	j 	forLower2		# loop back to forLower2
	
exitL2:
	li 	$v0, 4			# Print string syscall
	la 	$a0, newline 		# Readies printing of newline
	syscall				# Print newline
	addi	$t0, $t0, 1		# i++
	add	$t1, $0, $s1		# return layer to 0
	j 	forLower1		# loop back to forLower1
	

######### END OF PROGRAM ######### 

end:	
	li	$v0, 10			# Exits program
	syscall



.data
asterisk: .asciiz " * "
spaces: .asciiz "   "
newline: .asciiz "\n" 
