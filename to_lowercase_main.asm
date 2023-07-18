.data
str: .ascii "Never trust a computer you can't throw out a window. -Steve Wozniak\0"

.text
.globl main
main:
	la $a0, str					
	jal to_lowercase					
	
	li $v0, 10
	syscall
	
.include "hwk2.asm"	
