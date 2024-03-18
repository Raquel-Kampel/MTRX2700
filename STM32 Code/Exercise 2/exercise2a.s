.syntax unified
.thumb

#include "definitions.s"

main_2a:

@ 	Look at the GPIOE offset ODR, display as hex, then as binary. Look at the manual page 239

	LDR R0, =GPIOE  @ load the address of the GPIOE register into R0
	STRB R4, [R0, #ODR + 1]   @ store this to the second byte of the ODR (bits 8-15)
	EOR R4, #0xFF	@ toggle all of the bits in the byte (1->0 0->1)

	B main_2a @ return to the program_loop label
