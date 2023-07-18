# Eric Grunblatt
# egrunblatt
# 112613770

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################

############################## Do not .include any files! #############################

.text
strlen:
    	li $t0, 0					# $t0 = 0, counter
	str_len_loop:
		lbu $t1, 0($a0)				# loads first character into $a1
		beq $t1, $0, end_str_len_loop		# $a1 = 0, end loop
		addi $a0, $a0, 1			# $a0 = $a0 + 1
		addi $t0, $t0, 1			# counter adds 1
		j str_len_loop				# jump to top of loop
	end_str_len_loop:
	move $v0, $t0					# moves length to $v0
	jr $ra						# returns to main
   
index_of:
	li $a3, 0					# $a3 = 0, counter
	blt $a2, $a3, print_neg_1			# index < 0, print -1
	index_of_loop:					
		lbu $t0, 0($a0)				# $t0 = current character
		addi $a3, $a3, 1			# counter adds 1
		addi $a0, $a0, 1			# $a0 = $a0 + 1 
		blt $a3, $a2, index_of_loop		# counter < start index, restart
		beq $t0, $a1, end_index_of_loop		# $t0 = $a1, exit loop
		beq $t0, $0, print_neg_1		# $t0 = 0, print -1
		j index_of_loop				# jump to top of loop
		print_neg_1:
			li $v0, -1			# gets ready to print integer
			jr $ra				# jumps to end of code
	end_index_of_loop:
	addi $a3, $a3, -1				# counter subtracts one for the extra one added
	blt $a3, $a2, print_neg_1			# new index smaller than start index, print -1
	move $v0, $a3					# move new index to $v0
    	jr $ra						# returns to main

to_lowercase:
	li $a2, 65					# $a2 = 65, lower bound of uppercase letters
	li $a3, 90					# $a3 = 90, upper bound of uppercase letters
	li $t0, 0					# $t0 = 0, counter
	to_lowercase_loop:
		lbu $a1, 0($a0)				# $a1 = character in current position
		addi $a0, $a0, 1			# $a0 adds 1 to move 1 position to the right
		beq $a1, $0, end_to_lowercase_loop	# $a1 = 0x0000000, end loop
		blt $a1, $a2, to_lowercase_loop		# $a1 < 65, jump to top of loop
		bgt $a1, $a3, to_lowercase_loop		# $a1 > 90, jump to top of loop
		addi $t0, $t0, 1			# counter adds 1
		addi $a1, $a1, 32			# adds 32 to captial letter to make lowercase
		sb $a1, -1($a0)				# stores $a1 into current position in $a0
		j to_lowercase_loop			# jump to top of loop
	end_to_lowercase_loop:
	move $v0, $t0					# move number of uppercase letters changed to $v0
   	jr $ra						# returns to main

