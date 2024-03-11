.syntax unified
.thumb

@Task 1.3.2b
.global main

.data
@define variables
ascii_string: .asciz "Hello, World" @define an ascii string
string_buffer: .asciz "ufbxdjfhbxdkfjhbxdf" @ Define a null-terminated string


1bmain:

    LDR R0, string_buffer
    LDR R1, =ascii_string   @ store the memory address of the string into R1
    LDR R2, = 0x00			@R2: Shift value (positive or negative)
    MOV R2,#3               @ Set the shift value to 3 (you can change this value as needed)

    BL caesarCipher         @ Call the Caesar Cipher function



@caeserCipher function
.global caesarCipher

caeserCipher:

	@ Parameters:
    @   R1 - Memory address of the string
    @   R2 - Shift amount

	MOV R3, R2 @copy the shift value to R3

    @ Loop through the string
    loop:
        LDRB R3,[R1], #1        @ Load one byte at the current address of R1 into R3 and increment the address
        CMP R3, #0               @ Compares the byte in R4 to zero to check for the end of the string
        BEQ endLoop              @ If the above is true then, exit the loop

        ADD R3, R3, R2           @ Apply the Caesar Cipher shift to the current byte

        STRB R3,[R1, #-1]       @ Store the shifted byte back to memory

        B loop                   @ Repeat the loop

    endLoop:
    POP {PC}                     @ Restore the program counter


finished_everything:
	B finished_everything	@ infinite loop here
