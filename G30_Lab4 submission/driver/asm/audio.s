			.text
			.equ FIFO_CONTROL, 0xFF203040
			.equ FIFO_SPACE, 0xFF203044
			.equ FIFO_LEFT, 0xFF203048
			.equ FIFO_RIGHT, 0xFF20304C
			.global write_audio_ASM

write_audio_ASM: 
			PUSH {R1-R7, LR}

			LDR R1, = FIFO_SPACE  //Load fifo space to R0
			LDR R1, [R1]  //get data
			

			LDR R2, = FIFO_LEFT
			LDR R3, = FIFO_RIGHT

			LSR R1, #16  
			LDRB R4, [R1]  //R4 Holds WSRC

			LSR R1, #8   // R5 HOLDS WSLC
			LDRB R5, [R1]

			CMP R4, #0
			BEQ NONSPACE //exit the program if no space is left

			CMP R5, #0
			BEQ NONSPACE

			STR R0, [R2]  //Store R0 in right	
			STR R0, [R3]//Sotre R0 in left
			
			MOV R0, #1  //Set changed to 1
			POP {R1-R7, LR}
			BX LR

NONSPACE: 	MOV R0, #0  //When no space left, set changed to 0
			BX LR
			POP {R1-R7, LR}
			BX LR

			.end

			
			

