# 0  1  2  3  4  5
# 6  7  8  9  10 11
# 12 13 14 15 16 17
# 18 19 20 21 22 23

# p + r * cols + c


.macro	read_file(%bytes, %add)
	lw	$a0, 0($gp)	# load file descriptor saved in global memory, remove for stdin
	#li	$a0, 0	# file descriptor for stdin, uncomment for stdin
	move	$a1, %add	# buffer address
	addi	$a2, $0 %bytes	# number of bytes to take
	
	addi	$v0, $0, 14	# read from file
	syscall
.end_macro

.macro init_arr(%p)
	subi	$sp, $sp, 32
	sw	$t0, 28($sp)
	sw	$t1, 24($sp)
	sw	$t2, 20($sp)
	sw	$t3, 16($sp)
	sw	$t4, 12($sp)	
	
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
	li	$t5, 0x0d
	sb	$t5, 0(%p)			# store '\r' into memory
	addi	%p, %p, 1			# increase value of base address
	
	li	$t5, 0x0a
	sb	$t5, 0(%p)			# store '\n' into memory
	addi	%p, %p, 1			# increase value of base address
	
	li	$t1, 0				# set c = 0
	addi	$t0, $t0, 1			# r++
	#addi	%p, %p, 2			# # To change if aayusin yung inputs Skip halfword to balance rows with 2 words each
	j	init_loop

end_init_loop:

	lw	$t0, 28($sp)
	lw	$t1, 24($sp)
	lw	$t2, 20($sp)
	lw	$t3, 16($sp)
	lw	$t4, 12($sp)
	addi	$sp, $sp, 32
.end_macro

.macro get_input(%p)
	subi	$sp, $sp, 32
	sw	$t0, 28($sp)
	sw	$t1, 24($sp)
	sw	$t2, 20($sp)
	sw	$t3, 16($sp)
	sw	$t4, 12($sp)
	
read_lines:
	move	$t0, %p			# get buffer address
	read_file(48, $t0)		# reads 48 bytes from the input and saves it to the buffer address
	li	$t2, 0			# counter = 0
	li	$t1, 48			# numCols = 6
loop:
	li	$t4, 0x23		# t7 = '#'
	beq	$t2, $t1, end_loop	# counter < numCols
	lb	$t3, 0($t0)		# rows[counter] == '#' ?
	bne	$t3, $t4, go_back
	li	$t4, 0x58		# True: rows[counter] = 'X'
	sb	$t4, 0($t0)
go_back:
	addi	$t0, $t0, 1		# t0++
	addi	$t2, $t2, 1		# t2++
	j	loop
	
end_loop:	
	
    	lw	$t0, 28($sp)
	lw	$t1, 24($sp)
	lw	$t2, 20($sp)
	lw	$t3, 16($sp)
	lw	$t4, 12($sp)
	addi	$sp, $sp, 32
.end_macro

.macro init_chosen(%len, %arr)
	subi	$sp, $sp, 32
	sw	$t0, 28($sp)
	sw	$t1, 24($sp)
	sw	$t2, 20($sp)
	
	# tracks which piece has been used
	# chosen = [False for _ in range(numPieces)] 
	li	$t1, 0
	li	$t2, 0
loop:
	beq	%len, $t1, end
	sb	$t2, 0(%arr)
	addi	%arr, %arr, 1
	addi	$t1, $t1, 1
	j	loop
end:
	# returns arr
	lw	$t0, 28($sp)
	lw	$t1, 24($sp)
	lw	$t2, 20($sp)
	addi	$sp, $sp, 32
.end_macro 

.macro get_pieces(%len, %arr)
	subi	$sp, $sp, 32
	sw	$t0, 28($sp)
	sw	$t1, 24($sp)
	sw	$t2, 20($sp)
	sw	$t3, 16($sp)

	# This code asks for user to input the pieces and returns
	# an array containing the piecePairs
	move	$t0, %arr
	li	$t1, 0
	la	$t2, pieceAscii	# pieceAscii = []

outer_loop:
	beq	$t1, %len, end_outer_loop
	
	# row = [character for character in line]
	move	$t3, $t2			# get buffer address
	read_file(24, $t3)		# reads 24 bytes from the input and saves it to the buffer address
	
	convert_pieces_to_pairs($t2, $t1)# piecePairs = convert_piece_to_pairs(pieceAscii)
	addi	$t1, $t1, 1
	sw	$v0, 0(%arr) 		# converted_pieces.append(piecePairs)
	addi	%arr, %arr, 4		# move to next piece
	addi	$t3, $t3, 4
	j	outer_loop
	
