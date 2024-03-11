.syntax unified
.thumb

.global main

#include "initialise.s"
#include "3a.s"
#include "3b.s"
#include "3c.s"
#include "3d.s"

.data


.text


main:

	@ functions for set up
	BL initialise_power
	BL enable_peripheral_clocks
	BL enable_uart

	@ uncomment for exercise part:

	@ B part_a_main @ (transmit)

	@ B part_b_main @ (read)

	@ B part_c_main @ (change clock)

	B part_d_main @ (transmit and read)
