.data
sorted_alphabet: .ascii "aaaaaaaaaaaaaaaaaaaaaaaaaaa"
counts: .word 8 2 3 4 15 0 1 4 2 0 0 3 0 9 4 1 0 3 5 8 2 0 1 0 2 0

.text
.globl main
main:
	la $a0, sorted_alphabet
	la $a1, counts
	jal sort_alphabet_by_count
	
	li $v0, 4
	la $t0, sorted_alphabet
	move $a0, $t0
	syscall
	
	li $v0, 10
	syscall
	
.include "hwk2.asm"
