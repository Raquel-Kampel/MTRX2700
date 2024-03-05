.section .data

string: .asciz "Hello, World" @define an ascii string

.section . text

@caeserCipher function
.global caesarCipher

caeserCipher:
	@input:
	@R1: Memory address of string
	@R2: Shift value (positive or negative)

	PUSH{LR} @save the link register

	MOV R3, R2 @copy the shift value to R3

    @ Loop through the string
    loop:
        LDRB R4, [R1], #1        @ Load one byte at the current address of R1 into R4 and increment the address
        CMP R4, #0               @ Compares the byte in R4 to zero to check for the end of the string
        BEQ endLoop              @ If the above is true then, exit the loop

        ADD R4, R4, R3           @ Apply the Caesar Cipher shift to the current byte

        STRB R4, [R1, #-1]        @ Store the shifted byte back to memory

        B loop                   @ Repeat the loop

    endLoop:
    POP {PC}                     @ Restore the program counter

.section .text
.global main

main:

    LDR R1, =string              @ store the memory address of the string into R1
    MOV R2, #3                   @ Set the shift value to 3 (you can change this value as needed)

    BL caesarCipher              @ Call the Caesar Cipher function