generate_ciphertext_alphabet:
	addi $sp, $sp, -4				# allocate 4 bytes of space
	sw $t7, 0($sp)					# store $t7
	sw $t8, 4($sp)					# store $t8
	move $t7, $a0					# ciphertext alphabet
	move $t8, $a1					# keyphrase
	
	lbu $t0, 0($a1)					# $t0 = first character of keyphrase
	sb $t0, 0($a0)					# first position of $a0 = $t0
	li $a2, 1					# $a2 = 1, stack counter
	li $t3, 32					# $t3 = space
	
	ciphertext_loop:
		addi $a1, $a1, 1				# move 1 position to the right ($a1)
		lbu $t0, 0($a1)					# $t0 = first character of keyphrase
		beq $t0, $0, end_ciphertext_loop		# $t0 = 0x00000000, end loop
		
		beq $t0, $t3, ciphertext_loop			# $t0 = space, jump to top of loop
		li $t4, 48					# $t4 = 48
		blt $t0, $t4, ciphertext_loop			# $t0 < 48, go to ciphertext_loop
		li $t4, 122					# $t4 = 122
		bgt $t0, $t4, ciphertext_loop			# $t0 > 122, go to ciphertext_loop
		li $t4, 65					# $t4 = 65
		blt $t0, $t4, check_57				# $t0 < 65, go to ciphertext_loop
		li $t4, 90					# $t4 = 90
		bgt $t0, $t4, check_97				# $t0 > 90, go to ciphertext_loop
		
		j check_ciphertext_setup			# jump to check_ciphertext_setup
		check_57:
			li $t4, 57				# $t4 = 57
			bgt $t0, $t4, ciphertext_loop		# $t0 > 57, go to ciphertext_loop
			j check_ciphertext_setup		# jump to check_ciphertext_setup
		check_97:
			li $t4, 97				# $t4 = 97
			blt $t0, $t4, ciphertext_loop		# $t0 < 97, go to ciphertext_loop
			j check_ciphertext_setup		# jump to check_ciphertext_setup
			
		check_ciphertext_setup:
			move $t1, $t7				# $t1 = ciphertext_alphabet address
			li $a3, 0				# $a3 = 0, loop counter
		
		check_ciphertext_loop:
			beq $a3, $a2, end_check_ciphertext_loop	# loop counter = stack counter, exit
			lbu $t2, 0($t1)				# $t2 = current position character
			addi $a3, $a3, 1			# loop counter + 1
			addi $t1, $t1, 1			# move 1 position to the right ($t1)			
			beq $t0, $t2, ciphertext_loop		# current character = stack character, go ciphertext_loop
			j check_ciphertext_loop			# jump to check_ciphertext_loop
		end_check_ciphertext_loop:
		addi $a0, $a0, 1				# move 1 position to the right ($a0)
		sb $t0, 0($a0)					# first position of $a0 = $t0
		addi $a2, $a2, 1				# stack counter + 1
		j ciphertext_loop				# jump to ciphertext_loop
	end_ciphertext_loop:
	move $t9, $a2						# $s0 = number of unique alphanumeric characters
	
	li $t4, 96						# $t4 = 96
	li $t5, 122						# $t5 = 122
	lowercase_letter_loop:
		beq $t4, $t5, end_lowercase_letter_loop		# end loop after 26 iterations
		addi $t4, $t4, 1				# adds 1 to regular alphabet
		li $a3, 0					# $a3 = 0, loop counter
		move $t1, $t7					# $t1 = keyphrase
		check_lowercase_loop:
			beq $a3, $a2, end_check_lowercase_loop	# loop counter = stack counter, exit
			lbu $t2, 0($t1)				# $t2 = current position character
			addi $a3, $a3, 1			# loop counter + 1
			addi $t1, $t1, 1			# move 1 position to the right ($t1)			
			beq $t2, $t4, lowercase_letter_loop	# current character = stack character, go ciphertext_loop
			j check_lowercase_loop			# jump to check_ciphertext_loop
		end_check_lowercase_loop:
		addi $a0, $a0, 1				# move 1 position to the right ($a0)
		sb $t4, 0($a0)					# first position of $a0 = $t0
		addi $a2, $a2, 1				# stack counter + 1
		j lowercase_letter_loop				# jump to ciphertext_loop
	end_lowercase_letter_loop:
	
	li $t4, 64						# $t4 = 64
	li $t5, 90						# $t5 = 90
	uppercase_letter_loop:
		beq $t4, $t5, end_uppercase_letter_loop		# end loop after 26 iterations
		addi $t4, $t4, 1				# adds 1 to regular alphabet
		li $a3, 0					# $a3 = 0, loop counter
		move $t1, $t7
		check_uppercase_loop:
			beq $a3, $a2, end_check_uppercase_loop	# loop counter = stack counter, exit
			lbu $t2, 0($t1)				# $t2 = current position character
			addi $a3, $a3, 1			# loop counter + 1
			addi $t1, $t1, 1			# move 1 position to the right ($t1)			
			beq $t4, $t2, uppercase_letter_loop	# current character = stack character, go ciphertext_loop
			j check_uppercase_loop			# jump to check_ciphertext_loop
		end_check_uppercase_loop:
		addi $a0, $a0, 1				# move 1 position to the right ($a0)
		sb $t4, 0($a0)					# first position of $a0 = $t0
		addi $a2, $a2, 1				# stack counter + 1
		j uppercase_letter_loop				# jump to ciphertext_loop
	end_uppercase_letter_loop:
	
	li $t4, 47						# $t4 = 47
	li $t5, 57						# $t4 = 57
	number_loop:
		beq $t4, $t5, end_number_loop			# end loop after 26 iterations
		addi $t4, $t4, 1				# adds 1 to regular alphabet
		li $a3, 0					# $a3 = 0, loop counter
		move $t1, $t7					# $t1 = keyphrase
		check_number_loop:
			beq $a3, $a2, end_check_number_loop	# loop counter = stack counter, exit
			lbu $t2, 0($t1)				# $t2 = current position character
			addi $a3, $a3, 1			# loop counter + 1
			addi $t1, $t1, 1			# move 1 position to the right ($t1)			
			beq $t4, $t2, number_loop		# current character = stack character, go ciphertext_loop
			j check_number_loop			# jump to check_ciphertext_loop
		end_check_number_loop:
		addi $a0, $a0, 1				# move 1 position to the right ($a0)
		sb $t4, 0($a0)					# first position of $a0 = $t0
		addi $a2, $a2, 1				# stack counter + 1
		j number_loop					# jump to ciphertext_loop
	end_number_loop:
	addi $a0, $a0, 1					# move 1 position to the right ($a0)
	sb $0, 0($a0)						# last position in $a0 = null terminator
	
	move $v0, $t9						# move number of unique characters to $v0	
	lw $a2, 0($sp)						# load $a2 from stack
	addi $sp, $sp, 4					# deallocate 4 bytes
    	jr $ra							# returns to main

