.syntax unified
.thumb

@Task 1.3.2a
.global main

#include "1,2,3a"
#include "1,2,3b"
#include "1,2,3c"

.data
@ define variables

.text
@ define text


main:
	@BL 1amain
	@BL 1bmain
	BL 1cmain
