.syntax unified
.thumb

.global main


.data
@ define variables
ascii_string: .asciz "abcde\0" @string that needs to be shifted

.text

main:

	LDR R1, =ascii_string  @load the string into R1
	LDRB R2, =#1 @R2 is the number of places to shift to right or left
	LDR R3, =#0
	LDR R4, =#0x61 @a marker
	LDR R5, =#0x7A	@z marker

shift_direction:
	SUB R2, #2 @shift to left by 1
	CMP R2, #0
	BMI left_shift @Shift left if r2 is negative, right if positive

	B right_shift

right_shift:

	LDRB R6, [R1, R3] @load current letter into R3
	LDR R7, =#26
	CMP R6, #0 @ check if the end of the string
	BEQ end_of_string

	ADD R6, R2 @shift the letter
	CMP R6, R5 @if it is above "z" in the ascii values
	BMI below_z

	SUB R6, R7 @subtract 26 to give the real shift letter
	STRB R6, [R1, R3] @store the new value into r1
	ADD R3, #1
	B right_shift


below_z:

	STRB R6, [R1, R3] @replace value of r6 into r1
	ADD R3, #1
	B right_shift @continue to shift until end of string



left_shift:

	LDRB R6, [R1, R3] @load current letter into R3
	LDR R7,  =#26
	CMP R6, #0 @ check if the end of the string
	BEQ end_of_string

	ADD R6, R2
	CMP R6, R4
	BMI too_low @if it is below "a" in the ascii values

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
