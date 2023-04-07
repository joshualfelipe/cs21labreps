# CS 21 LAB3 -- S2 AY 2022-2023
# Joshua Felipe -- 04/07/2023
# cs21lab6_1.asm -- Shifting and Masking Exercise

.eqv input $s0
.eqv copy $s1

.macro texts(%string)
	li 	$v0, 4				# Print string syscall
	la 	$a0, %string 			# Readies printing of output1 text
	syscall					# Print output1 text
.end_macro

.text:
main:
	# Asks user for input
	texts(inputs)				# For aesthetic purposes only
	li	$v0, 5
	syscall				
	move	input, $v0			# Store input
	
	# Jump to function
	jal	item1
	
	# Output1 printing
	texts(output1)				# For aesthetic purposes only
	move	$a0, $t0			# Store return value to t0 for printing
	li	$v0, 1
	syscall					# Print out value of item1
	
	# Jump to function
	jal	item2
	
	texts(newline)
	texts(output2)				# For aesthetic purposes only
	move	$a0, $t0			# Store return value to t0 for printing
	li	$v0, 1
	syscall					# Print out value of item2
	
	li	$v0, 10				# End Program
	syscall


# Logic create a temporary variable (temp) with all 1s then shift temp to the left until input is equal to 0. 
# Afterwards, we invert the value of temp using nor such that everything on the left of the highest 1 bit are all 0s
# and everything on the right are 1s.
item1:
    	or    copy, input, $0            	# Create a copy of the input
   	li    $t0, 0xFFFFFFFF            	# Store all 1s to a temporary variable

loop1:    
    	beq    copy, $0, endloop1        	# Checks if copy == 0. If true terminate loop
    	srl    copy, copy, 1            	# Shift right till copy becomes 0
    	sll    $t0, $t0, 1            		# Shifts left until copy becomes 0
    	j    loop1                		# Loop back

endloop1:
    	nor    $t0, $t0, $0            		# Since all 1s are on the MSB side need to invert using nor
    	jr    $ra                		# Return to main


# Logic create a temporary variable (temp) with decimal value to 15 such that when we logical and it with input we get only the 4bits from LSB. 
# Afterwards, we determine the number of shifting to be done by subtracting the decimal value of temp to 32.
# Then we create another temporary variable (temp1) and store all 1s to it. Next we shift left 32 - temp times.
# Lastly we logical or the result with the 4bits from the LSB
item2:
	or	copy, input, $0			# Create a copy of input
	li	$t0, 0x0000000F			# Store 15 to t0
	and	$t1, $t0, copy			# Grab the first 4 bits from LSB
	li	$t2, 32				
	sub	$t3, $t2, $t1			# 32 - t1. This will determine the number of shifting to be done
	li	$t0, 0xFFFFFFFF			
	sllv	$t0, $t0, $t3			# Shift left the 32 - t1 times
	or	$t0, $t0, $t1			# Add the original 4 LSB bits to the end of result
	jr	$ra				# return to main
	
	
.data:
inputs:	.asciiz "Input: "
output1: .asciiz "Output1: "
output2: .asciiz "Output2: "
newline: .asciiz "\n" 


