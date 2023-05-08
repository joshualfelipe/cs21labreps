.data
filename:	.asciiz "test.in"	# remove for stdin
content:	.align 2		# word align
	.space 48		# allocate 256 bytes
content2:	.align 2		# word align
	.space 48		# allocate 256 bytes

# Prints the hexadecimal content of a register
.macro	print_register(%register)
	move	$a0, %register
	addi	$v0, $0, 34
	syscall
	
	addi	$a0, $0, 10
	addi	$v0, $0, 11
	syscall
.end_macro

# Reads a certain number of bytes from the input file and stores it into the buffer address
# This overwrites previously read content in memory
.macro	read_file(%bytes, %add)
	lw	$a0, 0($gp)	# load file descriptor saved in global memory, remove for stdin
#	addi	$a0, $0, 0	# file descriptor for stdin, uncomment for stdin
	move	$a1, %add	# buffer address
	addi	$a2, $0 %bytes	# number of bytes to take
	
	addi	$v0, $0, 14	# read from file
	syscall
.end_macro

.text
main:
	# remove this whole block for stdin, no setup is required in that case, only the read_file macro
	la	$a0, filename	# opens the file based on filename in .data directive
	addi	$a1, $0, 0
	addi	$a2, $0, 0
	addi	$v0, $0, 13	# open file
	syscall
	sw	$v0, 0($gp)	# save the file descriptor as a global variable
	# remove until here for stdin
	
	# Example usage
	la	$s0, content	# get buffer address
	read_file(48, $s0)		# reads 8 bytes from the input and saves it to the buffer address
	lw	$t0, 0($s0)
	lw	$t1, 4($s0)
	print_register($s0)
	print_register($t0)
	print_register($t1)
	
	la	$s0, content2	# get buffer address
	read_file(48, $s0)		# reads 8 bytes from the input and saves it to the buffer address
	lw	$t0, 0($s0)
	lw	$t1, 4($s0)
	
	print_register($s0)
	print_register($t0)
	print_register($t1)
	
exit:
	addi	$v0, $0, 10
	syscall
