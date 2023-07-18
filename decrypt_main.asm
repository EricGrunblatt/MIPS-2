.data
plaintext: .ascii "2WPlU0f6FQqkvvJz4eUDyKXvbmLf1Oxa5wozIGU06dOsF9WOUoIEljICyWDcaiDmbqZw"
ciphertext: .ascii "Xjc 1UN4dDn 6xXj jW5vJk WJ ORcK GmKf, PI iO4TVn, mV 0jW3 RwQREy 6mDE xKVlV1 NJ iMGqLk aDPJk aJf 2U8uHk 2Q R40 2jlJkV xK lZ. -3rUT8 RThYijc23\0"
keyphrase: .ascii "What's the difference between ignorance and apathy? I don't know and I don't care.\0"
corpus: .ascii "Call me Ishmael. Some years ago - never mind how long precisely - having little or no money in my purse, and nothing particular to interest me on shore, I thought I would sail about a little and see the watery part of the world. It is a way I have of driving off the spleen and regulating the circulation.\0"
.text
.globl main
main:
 	la $a0, plaintext
	la $a1, ciphertext
	la $a2, keyphrase
	la $a3, corpus
	jal decrypt
	
	# You must write your own code here to check the correctness of the function implementation.

	li $v0, 10
	syscall
	
.include "hwk2.asm"
