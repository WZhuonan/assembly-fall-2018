#include <stdio.h>

#include "./drivers/inc/LEDs.h"
#include "./drivers/inc/slider_switches.h"
#include "./drivers/inc/HEX_displays.h"
#include "./drivers/inc/pushbuttons.h"
#include "./drivers/inc/HPS_TIM.h"
#include "./drivers/inc/address_map_arm.h"
#include "./drivers/inc/int_setup.h"
#include "./drivers/inc/ISRs.h"

int main() {
/*
	while (1) {
		int switchVal = read_slider_switches_ASM();
		write_LEDs_ASM(switchVal);
		if (0x200 & switchVal) { //check if SW9 is on (clear)
			HEX_clear_ASM(HEX0 | HEX1 | HEX2 | HEX3 | HEX4 | HEX5); // clear all the display
			//HEX_flood_ASM(HEX4 | HEX5);
		} 
		else { //display the number
			HEX_flood_ASM(HEX4 | HEX5); // flood HEX4 and HEX5 first
			char val =  0xF & switchVal; //only consider the 4 swiches
			int pushbutton = 0xF & read_PB_data_ASM(); //check which pb is on
			HEX_write_ASM(pushbutton, val); //display
		}
	}

*/	

/*
	HPS_TIM_config_t hps_tim;
	hps_tim.tim = TIM0; // tim0 for the stopwatch
	hps_tim.timeout = 1000000; //interrupt time (ms)
	hps_tim.LD_en = 1; 
	hps_tim.INT_en = 0; //polling
	hps_tim.enable = 1; 
	HPS_TIM_config_ASM(&hps_tim); 

	
	HPS_TIM_config_t hps_tim_pb;
	hps_tim_pb.tim = TIM1; // tim1 for polling check
	hps_tim_pb.timeout = 5000; //interrupt time
	hps_tim_pb.LD_en = 1;
	hps_tim_pb.INT_en = 0;
	hps_tim_pb.enable = 1;
	HPS_TIM_config_ASM(&hps_tim_pb); 


	int push_buttons = 0;
	int ms_count = 0; // count the ms
	int sec_count = 0; // count the sec
	int min_count = 0; // count the min

	int timer_start = 0; //boolean: if the time is started

	while(1) {
		if (HPS_TIM_read_ASM(TIM0) && timer_start) { //tim0 is running and timer is start
			HPS_TIM_clear_INT_ASM(TIM0); //clear the timer
			ms_count += 10; //update the milliseconds

			if (ms_count >= 1000) { // update ms and sec
				ms_count -= 1000;
				sec_count++;//every 1000 ms is 1 sec
				
				if (sec_count >= 60) { // update sec and min
					sec_count -= 60;
					min_count++; //every 60 sec is 1 min

					if (min_count >= 60) {
						min_count = 0; //maximum 60 min
					}
				}
			}

			//display the time
			HEX_write_ASM(HEX0, ((ms_count % 100) / 10));
			HEX_write_ASM(HEX1, (ms_count / 100));
			HEX_write_ASM(HEX2, (sec_count % 10));
			HEX_write_ASM(HEX3, (sec_count / 10));
			HEX_write_ASM(HEX4, (min_count % 10));
			HEX_write_ASM(HEX5, (min_count / 10));
		}

		if (HPS_TIM_read_ASM(TIM1)) { //polling to check pushbutton

			HPS_TIM_clear_INT_ASM(TIM1);
			int pb = 0xF & read_PB_data_ASM();

			if ((pb & 1) && (!timer_start)) { //key 0 is pressed and timer is not running
				timer_start = 1; //then start the timer
			} 
			else if ((pb & 2) && (timer_start)) { //key 1 is pressed and timer is running
				timer_start = 0; // stop the timer
			} 
			else if (pb & 4) { //key 3 is pressed
				HEX_write_ASM(HEX0 | HEX1 | HEX2 | HEX3 | HEX4 | HEX5, 0); //clear the display
				ms_count = 0;
				sec_count = 0;
				min_count = 0;
				timer_start = 0; //initialize everything
			}
		}
	} 


*/
	 //INTERUPT STOPWATCH
	int_setup(2, (int []) {73, 199}); // 73 for pb and 199 for tim0
	enable_PB_INT_ASM(PB0 | PB1 | PB2);	// enable three pb
	HPS_TIM_config_t hps_tim;
	hps_tim.tim = TIM0;
	hps_tim.timeout = 1000000;
	hps_tim.LD_en = 1;
	hps_tim.INT_en = 0;
	hps_tim.enable = 1;

	HPS_TIM_config_ASM(&hps_tim); 

	int push_buttons = 0;
	int ms_count = 0;
	int sec_count = 0;
	int min_count = 0;

	int timer_start = 0; 

	
	while(1) {
		if (hps_tim0_int_flag) { //check if the interupt occurs, run the stopwatch
			hps_tim0_int_flag = 0; // clear the interupt status

			if (timer_start) {
				ms_count += 10; 

				// check and update ms, sec, and min, same as polling
				if (ms_count >= 1000) {
					ms_count -= 1000;
					sec_count++;
				
					if (sec_count >= 60) {
						sec_count -= 60;
						min_count++;

						if (min_count >= 60) {
							min_count = 0;
						}
					}
				}
				//display
				HEX_write_ASM(HEX0, ((ms_count % 100) / 10));
				HEX_write_ASM(HEX1, (ms_count / 100));
				HEX_write_ASM(HEX2, (sec_count % 10));
				HEX_write_ASM(HEX3, (sec_count / 10));
				HEX_write_ASM(HEX4, (min_count % 10));
				HEX_write_ASM(HEX5, (min_count / 10));
			}
		}

		if (pb_int_flag != 0) { //check interupt
			if ((pb_int_flag & 1) && (!timer_start)) { //key 0
				timer_start = 1;
			} else if ((pb_int_flag & 2) && (timer_start)) { //key 1
				timer_start = 0;
			} else if (pb_int_flag & 4) { //key 2
				HEX_write_ASM(HEX0 | HEX1 | HEX2 | HEX3 | HEX4 | HEX5, 0);
				ms_count = 0;
				sec_count = 0;
				min_count = 0;
				timer_start = 0; //initialize
			}

			pb_int_flag = 0;//change it back to 0
		}
	}

	return 0;
}
