.text
	li $v0, 13
	la $a0, filename
	li $a1, 0
	syscall
	
	li $v0, 14
	move $a0, $s0
	la $a1, filewords
	la $a2, 1024
	syscall
	
	li $v0, 4
	la $a0, filewords
	syscall
	
	li $v0, 16
	move $a0, $s0
	syscall
	
.data
filename: .asciiz "1.in"
filewords: .space 1024
