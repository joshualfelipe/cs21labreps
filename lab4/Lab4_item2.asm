.text
main: 
	addi	$t1, $0, 1		# Initialize t1 with a value
	addi	$t2, $0, 1		# Initialize t2 with a value
	bgt	$t1, $t2, some_label
	#slt	$at, $t1, $t2		# This checks if rs < rt. If true store 1, else store 0.
	#beq	$t1, $t2, exit		# This checks if rs == rt. If true we exit the program. Else, continue
	#beq	$at, $0, some_label	# If at = 0 then we branch to next condition. Else we continue
	
exit:
	li 	$v0, 10
	syscall

some_label:
	addi	$t0, $0, 1
	li 	$v0, 10
	syscall
	
	
