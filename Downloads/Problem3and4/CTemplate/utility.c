/* Private typedef -----------------------------------------------------------*/
/* Private define ------------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
/* Private function prototypes -----------------------------------------------*/
/* Private functions ---------------------------------------------------------*/
/*
Homework spec says to include ME586 lib for problem 4, however this requires us to
make some small changes to utility.c
*/
#include <ME586.h>

/*
Proposed Tests:
---------------
1. [Hyp] if we do nothing, character will always be present in the rx. So we may
         need to clear what is in the data register. According to some documentation
         I read, the RXNE bit is automattically cleared when you read a byte from the
        UART data register.
   [Result = ]


*/

//extern char checkcom();
//extern char getchar();
//extern void putchar();  // Same as showchar, but included in 586 lib

void showmsg(char * msg){
	// Local Variable Declarations
	//char size = sizeof(msg);
	int count = 0;
	
	// Loop through each character in msg and output to console using showchar
	while(msg[count] != 0x00){
		putchar(msg[count]);
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
   while (LoopCount < 5);
    

   return OutputNumber;


}
/***********************END OF FILE****/