end_outer_loop:
	lw	$t0, 28($sp)
	lw	$t1, 24($sp)
	lw	$t2, 20($sp)
	lw	$t2, 16($sp)
	addi	$sp, $sp, 32
.end_macro 

.macro freeze_blocks(%grid)
	subi	$sp, $sp, 32
	sw	$t0, 28($sp)
	sw	$t1, 24($sp)
	sw	$t2, 20($sp)
	sw	$t3, 16($sp)
	sw	$t4, 12($sp)
	sw	$t5, 8($sp)
	sw	$t6, 4($sp)
	
	move	$v0, %grid	# Returns grid
	move	$t6, $v0
	li	$t0, 0
	li	$t1, 0
	li	$t2, 10
	li	$t3, 6
	li	$t5, 0x58
loop1:
	beq	$t0, $t2, end_loop	# for i in range(6 + 4):
loop2:
	beq	$t1, $t3, end_loop2	# for j in range(6):
	lb	$t4, 0($t6)
	bne	$t4, 0x23, increment	# if grid[i][j] == '#':
	sb	$t5, 0($t6)		# grid[i][j] = 'X'
	
increment:
	addi	$t1, $t1, 1
	addi	$t6, $t6, 1
	j	loop2
end_loop2:
	addi	$t6, $t6, 2
	addi	$t0, $t0, 1
	li	$t1, 0
	j	loop1

end_loop:
	# return grid
	lw	$t0, 28($sp)
	lw	$t1, 24($sp)
	lw	$t2, 20($sp)
	lw	$t3, 16($sp)
	lw	$t4, 12($sp)
	lw	$t5, 8($sp)
	lw	$t6, 4($sp)
	addi	$sp, $sp, 32
.end_macro 

.macro is_equal_grids(%start, %final)
	subi	$sp, $sp, 32
	sw	$t0, 28($sp)
	sw	$t1, 24($sp)
	sw	$t2, 20($sp)
	sw	$t3, 16($sp)
	sw	$t4, 12($sp)
	
	move	$t0, %start
	move	$t1, %final

	li	$t2, 0
	li	$v0, 1
	
loop:
	beq	$t2, 20, end_loop
	lw	$t3, 0($t0)
	lw	$t4, 0($t1)
	bne	$t3, $t4, false
	addi	$t0, $t0, 4
	addi	$t1, $t1, 4
	addi	$t2, $t2, 1
	j	loop
false:	li	$v0, 0
end_loop:
	lw	$t0, 28($sp)
	lw	$t1, 24($sp)
	lw	$t2, 20($sp)
	lw	$t3, 16($sp)
	lw	$t4, 12($sp)
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
	
	move	$s1, %arr
	la	$s0, pieceCoords
	move	$t4, %inc
	sll	$t4, $t4, 4
	add	$s0, $s0, $t4
	move	$t2, $s0
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
	addi	$s1, $s1, 2
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
	
	move	$t0, %pos
	sll	$t0, $t0, 4
	addi	$t1, $t0, 4
	move	$t3, %piece
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
	lw	$t0, 24($sp)
	lw	$t1, 20($sp)
	lw	$t2, 16($sp)
	lw	$t3, 12($sp)
	lw	$t4, 8($sp)	
	addi	$sp, $sp, 32
.end_macro 

.macro deepcopy(%arr, %len)
	# Creates a deepcopy of either the chosen array or grid.
	subi	$sp, $sp, 32
	sw	$t0, 28($sp)
	sw	$t1, 24($sp)
	sw	$t2, 20($sp)
	sw	$t3, 16($sp)
	sw	$t4, 12($sp)
	
	li	$t4, %len
	move	$t1, %arr
	beq	$t4, 0xa, deep_copy_grid	# If 10, grid. Else, chosen
	j	deep_copy_chosen
	
deep_copy_grid:
	li	$t0, 96		# allocate 24 bytes for the copy
	li 	$v0, 9  	# system call for memory allocation
	move 	$a0, $t0
	syscall
	move 	$t3, $v0  	# save the address of the allocated memory to $t3
	
	# loop to copy chosen to chosen_copy
	li 	$t4, 0
	li 	$t5, 0