count_lowercase_letters:
	addi $sp, $sp, -8						# allocate 8 bytes
	sw $t4, 0($sp)							# store $t4 to stack
	sw $t5, 4($sp)							# store $t5 to stack
	move $t4, $a0							# $t4 = counts	
	move $t5, $a1							# $t5 = message
	li $a2, 97							# $a2 = 97, lower bound for lowercase
	li $a3, 122							# $a3 = 122, upper bound for lowercase
	li $t3, 0							# sum of lowercase numbers
	print_lowercase_count_loop:
		bgt $a2, $a3, end_print_lowercase_count_loop		# $a2 > "z", end loop
		li $t0, 0						# $t0 = 0, counter for occurrences of each letter
		move $a1, $t5						# $a1 = message
		count_current_letter_loop:
			lbu $t1, 0($a1)					# $t1 = current character of message
			beq $t1, $0, end_count_current_letter_loop	# $t1 = $0, end loop
			addi $a1, $a1, 1				# add 1 to message address
			bne $t1, $a2, count_current_letter_loop		# $t1 != current letter, go to top of loop
			addi $t0, $t0, 1				# add 1 to counter if it is equal
			j count_current_letter_loop			# jump to top of loop
		end_count_current_letter_loop:
		sw $t0, 0($a0)						# store counter in currrent $a0 index
		add $t3, $t3, $t0					# adds to $t0 to sum of lowercase letters
		addi $a2, $a2, 1					# adds 1 to current letter
		addi $a0, $a0, 4					# move position in counts
		j print_lowercase_count_loop				# jump to top of loop
	end_print_lowercase_count_loop:
	sw $0, 0($a0)							# null terminator
	move $v0, $t3							# $v0 = total number of lowercase letters
		
	lw $t4, 0($sp)							# load $t4
	lw $t5, 4($sp)							# load $t5
	addi $sp, $sp, 8						# deallocate 8 bytes

    	jr $ra								# returns to main

sort_alphabet_by_count:
	addi $sp, $sp, -8				# 8 bytes of space
	sw $a0, 0($sp)					# store $a0
	sw $a1, 4($sp)					# store $a1

	li $a2, 97					# $a2 = "a"
	li $a3, 122					# $a3 = "z"
	move $t3, $a0					# $t3 = sorted_alphabet
	
	set_alphabet_loop:
		bgt $a2, $a3, end_set_alphabet_loop	# $a2 > "z", end loop
		sb $a2, 0($t3)				# store current letter in current position in sorted_alphabet
		addi $t3, $t3, 1			# add 1 to address to get next position
		addi $a2, $a2, 1			# add 1 to current letter
		j set_alphabet_loop			# jump to top of loop
	end_set_alphabet_loop:
	sb $0, 0($t3)					# store null terminator at the end of sorted_alphabet
	
	li $a2, 0					# $a2 = outerloop counter
	li $a3, 26					# $a3 = outerloop upper bound
	sorted_alphabet_loop:
		bgt $a2, $a3, end_sorted_alphabet_loop	# $a2 > 122, end loop
		li $t0, -1				# $t0 = starting letter in inner loop
		li $t1, -1				# $t1 = temporary max letter for inner loop
		li $t2, -1				# $t2 = temporary max for inner loop
		move $t3, $a0 	 			# $t3 = sorted alphabet
		move $t4, $a1				# $t4 = counts	
		li $t5, 0				# $t5 = temporary max index
		find_max_loop:
			lbu $t6, 0($t3)			# $t6 = current element for sorted alphabet
			addi $t3, $t3, 1		# temporary sorted alphabet + 1
			lw $t7, 0($t4)			# $t7 = current element for counts
			addi $t4, $t4, 4		# temporary counts + 1
			addi $t0, $t0, 1		# adds to index
			beq $t6, $0, end_find_max_loop	# $t6 = $0, end loop
			bgt $t2, $t7, find_max_loop	# $t2 > current character, jump to top
			beq $t2, $t7, check_ascii	
			move $t5, $t0			# $t5 = max number index
			move $t1, $t6			# $t1 = max number letter
			move $t2, $t7			# $t2 = max number
			j find_max_loop			# jump to top
			check_ascii:
				ble $t1, $t6, find_max_loop
				move $t5, $t0			# $t5 = max number index
				move $t1, $t6			# $t1 = max number letter
				move $t2, $t7			# $t2 = max number
				j find_max_loop			# jump to top
				
		end_find_max_loop:
		move $t3, $a0 	 			# $t3 = sorted alphabet
		move $t4, $a1				# $t4 = counts	
		swap_letter:
			add $t3, $t3, $t5		# add max number index to sorted_alphabet
			li $t6, 4			# $t6 = 4
			mul $t5, $t5, $t6		# $t5 * 4
			add $t4, $t4, $t5		# add max number index to counts
			lbu $t6, 0($t3)			# $t6 = current element for sorted alphabet
			lw $t7, 0($t4)			# $t7 = current element for counts
			
			lbu $t8, 0($a0)			# $t8 = max letter
			lw $t9, 0($a1)			# $t9 = max number
			sb $t8, 0($t3)			# store $t8 in front in sorted_alphabet
			sw $t9, 0($t4)			# store $t9 in front in counts
			sb $t6, 0($a0)			# store $t6 in max spot in sorted_alphabet
			sw $0, 0($a1)			# store $t7 in max spot in counts
				
		addi $a0, $a0, 1			# add 1 to position in sorted_alphabet
		addi $a1, $a1, 4			# add 4 to posisiton in counts
		addi $a2, $a2, 1			# add 1 to loop number
		j sorted_alphabet_loop			# jump to top of loop
	end_sorted_alphabet_loop:			
																			
	lw $a0, 0($sp)					# load $a0
	lw $a1, 4($sp)					# load $a1
	addi $sp, $sp, 8				# deallocate 8 bytes
    	jr $ra						# returns to main

