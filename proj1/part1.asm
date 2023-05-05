.data
start_grid:	.space 96          # allocate space for a 4x6 char array
final_grid:	.space 96          # allocate space for a 4x6 char array
input_buffer:   .space 7        # space to hold input string
#prompt:         .asciiz "Enter a string: "
#_file:	.asciiz "1.in"
#input_buffer:	.space 8
#he: .asciiz "Input read successfully!\n"

# 0  1  2  3  4  5
# 6  7  8  9  10 11
# 12 13 14 15 16 17
# 18 19 20 21 22 23

# p + r * cols + c

.macro init_arr(%p)
	li	$t0, 0			# r
	li	$t1, 0			# c
	li	$t2, 6			# cols
	li	$t3, 4			# rows
	li	$t4, 0x2e		# ASCII '.'
init_loop:
	beq	$t0, $t3, end_init_loop		# r < rows
	beq	$t1, $t2, end_inner_init_loop	# c < cols
	sb	$t4, 0(%p)			# store '.' into memory
	addi	%p, %p, 1			# increase value of base address
	addi	$t1, $t1, 1			# increment counter
	j	init_loop

end_inner_init_loop:
	li	$t1, 0				# set c = 0
	addi	$t0, $t0, 1			# r++
	addi	%p, %p, 2			# Skip halfword to balance rows with 2 words each
	j	init_loop

end_init_loop:
.end_macro

.macro get_input(%p)
	la 	$t0, input_buffer   	# load address of input buffer
    	li 	$t1, 6              	# loop counter for lines

read_lines:
    	li 	$v0, 8              	# syscall code 8 for read string
    	move 	$a0, $t0          	# buffer address
    	li 	$a1, 7           	# maximum number of characters to read
   	syscall                		# call the syscall to read input
	move	$t2, $t0		# copy base address of input to t2
	
	li	$t5, 0			# counter = 0
	li	$s4, 6			# numCols = 6
loop:
	li	$t7, 0x23		# t7 = '#'
	beq	$t5, $s4, end_loop	# counter < numCols
	lb	$t6, 0($t2)		# rows[counter] == '#' ?
	bne	$t6, $t7, go_back
	li	$t7, 0x58		# True: rows[counter] = 'X'
	sb	$t7, 0($t2)
go_back:
	addi	$t2, $t2, 1		# t2++
	addi	$t5, $t5, 1		# t5++
	j	loop
	
end_loop:	
	lw 	$t3, 0($t0)		# grab the values in word[0]
	lw 	$t4, 4($t0)		# grab values in word[1]
	
    	sw 	$t3, 0(%p)          	# store string at memory location
    	sw 	$t4, 4(%p)		# store string at memory location

    	addi	$t0, $t0, 8       	# increment buffer pointer by 8 bytes
    	addi 	%p, %p, 8       	# increment memory pointer by 4 bytes
    	addi 	$t1, $t1, -1      	# decrement line counter
    	bnez	$t1, read_lines 	# loop until 6 lines have been read
.end_macro


###### DO NOT EDIT THESE BASE ADDRESS ######
# S0 base address of start grid
# S! base address of final grid

.text
	# Initiate grids to have 4 empty rows
	la	$s0, start_grid   	# $s0 = address of start_grid
	la	$s1, final_grid   	# $s1 = address of final_grid
	move	$s2, $s0		# S2 copy of base address of S0
	move	$s3, $s1		# S3 copy of base address of S1
	
	init_arr($s2)
	init_arr($s3)
	get_input($s2)
	get_input($s3)

	li	$v0, 5			# Get integer from user
	syscall
	move	$s2, $v0
	
    	li $v0, 10             # exit program
    	syscall