grid_copy_loop:
    	lw 	$t4, 0($t1)
    	sw 	$t4, 0($t3)
    	addi 	$t1, $t1, 4
    	addi 	$t3, $t3, 4
    	addi 	$t5, $t5, 1
    	blt 	$t5, 20, grid_copy_loop
	j	end_grid
	
deep_copy_chosen:
	li	$t0, 8		# allocate 8 bytes for the copy
	li 	$v0, 9  	# system call for memory allocation
	move 	$a0, $t0
	syscall
	move 	$t3, $v0  	# save the address of the allocated memory to $t3

	# loop to copy chosen to chosen_copy
	li 	$t4, 0
	li 	$t5, 0
chosen_copy_loop:
    	lw 	$t4, 0($t1)
    	sw 	$t4, 0($t3)
    	addi 	$t1, $t1, 4
    	addi 	$t3, $t3, 4
    	addi 	$t5, $t5, 1
    	blt 	$t5, 2, chosen_copy_loop

end_chosen:
	move	$v0, $t3
	j	end
	
end_grid:
	move	$v0, $t3

end:	
	lw	$t0, 28($sp)
	lw	$t1, 24($sp)
	lw	$t2, 20($sp)
	lw	$t3, 16($sp)
	lw	$t4, 12($sp)
	addi	$sp, $sp, 32
.end_macro 

.macro drop_piece_in_grid(%grid, %piece, %offset)
	# OFFLIMIT REGISTERS
	subi	$sp, $sp, 64
	sw	$s5, 60($sp)
	sw	$s6, 56($sp)
	sw	$s7, 52($sp)
	sw	$t0, 48($sp)
	sw	$t1, 44($sp)
	sw	$t2, 40($sp)
	sw	$t3, 36($sp)
	sw	$t4, 32($sp)
	sw	$t5, 28($sp)
	sw	$t6, 24($sp)
	sw	$t7, 20($sp)
	sw	$t8, 16($sp)
	sw	$t9, 12($sp)
	
	move	$s5, %grid
	move	$s6, %piece
	move	$s7, %offset
	
	deepcopy($s5, 10)
	subi	$v0, $v0, 0x50
	move	$t0, $v0	# gridCopy
	
	# for block in piece:
	li	$t7, 0
	subi	$sp, $sp, 4
	sw	$s6, 0($sp)
loop_block:
	# gridCopy[block[0]][block[1] + yOffset] = '#' 
	subi	$sp, $sp, 4
	sw	$t0, 0($sp)
	
	lb	$t4, 0($s6)	# block[0]
	lb	$t5, 2($s6)	# block[1]
	add	$t5, $t5, $s7	# block[1] + yoffset
	
	# p + r * cols + c
	li	$t6, 8
	mult	$t4, $t6
	mflo	$t4
	
	add	$t4, $t4, $t5
	add	$t0, $t0, $t4
	
	li	$t6, 0x23
	sb	$t6, 0($t0)
	
	addi	$s6, $s6, 4
	addi	$t7, $t7, 1
	
	lw	$t0, 0($sp)
	addi	$sp, $sp, 4
	bne	$t7, 4, loop_block
	
	lw	$s6, 0($sp)
	addi	$sp, $sp, 4
	
	# DO NOT TOUCH REGISTERS: T0, T1, T2, T3
loop_forever:
  	
	li	$t1, 0x1	# canStillGoDown
	li	$t2, 0		# initialize i

loop_i:
	beq	$t2, 10, end_loop_i
	li	$t3, 0		# initialize j
	
loop_j:
	beq	$t3, 6, end_loop_j
	subi	$sp, $sp, 4
	sw	$t0, 0($sp)
	# t0 is gridCopy
	
	move	$t4, $t2	# i
	move	$t5, $t3	# j
	#move	$t9, $t2
	
	# p + i * 8 + j
	sll	$t4, $t4, 3
	add	$t4, $t4, $t5
	add	$t0, $t0, $t4
	lb	$t9, 0($t0)
	bne	$t9, '#', go_back_to_j
	
	move	$t4, $t2	# i
	move	$t5, $t3	# j
	addi	$t4, $t4, 1
	bne	$t4, 10, check_next
	j	skip_check
	
