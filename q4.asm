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

LIST_IN		.set	0x0200
LIST_OUT	.set	0x0260

;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer

;-------------------------------Main Block--------------------------------------
			clr		R4 				; array
			clr		R5				; n
			clr 	R6				; array 2
			clr		R7				; n - number of duplicates
			clr 	R8				; previous copied


Q4
			mov.w #LIST_IN, R4
			mov.w #LIST_OUT, R6
			call #LISTINSET
			call #REP_FREE

;-------------------------------------------------------------------------------
; Main loop here
;-------------------------------------------------------------------------------
Mainloop	jmp		Mainloop

LISTINSET:
			mov.w	#8,	0(R4)		;Define the number of elements in the array
			mov.w	#2, 2(R4)
			mov.w	#2, 4(R4)
			mov.w	#2, 6(R4)
			mov.w	#4, 8(R4)
			mov.w	#5, 10(R4)
			mov.w	#5, 12(R4)
			mov.w	#7,	14(R4)
			mov.w	#8, 16(R4)
			ret

REP_FREE:
			mov.w @R4+, R5	; loop counter

			incd.w R6 ; move first element to array
			mov.w @R4+, 0(R6)
			incd.w R6
			add.w #1, R7
			dec.w R5

COPYLOOP	cmp.w @R4, -2(R6)
			jeq SKIP
			mov.w @R4, 0(R6) ; last copied element
			incd.w R6
			add.w #1, R7
SKIP		incd.w R4
			dec.w R5 ; loop counter (n)
			jnz COPYLOOP
			mov.w R7, &LIST_OUT
			ret
			;--

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
            
