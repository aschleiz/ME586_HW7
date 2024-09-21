;Equates
EXTI_PR     EQU 0x40010414
EXTI1_PReset EQU 0x02
esc_char    EQU 0x1B

           	AREA MyConst, DATA, READONLY	; allocates memory for initialized data

;const_label	Your DCB, , DCW, DCD, etc. statements go here.

			AREA MyData, DATA, READWRITE  ; allocates memory for uninitialized data

clicks      SPACE 2                       ; Initializes 16 bit (2 byte) space for clicks
outclicks   SPACE 2
	
			AREA    ARMex, CODE, READONLY
			ENTRY
__main      PROC
			EXPORT  __main

			IMPORT initint
			IMPORT serialIO
			IMPORT initcom
			IMPORT checkcom
			IMPORT getchar
			IMPORT shownum
            IMPORT inittime
			; Test code
                  ;mov r0, #0
			
                  ;D1 -------------------------------
			   ; Initialize clicks (halfword) to zero
			ldr R0, =clicks
			mov R1, #0x0000
			STRH R1, [R0]
			   ; Initialize outclicks (halfword) to zero
			ldr R0, =outclicks
			mov R1, #0x0000
			strh R1, [R0]
			;-----------------------------------


                  ;D2 --------------------------------
			bl initint ; Set up EXT1_IRQ port
			
                  ;D3 --------------------------------
			bl inittime ; Set up timer
			;mov R1, #0
            ;b done ;test code
                  ;D4 --------------------------------
            bl initcom


;------------------ this loops forever unless beq holds -----
;
; Desired behavior: output when outlicks is nonzero, then set outclicks to zero
; Desired behavior: when outclicks zero, checkcom and decide what to do next
; Log:


loop              nop
  ;XXX D5-1 -------------------------------------------
            ldr R3, =outclicks  ;The following didn't work because we load an address: ldrh R3, =outclicks
			ldrh R0, [R3]
			cmp R0, #0
			bne output           ;branch away when two values are not equal
  ;------------------------------------------------
  ;[DEBUG] Checkcom:	
			bl checkcom  ;returns FF if there's something in register  
			cmp R0, #0x00
			bne input      ;branch away when checkcom has nonzero.
			b loop ;if no data then keep looping
input       bl getchar
            
			cmp R0, #esc_char
			beq done
			b loop
;XXX D5-2 ----------------------------------------------------------			
output            bl shownum
                  
                  ;ldrh R0,=0x0 ; not allowed because = only works for ldr
				  ldr R0,=0x0 ;zero out outclicks
                  strh R0, [R3]
			b loop
;---------------------------------------------------------------
done    	b done
		
			ENDP
;;
;; Desired behavior: increment the clicks whenever the waveform is changing sine
;;
EXTI1_IRQHandler PROC
	        EXPORT EXTI1_IRQHandler
			push {LR}
			
			ldr R0, =clicks 
			ldr R1, [R0]
			add R1, #1
			str R1, [R0]
			
			ldr R0, =EXTI_PR
			mov R1, #EXTI1_PReset
			str R1, [R0]
			; Instructions
			pop {LR}
			bx lr
			ENDP

;; I: clicks and outlicks
;; O: *outclicks = *clicks, *clicks => 0
;; 
SysTick_Handler PROC ;Future question to address: search microvision docs to find where the whole table is located
                 EXPORT SysTick_Handler ;need this because otherwise the code will get stuck and call the wrong version of the handler (the weak one)
                                        ;this implies that we leave main once an exception is called
				 push {lr}
                 push {r0-r10}
                                    ;r3 is the setter variable, others are used for storing addresses
                 ldr r0, =clicks
                 ldr r1, =outclicks
                 ldrh r3, [r0]      ; 2 byte load is needed, now r3 has the value of clicks                 
                 strh r3, [r1]      ; copy clicks to outlicks, but make sure to send only 16 bits since it is 
                 ldr  r3, =0x0      ; clear the setter variable
                 strh  r3, [r0]      ; reset clicks to zero
                 


                 pop  {r0-r10}
                 pop  {lr}
				 bx lr
			ENDP
			END
		    