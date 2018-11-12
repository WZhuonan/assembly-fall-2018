			.text
			.equ HEX0_3, 0xFF200020
			.equ HEX4_5, 0xFF200030
			.global HEX_clear_ASM
			.global HEX_flood_ASM
			.global HEX_write_ASM

//clear
HEX_clear_ASM:
				PUSH {R4-R12,R14}
				LDR R2, =HEX0_3			//load the first display
				MOV R4, #0              // counter 
				MOV R5, #0xFFFFFF00     //11111111 11111111 11111111 00000000
				MOV R8, R5              //constant of above value

clear_loop:
				CMP R4, #5				//compare to see if we checked all the HEX (R4=6)
				BGT clear_done	        //if yes, done

                CMP R4, #4              //check if HEX0_3 is done
				LDREQ R2, =HEX4_5		//if yes go to HEX4_5
				MOVEQ R5, R8            //#restore R5 for change  

				AND R7, R0, #1         //check the LSB of the input R0
				ASR R0, R0, #1			//shift to the next bit
				CMP R7, #0              //check if there is any display at this HEX				
				BEQ clear_update		//if it's already cleared then update the information
						          

				//#do clear 				
				LDR R7, [R2]
				AND R7, R7, R5			//Set new value, perform ADD on 0 and random number, the result is 0
				STR R7, [R2]		    //Store it into the display
				

clear_update:
                ADD R4, R4, #1		    //  increment counter		
				LSL R5, #8			    //  shift R5 by 8 bits
				ADD R5, R5, #0xFF       //  make the byte of current HEX 0, e.g:R5 = 11111111 11111111 00000000 11111111 when HEX1
				B clear_loop            //  #return to loop

clear_done:
				POP {R4-R12,R14}
				BX LR

//flood				
HEX_flood_ASM:
				PUSH {R4-R12,R14}
				LDR R2, =HEX0_3			// Load the first display
				MOV R4, #0				//initialize counter
				MOV R5, #0xFF           //00000000 00000000 00000000 11111111
				MOV R8, R5

flood_loop:
				CMP R4, #5				//If all the one hot encoder are checked
				BGT flood_done	        //#we are done

                CMP R4, #4
				LDREQ R2, =HEX4_5		// Load the second display
				MOVEQ R5, R8
				
				AND R7, R0, #1          //check LSB
				ASR R0, R0, #1          //right shift R0 for 1 bit				
				CMP R7, #0
				BEQ flood_update        //#If bit is 0, jump to update
				
				//#do flood
				LDR R9, [R2]
				ORR R9, R9, R5			//Set new value
				STR R9, [R2]			//Store it into the display
			

flood_update:
                ADD R4, R4, #1			//Increment counter
				LSL R5, #8				//Shift R5 by 8 bits
				B flood_loop
flood_done:
				POP {R4-R12,R14}
				BX LR


//write			
HEX_write_ASM:
				MOV R5, R0              //store input string in R5
				PUSH {R1-R12, R14}
				BL HEX_clear_ASM		//clear displays to write 
				POP {R1-R12, R14}
				MOV R0, R5              //recover R0 
				PUSH {R4-R12, R14}
				LDR R2, =HEX0_3		//Load the first display
				MOV R4, #0 //counter
				
			

L0:
				CMP R1, #0               	// code for 0
				MOVEQ R5, #0x3F            //0111111
				MOVEQ R8, R5
				BEQ write_loop

L1:	
				CMP R1, #1              	//code for 1
				MOVEQ R5, #0x06            //0000110
				MOVEQ R8, R5
				BEQ write_loop

L2:	
				CMP R1, #2              	//code for 2
				MOVEQ R5, #0x5B            //1011011
				MOVEQ R8, R5
				BEQ write_loop

L3:	
				CMP R1, #3             	//code for 3
				MOVEQ R5, #0x4F            //1001111
				MOVEQ R8, R5
				BEQ write_loop

L4:	
				CMP R1, #4             	//code for 4
				MOVEQ R5, #0x66            //1100110
				MOVEQ R8, R5
				BEQ write_loop

L5:	
				CMP R1, #5         	    	//code for 5
				MOVEQ R5, #0x6D            //1101101
				MOVEQ R8, R5
				BEQ write_loop

L6:	
				CMP R1, #6            	 	//code for 6
				MOVEQ R5, #0x7D	           //1111101
				MOVEQ R8, R5
				BEQ write_loop

L7:	
				CMP R1, #7          	   	//code for 7
				MOVEQ R5, #0x07            //0000111
				MOVEQ R8, R5
				BEQ write_loop

L8:	
				CMP R1, #8             		//code for 8
				MOVEQ R5, #0x7F             //1111111
				MOVEQ R8, R5
				BEQ write_loop

L9:	
				CMP R1, #9             		//code for 9
				MOVEQ R5, #0x6F             //1101111
				MOVEQ R8, R5
				BEQ write_loop

L10:	
				CMP R1, #10             	//code for A
				MOVEQ R5, #0x77             //1110111
				MOVEQ R8, R5
				BEQ write_loop

L11:	
				CMP R1, #11             	//code for B
				MOVEQ R5, #0x7C             //1111100
				MOVEQ R8, R5
				BEQ write_loop

L12:	
				CMP R1, #12             	//code for C
				MOVEQ R5, #0x39             //0111001
				MOVEQ R8, R5
				BEQ write_loop

L13:	
				CMP R1, #13             	//code for D
				MOVEQ R5, #0x5E             //1011110
				MOVEQ R8, R5
				BEQ write_loop

L14:	
				CMP R1, #14             	//code for E
				MOVEQ R5, #0x79             //1111001
				MOVEQ R8, R5
				BEQ write_loop

											//code for F
				MOV R5, #0x71             	//1110001
				MOV R8, R5
				B write_loop

write_loop:
				CMP R4, #5				//if all the one hot encoder is checked
				BGT write_done	//done
				AND R7, R0, #1          //check if LSB is 0 or 1
				ASR R0, R0, #1			//right shift R0 for 1 bit

				CMP R4, #4
				LDREQ R2, =HEX4_5		// Load the second display
				MOVEQ R5, R8

				CMP R7, #0				
				BEQ write_update //#If bit is 0, jump to update

				//#do write 
				LDR R7, [R2]
				ORR R7, R7, R5			//Set new value
				STR R7, [R2]		    //Store it into the display				
				
write_update:
                ADD R4, R4, #1		// Increment				
				LSL R5, #8			//left shift R5 by 8 bits							
				B write_loop	   //#return to the start of the loop


write_done:
				POP {R4-R12,R14}
				BX LR

				.end


