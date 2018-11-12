				.text
				.global _start
_start2: 
				LDR R0, =ARRAY //R0 points to array
				LDR R1, N //R1 contains the number of elements in array
				PUSH {R0, R1, LR} //Push parameters and link register to stack to restored later
				BL subroutine  //Call subroutine
				LDR R0, [SP, #4] //get retrun value from stack and save to R0
				STR R0, MAX //store in memory
				LDR LR, [SP, #8] //restore link register
				ADD SP, SP, #12 //remove params from stack
stop:   B stop

subroutine: 	PUSH {R0-R3}  //Callee-save the registers before overwrite in subroutine
				LDR R1, [SP, #20] //Load N to R1
				LDR R2, [SP, #16] //Load array to R2
				MOV R0, #0  //clear R0
				LDR R0, [R2] //R0 holds the first number

MAX_LOOP: 		SUBS R1, R1, #1 //decrement counter
		  		BEQ DONE  //if it reaches 1, stop
				ADD R3, R2, #4 //R3 points to the next number
				LDR R3, [R3] //R3 holds value of next number
				ADD R2,#4  
				CMP R0, R3  //check if r3 is greater than the maximum
				BGE MAX_LOOP //if r3< current max, loop back
				MOV R0, R3  // if r3> current max, update max
				B MAX_LOOP  

DONE:      		STR R0, [SP, #20] //store max to stack, replacing N
				POP {R0-R3}//restore register
				BX LR

ARRAY:    .word 6,10,2,2,7,8
N: 		.word 6
MAX:    .space
