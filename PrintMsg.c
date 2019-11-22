#include "stm32f4xx.h"
#include <string.h>
#include <stdio.h>

void printMsg(int a)
{
	 float a1=* ((float * ) &a);
	 
	 char Msg1[100];
	 
	 char *ptr;
	 sprintf(Msg1, "%f, \n", a1);
	 
	 ptr = Msg1 ;
   while(*ptr != '\0'){
      ITM_SendChar(*ptr);
      ++ptr;
   
	 }
	 ITM_SendChar(',')	 ;
   }