generate_plaintext_alphabet:
	addi $sp, $sp, -8					# allocate 8 bytes
	sw $a0, 0($sp)						# store $a0
	sw $a1, 4($sp)						# store $a1
	li $a2, 9						# $a2 = 0, counter for number of repeated letters
	li $t1, 1						# min for letter occurrences in plaintext_alphabet
	move $t9, $a0						# $t9 = plaintext
	letter_count_loop:
		lbu $a3, 0($a1)					# $a3 = current letter in sorted alphabet
		beq $a3, $0, end_letter_count_loop		# $a3 = 0, counts up to repeated counter
		li $t0, 0					# $t0 = 0, occurrence counter
		enter_letter_loop:
			beq $a2, $t0, end_enter_letter_loop	# $a2 = 0, end loop
			sb $a3, 0($a0)				# store $a3 in current position in plaintext_alphabet
			addi $a0, $a0, 1			# add 1 to position of plaintext_alphabet
			addi $t0, $t0, 1			# add 1 to occurrence counter
			j enter_letter_loop			# jump to top of loop
		end_enter_letter_loop:
		addi $a1, $a1, 1				# add 1 to position of sorted_alphabet
		beq $a2, $t1, letter_count_loop			# $a2 = 1, jump to top of loop
		addi $a2, $a2, -1				# subtract 1 from max occurrence
		j letter_count_loop				# jump to top of loop
	end_letter_count_loop:
	sb $0, 0($a0)						# store $0 at the end of plaintext_alphabet
	
	move $a0, $t9						# $a0 = plaintext_alphabet
	sort_plaintext_loop:
		lbu $a1, 0($a0)				# $a1 = current first letter
		beq $a1, $0, end_sort_plaintext_loop	# $a1 = $0, end loop
		move $a2, $a0 	 			# $a2 = temporary plaintext alphabet
		li $t0, 123				# $t0 = temporary min 
		li $t1, -1				# $t1 = temporary min index
		find_min_loop:
			lbu $t2, 0($a2)			# $t2 = current letter for sorted alphabet
			addi $a2, $a2, 1		# $a2 = temporary plaintext alphabet + 1
			addi $t1, $t1, 1		# adds to index
			beq $t2, $0, end_find_min_loop	# $t2 = $0, end loop
			ble $t0, $t2, find_min_loop	# $t0 < current letter, jump to top
			move $t0, $t2			# $t0 = min
			move $t3, $t1			# $t3 = min index
			j find_min_loop			# jump to top
		end_find_min_loop:
		move $a2, $a0 	 			# $a2 = plaintext alphabet
		swap_plaintext:
			add $a2, $a2, $t3		# $a2 = address + index
			lbu $t4, 0($a2)			# $t4 = temporary min for plaintext alphabet
			sb $a1, 0($a2)			# store first letter in temporary min position
			sb $t4, 0($a0)			# store temporary min where first element was
		addi $a0, $a0, 1			# add 1 to position of plaintext_alphabet
		j sort_plaintext_loop			# jump to top of loop
	end_sort_plaintext_loop:
	
	lw $a0, 0($sp)					# load $a0
	lw $a1, 4($sp)					# load $a1
	addi $sp, $sp, 8				# deallocate 8 bytes
   	jr $ra						# returns to main

