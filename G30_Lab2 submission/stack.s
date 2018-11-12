			.text
			.global _start

_start1:		MOV R0, #1			//the number that we are going to PUSH is 1

PUSH:		SUB SP, SP, #4		//R2 points the the address before the first number
			STR R0, [SP]		//push number in R0 to the first

			MOV R0, #2			//the number that we are going to PUSH is 2
			SUB SP, SP, #4		//R2 points the the address before the first number
			STR R0, [SP]		//push number in R0 to the first
			
			MOV R0, #5			//the number that we are going to PUSH is 5
			SUB SP, SP, #4		//R2 points the the address before the first number
			STR R0, [SP]		//push number in R0 to the first

POP:        LDR R0, [SP]
			ADD SP,SP,#4
			
			LDR R1, [SP]
			ADD SP,SP,#4
			
			LDR R2, [SP]
			ADD SP,SP,#4

END:		B END				//infinite loop!!!
			
			
			
