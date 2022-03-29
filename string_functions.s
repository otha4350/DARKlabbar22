##############################################################################
#
#  KURS: 1DT038 2018.  Computer Architecture
#	
# DATUM:
#
#  NAMN:			
#
#  NAMN:
#
##############################################################################

	.data
	
ARRAY_SIZE:
	.word	10	# Change here to try other values (less than 10)
FIBONACCI_ARRAY:
	.word	1, 1, 2, 3, 5, 8, 13, 21, 34, 55
STR_str:
	.asciiz "abcd"
	#.asciiz ""

	.globl DBG
	.text

##############################################################################
#
# DESCRIPTION:  For an array of integers, returns the total sum of all
#		elements in the array.
#
# INPUT:        $a0 - address to first integer in array.
#		$a1 - size of array, i.e., numbers of integers in the array.
#
# OUTPUT:       $v0 - the total sum of all integers in the array.
#
##############################################################################
integer_array_sum:  

DBG:	##### DEBUGG BREAKPOINT ######

        addi    $v0, $zero, 0           # Initialize Sum to zero.
	add	$t0, $zero, $zero	# Initialize array index i to zero.
	
for_all_in_array:

	#### Append a MIPS-instruktion before each of these comments
	
	beq $t0, $a1, end_for_all# Done if i == N
	sll	$t1, $t0, 2  # 4*i
	add $t1, $a0, $t1# address = ARRAY + 4*i
	lw	$t1, 0($t1)	# n = A[i]
    add $v0 $v0 $t1   	# Sum = Sum + n
    addi $t0 $t0 1    # i++ 
  	j for_all_in_array# next element
	
end_for_all:
	
	jr	$ra			# Return to caller.
	
##############################################################################
#
# DESCRIPTION: Gives the length of a string.
#
#       INPUT: $a0 - address to a NUL terminated string.
#
#      OUTPUT: $v0 - length of the string (NUL excluded).
#
#    EXAMPLE:  string_length("abcdef") == 6.
#
##############################################################################	
string_length:

	#### Write your solution here ####
	add $v0 $zero $zero #initialize i to 0

for_string_length:
	lb $t1 0($a0) #load letter to t1
	beq $zero $t1 end_string_length #if letter = 0 then done
	addi $v0 $v0 1 #increment index by 1
	addi $a0 $a0 1 #increment address by 1 byte
	j for_string_length #next letter

end_string_length:
	jr	$ra
	
##############################################################################
#
#  DESCRIPTION: For each of the characters in a string (from left to right),
#		call a callback subroutine.
#
#		The callback suboutine will be called with the address of
#	        the character as the input parameter ($a0).
#	
#        INPUT: $a0 - address to a NUL terminated string.
#
#		$a1 - address to a callback subroutine.
#
##############################################################################	
string_for_each:

	addi	$sp, $sp, -4		# PUSH return address to caller
	sw	$ra, 0($sp)

	#### Write your solution here ####
for_string_for_each:
	lb $t1 0($a0) #load letter to t1
	beq $zero $t1 end_string_for_each #if letter = 0 then done

	addi	$sp, $sp, -4		# PUSH a0 address to stack
	sw	$a0, 0($sp)
	jal $a1			# jump  and save position to $ra
	lw	$a0, 0($sp)		# Pop a0 
	addi	$sp, $sp, 4		

	addi $a0 $a0 1 #increment address by 1 byte
	j for_string_for_each #next letter


end_string_for_each:

	lw	$ra, 0($sp)		# Pop return address to caller
	addi	$sp, $sp, 4		

	jr	$ra

##############################################################################
#
#  DESCRIPTION: Transforms a lower case character [a-z] to upper case [A-Z].
#	
#        INPUT: $a0 - address of a character 
#
##############################################################################		
to_upper:

	#### Write your solution here ####
    lb $t0 0($a0) #load letter to t0
	addi $t1 $zero 0x61 #initialize t1 to 0x61 (ascii 'a')
	blt		$t0, $t1, exit_to_upper	# if letter < 'a' then exit
	addi	$t0, $t0, -0x20			# $t0 = letter but uppercase

	
exit_to_upper:
	jr	$ra

#####################################################################
#
#	DESCRIPTION: Reverses a string
#
#		INPUT: $a0 - Address to a NUL-terminated string
#

#####################################################################

reverse_string:
	addi	$sp, $sp, -8		# PUSH return address to caller
	sw	$ra, 4($sp) #save return address
	sw  $a0 0($sp) #save a0
	
	jal string_length
	add $a1 $v0 $zero

	lw $a0 0($sp)
	addi $sp $sp 4

	add $t0 $zero $zero

