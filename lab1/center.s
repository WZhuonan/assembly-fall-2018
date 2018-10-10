			.text
			.global _start1
_start1:
		LDR R4,= RESULT   // R4 points to the result location
		LDR R2, [R4, #4]  // R2 holds the number of element in the list
		ADD R3, R4, #8    // R3 points to the index of first number
		LDR R5, [R4, #8]  // R5 points to the value of first number
		
SUM:	SUB R2, R2, #1    //decrement the counter
		CMP R2, #0
		BEQ AVG
		ADD R3, R3, #4    //R3 points to the next number
		LDR R1, [R3]      //R1 holds the value of next number
		ADD R5, R1, R5    //Now R5 is the total sum plus the next number
		B SUM             //Branch back to sum
		
AVG:    LDR R6, [R4, #4]   //A new number R6 holds the number of elements
AVGLOOP:LSR R5, R5, #1     //Divide sum by 2, R5 is current average
		LSR R6, R6, #1		//Divide number of elements by 2
		CMP R6, #1         //Check if R6 greater than 1
		BLT RESET
		BEQ RESET
		B AVGLOOP          //If yes, branch back to loop keeps deviding

RESET:	LDR R2, [R4, #4]  // R2 holds the number of element in the list
		ADD R3, R4, #8    // R3 points to the index of first number
		LDR R7, [R3]	  // R7 points to the value of first number
		
		
SUBLOOP:SUB R2, R2, #1 //Decrement
		CMP R2, #0
		BLT END   	 //end if decrement to 0
		SUB R8, R7, R5  //subtract the average from current value
		STR R8, [R3]	// store the centered number to same index
		ADD R3, R3, #4  // point to next index
		LDR R7, [R3]   // load next number index
		B SUBLOOP
		
END:	B END  //infinite loop

RESULT:		.word	0           // R4
N:			.word	8           // R2 number of samples in the list, must be power of 2
NUMBERS:	.word	4, 5, 3, 6  // list of signal samples, must be multiple of 2 of them
            .word	1, 9, 2, 3
		
		