check_next:
	sll	$t4, $t4, 3
	add	$t4, $t4, $t5
	lw	$t0, 0($sp)
	add	$t0, $t0, $t4
	lb	$t9, 0($t0)
	bne	$t9, 'X', go_back_to_j

skip_check:
	lw	$t0, 0($sp)
	addi	$sp, $sp, 4
	li	$t1, 0x0
	j	end_loop_j

go_back_to_j:
	addi	$t3, $t3, 1
	lw	$t0, 0($sp)
	addi	$sp, $sp, 4
	j	loop_j	
	
end_loop_j:
	addi	$t2, $t2, 1
	li	$t3, 0
	beqz	$t1, end_loop_i		# if not canStillGoDown:
	j	loop_i

end_loop_i:
	beqz	$t1, end_loop_forever	
	# if canStillGoDown:
	# DO NOT TOUCH REGISTERS FOR THIS PART: T0, T1, T2
	li	$t8, 8		# i

loop_down_i:
	li	$t2, 0		# j
loop_down_j:		
	subi	$sp, $sp, 4
	sw	$t0, 0($sp)
	
	move	$t3, $t8
	move	$t4, $t2
	move	$t6, $t0
	
	# p + i * 8 + j
	# gridCopy[i][j] == '#'
	sll	$t3, $t3, 3
	add	$t3, $t4, $t3
	add	$t6, $t6, $t3
	lb	$t5, 0($t6)
	bne	$t5, 0x23, skip
	
	# gridCopy[i][j] = '.'
	li	$t7, 0x2e
	sb	$t7, 0($t6)
	
	# gridCopy[i + 1][j] = '#'
	move	$t3, $t8
	move	$t6, $t0
	addi	$t3, $t3, 1
	sll	$t3, $t3, 3
	add	$t3, $t4, $t3
	add	$t6, $t6, $t3
	
	li	$t7, 0x23
	sb	$t7, 0($t6)
	
skip: 	
	lw	$t0, 0($sp)
	addi	$sp, $sp, 4
	addi	$t2, $t2, 1
	bne	$t2, 6, loop_down_j
	subi	$t8, $t8, 1
	bne	$t8, -1, loop_down_i
	
	
  	
	j	loop_forever
	
end_loop_forever:
	##### DELETE THIS ######
	move	$t7, $a0
	print($t0)
	la	$a0, newline
 	li 	$v0, 4
  	syscall
  	move	$a0, $t7
  	##### DELETE THIS ######


	# for i in range(4 + 6):
	
	li	$t1, 9		# maxY
	li	$t2, 0		# i

loop_outside_i:
	li	$t3, 0		# j
loop_outside_j:	
	subi	$sp, $sp, 4
	sw	$t0, 0($sp)
	
	move	$t4, $t2
	move	$t5, $t3
	move	$t6, $t0
	
	# p + i * 8 + j
	# gridCopy[i][j] == '#'
	sll	$t4, $t4, 3
	add	$t4, $t4, $t5
	add	$t6, $t6, $t4
	lb	$t7, 0($t6)
	bne	$t7, 0x23, skip_outside
	
	# maxY = min(maxY, i)
	blt	$t1, $t2, skip_outside	# maxY < i
	move	$t1, $t2
	
skip_outside:
	lw	$t0, 0($sp)
	addi	$sp, $sp, 4
	addi	$t3, $t3, 1
	bne	$t3, 6, loop_outside_j
	addi	$t2, $t2, 1
	bne	$t2, 10, loop_outside_i
	
	ble	$t1, 3, ret_grid_F
	freeze_blocks($t0)
	move	$v0, $t0
	li	$v1, 0x1
	j	end_of_piece_drop
ret_grid_F:
	move	$v0, $s5
	li	$v1, 0x0
end_of_piece_drop:
	lw	$s5, 60($sp)
	lw	$s6, 56($sp)
	lw	$s7, 52($sp)
	lw	$t0, 48($sp)
	lw	$t1, 44($sp)
	lw	$t2, 40($sp)
	lw	$t3, 36($sp)
	lw	$t4, 32($sp)
	lw	$t5, 28($sp)
	lw	$t6, 24($sp)
	lw	$t7, 20($sp)
	lw	$t8, 16($sp)
	lw	$t9, 12($sp)
	addi	$sp, $sp, 64
