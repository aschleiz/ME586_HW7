;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;
;; UNIT:    inittime
;; PURPOSE: initialize the systick interrrupt
;; 
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;Equates

;myEquate	EQU 0x12345678
STK_RVR  EQU 0xE000E014 ; Systick Reload Value Register Addr
PERIOD   EQU 100 ; set up a period im ms
LOAD_VAL EQU 24000000/8*PERIOD/1000-1 ; this value is decremented each cycle, such that
                                      ; the amount of time taken to decrement is equal to the desired period
STK_CTRL EQU 0xE000E010 



           	AREA MyConst, DATA, READONLY	; allocates memory for initialized data

;const_label	Your DCB, , DCW, DCD, etc. statements go here.

			AREA MyData, DATA, READWRITE  ; allocates memory for uninitialized data

;data_label	Your SPACE, etc. statements go here.
	
			AREA    ARMex, CODE, READONLY
			ENTRY
inittime	PROC
			EXPORT  inittime

;------------------------------------------------------------------------------------
;your code goes here
			nop
                  push {lr}
                  push {r0-r10} ;This is just a habit.

                  ;Subunit 1: initialize count down value
                  ldr R0, =LOAD_VAL
                  ldr R1, =STK_RVR
                  str R0, [R1]     ;count is in R1 now

                  ;Subunit 2: start the tick
                  ; last three bits => 011 <=> 0x3
                    ;since we have a bit pattern involving 1/0 then best
                    ;practice is to use and to clear the register bits we want
                    ;to set, then use orr to enable the specific bits
                  ldr r0, =STK_CTRL
                  ldr r1, =0x3 ;00..11
                  ldr r2, [r0]
                  ldr r3, =0xFFFFFFF0
                  and r2, r3 ;reset the last 4 bits by clearing
                  orr r2, r1
                  str r2, [r0]                           

                  pop  {r0-r10}
                  pop {lr}
				  bx lr
				  ;; Test report: initial: ST_RELOAD -> 0x000493DF, Enabled clock, and tick int is set! Else zero in STK_CTRL
;;

		
			ENDP
			END