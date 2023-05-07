# FOR TESTING ONLY DO NOT SUBMIT THIS !!!

###### MACROS ######
.macro get_node(%idx)
	# If NULL return 0
	bne	$zero, %idx, gn_next
	move	$v0, $zero
	j	gn_done
	
	# Else get address
	gn_next:
	li	$t0, %idx
	sll	$t0, $t0, 2		# Shifting to get node from word
	lw	$v0, array($t0)		# Getting the nodes from array and returning its address
	
	gn_done:
.end_macro

.macro create_new_node(%val %idx)
	# Make Node
	li	$a0, %val
	jal	new_node		# Create new node using new_node()
	
	# Save Node Address to Array for easy accessing
	li	$t0, %idx
	sll	$t0, $t0, 2		# Shifting to save nodes in 1 word
	sw	$v0, array($t0)		# Storing nodes into array
.end_macro

.macro link_node(%parent, %left, %right)
	get_node(%parent)		# Get address of parent
	move	$a0, $v0
	get_node(%left)			# Get address of left node
	move	$a1, $v0
	get_node(%right)		# Get address of right node
	move	$a2, $v0
	jal	link			# Creating the links between nodes using link()
.end_macro

.macro print_depth(%root)
	.data
	d1:	.asciiz "\nDepth: "	# For aesthetics
	
	.text
	get_node(%root)			# Get root address
	move	$a0, $v0
	jal	depth			# Get depth of tree using depth()
	move	$t0, $v0		# copy v0 to t0 since v0 will be used for syscall
	
	la	$a0, d1			# print string
	li	$v0, 4
	syscall
	
	move	$a0, $t0		# print depth
	li	$v0, 1
	syscall
.end_macro

.macro print_even(%root, %level)
	.data
	e1:	.asciiz "\neven_max: "	# For aesthetics only
	
	.text
	get_node(%root)			# Get root address
	move	$a0, $v0
	li	$a1, %level		
	jal	even_level_max		# Get even_level_max using even_level_max()
	move	$t0, $v0
	
	la	$a0, e1			# Print string
	li	$v0, 4
	syscall
	
	move	$a0, $t0		# Print even_level max
	li	$v0, 1
	syscall
.end_macro

.data
array:	.space 400	# Allocates 400 bytes for nodes. 10 nodes with 4 bytes (1 word) each

.text
.eqv	NULL 0
.eqv	_a 1
.eqv	_b 2
.eqv	_c 3
.eqv	_d 4
.eqv	_e 5
.eqv	_f 6
.eqv	_g 7
.eqv	_h 8
.eqv	_i 9
.eqv	_j 10

main:		
		create_new_node(3,_a)
create_new_node(4,_b)
create_new_node(5,_c)
create_new_node(1,_d)
create_new_node(8,_e)
create_new_node(2,_f)
create_new_node(7,_g)
create_new_node(6,_h)
link_node(_a,_b,_c)
link_node(_b,_d,_e)
link_node(_c,_f, NULL)
link_node(_d,NULL,_g)
link_node(_f,NULL, _h)
link_node(_g,NULL, NULL)
link_node(_h,NULL, NULL)

		print_depth(_a)
		print_even(_a,0)
	
		li	$v0, 10
		syscall
	

##### YOUR CODE HERE #####