.end_macro 

.macro print(%add)
	subi	$sp, $sp, 32
	sw	$t1, 0($sp)
	sw	$t2, 4($sp)
	sw	$t3, 8($sp)
	
	li	$t1, 0
	move	$t3, %add
loop:
	lb	$t2, ($t3)
	
	move	$a0, $t2
 	li 	$v0, 11
  	syscall
  	
	addi	$t1, $t1, 1
	addi	$t3, $t3, 1	
	blt	$t1, 80, loop
	
	la	$a0, newline
 	li 	$v0, 4
  	syscall
	
	lw	$t1, 0($sp)
	lw	$t2, 4($sp)
	lw	$t3, 8($sp)
	addi	$sp, $sp, 32
.end_macro

.macro print_chosen(%add)
	subi	$sp, $sp, 32
	sw	$t1, 0($sp)
	sw	$t2, 4($sp)
	sw	$t3, 8($sp)
	
	li	$t1, 0
	move	$t3, %add
loop:
	lb	$t2, 0($t3)
	
	move	$a0, $t2
 	li 	$v0, 1
  	syscall
  	
	addi	$t1, $t1, 1
	addi	$t3, $t3, 2	
	blt	$t1, 6, loop
	
	la	$a0, newline
 	li 	$v0, 4
  	syscall
	
	lw	$t1, 0($sp)
	lw	$t2, 4($sp)
	lw	$t3, 8($sp)
	addi	$sp, $sp, 32
.end_macro
###### DO NOT MODIFY THESE REGISTERS ######
# S0 base address of start grid
# S1 base address of final grid
# S2 number of pieces
# S3 base address for chosen
# S4 base address of pieces

.text
	# Initialize grids to have 4 empty rows
	la	$s0, start_grid   	# $s0 = address of start_grid
	la	$s1, final_grid   	# $s1 = address of final_grid
	move	$s2, $s0		# S2 copy of base address of S0
	move	$s3, $s1		# S3 copy of base address of S1
	
	# remove this whole block for stdin, no setup is required in that case, only the read_file macro
	la	$a0, filename	# opens the file based on filename in .data directive
	li	$a1, 0
	li	$a2, 0
	li	$v0, 13	# open file
	syscall
	sw	$v0, 0($gp)	# save the file descriptor as a global variable
	# remove until here for stdin
	
	##### GET STARTING AND FINAL GRID #####
	init_arr($s2)
	init_arr($s3)
	get_input($s2)
	get_input($s3)
	
	##### GET INTEGER INPUT #####
	la	$t0, int			# get buffer address
	read_file(3, $t0)		# reads 1 bytes from the input and saves it to the buffer address
	lb	$s2, 0($t0)
	subi	$s2, $s2, 0x30		# removes the extra
	
	##### INITIALIZE CHOSEN PIECES ARRAY #####
	la	$s3, chosen
	move	$t0, $s3		# make copy of address of s3
	init_chosen($s2, $t0)
	
	##### GET PIECCES INPUT #####
	la	$s4, converted_pieces
	move	$t0, $s4		# make copy of address of s4
	get_pieces($s2, $t0)
	lw	$s4, 0($s4)
	
	##### WORKING FUCNTION CALLS #####
	#li $t0, 0
	#get_max_x_of_piece($s4, $t0)
	#freeze_blocks($v0)
	#is_equal_grids($s0, $s1)
	#deepcopy($s1, 10)
	#deepcopy($s3, 2)
	#drop_piece_in_grid($a0, $a1, $a2)
	#move	$a1, $s4		# chosen
	#li	$a2, 4			# pieces
	#move $t0, $v0
	##### BACKTRACK #####
	#backtrack($s0, $s3, $s4, $s2)

	#move	$s5, $v0
	
	##### TESTING #####
	#move	$t0, $v0
	#print($t0)
	#move	$t0, $v0
	#li	$v0, 1
	#move	$a0, $t0
	#syscall
	
	##### DROP PIECE IN GRID #####
	move	$a0, $s0		# grid
	move	$a1, $s3		# chosen
	move	$a2, $s4		# pieces
	
	jal	backtrack
	j	end_program
	
	#drop_piece_in_grid($a0, $a1, $a2)
