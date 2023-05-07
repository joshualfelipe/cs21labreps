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
	addi	%p, %p, 2			# # To change if aayusin yung inputs Skip halfword to balance rows with 2 words each
	j	init_loop

end_init_loop:
.end_macro

.macro get_input(%p)
	la 	$t0, input_buffer   	# load address of input buffer
    	li 	$t1, 6              	# loop counter for lines

read_lines:
    	li 	$v0, 8              	# syscall code 8 for read string
    	move 	$a0, $t0          	# buffer address
    	li 	$a1, 8	         	# maximum number of characters to read
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

.macro init_chosen(%len, %arr)
	li	$t1, 0
	li	$t2, 0
loop:
	beq	%len, $t1, end
	sb	$t2, 0(%arr)
	addi	%arr, %arr, 1
	addi	$t1, $t1, 1
	j	loop
end:
.end_macro 

.macro get_pieces(%len, %arr)
	li	$t1, 0
	li	$t2, 4
	la	$t4, input_buffer
	move	$t5, $t4
	la	$t3, pieceAscii

outer_loop:
	beq	$t1, %len, end_outer_loop
	
inner_loop:
	li 	$v0, 8              	# syscall code 8 for read string
    	move 	$a0, $t5          	# buffer address
    	li 	$a1, 6           	# maximum number of characters to read
   	syscall                		# call the syscall to read input
	
	addi	$t5, $t5, 4
	addi	$t2, $t2, -1
	bne	$t2, $zero, inner_loop
	
	sw	$t4, 0($t3)		# pieceAscii.append(row)
	move	$t4, $t5
	convert_pieces_to_pairs($t3, $t1)# piecePairs = convert_piece_to_pairs(pieceAscii)
	addi	$t1, $t1, 1
	sw	$v0, 0(%arr) 		# converted_pieces.append(piecePairs)
	addi	%arr, %arr, 4
	addi	$t3, $t3, 4
	li	$t2, 4
	j	outer_loop
	
end_outer_loop:
.end_macro 

.macro freeze_blocks(%grid)
	subi	$sp, $sp, 32
	sw	$t0, 28($sp)
	sw	$t1, 24($sp)
	sw	$t2, 20($sp)
	sw	$t3, 16($sp)
	sw	$t4, 12($sp)
	sw	$t5, 8($sp)
	
	li	$v0, %grid	# Returns grid
	li	$t0, 0
	li	$t1, 0
	li	$t2, 10
	li	$t3, 6
	li	$t5, 0x58
loop1:
	beq	$t0, $t2, end_loop
loop2:
	beq	$t1, $t3, end_loop2
	lb	$t4, 0(%grid)
	bne	$t4, 0x23, increment
	sb	$t5, 0(%grid)
	
increment:
	addi	$t1, $t1, 1
	addi	%grid, %grid, 1
	j	loop2
end_loop2:
	addi	%grid, %grid, 2
	addi	$t0, $t0, 1
	li	$t1, 0
	j	loop1

end_loop:
	lw	$t0, 28($sp)
	lw	$t1, 24($sp)
	lw	$t2, 20($sp)
	lw	$t3, 16($sp)
	lw	$t4, 12($sp)
	lw	$t5, 8($sp)
	addi	$sp, $sp, 32
.end_macro 

.macro is_equal_grids(%start, %final)
	subi	$sp, $sp, 32
	sw	$t0, 28($sp)
	sw	$t1, 24($sp)
	sw	$t2, 20($sp)
	sw	$t3, 16($sp)
	sw	$t4, 12($sp)
	sw	$t5, 8($sp)
	sw	$t6, 4($sp)
	
	li	$t0, 0
	li	$t2, 10
	li	$v0, 0x1
loop1:
	beq	$t0, $t2, end_loop
	lw	$t4, 0(%start)
	lw	$t5, 0(%final)
	bne	$t4, $t5, false
	addi	%start, %start, 4
	addi	%final, %final, 4
end_loop2:
	addi	$t0, $t0, 1
	addi	%start, %start, 4	# To change if aayusin yung inputs
	addi	%final, %final, 4	# To change if aayusin yung inputs
	j	loop1
false:	li	$v0, 0
end_loop:	
	lw	$t0, 28($sp)
	lw	$t1, 24($sp)
	lw	$t2, 20($sp)
	lw	$t3, 16($sp)
	lw	$t4, 12($sp)
	lw	$t5, 8($sp)
	lw	$t6, 4($sp)
	addi	$sp, $sp, 32
.end_macro 

