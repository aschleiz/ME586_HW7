

           	AREA MyConst, DATA, READONLY	; allocates memory for initialized data

;const_label	Your DCB, , DCW, DCD, etc. statements go here.
s_char DCB 's'
d_char DCB 'd'
esc_char DCB 27 ;specifies it in decimal unless other base is indicated

			AREA MyData, DATA, READWRITE  ; allocates memory for uninitialized data

;data_label	Your SPACE, etc. statements go here.
	
			AREA    ARMex, CODE, READONLY
			ENTRY
keycount         	PROC
			EXPORT keycount
			IMPORT serialIO
                        IMPORT initcom
                        IMPORT checkcom
                        IMPORT getchar
                        IMPORT shownum
			IMPORT showchar
			IMPORT bindec
			;------------------------------------------------------------------------------------

            ;Actual keyct code
            MOV R10, #0x0 ;R10 will be our counter
            bl initcom
CHECKAGAIN  bl checkcom ;should return updated R0
            CMP R0, #0x0
            beq CHECKAGAIN ;desired to hit this only when not FF
            ; Where the magic happens
            bl getchar ;this will update R0's ls-byte
            ;;THREE options
            ;; char_char is the format
            PUSH {R1-R2} ;protecting my program
            LDR  R1, =esc_char ;Is there an easier way to do this?
            LDRB R2, [R1]
            CMP R0, R2
            beq done ; if you get escape go to inf loop 'done'
            PUSH {R0} ;Homework specification has us keep reusing R0 for every function's argument, so we need to save state for when we come out of the shownum
			MOV R0, R10 ;copy counter to R0 since shownum processes R0
            bl shownum ; won't exist for now, relies on R0
            POP {R0} ;retreive the value of R0 containing the character
			LDR R1, =d_char
            LDRB R2, [R1]
            CMP R0, R2
            beq decrement
                 
            LDR R1, =s_char
            LDRB R2, [R1]
            CMP R0, R2
            beq increment
            b msg_rcv_error ;if it fails both comps then wrong thing sent
increment   ADD R10, #0x1
            b COMMON_RETURN
decrement   SUB R10, #0x1
            b COMMON_RETURN

COMMON_RETURN POP {R1-R2}
              b CHECKAGAIN 
                        




done    	b done
msg_rcv_error  b msg_rcv_error
			ENDP
			END
