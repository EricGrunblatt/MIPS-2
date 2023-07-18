.data
counts: .word -890186 -438641 -817157 612618 -145953 -440997 -774137 758469 889951 834642 -919986 -204919 124497 179267 -303331 -285295 786955 -891155 -665164 -716764 -292806 176422 -299979 471550 -485856 -656536
message: .ascii "We can only see a short distance ahead, but we can see plenty there that needs to be done. -Alan Turing\0"

.text
.globl main
main:
	la $a0, counts
	la $a1, message
	jal count_lowercase_letters
	
	li $t0, 0
	li $t1, 26
	li $t2, 32
	la $t3, counts	
	
	li $v0, 10
	syscall
	
.include "hwk2.asm"