encrypt_letter:
	addi $sp, $sp, -4			# allocate 4 bytes
	sw $a0, 0($sp)				# store $a0
	li $t0, 97				# $t0 = first lowercase letter
	li $t1, 122				# $t1 = last lowercase letter
	blt $a0, $t0, encrypt_print_neg_1	# less than first lowercase letter, print -1
	bgt $a0, $t1, encrypt_print_neg_1 	# greater than last lowercase letter, print -1
	j encrypt_index_setup			# jump to encrypt_index_setup
	
	encrypt_print_neg_1:
		li $v0, -1			# gets ready to print integer
		jr $ra				# returns to main
	
	encrypt_index_setup:
	li $t0, 0					# $t0 = 0, index of first plaintext_letter
	encrypt_index_loop:
		lbu $t1, 0($a2)				# $t1 = current character of plaintext_alphabet
		beq $t1, $a0, end_encrypt_index_loop	# $t1 = plaintext_letter, end loop
		addi $t0, $t0, 1			# add 1 to index counter
		addi $a2, $a2, 1			# add 1 to address of plaintext_alphabet
		j encrypt_index_loop			# jump to top of loop
	end_encrypt_index_loop:
	
	li $t2, 0						# $s1 = number of occurrences
	number_of_occurrences_loop:
		lbu $t3, 0($a2)					# $t0 = current occurrence of plaintext_letter
		bne $t3, $a0, end_number_of_occurrences_loop	# $t0 != plaintext_letter, end loop
		addi $t2, $t2, 1				# add 1 to occurrence counter
		addi $a2, $a2, 1				# add 1 to address of plaintext_alphabet
		j number_of_occurrences_loop			# jump to top of loop 
	end_number_of_occurrences_loop: 
	div $a1, $t2						# divide letter_index by number of occurrences
	mfhi $t3						# $s2 = remainder of previous division
	add $t6, $t0, $t3					# add remainder to $s0
	
	
	li $t4, 0						# $t0 = counter
	encrypt_letter_loop:
		lbu $t5, 0($a3)					# $t5 = current character in ciphertext_alphabet
		beq $t4, $t6, end_encrypt_letter_loop		# $t4 = target index, end loop
		addi $t4, $t4, 1				# add 1 to counter
		addi $a3, $a3, 1				# add 1 to address of ciphertext_alphabet
		j encrypt_letter_loop				# jump to top of loop
	end_encrypt_letter_loop:

	lw $a0, 0($sp)						# load $a0
	addi $sp, $sp, 4					# deallocate 4 bytes
	move $v0, $t5						# $v0 = ascii value
	jr $ra							# returns to main

