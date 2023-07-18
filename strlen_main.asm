.data
str: .ascii "Wolfie SeAWolf!!! 2020??\0"

.text
.globl main
main:
	la $a0, str					# loads str address to $a0
	jal strlen					# jump and link to str
	
	li $v0, 10
	syscall 
	
.include "hwk2.asm"
