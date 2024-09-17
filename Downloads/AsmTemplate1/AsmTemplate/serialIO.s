Const1     EQU 0x00
Const2     EQU 0x11
APB2PC_ENR EQU 0x40021018
GPIOA_CRH  EQU 0x40010804
USART1_BRR EQU 0x40013808
USART1_CR1 EQU 0x4001380C
USART1_SR  EQU 0x40013800
USART1_DR  EQU 0x40013804
	
			AREA  Mydata, DATA, READWRITE

; your readwrite data goes here
Readwrite1  space 2
Readwrite2  space 7
ASCII_CHARS space 6 ;each ascii char is 8-bits or 1 byte

            AREA DATAINIT, DATA, READONLY
ASCII      DCB   'A'

			AREA 	ARMex, CODE, READONLY

serialIO    		PROC
			EXPORT serialIO
			
			push {LR}
			bl initcom
			nop
			mov R0, 0x16
			bl checkcom
			mov R1, 0x16
			bl getchar
			bl testChComp
			pop {LR}
			bx LR
;done		b done
			ENDP



initcom 		PROC
			EXPORT initcom
			push {lr}
			push {R0} ;address variable
			push {R1} ;value variable
			push {R2}
			; your program goes here
			nop
			;;[XXX]INITCOM1: initializing bus clock
			LDR R0, =APB2PC_ENR
			MOV R1, #0x4005 ;need to write 0100-0000-0000-0101 <=> 0x4005
			LDR R2, [R0]
			ORR R2, R1
			STR R2, [R0] ;store the val in R1 into the address for R0, which is APB2PC_ENR
			             ;for this application it is fine to just force the values exactly as we want
						 ;since we do not need to enable multiple peripherals at different points in
						 ;program execution. In a case where we might have software turn on GPIO in response
						 ;to something it sees, then we would want to ORR here.
			
			;;[XXX]INITCOM2: Configure GPIO ports
			;;      assume that you have some initial state in the GPIO ports that you do not want
			;;      to change. Thus you need some operator that allows you to impact only the bits that 
			;;      you want to change. So if we write 
			;;      [conclusion = not and] hyp1 :if we do DESIRED and PREVIOUS
			;;            Test 0111 AND 1111 = 0111, but 0111 and 0000 = 0000 
			;;      [conclusion = not or ] hyp2: DESIRED or PREVIOUS
			;;          Test 0111 or 1111 = 1111, but 0111 and 0000 = 0111, which is not
            ;;          what we want because we want it to just set the bits exactly as we specify
            ;;          but it would be useful for the case where you want to keep what high as high.
            ;;      [conclusion = not xor]
            ;;      --> [conclusion = need two step process, need to be able to control the exact state.
            ;;                  Professor's suggestion is to use and to keep high's as high but zero
            ;;                  out the bits to change
            LDR R0, =GPIOA_CRH ;set the address register
			LDR R1, = 0xFFFFF00F   ; 0x...P10P9P8, so we want to use this to filter out the bits that
			                       ; we want to set exactly. We will then combine it with orr to get the exact bit
								   ; pattern that we want
            ; AND R1, [R0]           ; Why can't you do this? Because [R0] needs to be loaded to memory
            LDR R2,[R0]
            AND R1, R2 ;Now we have cleared the bits we want to and saved that to R1
			ORR R1, 0x04B0 ;0d4,0d11,0 <=> 0x04B0 ;since we are orr'ing the things that we don't change must
			                       ;be set as zero. Want 10 as input and 9 as AFOutput max speed. 
			STR R1, [R0]   ;so we have set the 
            
			
			;;[Test? CHECK IN HW] [XXX]INITCOM3: modify the BRR register
			;;so this is where we will set our baudrate
			LDR R0, =USART1_BRR
			MOV R1, #0x00D0 ;13 for mantissa and zero for fraction.
			STR R1, [R0] ;put the desired bit pattern into R0 from R1
			
			;;[Test= check TX in HW ] [ ] INITCOM4: Configuring USART1_CR1
			
			;0010|0000|0000|1100 <=> 0x200C
			LDR R0, =USART1_CR1
			MOV R1, #0x200C
			STR R1, [R0]
			
			
			
			pop {R2}
			pop {R1}
			pop {R0}
			pop {lr}
			bx lr
			ENDP



checkcom		PROC
			EXPORT checkcom
				;; [PASS!] TCCC1: register state is x000020c0, should go through NODATA
			    ;; [     ] TCCC2: HW test setting RXNE to both states
				;; [PASS!] TCCC3: Set R3 = 0x70, expect R0 output to be FF
			push {lr}
			push {R1-R9}
			
			LDR R1, =USART1_SR
			;;Inspect bit 5 RXNE of above register
			LDR R2, =0x00000020 ;0x000000|X=bits7654=>desired0010=>0x2|X=3210
READSTATUS  LDRB R3, [R1] ;returned zero
			;LDRH R3, [R0]  ;returned 
			;; START EXIT PATTERN1: mask pattern based on having eq branch away
			TST R2, R3 ;;returns R2 AND R3, 0 if RXNE=0
			beq NODATA ;;if zero flag is up no data was there
			MOV R0, #0xFF
			b   EXIT
			;; END EXIT PATTERN1

			
			
			
			;;output to R0 if data is present FF, else 0
NODATA      MOV R0, #0x0


EXIT		pop {R1-R9}
			pop {lr}
			bx lr
			ENDP
				
getchar 		PROC
			EXPORT getchar
			push {lr}
			;TCC4: verify this in hardware debuggers

            push {r1-r2}
			
			LDR R1,=USART1_DR 
			LDRB R2, [R1] ;;since we have 8 data we just load the whole byte
			AND R0, R2, #0x7F; 0111|1111
			
			pop {r1-r2}
			pop {lr}
			bx lr
			ENDP

showchar 		PROC
			EXPORT showchar
				
			push {lr}
			; your program goes here
            push {r1-r2}	
			push {r3-r4}
			LDR  R3, =USART1_SR
CHECKTXE    LDRB R4, [R3]
            TST  R4, #0x80 ; 8 = 1000, so bit 7, or eigth bit is expected high
			BEQ  CHECKTXE  ; loop if the above is zero, aka TXE is not set or ready.
			LDR  R1, =USART1_DR 
			STRB R0, [R1] ;this stores the lowest byte of R0 which should contain just ascii char
			pop {r3-r4}
			pop {r1-r2}
			pop {lr}
			bx lr
			ENDP
testChComp  PROC
			EXPORT testChComp
				;;Conclusion: you can save comparison characters and use that to compare
				;;we'll do this and export it
			push {lr}
			; your program goes here
            LDR R1,=ASCII
			LDRB R2,[R1]
			CMP R0, R2 ;sould set zero flag if R0 = 41
			pop {lr}
			bx lr
			ENDP
				
bindec  		PROC
			EXPORT bindec
			push {lr}
			push {R10}
			
			ldr R11, =ASCII_CHARS ; Load address of allocated memory into R11
			sxth R0				  ; Sign extend the 16 bit value to 32 bits
			cmp R0, #0            ; Test first bit of R11 to determine if number is pos or neg
			bpl pos				  ; Branch positive
			bmi negative		  ; Branch negative
			
pos			; Write space in first byte of array, increment address to end of bindec_arr
			mov R10, #0x20        ; Set R10 equal to 0x20, which is the ascii code for space
			strb R10, [R11], #5   ; Store space character in first byte of bindec_arr, increment address in R11 to end of bindec_arr
			b bitconv             ; Branch to bit conversion
			
negative	; Put minus sign in first byte of array, increment address to end of bindec_arr
			mov R10, #0x2D        ; Set R10 equal to 0x2D, which is the ascii code for -
			strb R10, [R11], #5   ; Store - character in first byte of bindec_arr, increment address in R11 to end of bindec_arr
;			sxth R1
			mov R2, R0            ; Temporarily store R1 value in R2
			sub R0, R2			  ; Flip sign of R1 from positive to negative using successive subtractions
			sub R0, R2
			
bitconv		mov R2, #0x5          ; Set R2 as loop counter
			mov R5, R0            ; Copy value in R1 to R5, as division loop expects this
bitset		b divide              ; Branch to divide
postdiv		add R5, #0x30
			strb R5, [R11], #-1   ; Store remainder of division held in R5 to the last byte in bindec_arr, increment address in R11 back 1
			mov R5, R6            ; Move the quotient value from R6 to R5 to prepare for next division operation
			subs R2, #1           ; Decrement loop counter
			bne bitset			  ; Loop again if R2 > 0
			b binstop             ; Branch to the end of the subroutine if R2 = 0

divide      nop
			mov R6, #0            ; Set R6 (quotient value) to 0
divloop		subs R5, #0xA         ; This branch divides by successive subtraction until R5 is negative
			add R6, #0x1
			cmp R5, #0
			bpl divloop
			add R5, #0xA          ; Increment R5 by 10 to account for 1 too many loops
			sub R6, #0x1          ; Increment R6 by 1 to account for 1 too many loops
			b postdiv             ; Branch back to bitset loop
			
binstop		nop

			pop {R10}
			pop {lr}
			bx lr
			ENDP
				
shownum  		PROC
			EXPORT shownum
			push {lr}
			push {r1-r5}
			; your program goes here
			;;ASSUMES that R0 contains counter
			;ASCII_CHARS

			bl bindec
			MOV R1, #1 ;;start the counter
            LDR R2, =ASCII_CHARS
LOOPSTART	LDRB R0, [R2], #1 ;post-index, so now it is offset
            bl showchar
			CMP R1, #6
			ADD R1, #1
			bne LOOPSTART ;will fail once R1 has just been set for 7th iteration
			              ;which means we went thru 6 times.
			mov R0, #0xA
			bl showchar
			mov R0, #0xD
			bl showchar
			mov R2, #0
bell		mov R0, #0x7
			bl showchar
			mov R0, #0x7
			bl showchar
			mov R0, #0x7
			bl showchar
			mov R0, #0x7
			bl showchar
			mov R0, #0x7
			bl showchar
			mov R0, #0x7
			bl showchar
			mov R0, #0x7
			bl showchar
			add R2, #0x1
			CMP R0, #0xFF
			beq bell
			pop {r1-r5}
            nop
			
			pop {lr}
			bx lr
			ENDP

			END