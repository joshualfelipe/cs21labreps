# CS 21 LAB3 -- S2 AY 2022-2023
# Joshua Felipe -- 04/24/2023
# binary_tree.asm -- Exercise on MIPS dynamic memory allocation through Binary Tree Traversals



# Memory allocation guide
# word1 = data = address + 0
# word2 = left = address + 4
# word3 = right = address + 8


.text
##### NEW_NODE #####
new_node:	
		# new_node(data):
		# malloc is always 12 bytes
		# data = a0
		
		move	$t0, $a0	# store data to a temporary variable
		
		li	$a0, 12		# allocate specific number of bytes
		li	$v0, 9 		# sbrk in MIPS
		syscall			# ret
		
		sw	$t0, 0($v0)	# ret->data = data
		sw	$zero, 4($v0)	# ret->left = NULL
		sw	$zero, 8($v0)	# ret->right = NULL
		
		jr	$ra		# return ret

				
##### LINK #####
link:
		# link(parent, left, right)
		# parent = a0
		# left = a1
		# right = a2
		
		sw	$a1, 4($a0)
		sw	$a2, 8($a0)
		jr	$ra


##### DEPTH #####
depth:		
		# depth(root)
		# root = a0

		# PREAMBLE
		subi	$sp, $sp, 32
		sw	$ra, 28($sp)
		sw	$s0, 24($sp)	# ROOT
		sw	$s1, 20($sp)	# LEFT
		sw	$s2, 16($sp)	# RIGHT
		
		# BASE CASE (root == NULL)
		bnez	$a0, recurse_depth
		li	$v0, -1		# Returns -1 if NULL
		j	end_depth
recurse_depth:
		# left = depth(root->left);
		move	$s0, $a0	# Store copy of root address to s0 since this will be used again for right
		lw	$a0, 4($a0)	# root->left
		jal	depth		
		move	$s1, $v0	# left = depth(root->left)
		
		# right = depth(root->right);
		move	$a0, $s0	# Get root address copy from $s0
		lw	$a0, 8($a0)	# root->right
		jal	depth
		move	$s2, $v0	# right = depth(root->right);
		
		#  1 + (left > right ? left : right)
		bge	$s1, $s2, left
		addi	$v0, $s2, 1	# return right + 1
		j	end_depth
left:		addi	$v0, $s1, 1	# return left + 1	
end_depth:	lw	$s2, 16($sp)
		lw	$s1, 20($sp)
		lw	$s0, 24($sp)
		lw	$ra, 28($sp)
		addi	$sp, $sp, 32
		jr	$ra


##### EVEN_LEVEL_MAX #####
even_level_max:		
		# even_level_max(Node *root, int level)
		# root = a0
		# level = a1
		
		# PREAMBLE
		subi	$sp, $sp, 32
		sw	$ra, 28($sp)	# return address
		sw	$s0, 24($sp)	# root
		sw	$s1, 20($sp)	# left
		sw	$s2, 16($sp)	# right
		sw	$s3, 12($sp)	# level
		
		# BASE CASE (root == NULL)
		bnez	$a0, recurse_even
		li	$v0, 0x80000000	# return 0x80000000
		j	else_even		
recurse_even:
		# left = even_level_max(root->left, level + 1);
		move	$s0, $a0	# Store copy of root address to s0 since this will be used again for right
		move	$s3, $a1	# Store copy of level to s3 since this will be used again for right
		lw	$a0, 4($a0)	# root->left
		addi	$a1, $a1, 1	# level + 1
		jal	even_level_max
		move	$s1, $v0	# LEFT
		
		# right = even_level_max(root->right, level + 1);
		move	$a0, $s0	# Get root address copy from $s0
		move	$a1, $s3	# Get level copy from $s3
		lw	$a0, 8($a0)	# root->right
		addi	$a1, $a1, 1	# level + 1
		jal	even_level_max
		move	$s2, $v0	# RIGHT
		
		# greater = (left > right) ? left : right;
		bge	$s1, $s2, left_even
		move	$v0, $s2	# greater = right
		j	end_even
		
left_even:	move	$v0, $s1	# greater = left
end_even:	
		li	$t0, 2
		div	$t1, $s3, $t0
		mfhi	$t2		
		bnez	$t2, else_even	# level % 2 == 0 | else return greater
		lw	$t1, 0($s0)	# root->data
		bge	$v0, $t1, else_even	# # else return greater
		move	$v0, $t1	# return root->data					
else_even:	
		lw	$ra, 28($sp)	# return address
		lw	$s0, 24($sp)	# root
		lw	$s1, 20($sp)	# left
		lw	$s2, 16($sp)	# right
		lw	$s3, 12($sp)	# level
		addi	$sp, $sp, 32
		jr	$ra

