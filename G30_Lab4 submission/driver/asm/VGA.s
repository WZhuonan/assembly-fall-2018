			.text
			.equ CHAR_BASE, 0xC9000000
			.equ PIXE_BASE, 0xC8000000
			.global VGA_clear_charbuff_ASM
			.global VGA_clear_pixelbuff_ASM
			.global VGA_write_char_ASM
			.global VGA_write_byte_ASM
			.global VGA_draw_point_ASM

VGA_clear_charbuff_ASM: 
			PUSH {R0-R11, LR}
			MOV R0, #0				// R0 IS THE COUNTER FOR X
			LDR R3, =CHAR_BASE		// LOAD THE CHAR BASE
			MOV R2, #0				// USE R2 TO CLEAR
CHAR_XLOOP:	
			MOV R1, #0				// R1 IS THE COUNTER FOR Y, INITIALIZE IT IN EVERY INTERATION
			ADD R4, R3, R0, LSL #1	// R4 CONTAINS THE ADDRESS OF BASE AND X
CHAR_YLOOP:
			ADD R5, R4, R1, LSL #7	// R5 CONTAINS THE ADDRESS OF BASE, X, AND Y. IT'S THE FINAL ADDRESS
			STRH R2, [R5]			// CLEAR THIS CHAR
			//LSR R1, #7				// SHIFT R1 BACK
			ADD R1, R1, #1			// INCREMENT THE Y COUNTER
			CMP R1, #60
			BLT CHAR_YLOOP			// IF R1 IS LESS THAN 60 THEN CONTINUE Y LOOP
			ADD R0, R0, #1			// INCREMENT THE X COUNTER IF Y COUNTER REACHES 60
			CMP R0, #80
			BLT CHAR_XLOOP			// IF R0 IS LESS THAN 80 THEN CONTINUE X LOOP
CHAR_DONE:	
			POP {R0-R11, LR}		// CLEAR IS DONE IF X COUNTER REACHES 80
			BX LR
VGA_clear_pixelbuff_ASM: 
			PUSH {R0-R11, LR}
			MOV R0, #0				// R0 IS THE COUNTER FOR X
			LDR R3, =PIXE_BASE		//LOAD THE PIXEL BASE
			MOV R2, #0				// USE R2 TO CLEAR
PIX_XLOOP:	
			MOV R1, #0				// R1 IS THE COUNTER FOR Y, INITIALIZE IT IN EVERY INTERATION
			//LSL R0, #1				// X IS AT 1-9 BITS
			ADD R4, R3, R0, LSL #1			// R4 CONTAINS THE ADDRESS OF BASE AND X
			//LSR R0, #1				// SHIFT R0 BACK
PIX_YLOOP:
			//LSL R1, #10				// Y IS AT 10-17 BITS
			ADD R5, R4, R1, LSL #10			// R5 CONTAINS THE ADDRESS OF BASE, X, AND Y. IT'S THE FINAL ADDRESS
			STRH R2, [R5]			// CLEAR THIS PIXEL
			//LSR R1, #10				// SHIFT R1 BACK
			ADD R1, R1, #1			// INCREMENT THE Y COUNTER
			CMP R1, #240
			BLT PIX_YLOOP			// IF R1 IS LESS THAN 240 THEN CONTINUE Y LOOP
			ADD R0, R0, #1			// INCREMENT THE X COUNTER IF Y COUNTER REACHES 240
			CMP R0, #320
			BLT PIX_XLOOP			// IF R0 IS LESS THAN 320 THEN CONTINUE X LOOP
PIX_DONE:	
			POP {R0-R11, LR}		// CLEAR IS DONE IF X COUNTER REACHES 320
			BX LR
			

VGA_write_char_ASM:
			PUSH {R0-R11, LR}
			CMP R0, #0				// CHECK IF X IS WITHIN 0 TO 79 AND Y IS WITHIN 0 TO 59
			BXLT LR
			CMP R0, #79
			BXGT LR
			CMP R1, #0
			BXLT LR
			CMP R1, #59
			BXGT LR
			
			LDR R3, =CHAR_BASE		
			ADD R5, R1, #0			// COPY R1 TO R6
			LSL R5, #7				// SHIFT R5
			ADD R5, R5, R0			
			ADD R5, R5, R3			// R5 NOW CONTAINS THE FINAL ADDRESS
			STRB R2, [R5]			// STORE THE THIRD ARGUMENT INTO R5
			
			POP {R0-R11, LR}
			BX LR

VGA_write_byte_ASM:
			PUSH {R0-R8, LR}
	
			LDR R3, =ASCII
			MOV R7, R2			//Hold argument
			MOV R5, #0b11110000		//0b11110000 for x coordinates
	
			AND R2, R2, R5		//Get value for the first byte
			LSR R2, R2, #4		//Left shift by 2^4 to place it properly
			ADD R4, R3, R2	//Get memory location
			LDRB R2, [R4]	//Get the ascii code into R2 to pass to write_char

			BL VGA_write_char_ASM	//Write the char to screen
	
			ADD R0, R0, #1		//Increment x to write next digit	

			MOV R5, #0b00001111		//0b00001111 for y coordinates
			MOV R2, R7			//Get argument back

			AND R2, R2, R5		//Value for second byte
			ADD R4, R3, R2		//Memory location
			LDRB R2, [R4]		//Store

			BL VGA_write_char_ASM	//Write to screen

			POP {R0-R8, LR}
	
			BX LR
	
ASCII:
	.byte 0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46
	//      0     1     2     3     4     5     6     7     8     9     A     B     C     D     E     F  // 



VGA_draw_point_ASM:
			PUSH {R0-R11, LR}
			CMP R0, #0				// CHECK IF X IS WITHIN 0 TO 319 AND Y IS WITHIN 0 TO 239
			BXLT LR
			LDR R10, =319
			CMP R0, R10
			BXGT LR
			CMP R1, #0
			BXLT LR
			CMP R1, #239
			BXGT LR

			LDR R3, =PIXE_BASE	
			ADD R3, R3, R0, LSL #1			//Get memory location for x
			ADD R3, R3, R1, LSL #10			//Get memory location for y
			STRH R2, [R3]			// STORE THE THIRD ARGUMENT INTO R5
			
			POP {R0-R11, LR}
			BX LR


.end
