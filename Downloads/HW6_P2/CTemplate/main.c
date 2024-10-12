/**
  ******************************************************************************
  * @file    main.c 
  * @author  Zhou Zeng
  * @version V1.1.0
  * @date    10-Oct-2018
  * @brief   Main program body.
  ******************************************************************************
  */ 

/* Includes ------------------------------------------------------------------*/
#include "ME586.h"

/* Private typedef -----------------------------------------------------------*/
/* Private define ------------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
/* Private function prototypes -----------------------------------------------*/
/* Private functions ---------------------------------------------------------*/


/*
Test Report
a. Manually sending external output without external input [PASS]
b. 

*/

int UserControl = 0;
int main(void)
{
      initcom();
      printf("Enter a key press to start data collection\n\r");
      initadc();
      initdac();
      int digVolt = 0;
      int chan = 0;
      int i = 0;
    
      while(1){
          if (UserControl == 1){
             digVolt = a_to_d(chan);
             //can put some lag here.
             printf("The USER CNTRL input voltage integer is: %d \n\r", digVolt);
             WaitForKeypress();
             d_to_a(chan,digVolt);
             WaitForKeypress();}   
          else {
             digVolt = a_to_d(chan);
             //can put some lag here.
             printf("The CONT MODE input voltage integer is: %d \n\r", digVolt);
             d_to_a(chan,digVolt);
             }
             }
}

void timehand(void){
}

void inthand(void){
}

/***********************END OF FILE****/
