.syntax unified
.thumb

.global main

#include "initialise.s"
#include "sub_cipher.s"
#include "letter_count.s"
#include "receive.s"
#include "transmit.s"


.data

.text


main:

	@ functions for set up
	@ BL enable_timer2_clock
	BL initialise_discovery_board
	BL initialise_power
	BL enable_peripheral_clocks
	BL enable_uart

	@ uncomment for exercise part:

	@ code 1 reads from terminal, encode using sub cipher, transmit to second board
	@ code 2 reads from UART4, decondes message, count how many letters using LED

transmitting:

	@ read from terminal (USART1), store message in R1
	@ encode message in sub_cipher
	@ transmit message to second board (UART4)
	@ finish



reading:

	@ read from pin (UART4), store message in R1
	@ decode message in sub_cipher
	@ count how many letters, display with LEDs
	@ finish
