.data
str: .ascii "CSE 220 COVID-19 Edition\0"
ch: .byte 'V'
start_index: .word 8

.text
.globl main

main:
	la $a0, str					# $a0 = str address
	lbu $a1, ch					# $a1 = character
	lw $a2, start_index				# $a2 = starting index
	jal index_of					# jump and link index_of
	
	li $v0, 10
	syscall
	
.include "hwk2.asm"
