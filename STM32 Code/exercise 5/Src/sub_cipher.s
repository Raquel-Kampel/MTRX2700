.syntax unified
.thumb

@Task 1.3.2c


.data
@ define variables

ascii_string: .asciz "encode this\0" @ null-terminated string
substitution_table: .asciz "zvsrlkxdupnybqctjwmigehaof" @ substitution table


.text
@ define text


@ this is the entry function called from the startup file
sub_cipher:

	LDR R0, =substitution_table @ address of the substitution_table
	LDR R1, =ascii_string 		@ the address of the current string
	LDR R2, =0x00  				@ 0: encoding mode, other: decoding mode
	LDR R3, =0x00 				@ counter to the current place in the string
	LDR R4, =0x01				@ number of decodes/encodes


string_loop:
	CMP R4, #0 				@ check if number of decodes/encodes reached zero
	BEQ finished_everything @ exit loop
	LDRB R5, [R1, R3]		@ load current letter into R5
	CMP R5, #0				@ check if null terminator
	BEQ end_of_string		@ enter end of string loop

	@ check if character is a lowercase letter
	CMP R5, #97
	BLT end_of_letter 		@ if less than 'a', skip substitution
	CMP R5, #122
	BGT end_of_letter		@ if greater than 'z', skip substitution

	@ check encoding or decoding mode
	CMP R2, #0
	BEQ encoding_mode 		@ if R2 = 0, enter encoding mode
	B decoding_mode			@ if R2 != 0, enter decoding mode


encoding_mode:
	SUB R5, #97 		@ convert into character index (0-25)
	LDRB R6, [R0, R5]	@ load encoded character into R6
	STRB R6, [R1, R3]	@ store encoded character in the ascii string
	B end_of_letter 	@ return to string loop


decoding_mode:
	MOV R6, #-1	@ cipher index

	@ loop to find cipher index of current letter
	find_cipher_index:
		ADD R6, #1				@ increment index by 1
		LDRB R7, [R0, R6] 		@ load letter at index R6 into R7
		CMP R5, R7				@ check if letter at the index and current letter are equal
		BNE find_cipher_index	@ return to start of loop

	ADD R6, #97			@ decodes R6 to the correct ASCII value
	STRB R6, [R1, R3]	@ store decoded character in the ascii string
	B end_of_letter		@ return to string loop


end_of_letter:
	ADD R3, #1		@ increment letter counter by 1
	B string_loop	@ return to string loop


end_of_string:
	SUB R4, #1		@ decrease number of encodes/decodes by 1
	MOV R3, #0		@ reset letter counter
	B string_loop	@ return to string loop


finished_everything:

	B finished_everything	@ infinite loop here













/*
.syntax unified
.thumb


.data

substitution_table: .asciz "zvsrlkxdupnybqctjwmigehaof" @ substitution table


.text


sub_cipher:

	LDR R0, =substitution_table @ address of the substitution_table
	LDR R1, =ascii_string 		@ the address of the current string
	LDR R2, =0x01  				@ 0: encoding mode, other: decoding mode
	LDR R3, =0x00 				@ counter to the current place in the string


string_loop:
	LDRB R5, [R1, R3]		@ load current letter into R5
	CMP R5, #0x0D			@ check if null terminator
	BEQ end_of_string		@ enter end of string loop

	@ check if character is a lowercase letter
	CMP R5, #97
	BLT end_of_letter 		@ if less than 'a', skip substitution
	CMP R5, #122
	BGT end_of_letter		@ if greater than 'z', skip substitution

	@ check encoding or decoding mode
	CMP R2, #0
	BEQ encoding_mode 		@ if R2 = 0, enter encoding mode
	B decoding_mode			@ if R2 != 0, enter decoding mode


encoding_mode:
	SUB R5, #97 		@ convert into character index (0-25)
	LDRB R6, [R0, R5]	@ load encoded character into R6
	STRB R6, [R1, R3]	@ store encoded character in the ascii string
	B end_of_letter 	@ return to string loop


decoding_mode:
	MOV R6, #-1	@ cipher index

	@ loop to find cipher index of current letter
	find_cipher_index:
		ADD R6, #1				@ increment index by 1
		LDRB R7, [R0, R6] 		@ load letter at index R6 into R7
		CMP R5, R7				@ check if letter at the index and current letter are equal
		BNE find_cipher_index	@ return to start of loop

	ADD R6, #97			@ decodes R6 to the correct ASCII value
	STRB R6, [R1, R3]	@ store decoded character in the ascii string
	B end_of_letter		@ return to string loop


end_of_letter:
	ADD R3, #1		@ increment letter counter by 1
	B string_loop	@ return to string loop


end_of_string:
	SUB R4, #1		@ decrease number of encodes/decodes by 1
	MOV R3, #0		@ reset letter counter
	B string_loop	@ return to string loop


finished_everything:

	B finished_everything	@ infinite loop here
*/
