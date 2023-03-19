# CS 21 LAB3 -- S2 AY 2022-2023
# Joshua Felipe -- 03/06/2023
# cs21lab3.asm -- Introduction to MIPS-MARS and Assembly Language Programming

.text
main:	#addi	$s0, $0, 0x4E10C521	# $s0 = 0x4E10C521
	#addi	$s1, $0, -23		# $s1 = -23
	#addi	$t2, $0, 0x4E10C521	# $t2 = 0x4E10C521
	#addi	$t3, $0, 0xC0DEBABE	# $t3 = 0xC0DEBABE
	#addi	$t4, $0, 0x00000923	# $t4 = 0x00000923
	
	add	$t0, $s0, $s1		# $s0 + $s1 = $t0
	nor	$t1, $t2, $t3		# $t1 = $t2 nor $t3
	and	$t5, $t2, $t3		# $t5 = $t2 and $t3
	srl	$t4, $t4, 5		# $t4 = shift 5 to the right
	xor	$t6, $t2, $t3		# $t6 = $t2 xor $t3
	li 	$v0, 10 		# syscall code 10
	syscall 			# syscall code 10

.data
##### DATA ##### 
