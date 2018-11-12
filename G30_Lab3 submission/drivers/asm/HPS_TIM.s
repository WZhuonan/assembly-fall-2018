			.text
			.equ TIM_0, 0xFFC08000
			.equ TIM_1, 0xFFC09000
			.equ TIM_2, 0xFFD00000
			.equ TIM_3, 0xFFD01000
			.global HPS_TIM_config_ASM
			.global HPS_TIM_read_ASM
			.global HPS_TIM_clear_INT_ASM



HPS_TIM_config_ASM:
			PUSH {R1-R7}
			LDR R3, [R0]				//Load TIM into R3
			AND R3, R3, #0xF			//clear leading bits
			MOV R1, #0					//counter
			
HPS_TIM_config_ASM_LOOP:
			CMP R1, #4					//check the counter 
			BGE HPS_TIM_config_ASM_DONE	//if greater than 5, done

			
			AND R5, R3, #1 				//check the bit
			CMP R5, #0 
			ASR R3, R3, #1				//shift to the next bit
			ADDEQ R1, R1, #1			//increament counter
			BEQ HPS_TIM_config_ASM_LOOP	//branch back to loop if the bit is 0
			
			CMP R1, #0					//if it's 1, load the corresponding timer
			LDREQ R2, =TIM_0
			CMP R1, #1
			LDREQ R2, =TIM_1
			CMP R1, #2
			LDREQ R2, =TIM_2
			CMP R1, #3
			LDREQ R2, =TIM_3
		
			LDR R4, [R0, #0x8]			//First need to disable the timer before doing any change
			AND R4, R4, #0x6			//Only change the E bit
			STR	R4, [R2, #0x8] 			//store result back
	
			//Now we can start configuring the proper timer

			LDR R4, [R0, #0x4]			//Load the timeout address
			STR R4, [R2] 				//Write the argument to it
			
			LDR R5, [R0, #0xC]			//Load INT_en param
			LSL R5, R5, #2				//shift by 2 bits to get the I bit

			LDR R4, [R0, #0x8]			//Load LD_en address param
			LSL R4, R4, #1				//shift by one bit to get the M bit

			LDR R6, [R0, #0x10]			//Load the enable param

			ORR R7, R4, R5				//Mix M and I
			ORR R7, R7, R6				//Mix M, I and E

			STR R7, [R2, #0x8]			//Store the result

			ADD R1, R1, #1				//Increment counter
			B HPS_TIM_config_ASM_LOOP

HPS_TIM_config_ASM_DONE:
			POP {R1-R7}
			BX LR
			

HPS_TIM_read_ASM:
			PUSH {R1-R4}
			AND R0, R0, #0xF			//Get rid of random numbers ahead of our one-hot string
			MOV R1, #0					//Initialize counter
			
HPS_TIM_read_ASM_LOOP:
			CMP R1, #4					//if we covered all 4 timers then we're done
			BGE HPS_TIM_read_ASM_DONE	

			AND R4, R0, #1 //check if this bit is hot
			CMP R4, #0 

			ASR R0, R0, #1				//regardless of if it's high or not, prepare for next iteration
			ADDEQ R1, R1, #1			//If it is 0, increment the counter, otherwise don't because we need it below
			BEQ HPS_TIM_read_ASM_LOOP	//If the bit was low then keep looping

			//Get the corresponding timer
			CMP R1, #0
			LDREQ R2, =TIM_0
			CMP R1, #1
			LDREQ R2, =TIM_1
			CMP R1, #2
			LDREQ R2, =TIM_2
			CMP R1, #3
			LDREQ R2, =TIM_3

			LDR R3, [R2, #0x10]			//Load the s bit
			AND R0, R3, #1				//just so we don't have garbage in front of our bit
			B HPS_TIM_read_ASM_DONE 

HPS_TIM_read_ASM_DONE:
			POP {R1-R4}
			BX LR


//This is the same thing as the read subroutine, except that the only thing we need to do is to read the F bit, which nicely clear everything for us
HPS_TIM_clear_INT_ASM:
			PUSH {R1-R4}
			AND R0, R0, #0xF			
			MOV R1, #0					
			
HPS_TIM_clear_INT_ASM_LOOP:
			CMP R1, #4					
			BGE HPS_TIM_clear_INT_ASM_DONE	
			
			AND R4, R0, #1
			CMP R4, #0
			ASR R0, R0, #1				
			ADDEQ R1, R1, #1			
			BEQ HPS_TIM_clear_INT_ASM_LOOP	

			CMP R1, #0
			LDREQ R2, =TIM_0
			CMP R1, #1
			LDREQ R2, =TIM_1
			CMP R1, #2
			LDREQ R2, =TIM_2
			CMP R1, #3
			LDREQ R2, =TIM_3

			LDR R4, [R2, #0xC]			

			ADD R1, R1, #1				
			B HPS_TIM_clear_INT_ASM_LOOP

HPS_TIM_clear_INT_ASM_DONE:
			POP {R1-R4}
			BX LR			

			.end
