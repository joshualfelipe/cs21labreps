# CS 21 LAB3 -- S2 AY 2022-2023
# Joshua Felipe -- 03/18/2023
# floydwarshall.asm -- Floyd-Warshall Algorithm implementation in MIPS

.eqv INF 0x7fffffff
.eqv matrixF $s0
.eqv val_k $s1
.eqv val_i $s2
.eqv val_j $s3
.eqv N 4
.eqv x $t3
.eqv y $t4
.eqv val_ik $s4
.eqv val_kj $s5
.eqv val_ij $s6

.text
main:
	la 	matrixF, matrix		# Store matrix values to matrix
	addi	val_k, $0, 0		# k = 0
	addi	val_i, $0, 0		# i = 0
	addi	val_j, $0, 0		# j = 0
	
	# $t5 = 16 | $t6 = 4
	addi	$t5, $0, 16		# $t5 = 16; will be used for multiplying x
	addi	$t6, $0, 4		# $t6 = 4; will be used for multiplying y
	
loopK:	
	beq	val_k, N, done		# If k == N, then break

loopI:
	beq	val_i, N, endI		# If i == N, then break	 loopI
	
loopJ:
	beq	val_j, N, endJ		# If j == N, then break loopJ
	
	# dist[x][y] = (x * 4 *4) + (y * 4) = (x * 16) + (y * 4)	
	mul	x, val_i, $t5
	mul	y, val_k, $t6	
	add	$t0, x, y		# $t0 = dist[i][k]
	addu	$t0, $t0, matrixF
	lw	val_ik, 0($t0)
					
	mul	x, val_k, $t5
	mul	y, val_j, $t6	
	add	$t1, x, y		# $t1 = dist[k][j]
	addu	$t1, $t1, matrixF
	lw	val_kj, 0($t1)		
	
	mul	x, val_i, $t5
	mul	y, val_j, $t6	
	add	$t2, x, y		# $t2 = dist[i][j]
	addu	$t2, $t2, matrixF
	lw	val_ij, 0($t2)		
	
	beq	val_ik, INF, exit1
	beq	val_kj, INF, exit1
	addu	$t3, val_ik, val_kj	# $t3 = val_ik + val_kj
	j	checkIflessthan

exit1:
	li	$t3, INF
	
checkIflessthan:
	ble	val_ij, $t3, exit2	# If $t3 < val_ij, Skip next instruction					
	move	val_ij, $t3

exit2:
	sw	val_ij, 0($t2)		# Store val_ij to address dist[i][j]
	addi	val_j, val_j, 1		# j++
	j	loopJ			# Loop back to j
	

endJ:					# Goes back to i loop
	srl	val_j, val_j, 6		# Reset j to 0
	addi	val_i, val_i, 1		# i++
	j	loopI			# Loop back to i
	
	
endI:					# Goes back to k loop
	srl	val_j, val_j, 6		# Reset j to 0
	srl	val_i, val_i, 6		# Reset i to 0
	addi	val_k, val_k, 1		# k++
	j	loopK			# Loop back to k
	
done:
	# end instructions here
	li $v0, 10
	syscall


.data
matrix: .word 0		# 00, 0
	.word 3		# 04, 4
	.word INF	# 08, 8
	.word 5		# 0C, 12
	.word 2		# 10, 16
	.word 0		# 14, 20
	.word INF	# 18, 24
	.word 4		# 1C, 28
	.word INF	# 20, 32
	.word 1		# 24, 36
	.word 0		# 28, 40
	.word INF	# 2C, 44
	.word INF	# 30, 48
	.word INF	# 34, 52
	.word 2		# 38, 56
	.word 0		# 3C, 60
