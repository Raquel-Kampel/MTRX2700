.syntax unified
.thumb

.global main


.data
@ define variables
ascii_string: .asciz "abcde\0" @ Define a null-terminated string

.text
@ define text


@ this is the entry function called from the startup file
main:

	LDR R1, =ascii_string  @ the address of the string
	LDRB R2, =#1
	LDR R3, =#0
	LDR R4, =#0x61 @a marker
	LDR R5, =#0x7A	@z marker

shift_direction:
	SUB R2, #2
	CMP R2, #0
	BMI left_shift

	B right_shift

right_shift:

	LDRB R6, [R1, R3] @load current letter into R3
	LDR R7, =#26
	CMP R6, #0 @ check if the end of the string
	BEQ end_of_string

	ADD R6, R2
	CMP R6, R5
	BMI below_z

	SUB R6, R7
	STRB R6, [R1, R3]
	ADD R3, #1
	B right_shift


below_z:

	STRB R6, [R1, R3]@replace value of r6 into r1
	ADD R3, #1
	B right_shift



left_shift:

	LDRB R6, [R1, R3] @load current letter into R3
	LDR R7,  =#26
	CMP R6, #0 @ check if the end of the string
	BEQ end_of_string

	ADD R6, R2
	CMP R6, R4
	BMI too_low

	STRB R6, [R1, R3] @replace value of r6 into r1
	ADD R3, #1
	B left_shift

too_low:

	ADD R6, R7
	STRB R6, [R1, R3]
	ADD R3, #1
	B left_shift

end_of_string:

 	B end_of_string
