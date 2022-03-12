;; Author: YOUR NAME GOES HERE

;; This program computes the factorial of a number
;; and then divides the number by 5 to obtain the
;; quotient and the remainder

.ORIG x3000

;; Main program register usage:
; R1 = NUMBER
; R6 = stack pointer

;; Main program pseudocode:

; number = factorial(number)
; quotient = number // 5
; remainder = number % 5

; Main rogram code
	LD R6, STACKBOTTOM	; Initialize the stack pointer
	LD R1, NUMBER	
	JSR FACTORIAL
	ST R1, NUMBER
	LD R2, DIVISOR
	JSR DIV
	ST R3, QUOTIENT
	ST R4, REMAINDER
	HALT

; Main program data variables
NUMBER		.BLKW #1
QUOTIENT	.BLKW #1
DIVISOR		.FILL #5
REMAINDER	.BLKW #1
STACKBOTTOM	.FILL xFDFF	; Address of the bottom of the stack


;; Subroutine FACTORIAL
;  Returns the factorial of R1 in R1
;  Input parameter: R1 (the number)
;  Output parameter: R1 (the number)
;  Working storage: R2 and R3

; Pseudocode:

; product = 1
; while n > 0
;    product *= n
;    n -= 1

FACTORIAL	ADD R0, R7, #0	; Save registers
		JSR PUSH
           	ADD R0, R3, #0
		JSR PUSH
           	ADD R0, R2, #0
		JSR PUSH
		LD R2, FACTONE	; Initialize the product to 1
FACTLOOP	JSR MUL		; R3 = R1 * R2
		ADD R2, R3, #0	; Shift the product back to R2
		ADD R1, R1, #-1	; Decrement the number
		BRp FACTLOOP
		ADD R1, R2, #0	; Shift product for return
		JSR POP		; Restore registers
		ADD R2, R0, #0
		JSR POP		; Restore registers
		ADD R3, R0, #0
		JSR POP
		ADD R7, R0, #0
		RET

; Data for subroutine FACTORIAL
FACTONE	.FILL #1


;; Subroutine MUL
;  Multiplies R1 by R2 and stores result in R3
;  R3 = R1 * R2
;  Input parameters: R1 and R2, both non-negative
;  Output parameter: R3

;; Pseudocode design:

; sum = 0
; while first > 0
;	sum += second
;	first -= 1
; return sum

MUL	ADD R0, R7, #0	; Save registers
	JSR PUSH
	ADD R0, R1, #0	        
	JSR PUSH
	AND R3, R3, #0	; Initialize sum for accumulation
        ADD R1, R1, #0  ; if first or second is 0, quit
        BRz ENDMUL
        ADD R2, R2, #0
        BRz ENDMUL
MULLOOP	ADD R3, R3, R2	; sum += second
	ADD R1, R1, #-1	; first -= 1
	BRp MULLOOP	; Exit when first == 0
ENDMUL	JSR POP		; Restore registers
	ADD R1, R0, #0
	JSR POP
	ADD R7, R0, #0

	RET


;; Subroutine DIV
;  Divides R1 by R2 and stores quotient in R3 and remainder in R4
;  R3 = R1 // R2, R4 = R1 % R2
;  Input parameters: R1 (dividend) and R2 (divisor), both positive integers
;  Output parameters: R3 (quotient) and R4 (remainder)

; Pseudocode:

; quotient = 0
; while (dividend - divisor) >= 0
;     dividend -= divisor
;     quotient += 1
; remainder = dividend

DIV	ADD R0, R7, #0	; Save registers
	JSR PUSH
	ADD R0, R2, #0	        
	JSR PUSH
	ADD R0, R1, #0
        JSR PUSH
	NOT R2, R2	; Negate the divisor
	ADD R2, R2, #1  
	AND R3, R3, #0	; Initialize the quotient (a counter)
DIVLOOP	ADD R4, R1, R2	; Entry test for the division loop (dividend - divisor >= 0)
	BRn ENDDIV
	ADD R1, R1, R2	; dividend -= divisor
	ADD R3, R3, #1	; quotient += 1
	BR DIVLOOP	; Return to the top of the loop
ENDDIV	ADD R4, R1, #0	; Set the remainder to dividend for return	
	JSR POP		; Restore registers
	ADD R1, R0, #0
	JSR POP
	ADD R2, R0, #0
	JSR POP
	ADD R7, R0, #0
	RET


;; Runtime stack management

;; Subroutine PUSH
;  Copies R0 to the top of the stack and decrements the stack pointer
;  Input parameters: R0 (the datum) and R6 (the stack pointer)
;  Output parameter: R6 (the stack pointer)
PUSH	ADD 	R6, R6, #-1
	STR 	R0, R6, #0
	RET

;; Subroutine POP
;  Copies the top of the stack to R0 and increments the stack pointer
;  Input parameter: R6 (the stack pointer)
;  Output parameters: R0 (the datum) R6 (the stack pointer)
POP	LDR 	R0, R6, #0
	ADD 	R6, R6, #1
	RET

.END