encrypt:
	addi $sp, $sp, -36
	sw $s0, 0($sp)					# $s0 = ciphertext address
	sw $s1, 4($sp)					# $s1 = plaintext address
	sw $s2, 8($sp)					# $s2 = keyphrase address
	sw $s3, 12($sp)					# $s3 = corpus address	
	sw $s4, 16($sp)					# $s4 = counts
	sw $s5, 20($sp)					# $s5 = sorted alphabet
	sw $s6, 24($sp)					# $s6 = plaintext alphabet
	sw $s7, 28($sp)					# $s7 = ciphertext alphabet
	sw $ra, 32($sp)					# $ra = main return address
	move $s0, $a0					# $s0 = $a0
	move $s1, $a1					# $s1 = $a1
	move $s2, $a2					# $s2 = $a2
	move $s3, $a3					# $s3 = $a3
	
	lbu $t0, 0($s1)					# check for no string
	beq $t0, $0, end_encrypt			# exit
	
	lbu $t0, 0($s2)					# check for no string
	beq $t0, $0, end_encrypt			# exit
	
	lbu $t0, 0($s3)					# check for no string
	beq $t0, $0, end_encrypt			# exit
							
			
	en_step_1:
		move $a0, $s1					# $a0 = plaintext address
		jal to_lowercase				# jump and link to_lowercaase	
		
		move $a0, $s3					# $a0 = corpus address	
		jal to_lowercase				# jump and link to_lowercase					

	# creating the counts address
	en_step_2:
		addi $sp, $sp, -104				# 104 bytes of space
		move $s4, $sp					# $s4 = counts
		move $t0, $s4					# $t0 = 104 bytes of space
		li $t1, 0					# $t1 = counter
		li $t2, 26					# $t2 = boundary
		li $t3, 10					# $t3 = random value
		create_count_loop:			
			beq $t1, $t2, end_create_count_loop	# counter reaches boundary, end loop
			sb $t3, 0($t0)				# store random value
			addi $t0, $t0, 4			# change position
			addi $t1, $t1, 1			# add to counter
			j create_count_loop			# jump to top
		end_create_count_loop:
		sb $0, 0($t0)					# store null terminator
		
	# creating the sorted alphabet address	
	en_step_4:
		addi $sp, $sp, -28				# 28 bytes of space
		move $s5, $sp					# $s6 = alphabet address
		move $t0, $s5					# $a0 = alphabet
		li $t1, 0					# $t1 = counter
		li $t2, 26					# $t2 = boundary
		li $t3, 97					# $t3 = random value
		create_alph_loop:
			beq $t1, $t2, end_create_alph_loop	# $t0 = 26, end loop
			sb $t3, 0($t0)				# all inputs are a's, will be changed when calling sort alphabet
			addi $t0, $t0, 1			# moves 1 position in $a0
			addi $t1, $t1, 1			# adds 1 to counter
			addi $t3, $t3, 1			# adds 1 to current letter
			j create_alph_loop			# jumps to top of loop
		end_create_alph_loop:
		sb $0, 0($t0)					# null terminator
	
	en_step_6:
		addi $sp, $sp, -64				# allocate 64 bytes of space
		move $s6, $sp					# $s6 = 64 bytes of space
		move $t0, $s6					# $t0 = $s6
		li $t1, 0					# $t1 = counter
		li $t2, 62					# $t2 = boundary
		li $t3, 97					# $t3 = random value
		create_plain_loop:
			beq $t1, $t2, end_create_plain_loop	# counter = boundary, end loop
			sb $t3, 0($t0)				# store random value
			addi $t1, $t1, 1			# add to counter
			addi $t0, $t0, 1			# next position
			j create_plain_loop			# jump to top of loop
		end_create_plain_loop:
		sb $0, 0($t0)					# null terminator
				
	en_step_8:
		addi $sp, $sp, -64				# allocate 64 bytes of space
		move $s7, $sp					# $s6 = 64 bytes of space
		move $t0, $s7					# $a0 = alphabet
		li $t1, 0					# $t1 = counter
		li $t2, 62					# $t2 = boundary
		li $t3, 97					# $t3 = random value
		create_cipher_loop:
			beq $t1, $t2, end_create_cipher_loop	# counter = boundary, end loop
			sb $t3, 0($t0)				# store random value
			addi $t1, $t1, 1			# add to counter
			addi $t0, $t0, 1			# next position
			j create_cipher_loop			# jump to top of loop
		end_create_cipher_loop:
		sb $0, 0($t0)					# null terminator
		
	en_step_3:
		move $a0, $s4					# $s4 = counts
		move $a1, $s3					# $a1 = corpus address
		jal count_lowercase_letters			# jump and link count_lowercase_letters	
					
			
	en_step_5:
		move $a0, $s5					# $s5 = sorted alphabet
		move $a1, $s4					# $s4 = counts
		jal sort_alphabet_by_count		
												
	
	en_step_7:
		move $a0, $s6					# $s1 = plaintext alphabet
		move $a1, $s5					# $s5 = sorted alphabet
		jal generate_plaintext_alphabet
		
	en_step_9:
		move $a0, $s7					# $s7 = ciphertext_alphabet
		move $a1, $s2					# $s2 = keyphrase
		jal generate_ciphertext_alphabet						
		
	en_step_10:	
		li $s3, 0				# lowercase letters encrypted
		li $s4, 0				# other characters encrypted
		li $s5, 0				# $s5 = index
		move $s2, $s0
		en_step_10_loop:
			li $t4, 97				# $t4 = "a"
			li $t5, 122				# $t5 = "z"
			lbu $t6, 0($s1)				# $t6 = current plaintext letter	
			beq $t6, $0, end_en_step_10_loop	# end of plaintext, end loop
			blt $t6, $t4, print_original_char 	# $t1 < 97, put character in ciphertext
			bgt $t6, $t5, print_original_char	# $t1 > 122, put character in ciphertext
			
			move $a0, $t6				# plaintext letter
			move $a1, $s5				# index
			move $a2, $s6				# $a2 = plaintext_alphabet
			move $a3, $s7				# $a3 = ciphertext_alphabet
			jal encrypt_letter			# jump and link encrypt_letter
			
			sb $v0, 0($s2)				# $s3 = character
			addi $s2, $s2, 1			# move ciphertext position 
			addi $s3, $s3, 1			# add to alphanumeric counter
			addi $s5, $s5, 1			# add to index
			addi $s1, $s1, 1			# move plaintext position
			j en_step_10_loop			# jump to top of loop
			
			print_original_char:
				sb $t6, 0($s2)			# store character
				addi $s2, $s2, 1		# move ciphertext position
				addi $s4, $s4, 1		# add to other character counter
				addi $s5, $s5, 1		# add to index
				addi $s1, $s1, 1		# move plaintext position
				j en_step_10_loop		# jump to top of loop
		end_en_step_10_loop:
		
	en_step_11:
		sb $0, 0($s2)					# null terminator
	
		move $v0, $s3					# $v0 = lowercase sum
		move $v1, $s4					# $v1 = other character sum
		
	addi $sp, $sp, 104				# deallocate 104 bytes of space	
	addi $sp, $sp, 28				# deallocate 28 bytes	
	addi $sp, $sp, 64				# deallocate 64 bytes
	addi $sp, $sp, 64				# deallocate 64 bytes
	lw $s0, 0($sp)					# $a0 = ciphertext
	lw $s1, 4($sp)					# $a1 = plaintext
	lw $s2, 8($sp)					# $a2 = keyphrase
	lw $s3, 12($sp)					# $a3 = corpus
	lw $s4, 16($sp)					# $s4 = counts
	lw $s5, 20($sp)					# $s5 = sorted alphabet
	lw $s6, 24($sp)					# $s6 = plaintext alphabet
	lw $s7, 28($sp)					# $s7 = ciphertext alphabet
	lw $ra, 32($sp)					# $ra = main return address
	addi $sp, $sp, 36				# deallocate 36 bytes
	
	end_encrypt:	
    	jr $ra						# returns to main

