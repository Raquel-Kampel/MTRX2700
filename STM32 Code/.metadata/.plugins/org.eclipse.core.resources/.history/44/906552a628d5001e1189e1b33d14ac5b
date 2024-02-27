.syntax unified
.thumb

@Task 1.3.2a
.global main


.data
@ define variables

@define an ASCII string
ascii_string: .asciz "A random ASCII string !\0" @ Define a null-terminated string



.text
@ define text


@ this is the entry function called from the startup file
main:

	LDR R1, =ascii_string  @ the address of the string
	LDR R2, =string_buffer  @ the address of the string
	LDR R3, =0x00 	@ counter to the current place in the string


string_loop:
	LDRB R3, [R1, R3]	@ load the byte from the ascii_string (byte number R2)
	STRB R3, [R2, R3]	@ store the byte in the string_buffer (byte number R2)
