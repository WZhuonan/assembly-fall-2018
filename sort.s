			.text
			.global _start3

_start3:	LDR R0, =N     // R0 points to N
			LDR R1, [R0]    // R1 holds the number of element in the list
			ADD R1,R1,#1	// add 1 to R1
			ADD R2, R0, #4      // R2 points to the index of first number
			LDR R3, [R2]        // R3 holds the first number
			MOV R4, #0			//R4 is boolean, 0 false, 1 true
			MOV R5, #2			//COUNTER FOR INNER LOOP, STARTS AT 2, GOES TO N
			B OUTERLOOP
			

OUTERLOOP:	CMP R4, #1		// check if R4 is true
			BEQ END 		//R4 IS 1, END LOOP
			MOV R4,#1		//SET R4 (SORTED) TO 1, TRUE

			ADD R2, R0, #4      // RESET R2 points to the first number initially (index)
			LDR R3, [R2]        // RESET R3 holds the first number in the array initially (value)
			MOV R5, #2			//RESET COUNTER FOR INNER LOOP, STARTS AT 2, GOES TO N

			B INNERLOOP		//compare and swap

INNERLOOP:	CMP R5, R1		//R5 IS INNER INDEX (i), R1 IS N
			BEQ OUTERLOOP	//WHEN i IS N, GO TO OUTER
			ADD R5,R5,#1	//INCREMENT INNER LOOP COUNTER
			ADD R2,R2,#4	//R2 POINTS TO THE NEXT NUMBER
			MOV R6, R2		//R6 POINTER TO A [i]
			SUB R7, R6,#4	//R7 POINTER TO A [i-1] (aka r2 -4 to get to previous elem)
			LDR R8, [R6]	//R8 value at A[i]
			LDR R9, [R7]	//R9 valuE at A[i-1]
			CMP R8,R9		//IF A[i] < A[i-1], SWAP
			BLT SWAP		// SWAP
			B INNERLOOP		// ELSE LOOP AGAIN
			
SWAP:		MOV R4, #0		//SET SORTED FALSE, =0
			STR R8, [R7]		//R8 IS VALUE OF A[i]
			STR R9,	[R6]		//R9 IS VALUE OF A[i-1] 
			
			B INNERLOOP			//AFTER SWAP GO Back to inner

END:		B END               // infinite loop

N:		.word	8           // number of samples in the list, must be power of 2
ARRAY:	.word	4, 5, 3, 15  // list of signal samples, must be multiple of 2 of them
        .word	8, 8, 6, 1
