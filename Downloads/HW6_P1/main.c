/**
  ******************************************************************************
  * @file    main.c 
  * @author  Alex Schleizer
  * @version V1.1.0
  * @date    10-14-2024
  * @brief   Homework 6 Problem 1 Code File.
  ******************************************************************************
  */ 

/* Includes ------------------------------------------------------------------*/
#include "ME586.h"

/* Private typedef -----------------------------------------------------------*/
/* Private define ------------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
int outval = 0;
/* Private function prototypes -----------------------------------------------*/
/* Private functions ---------------------------------------------------------*/
void checkloop(void);
int readloop(void);
void do_nothing(int);

int main(void)
{
	  initcom();
		printf("Press a key to start the process! ");
		WaitForKeypress();
		putchar('\n');
		putchar('\r');
		while(1){
			//checkloop();
			outval = readloop();
	//		shownum(outval);
	//		putchar('\n');
	//		putchar('\r');
		};
} //end of main program


void checkloop(void){
	int tmp = 0x00;
	while (tmp == 0x00){
		checkcom();
		
	}
}

int readloop(void){
	int count = 0;
	short digval = 0;
	initports(0x100);
	while(1){
		digval = digin();
		//digval >> 8;
		digval = digval & 0x0100; // Mask unnecessary bits, might not be needed
		if (digval != 0x00){
			count++;
			//initports(0x0);
			digout(count);
			do_nothing(0x000FFFFF);
		}
		else{
			if(count != 0){
				shownum(count); //TC5: double check int to short
				putchar('\n');
				putchar('\r');
			break;
			}
		}
	}
	return count;
}

void do_nothing(int len){
	int counter = 0;
	while(counter < len){
		counter++;
	}
}

void timehand(void){
}

void inthand(void){
}

/***********************END OF FILE****/
