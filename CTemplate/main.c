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
#include <stdlib.h>
/* Private typedef -----------------------------------------------------------*/
/* Private define ------------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
int USER_CHOICE;
int X;
struct gains {
float kp;
float ki;
float kd;
};
float setpoint;
struct gains PIDgains;
float controllerPeriod;
int *ADCvalues;
float error_prior = 0;
float integral = 0;
int ct = 0;

/* Private function prototypes -----------------------------------------------*/
/* Private functions ---------------------------------------------------------*/

void starttime(float millisec){
   inittime(millisec);
   disable_timer_interrupt(); //Thinking to leave this off until user specifies
}

void starttime2(float millisec){
   inittime(millisec);
   //second function is to just initialize it in case the first doesn't work
}



int main(void)
{
    int tmp;
    initcom();
    initadc();
    initdac();


	 while(1){
    printf("I command you to give a command: \r\n");
    printf("1) set PID gains \r\n");
    printf("2) set setpoint/reference signal \r\n");
    printf("3) set controller time period \r\n");
    printf("4) set storage elements \r\n");
    printf("5) set the controller loose! \r\n");
    printf("6) output X number of ADC values representing the controller output signal \r\n");
    printf("7) exit the program \n\r");
    USER_CHOICE = getnum();
    switch(USER_CHOICE)
    {
       case 1:
          printf("input kp \n\r"); //might need to wait for key press
          PIDgains.kp = getfloat();
          printf("input ki \n\r");
          PIDgains.ki = getfloat();
          printf("input kd \n\r");
          PIDgains.kd = getfloat();
          break;
       case 2:
          setpoint = getfloat();
			    break;
       case 3:
          printf("input period in millisecs \n\r");
          controllerPeriod = getfloat();
          starttime(controllerPeriod); //this might be the best placement
			    break;
       case 4:
         printf("Input the number of elements to output \n\r");
          X = getnum();
          ADCvalues = (int *) malloc(X*sizeof(int));
			    break;			 
       case 5:
          printf("controller is running...\n\r");
          restore_timer_interrupt();
			    break;			 
       case 6:
          disable_timer_interrupt();
          printf("adc values: \n\r");
          for(int i=0; i<X; i++){
              tmp = *(ADCvalues+i);
              printf("%d \n\r",tmp);
          }
			    break;					
       case 7:
          disable_timer_interrupt();
          while(1){//done}
          }
			    break;					
       default:
          printf("Error incorrect input \n\r");
			    break;
    }
    





    };
} //end of main program


void timehand(void){
/* GLOBALS
int USER_CHOICE;
int X;                     <------- see problem 2.4)
struct gains {
float kp;
float ki;
float kd;
}
float setpoint;            <---- reference value
struct gains PIDgains;     <---- kp,ki,kd
float controllerPeriod;    
int *ADCvalues;            <---- read from this
   
*/

}

void inthand(void){
}

/***********************END OF FILE****/
