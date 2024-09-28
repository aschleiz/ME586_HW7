/**
  ******************************************************************************
  * @file    utility.c 
  * @author  Alex Schleizer
  * @version V1.1.0
  * @date    26-Sep-2024
  * @brief   Collection of utility functions.
  ******************************************************************************
  */ 

/* Includes ------------------------------------------------------------------*/

extern void showchar(char);
extern void initcom(void);
extern void shownum(short);
extern char checkcom();
extern char getchar();
/* Private typedef -----------------------------------------------------------*/
/* Private define ------------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
/* Private function prototypes -----------------------------------------------*/
/* Private functions ---------------------------------------------------------*/
void showmsg(char * msg){
	// Local Variable Declarations
	//char size = sizeof(msg);
	int count = 0;
	
	// Loop through each character in msg and output to console using showchar
	while(msg[count] != 0x00){
		showchar(msg[count]);
		count++;
	}
}


short getanum(){
   
   char digit_array[] = {0,0,0,0,0};
   short OutputNumber = 0;
   char LoopCount     = 0;
   char PowTen        = 1;
   char CarriageRet   = '\r';
   char TmpChar       = '0';
   char TmpNum        = 0;
   char CheckComOutput = checkcom();
   


   do {
      while (CheckComOutput == 0){
           CheckComOutput = checkcom();
      }
      TmpChar = getchar();
      if(TmpChar == '\r'){
         break;                        //hop out of the whole loop
      }
      digit_array[LoopCount] = TmpChar;
      TmpNum = (TmpChar-30)*PowTen;    //Subtract 30 from ascii to get decimal

      OutputNumber = OutputNumber + TmpNum;
      PowTen = PowTen * 10;
      LoopCount = LoopCount + 1;
   }
   while (LoopCount < 5))


   return OutputNumber;


}





/***********************END OF FILE****/