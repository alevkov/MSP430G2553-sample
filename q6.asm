;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file
            
;-------------------------------------------------------------------------------
            .def    RESET                   ; Export program entry-point to
                                            ; make it known to linker.
;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory.
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section.
            .retainrefs                     ; And retain any sections that have
                                            ; references to current section.

LIST_IN		.set	0x0214

;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer

;-------------------------------Main Block--------------------------------------
			clr		R4 				; array
			clr		R5				; n
			clr 	R6				; max value


Q4			mov.w #LIST_IN, R4
			call #LISTINSET
			call #CLIP_FILTER

;-------------------------------------------------------------------------------
; Main loop here
;-------------------------------------------------------------------------------
Mainloop	jmp		Mainloop

LISTINSET:
			mov.w	#8,	0(R4)		;Define the number of elements in the array
			mov.w	#45, 2(R4)
			mov.w	#26, 4(R4)
			mov.w	#31, 6(R4)
			mov.w	#49, 8(R4)
			mov.w	#51, 10(R4)
			mov.w	#23, 12(R4)
			mov.w	#7,	14(R4)
			mov.w	#81, 16(R4)
			ret


CLIP_FILTER:
			mov.w @R4+, R5	; loop counter
			mov.w @R4+, R6 ; max value
			dec.w R5
CMPLOOP		cmp.w @R4, R6
			jge SKIP
			mov.w R6, 0(R4)
SKIP		incd.w R4
			dec.w R5 ; loop counter (n)
			jnz CMPLOOP
			ret

;-------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack
            
;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
            
