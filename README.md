# MTRX2700 Project 2

## Group Members
Raquel Kampel,
Eric Jiang,
Campbell Kerr

## Roles and Responbilities
- Question 1a - Together
          b - Raquel
          c - Campbell
- Question 2 - Eric
- Question 3 - Campbell
- Question 4 - Raquel
- Question 5 - Together

## Project Overview
All individual questions are coded in their own .s file. A main file is created to branch to each question when uncommented. 

## Exercise # - Looping through characters in a ASCII string to perform different operations such as converting letters to lower/upper case, shifting the value of the string or encoding the messsge. 

### Summary
1.3.2a 

1.3.2b Shifts down/up the alphabet based on user input, n the direction of a --> z or z --> a. Depending on if the hexidecimal value of the current letter is below "a" (0x61) or above "z" (0x7A), a right/left shift is applied until the null terminating character is reached which is the end of the string.

1.3.2c. 
### Usage

### Valid input
any ASCII string. 

### Functions and modularity
There is a function to detemine which shift direction fucntion will be implemented. 
The left and right shift functions, each apply their own specific value to the string. There are also two seperate functions to determine if the current character is below a. 

### Testing
Using putty to test. 
input a random string and adding a value to R2. 

### Notes
- Members
- Project details
- High level info about code
- Testing procedure details

## Exercise 4 # - Hardware Timer Delay Function with String Shifting

### Summary
The code creates delay periods using the Timer 2 (TIM2) that is configured in initialise.s file. The code implements a delay function using hardware timers and provides string shifting functionality.
#### steps:
 - start counter (timer control register 1) = TIM2_CR1 / Set a 1 in bit 0
 - TIM2_CNT
 - TIM2_PSC
 - TIM2_ARR is to shorten the counting period /auto-reload register


### Usage

### Valid input
The delay function takes a delay of any reasonable time passed through register R1.
### Functions and modularity

### Testing
 - Using putty to test
 - The delay function: Testing with various delay periods to verify accuracy, checking edge cases such as very short or very long delays.

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

 - The Auto-Reload Preload (ARPE) bit is enabled for precise management of delay    
   periods entirely in hardware.
 - The delay function waits for the timer to reach the specified delay time before 
   returning.
  
