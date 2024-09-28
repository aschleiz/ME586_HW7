#include "utility.c"
extern void showmsg(char *);
extern void keycount();
extern void initcom();

int main(void)
{
   char * IntroMsg[] = "counter program running: input s,d, or esc from keyboard to increment, decrement, or escape the counter program \0";
   initcom();
   showmsg(IntroMsg);
   
   //The following contains an infiniti
   //  loop so it will spin indefinitely.
   keycount();	
   
while(1){};
}


