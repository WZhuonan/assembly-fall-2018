			.text
			.global _start

_start:
			LDR R4, =MAX		//R4 
			LDR R5, =MIN
			LDR R9, =SUBT
			LDR R2, [R5, #8]
			LDR R6, [R5, #8]
			ADD R3, R5, #12
			ADD R7, R5, #12
			LDR R0, [R3]
			LDR R8, [R3]
			

LOOP1:		SUBS R2, R2, #1
			BEQ DONE1
			ADD R3, R3, #4
			LDR R1, [R3]
			CMP R0, R1
			BGE LOOP1
			MOV R0, R1
			B LOOP1

DONE1:		STR R0, [R4]

LOOP2:		SUBS R6, R6, #1
			BEQ DONE2
			ADD R7, R7, #4
			LDR R1, [R7]
			CMP R1, R8
			BGE LOOP2
			MOV R8, R1			
			B LOOP2

DONE2:		STR R8, [R5]
			
		
SUBSH:		SUBS R10, R0, R8
				LSR R11, R10, #2
			STR R11, [R9]

END:		B END

			
			

MAX:		.word	0
MIN:		.word	0
SUBT:		.word	0
N:			.word	7
NUMBERS:	.word	13, 5, 3, 9
			.word	1, 8, 2
