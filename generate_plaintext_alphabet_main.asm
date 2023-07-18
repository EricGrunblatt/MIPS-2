.data
plaintext_alphabet: .ascii "eauUCg5cfQjiY6bs6BKEqE1cXtvHZEn0MOHKZ9uaz5XPGBRIOYQM41FHQAxGc2W"
sorted_alphabet: .ascii "jmhoxqzgityudwsecvfalnkrbp\0"

.text
.globl main
main:
	la $a0, plaintext_alphabet
	la $a1, sorted_alphabet
	jal generate_plaintext_alphabet
	
	li $v0, 4
	la $a0, plaintext_alphabet
	syscall
	
	li $v0, 10
	syscall
	
.include "hwk2.asm"