for_reverse_string:
	sub $t1 $a1 $t0 #t1 = length - i 
	addi $t1 $t1 -1
	blt $t1 $t0 end_for_reverse_string #if (length - i) < i then done
	

	add $t2 $a0 $t0 #t2 = address to first char
	add $t3 $a0 $t1 #t3 = address to second char
	
	lb	$t4, 0($t2) #t4 = first char
	lb  $t5, 0($t3) #t5 = second char

	sb		$t4, 0($t3) #save first char to second char's address 
	sb		$t5, 0($t2)	#save second char to first char's address 
	
	addi $t0 $t0 1

	j for_reverse_string

end_for_reverse_string:

	lw	$ra, 0($sp)		# Pop return address to caller
	addi	$sp, $sp, 4	

	jr $ra

##############################################################################
#
# Strings used by main:
#
##############################################################################

	.data

NLNL:	.asciiz "\n\n"
	
STR_sum_of_fibonacci_a:	
	.asciiz "The sum of the " 
STR_sum_of_fibonacci_b:
	.asciiz " first Fibonacci numbers is " 

STR_string_length:
	.asciiz	"\n\nstring_length(str) = "

STR_for_each_ascii:	
	.asciiz "\n\nstring_for_each(str, ascii)\n"

STR_for_each_to_upper:
	.asciiz "\n\nstring_for_each(str, to_upper)\n\n"	

STR_string_reverse:
	.asciiz "\n\nstring_reverse(str)\n\n"

	.text
	.globl main

##############################################################################
#
# MAIN: Main calls various subroutines and print out results.
#
##############################################################################	
main:
	addi	$sp, $sp, -4	# PUSH return address
	sw	$ra, 0($sp)

	##
	### integer_array_sum
	##
	
	li	$v0, 4
	la	$a0, STR_sum_of_fibonacci_a
	syscall

	lw 	$a0, ARRAY_SIZE
	li	$v0, 1
	syscall

	li	$v0, 4
	la	$a0, STR_sum_of_fibonacci_b
	syscall
	
	la	$a0, FIBONACCI_ARRAY
	lw	$a1, ARRAY_SIZE
	jal 	integer_array_sum

	# Print sum
	add	$a0, $v0, $zero
	li	$v0, 1
	syscall

	li	$v0, 4
	la	$a0, NLNL
	syscall
	
	la	$a0, STR_str
	jal	print_test_string

	##
	### string_length 
	##
	
	li	$v0, 4
	la	$a0, STR_string_length
	syscall

	la	$a0, STR_str
	jal 	string_length

	add	$a0, $v0, $zero
	li	$v0, 1
	syscall

	##
	### string_for_each(string, ascii)
	##
	
	li	$v0, 4
	la	$a0, STR_for_each_ascii
	syscall
	
	la	$a0, STR_str
	la	$a1, ascii
	jal	string_for_each

	##
	### string_for_each(string, to_upper)
	##
	
	li	$v0, 4
	la	$a0, STR_for_each_to_upper
	syscall

	la	$a0, STR_str
	la	$a1, to_upper
	jal	string_for_each
	
	la	$a0, STR_str
	jal	print_test_string
	
	##
	### string_reverse(str)
	##

	li	$v0, 4
	la	$a0, STR_string_reverse
	syscall

	la $a0 STR_str
	jal reverse_string

	la $a0 STR_str
	jal print_test_string

	lw	$ra, 0($sp)	# POP return address
	addi	$sp, $sp, 4	
	
	# comment this line for mars
	jr	$ra

	# uncomment the next two lines for mars
	# li $v0, 10
    # syscall

##############################################################################
#
#  DESCRIPTION : Prints out 'str = ' followed by the input string surronded
#		 by double quotes to the console. 
#
#        INPUT: $a0 - address to a NUL terminated string.
#
##############################################################################
print_test_string:	

	.data
STR_str_is:
	.asciiz "str = \""
STR_quote:
	.asciiz "\""	

	.text

	add	$t0, $a0, $zero
	
	li	$v0, 4
	la	$a0, STR_str_is
	syscall

	add	$a0, $t0, $zero
	syscall

	li	$v0, 4	
	la	$a0, STR_quote
	syscall
	
	jr	$ra
	

##############################################################################
#
#  DESCRIPTION: Prints out the Ascii value of a character.
#	
#        INPUT: $a0 - address of a character 
#
##############################################################################
ascii:	
	.data
STR_the_ascii_value_is:
	.asciiz "\nAscii('X') = "

	.text

	la	$t0, STR_the_ascii_value_is

	# Replace X with the input character
	
	add	$t1, $t0, 8	# Position of X
	lb	$t2, 0($a0)	# Get the Ascii value
	sb	$t2, 0($t1)

	# Print "The Ascii value of..."
	
	add	$a0, $t0, $zero 
	li	$v0, 4
	syscall

	# Append the Ascii value
	
	add	$a0, $t2, $zero
	li	$v0, 1
	syscall


	jr	$ra
	