decrypt:
	addi $sp, $sp, -36
	sw $s0, 0($sp)					# $s0 = plaintext address
	sw $s1, 4($sp)					# $s1 = ciphertext address
	sw $s2, 8($sp)					# $s2 = keyphrase address
	sw $s3, 12($sp)					# $s3 = corpus address	
	sw $s4, 16($sp)					# $s4 = counts
	sw $s5, 20($sp)					# $s5 = sorted alphabet
	sw $s6, 24($sp)					# $s6 = plaintext alphabet
	sw $s7, 28($sp)					# $s7 = ciphertext alphabet
	sw $ra, 32($sp)					# $ra = main return address
	move $s0, $a0					# $s0 = $a0
	move $s1, $a1					# $s1 = $a1
	move $s2, $a2					# $s2 = $a2
	move $s3, $a3					# $s3 = $a3
		
	lbu $t0, 0($s1)					# check for no string
	beq $t0, $0, end_decrypt			# exit
	
	lbu $t0, 0($s2)					# check for no string
	beq $t0, $0, end_decrypt			# exit
	
	lbu $t0, 0($s3)					# check for no string
	beq $t0, $0, end_decrypt			# exit
								
	de_step_1:
		move $a0, $s3					# $a0 = corpus address	
		jal to_lowercase				# jump and link to_lowercase					

	# creating the counts address
	de_step_2:
		addi $sp, $sp, -104				# 104 bits of space
		move $s4, $sp					# $s4 = counts
		move $t0, $s4					# $t0 = $s4
		li $t1, 0					# $t1 = counter
		li $t2, 26					# $t2 = boundary
		li $t3, 10					# $t3 = random character
		de_create_count_loop:
			beq $t1, $t2, end_de_create_count_loop	# counter = boundary, end loop
			sb $t3, 0($t0)				# store random character
			addi $t0, $t0, 4			# move counts position
			addi $t1, $t1, 1			# add to counter
			j de_create_count_loop			# jump to top of loop
		end_de_create_count_loop:
		sb $0, 0($t0)					# null terminator
		
	# creating the sorted alphabet address	
	de_step_4:
		addi $sp, $sp, -28				# 28 bytes of space
		move $s5, $sp					# $s6 = alphabet address
		move $t0, $s5					# $a0 = alphabet
		li $t1, 0					# $t1 = counter
		li $t2, 26					# $t2 = h bit
		li $t3, 97
		de_create_alph_loop:
			beq $t1, $t2, end_de_create_alph_loop	# $t0 = 26, end loop
			sb $t3, 0($t0)				# all inputs are a's, will be changed when calling sort alphabet
			addi $t0, $t0, 1			# moves 1 position in $a0
			addi $t1, $t1, 1			# adds 1 to counter
			addi $t3, $t3, 1			# adds 1 to current letter
			j de_create_alph_loop			# jumps to top of loop
		end_de_create_alph_loop:
		sb $0, 0($t0)					# null terminator
	
	de_step_6:
		addi $sp, $sp, -64				# allocate 64 bytes of space
		move $s6, $sp					# $s6 = 104 bytes of space
		move $t0, $s6					# $t0 = $s6
		li $t1, 0					# $t1 = counter
		li $t2, 62					# $t2 = boundary
		li $t3, 97					# $t3 = random character
		de_create_plain_loop:
			beq $t1, $t2, end_de_create_plain_loop	# counter = boundary, end loop
			sb $t3, 0($t0)				# store random character
			addi $t1, $t1, 1			# add to counter
			addi $t0, $t0, 1			# move position
			j de_create_plain_loop			# jump to top of loop
		end_de_create_plain_loop:
		sb $0, 0($t0)					# null terminator
				
	de_step_8:
		addi $sp, $sp, -64				# allocate 64 bytes of space
		move $s7, $sp					# $s6 = 104 bytes of space
		move $t0, $s7					# $t0 = $s6
		li $t1, 0					# $t1 = counter
		li $t2, 62					# $t2 = boundary
		li $t3, 97					# $t3 = random character
		de_create_cipher_loop:				
			beq $t1, $t2, end_de_create_cipher_loop	# counter = boundary, end loop
			sb $t3, 0($t0)				# store random character
			addi $t1, $t1, 1			# add to counter
			addi $t0, $t0, 1			# move position
			j de_create_cipher_loop			# jump to top of loop
		end_de_create_cipher_loop:
		sb $0, 0($t0)					# null terminator
		
	de_step_3:
		move $a0, $s4					# $s4 = counts
		move $a1, $s3					# $a1 = corpus address
		jal count_lowercase_letters			# jump and link count_lowercase_letters	
					
			
	de_step_5:
		move $a0, $s5					# $s5 = sorted alphabet
		move $a1, $s4					# $s4 = counts
		jal sort_alphabet_by_count		
												
	
	de_step_7:
		move $a0, $s6					# $s1 = plaintext alphabet
		move $a1, $s5					# $s5 = sorted alphabet
		jal generate_plaintext_alphabet
		
	de_step_9:
		move $a0, $s7					# $s7 = ciphertext alphabet
		move $a1, $s2					# $s2 = keyphrase
		jal generate_ciphertext_alphabet					
		
		move $a0, $s1					# $s1 = ciphertext 
		jal strlen					# jump and link strlen
		move $t9, $v0					# $v0 = string length
		
	de_step_10:
		li $s3, 0					# alphanumerical characters encrypted
		li $s4, 0					# other characters encrypted
		li $s5, 0					# index
		move $s2, $s0					# $s2 = plaintext
		de_step_10_loop:
			lbu $t6, 0($s1)				# $t6 = current ciphertext letter
			beq $s5, $t9, end_de_step_10_loop	# end of ciphertext, end loop
			addi $s1, $s1, 1			# move ciphertext position
			
			li $t4, 48				# $t4 = 48
			blt $t6, $t4, de_print_original 	# $t1 < 48, put character in ciphertext
			li $t4, 122				# $t4 = 122
			bgt $t6, $t4, de_print_original		# $t1 > 122, put character in ciphertext
			li $t4, 57				# $t4 = 57
			bgt $t6, $t4, de_check_57		# $t1 > 57, check
			li $t4, 90				# $t4 = 90
			bgt $t6, $t4, de_check_90		# $t1 > 90, check
			
			j decrypt_setup		
			de_check_57:
				li $t4, 65			# $t4 = 65
				blt $t6, $t4, de_print_original	# $t1 < 65, put character in ciphertext
				j decrypt_setup			# jump to setup
			de_check_90:
				li $t4, 97			# $t4 = 97
				blt $t6, $t4, de_print_original	# $t1 < 97, put character in ciphertext
				j decrypt_setup			# jump to setup
			
			decrypt_setup:
			li $t0, 0				# $t0 = 0
			move $a0, $s7				# ciphertext alphabet
			move $a1, $t6				# character
			move $a2, $t0				# index
			jal index_of				# jump and link encrypt_letter
		
			move $t0, $s6				# $t0 = plaintext alphabet
			add $t0, $t0, $v0			# add index to alphabet
			lbu $t1, 0($t0)				# load character
			sb $t1, 0($s2)				# store character in plainext
			addi $s2, $s2, 1			# move plaintext position
			addi $s3, $s3, 1			# add to counter
			addi $s5, $s5, 1			# add to index
			j de_step_10_loop			# jump to top of loop
			
			de_print_original:
				sb $t6, 0($s2)			# store character in plaintext
				addi $s2, $s2, 1		# move plaintext position
				addi $s4, $s4, 1		# add to counter
				addi $s5, $s5, 1		# add to index
				j de_step_10_loop		# jump to top of loop
		end_de_step_10_loop:
	
	de_step_11:
		sb $0, 0($s2)					# null terminator
			
		move $v0, $s3					# $v0 = alphanumeric sum
		move $v1, $s4					# $v1 = other characters
	
	addi $sp, $sp, 104				# deallocate 104 bytes of space	
	addi $sp, $sp, 28				# deallocate 28 bytes	
	addi $sp, $sp, 64				# deallocate 64 bytes
	addi $sp, $sp, 64				# deallocate 64 bytes
	lw $s0, 0($sp)					# $s0 = plaintext
	lw $s1, 4($sp)					# $s1 = ciphertext
	lw $s2, 8($sp)					# $s2 = keyphrase
	lw $s3, 12($sp)					# $s3 = corpus
	lw $s4, 16($sp)					# $s4 = counts
	lw $s5, 20($sp)					# $s5 = sorted alphabet
	lw $s6, 24($sp)					# $s6 = plaintext alphabet
	lw $s7, 28($sp)					# $s7 = ciphertext alphabet
	lw $ra, 32($sp)					# $ra = main return address
	addi $sp, $sp, 36				# deallocate 36 bytes
		
	end_decrypt:
    	jr $ra							# returns to main

############################## Do not .include any files! #############################

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
