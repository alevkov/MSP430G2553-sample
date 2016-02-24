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


ARY1		.set	0x0200
ARY1S		.set	0x0210
ARY2		.set	0x0220
ARY2S		.set	0x0230

;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer

;-------------------------------Main Block--------------------------------------
			clr		R4 ; array
			clr		R5
			clr 	R6


SORT1		mov.w	#ARY1, R4  ; unsorted array storage

			call	#ARRAY1SET
			call	#SORT

SORT2		mov.w	#ARY2, R4

			call	#ARRAY2SET
			call	#SORT


;-------------------------------------------------------------------------------
; Main loop here
;-------------------------------------------------------------------------------
Mainloop	jmp		Mainloop

ARRAY1SET:

			mov.b	#10,	0(R4)		;Define the number of elements in the array
			mov.b	#17, 	1(R4)
			mov.b	#55, 	2(R4)
			mov.b	#-9, 	3(R4)
			mov.b	#22, 	4(R4)
			mov.b	#36, 	5(R4)
			mov.b	#-7, 	6(R4)
			mov.b	#37,	7(R4)
			mov.b	#8, 	8(R4)
			mov.b	#-77,	9(R4)
			mov.b	#8, 	10(R4)
			ret

ARRAY2SET:

    		mov.b  #10,   0(R4)
    		mov.b  #90,   1(R4)
    		mov.b  #-10,  2(R4)
    		mov.b  #-45,  3(R4)
    		mov.b  #25,   4(R4)
    		mov.b  #-46,  5(R4)
    		mov.b  #-8,   6(R4)
    		mov.b  #99,   7(R4)
    		mov.b  #20,   8(R4)
    		mov.b  #0,    9(R4)
    		mov.b  #-64, 10(R4)
			ret


; SORT subroutine (Bubble Sort)

;	WHAT IS A BUBBLE SORT?
;			1) Two loops, inner and outer
;			2) Inner loop compares two adjacent elements in array (with overlap):
;				If the second element is greater than the first, swap them. Repeat untill the end of array is reached
;			3) Repeat inner loop (inside outer loop) n times where n is the number of elements in array
;


SORT:		clr   R7 	; counter 1 (inner loop)
			clr	  R8    ; counter 2 (outer loop)
			clr   R10	; swap value 1
			clr   R11	; swap value 2
			clr   R12   ; inner counter copy

			mov.b @R4, R7 ; inner counter, decremented by 1 (n - 1)
			dec.b R7
			mov.b R7, R12 ; store inner counter for reuse

			mov.w R4, &0300h ; store starting address of array in RAM
							 ; for setting after the inner loop is finished
							 ; to go back to the first element and start loop again

			mov.b @R4+, R8; outer counter, = n

SWAPLOOP
			mov.b @R4+, R10
			mov.b @R4+, R11
			cmp.b R10, R11 ; compare two adjacent elements


			jge SKIP ; if second is greater than first, skip swapping

SWAP		xor.b -2(R4), -1(R4) ; swap here for n - 1 times
			xor.b -1(R4), -2(R4) ; swapping two adjacent elements
			xor.b -2(R4), -1(R4) ; using xor swap

SKIP		dec R4 ; go one step backwards
			dec.b R7
			jnz SWAPLOOP

DONECOMP
			mov.w &0300h, R4
			inc	  R4
			mov.b   R12, R7 ; reload inner counter
			dec 	R8 ; decrement outer counter
			jnz SWAPLOOP ; restart outer loop

			clr		R4 ; when done, initialize R4 for next array

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
            
