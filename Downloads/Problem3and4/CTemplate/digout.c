/**
  ******************************************************************************
  * @file    digout.c 
  * @author  Emmit Benitez, Alex Schleizer
  * @version V1.1.0
  * @date    10-Oct-2018
  * @brief   Main program body.
  ******************************************************************************
  */ 

/* Includes ------------------------------------------------------------------*/
#include "ME586.h"
//#include "utility.c" // Don't think we need to include this line, just need the
// extern function definitions
extern short getanum(void);
extern void showmsg(char);

/* Private typedef -----------------------------------------------------------*/
/* Private define ------------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
char RequestMsg[]= "Please enter an unsigned 16 bit number\n";
/* Private function prototypes -----------------------------------------------*/
/* Private functions ---------------------------------------------------------*/


int main(void)
{
    //1. verify that we don't need MELib.h in this directory
    initcom();
	  while(1){
       showmsg(*RequestMsg);
	     short value = getanum();
			 //char tempnum = value; // Type conversion assigns the value of tempnum to be the low byte of value
			 // digout((short)tempnum);
			 short tempnum = (value & 0x000F); //Alternate method of isolating lowest byte
			 digout(tempnum);
	};
} //end of main program


void timehand(void){
}

void inthand(void){
}

/***********************END OF FILE****/
