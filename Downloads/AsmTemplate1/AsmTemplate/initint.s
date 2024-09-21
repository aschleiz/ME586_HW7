;Equates
IRQADDR      EQU 0x0000005C
RCC_APB2ENR  EQU 0x40021018
GPIOA_CRL    EQU 0x40010800
EXTI_IMR     EQU 0x40010400
EXTI_FTSR    EQU 0x4001040C
EXTI_PR      EQU 0x40010414
NVIC_ISER0   EQU 0xE000E100

           	AREA MyConst, DATA, READONLY	; allocates memory for initialized data

;const_label	Your DCB, , DCW, DCD, etc. statements go here.

			AREA MyData, DATA, READWRITE  ; allocates memory for uninitialized data

;data_label	Your SPACE, etc. statements go here.
	
			AREA    ARMex, CODE, READONLY
			ENTRY
initint		PROC                    ; Routine that enables the IRQ interrupt pin, based off lecture 11 slides/notes
			EXPORT  initint
			push{LR}
            
			ldr R0, =RCC_APB2ENR    ; Load the address of the APB2 Enable Register
			ldr R1, [R0]            ; Load the contents of the APB2 Enable Register to R1
			ORR R1, #0x4            ; Enable the second bit (IOPA EN) of APB2 ENR
			str R1, [R0]            ; Write the value in R1 back to the APB2 ENR address
			
            ldr R0, =GPIOA_CRL      ; Load the address of the GPIOA config register
            ldr R1, [R0]            ; Load the contents of the config register to R1
            ORR R1, #0x40           ; Set GPIOA pin 1 to floating input
			str R1, [R0]            ; Store the register value back to the memory address

            ldr R0, =EXTI_IMR       ; Load the address of the interrupt mask register to R0
			mov R1, #0x2            ; Enable the 2s bit of the interrupt mask register
			str R1, [R0]            ; Store the desired value back to the memory address

            ldr R0, =EXTI_FTSR      ; Load the address of the falling trigger selection register
            mov R1, #0x2            ; Enable the 2s bit of the ftsr
            str R1, [R0]            ; Write the desired value back to the EXTI_FTSR address
			
            ; Wanted to include this section as it was in the lecture notes, but is not needed
            ; in this subroutine
;            ldr R0, =EXTI_PR        ; Load the value of the pending register to R0
;            mov R1, #0x2            ; Set the 2s bit of the register to 1 to clear interrupt
;            str R1, [R0]            ; Write the desired value to the EXTI_PR address

            ldr R0, =NVIC_ISER0       ; Load the value of the NVIC Set-Enable register to R0
			mov R1, #0x80            ; Set the value of the 7th bit to 1 to enable
            str R1, [R0]             ; Store the desired value to the NVIC_ISER0 address

            pop {LR}
			bx LR
done    	b done
		
			ENDP
			END