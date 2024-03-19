.syntax unified
.thumb

@Task 1.3.2a

.global main

.data
@ define variables

@define an ASCII string
ascii_string: .asciz "ABCDEF\0" @ Define a null-terminated string
string_buffer: .asciz "buffer\0" @ Define a null-terminated string



.text
@ define text


@ this is the entry function called from the startup file
main:

	LDR R0, =string_buffer @buffer
	LDR R1, =ascii_string  @abcdef
	LDR R2, =#0  @lower case or upper case command
	LDR R3, =0x00 	@ counter to the current place in the string

string_loop:
	LDRB R4, [R1, R3]	@ load the byte from the ascii_string (byte number R2)
	CMP R4, #0
	BEQ finished_everything
	@STRB R3, [R2, R3]	@ store the byte in the string_buffer (byte number R2)
	CMP R2, #0 @ Test to see whether this byte is zero
	BEQ lowercase_loop @loop to lower case if R2 is 0
	B uppercase_loop @else looop to uppercase


lowercase_loop:
	@LDR R3, #1 @increment to the next letter

	CMP R4, #97 @subtract 97 from ASCII value

	BMI make_lowercase @if negative then the letter is uppercase

	STRB R4, [R0, R3] @puts new letter into buffer
	ADD R3, #1


make_lowercase:
	ADD R4, #32
	STRB R4, [R0, R3]@ turns uppercase into lowercase
	ADD R3, #1
	B string_loop @exits loop


uppercase_loop:
	CMP R4, #91
	BMI stay_uppercase

	SUB R4, #32
	STRB R4, [R0, R3]@ turns uppercase into lowercase
	ADD R3, #1
	B string_loop @exits loop

stay_uppercase:
	STRB R4, [R0, R3]
	ADD R3, #1
	B string_loop


finished_everything:

	B finished_everything 	@ infinite loop here



finished_everything:

	B finished_everything 	@ infinite loop here
