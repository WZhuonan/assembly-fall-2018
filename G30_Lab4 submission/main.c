#include <stdio.h>

//#include "./drivers/inc/slider_switches.h"
//#include "./drivers/inc/pushbuttons.h"
//#include "./drivers/inc/VGA.h"
//#include "./drivers/inc/ps2_keyboard.h"

void test_char() {
	int x,y;
	char c = 0;

	for(y = 0; y<= 59; y++)
		for(x=0; x<=79; x++)
			VGA_write_char_ASM(x,y,c++);
}

void test_byte() {
	int x,y;
	char c=0;
	
	for(y=0; y<=59; y++)
		for(x=0; x<=79; x+=3)
			VGA_write_byte_ASM(x,y,c++);
}

void test_pixel() {
	int x,y;
	unsigned short colour = 0;

	for(y=0; y<=239; y++)
		for(x=0;x<=319;x++)
			VGA_draw_point_ASM(x,y,colour++);
}

/*int main() {
	test_byte();

	return 0;
}*/

/*int main() {

	while (1){
		
		if(read_PB_data_ASM() == 1){
			if (read_slider_switches_ASM() == 0) {
				test_char();
			}
			else {
				test_byte();
			}
		}
		else if(read_PB_data_ASM() == 2){
			test_pixel();
		}		
		else if(read_PB_data_ASM() == 4){
			VGA_clear_charbuff_ASM();
		}
		else if(read_PB_data_ASM() == 8){
			VGA_clear_pixelbuff_ASM();
		}

	}

}*/



/*
// PS2 keyboard
int main() {
	// clear the screen
	VGA_clear_charbuff_ASM();
	VGA_clear_pixelbuff_ASM();
	// initialize x and y
	int x = 0;
	int y = 0;

	char ch;

	while(1){
		int check = read_PS2_data_ASM(&ch);
		if (check == 1){
			VGA_write_byte_ASM(x,y,ch);
			x += 3; // each byte takes 2 and a space takes 1
			if (x>79){				// the row is full
				x = 0;
				y+=1;
			}
			if (y > 59){			// the screen is full
				x = 0;
				y = 0;
				VGA_clear_charbuff_ASM();
			}
		}
		
	}

}
*/


//Audio

int main (){
	int i=0;

	//100 Hz at 48k samples/sec, there are 240 samples 1s and 240 sample 0s
	while(1){
		for(i=0; i<240;i++){
			if(write_audio_ASM(0x00FFFFFF)!=1){
				i--;
			}
		}
		for(i=0; i<240;i++){
			if(write_audio_ASM(0x00000000)!=1){
				i--;
	
			}

		}
	}
}
