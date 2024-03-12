# MTRX2700 Project 2

## Group Members
Raquel Kampel
Eric Jiang
Campbell Kerr

## Roles and Responbilities


## Project Overview
All individual questions are coded in their own .s file. A main file is created to branch to each question when uncommented. 

## Exercise # - One Line Descriptor

### Summary

### Usage

### Valid input

### Functions and modularity

### Testing
Using putty to test

### Notes
- Members
- Project details
- High level info about code
- Testing procedure details

## Exercise 4 # - One Line Descriptor

### Summary
Using the Timer 2 (TIM2) that is configured in initialise.s file. 
#### steps:
 - start counter (timer control register 1) = TIM2_CR1 / Set a 1 in bit 0
 - TIM2_CNT
 - TIM2_PSC
 - TIM2_ARR is to shorten the counting period /auto-reload register


### Usage

### Valid input

### Functions and modularity

### Testing
Using putty to test

### Notes
- using general purpose time TIM2 which is a 32-bit timer
- base adress of timer 2 = 0x4000 0000

- Selecting appropriate prescalar values
- count rate is is 8MHz:
  Tick duration 1/frequency x (Prescalar value + 1)
  
  eg, precalar of 1 = 8Mhz
  
  1 microsecond:
  prescalar value = [8MHz x (1x10^-6)/(1x10^-6)]-1 = 7

  1 second
  prescalar value = [8MHz x 1]/(1)-1 = 7999999

  1 hour
  prescalar = (8MHz x3600)-1 = 28799999

  1c
  
  