.macro convert_pieces_to_pairs(%arr, %inc)
	subi	$sp, $sp, 32
	sw	$s0, 28($sp)
	sw	$t0, 24($sp)
	sw	$t1, 20($sp)
	sw	$s1, 16($sp)
	sw	$t2, 12($sp)
	sw	$t3, 8($sp)
	sw	$t4, 4($sp)
	
	la	$s0, pieceCoords
	move	$t4, %inc
	sll	$t4, $t4, 4
	add	$s0, $s0, $t4
	move	$t2, $s0
	lw	$s1, 0(%arr)
	li	$t0, 0		# initialize i
	li	$t1, 0		# initialize j

loop_i:
	blt	$t0, 4, loop_j
	j	end_i
	
loop_j:
	bge	$t1, 4, end_j
	lb	$t3, 0($s1)	# load value of piecegrid[i][j]
	beq	$t3, 0x23, piece_found	# piecegrid[i][j] == '#'
	addi	$s1, $s1, 1
	addi	$t1, $t1, 1
	j	loop_j
		
piece_found:
	sb	$t0, 0($t2)
	sb	$t1, 2($t2)
	addi	$t1, $t1, 1
	addi	$t2, $t2, 4
	addi	$s1, $s1, 1
	j	loop_j
	
end_j:
	addi	$t0, $t0, 1
	li	$t1, 0
	j	loop_i

end_i:
	move	$v0, $s0
	lw	$s0, 28($sp)
	lw	$t0, 24($sp)
	lw	$t1, 20($sp)
	lw	$s1, 16($sp)
	lw	$t2, 12($sp)
	lw	$t3, 8($sp)
	lw	$t4, 4($sp)
	addi	$sp, $sp, 32	
.end_macro 

.macro get_max_x_of_piece(%piece, %pos)
	subi	$sp, $sp, 32
	sw	$t0, 24($sp)
	sw	$t1, 20($sp)
	sw	$t2, 16($sp)
	sw	$t3, 12($sp)
	sw	$t4, 8($sp)
	
	li	$t0, %pos
	sll	$t0, $t0, 3
	addi	$t1, $t0, 4
	move	$t3, %piece
	lw	$t3, 0($t3)
	add	$t3, $t3, $t0
	li	$t2, -1
	
loop:
	bge	$t0, $t1, end
	lb	$t4, 2($t3)
	addi	$t3, $t3, 4
	addi	$t0, $t0, 1
	blt	$t2, $t4, block_is_greater
	j	loop
block_is_greater:
	move	$t2, $t4
	j	loop
end:
	move	$v0, $t2
	sw	$t0, 24($sp)
	sw	$t1, 20($sp)
	sw	$t2, 16($sp)
	sw	$t3, 12($sp)
	sw	$t4, 8($sp)	
	addi	$sp, $sp, 32
.end_macro 

###### DO NOT MODIFY THESE REGISTERS ######
# S0 base address of start grid
# S1 base address of final grid
# S2 number of pieces
# S3 base address for chosen
# S4 base address of pieces

.text
	# Initiate grids to have 4 empty rows
	la	$s0, start_grid   	# $s0 = address of start_grid
	la	$s1, final_grid   	# $s1 = address of final_grid
	move	$s2, $s0		# S2 copy of base address of S0
	move	$s3, $s1		# S3 copy of base address of S1
	
	#init_arr($s2)
	#init_arr($s3)
	#get_input($s2)
	#get_input($s3)

	#li	$v0, 5			# Get integer from user
	#syscall
	#move	$s2, $v0
	li	$s2, 2
	
	#la	$s3, chosen
	#move	$t0, $s3		# make copy of address of s3
	#init_chosen($s2, $t0)

	la	$s4, converted_pieces
	move	$t0, $s4		# make copy of address of s4

	get_pieces($s2, $t0)
	get_max_x_of_piece($s4, 0)
	#move	$s4, $t0
	#freeze_blocks($t7)
	#is_equal_grids($s0, $s1)
	move	$s5, $v0
	
	
	
	li	$v0, 1
	move	$a0, $s5
	syscall
	
    	li $v0, 10             # exit program
    	syscall


.data
start_grid:	.space 96	# allocate space for a 4x6x4 char array
final_grid:	.space 96	# allocate space for a 4x6x4 char array
chosen:		.space 24	# allocate space for 4x6 bool array 
converted_pieces:.space 24	# allocate space for 4x6 converted pieces array 
pieceAscii:	.space 96	# allocate 4x4x6 for pieceAscii
pieceCoords:	.space 96	# allocate 4x4x6 for pieceCoords
input_buffer:   .space 8		# space to hold input string

#prompt:         .asciiz "Enter a string: "
#_file:	.asciiz "1.in"
#input_buffer:	.space 8
#he: .asciiz "Input read successfully!\n"
