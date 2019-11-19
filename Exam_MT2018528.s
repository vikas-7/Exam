;Below Program performs following things
;1)calculates infinte Sine series for different values of theta stored in register S2
;2)calculates infinte Cosine series for different values of theta stored in register S2
;3) X=rcos(Q), Y=rsin(Q)in stored in register S10, S9 respectively
;4) Value of radius is stored in register S4	
	
	
	area     Circle, CODE, READONLY
     	IMPORT printMsg
     	IMPORT printMsg1
	 EXPORT __main
     ENTRY 
__main  FUNCTION
        
        MOV R3,#10;Holding the Number of Terms in Series 'n'
        VLDR.F32 S0,=0;Holding the sum of series elements 's'
        VLDR.F32 S1,=1;Temp Variable 'v' to hold the intermediate series elements 't'
        VLDR.F32 S2,=0;Input value in degrees
		VLDR.F32 S3,=0.0174533; value of 1 degree in radian
		VMUL.F32 S2,S2,S3; convert degree to radian S2=S2*S3
		VLDR.F32 S8,=1; Variable to hold the series
		MOV R2,#2
		MOV R1, #1;Counting Variable 'i'
		MOV R5,R3 ;store R0 into R5
		VLDR.F32 S4,=100;input the value of radius
		VLDR.F32 S11,=10;increment value
		VMUL.F32 S11,S11,S3
		VLDR.F32 S12,=360;Compare with theta
		VMUL.F32 S12,S12,S3
		
;implementation of Sin Series

SINEF   
		VMUL.F32 S8,S2,S8; t = t*x
		VMOV.F32 S5,R1;Moving the bit stream in R1('i') to S5(floating point register)
        VCVT.F32.U32 S5, S5;Converting the bitstream into unsigned fp Number 32 bit
        VDIV.F32 S7,S8,S5;Divide t by 'i' and store it in 't1'
		B LOOP;goto comparision for even/odd

LOOP	UDIV R5,R3,R2;to find quotient R0is divided R2 is divisor R0/R2
		MLS R5,R5,R2,R3   ;to find remainder  multiplies the values from R2 and R5, subtracts the result from the value from R0, and places the least significant 32 bits of the final result in Rd.
		CMP R5,#0         ;compare register R5 with 0
		BEQ ADDTN	;if R5=0 branch to ADDITION
		BNE SUBST		;if R5!=0 branch to SUBST
		
ADDTN	VADD.F32 S0,S0,S7; add 's' to 't1' and store it in 's'
		b temp

SUBST	VSUB.F32 S0,S0,S7;subtract 's' to 't1' and store it in 's'
		B temp
		
temp	ADD R1,R1,#1;Increment the counter variable 'i'
		B COSF


;implementation of Cos Series

COSF	VMUL.F32 S7,S2,S7; t1 = t1*x
		VMOV.F32 S6,R1;Moving the bit stream in R1('i') to S6(floating point register)
        VCVT.F32.U32 S6, S6;Converting the bitstream into unsigned fp Number 32 bit
        VDIV.F32 S8,S7,S6;Divide t1 by 'i' and store it back in 't'
		B LOOP1;goto comparision for even/odd
		
LOOP1	UDIV R5,R3,R2;to find quotient R0is divided R2 is divisor R0/R2
		MLS R5,R5,R2,R3   ;to find remainder  multiplies the values from R2 and R5, subtracts the result from the value from R0, and places the least significant 32 bits of the final result in Rd.
		CMP R5,#0         ;compare register R5 with 0
		BEQ SUBSTR		  ;if R5=0 branch to SUBSTR
		BNE ADDITN		  ;if R5!=0 branch to ADDITN
		
SUBSTR	VSUB.F32 S1,S1,S8;subtract 'v' to 't' and store it in 'v'
		B temp1
		
ADDITN	VADD.F32 S1,S1,S8;Finally add 'v' to 't' and store it in 'v'
		B temp1
	
temp1	ADD R1,R1,#1;Increment the counter variable 'i'
		SUB R3, #1;DECREMENT the no. of series by 1
		CMP R3, #0; compare R0 with 0
		BEQ MULTI;if R0=0 branch to stop
		BNE SINEF;if R0!=0 branch to SINEF
	
MULTI	VMUL.F32 S10,S4,S1;Multiply radius with cos(x) to get X
		VMOV.F32 R0,S10
		BL printMsg
		VMUL.F32 S9,S4,S0;Multiply radius with Sine(x) to get Y
		VMOV.F32 R0,S9
		BL printMsg
		VCMP.F32 S2,S12
		VMRS APSR_NZCV,FPSCR
		BEQ stop
		BNE INCR
		
INCR	VADD.F32 S2,S2,S11
        MOV R3,#16;Holding the Number of Terms in Series 'n'
        VLDR.F32 S0,=0;Holding the sum of series elements 's'
        VLDR.F32 S1,=1;Temp Variable 'v' to hold the intermediate series elements 't'
		VLDR.F32 S8,=1; Variable to hold the series
		MOV R2,#2
		MOV R1, #1;Counting Variable 'i'
		MOV R5,R3 ;store R0 into R5
		B SINEF
		
stop    B stop
        ENDFUNC
        END