backtrack:	
	# REMOVE FROM MACRO
	subi	$sp, $sp, 32
	sw	$s0, 28($sp)	# currGrid
	sw	$s3, 24($sp)	# chosen
	sw	$s4, 20($sp)	# pieces	
	sw	$t1, 16($sp)	# i
	sw	$t5, 12($sp)	# offset
	sw	$s5, 8($sp)	# chosen_copy
	sw	$ra, 4($sp)
	
	move	$s0, $a0	# address of currGrid -> nextGrid	($s0)
	move	$s3, $a1	# address of chosen -> chosen_copy	($s5)
	move	$s4, $a2	# address of pieces -> pieces		($s4)
	
	
	##### DELETE THIS ######
	#print($s0)
	#print($s1)
	##### DELETE THIS ######
	
	is_equal_grids($s0, $s1)

	bnez	$v0, end
else:
	deepcopy($s3, 2)
	move	$s5, $v0	# chosen_copy = chosen[:]
	subi	$s5, $s5, 8
	
	li	$t1, 0		# initialize i
	move	$s6, $s3
	move	$s7, $s5
loop_i:
	lb	$t2, 0($s6)		# chosen[i]
	bnez	$t2, loop_back_to_i
	
	get_max_x_of_piece($s4, $t1)	# get_max_x_of_piece(pieces[i])
	move	$t3, $v0		#  max_x_of_piece
	
	#  for offset in range(6 - max_x_of_piece):
	li	$t5, 6
	sub	$t3, $t5, $t3	 	# range(6 - max_x_of_piece)
	li	$t5, 0			# offset

loop_offset:
	# nextGrid, success = drop_piece_in_grid(currGrid, pieces[i], offset)
	# ASSUMPTION $v0 = nextGrid & $v1 = success
	
	subi	$sp, $sp, 4
	sw	$t1, 0($sp)
	sll	$t1, $t1, 4
	add	$t1, $t1, $s4
		
	drop_piece_in_grid($s0, $t1, $t5)
	
	lw	$t1, 0($sp)
	addi	$sp, $sp, 4
	
	beqz	$v1, loop_back_to_offset	# if success:
	li	$t0, 1
	sb	$t0, 0($s7)			# chosen_copy[i] = True	

	move	$a0, $v0			# nextGrid
	move	$a1, $s5			# chosen_copy
	move	$a2, $s4			# pieces
	jal	backtrack			# backtrack(nextGrid, chosen_copy, pieces)
	
	bnez	$v0, end	
	li	$t0, 0
	sb	$t0, 0($s7)			# chosen_copy[i] = False
	
loop_back_to_offset:
	addi	$t5, $t5, 1			# offset++
	blt	$t5, $t3, loop_offset
	
loop_back_to_i:
	addi	$t1, $t1, 1			# i++
	add	$s6, $s3, $t1			# chosen++
	add	$s7, $s5, $t1			# chosen_copy++
	blt	$t1, $s2, loop_i	
	
return_false:
	li	$v0, 0
	
end:
	lw	$s0, 28($sp)	# currGrid
	lw	$s3, 24($sp)	# chosen
	lw	$s4, 20($sp)	# pieces	
	lw	$t1, 16($sp)	# i
	lw	$t5, 12($sp)	# offset
	lw	$s5, 8($sp)	# chosen_copy
	lw	$ra, 4($sp)
	addi	$sp, $sp, 32
	jr	$ra
	
end_program:
	move	$t0, $v0
	beqz	$t0, print_no
	li	$v0, 4
	la	$a0, yes
	syscall
	j	stop_program

print_no:
	li	$v0, 4
	la	$a0, no
	syscall

stop_program:
    	li $v0, 10             # exit program
    	syscall


.data
start_grid:	.space 96	# allocate space for a 4x6x4 char array
final_grid:	.space 96	# allocate space for a 4x6x4 char array
int:		.space 8
chosen:		.space 24	# allocate space for 4x6 bool array 
converted_pieces:.space 24	# allocate space for 4x6 converted pieces array 
pieceAscii:	.space 96	# allocate 4x4x6 for pieceAscii
pieceCoords:	.space 96	# allocate 4x4x6 for pieceCoords
input_buffer:   .space 8		# space to hold input string
deep_grid:	.space 96
deep_chosen:	.space 24
filename:	.asciiz "test.in"

newline:	.asciiz "\n\n"
yes:		.asciiz "YES"
no:		.asciiz "NO"
