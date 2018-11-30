TITLE Programming Assignment #1   (Project01.asm)

; Author: Kevin Harvell
; Last Modified: 9/27/2018
; OSU email address: harvellk@oregonstate.edu
; Course number/section: CS271/400
; Project Number: Project #1       Due Date: 10/7/2018
; Description: This program displays my name and program title, prompts user for 2 numbers and
;	and calculates the sum, difference, product, (integer) quotient and remainder of the numbers, then
;	displays a terminating message.

INCLUDE Irvine32.inc

START = 1
QUIT = 2

.data
choice			DWORD	?		;play or quit as an integer
num1			DWORD	?		;first integer entered by user
num2			DWORD	?		;second integer entered by user
sum				DWORD	?		
difference		DWORD	?
product			DWORD	?
quotient		DWORD	?
remainder		DWORD	?
lastNum			DWORD	?
ten				DWORD	10
round			DWORD	5
intro_1			BYTE	"Elementary Arithmetic by Kevin Harvell", 0
ec1				BYTE	"**EC1: Program repeats until user chooses to quit.", 0
ec2				BYTE	"**EC2: Program verifies second number is less than first.", 0
ec3				BYTE	"**EC3: Program displays qutient as a floating-point number, rounded to the nearest .001", 0
start_prompt	BYTE	"1. Start", 0
quit_prompt		BYTE	"2. Quit", 0
intro_2			BYTE	"Enter 2 integers, and I'll show you the sum, difference, product, quotient and remainder.", 0
prompt_1		BYTE	"First number: ", 0
prompt_2		BYTE	"Second number: ", 0
result_sum		BYTE	" + ", 0
result_diff		BYTE	" - ", 0
result_prod		BYTE	" x ", 0
result_div		BYTE	" / ", 0
result_rem		BYTE	" remainder ", 0
result_eq		BYTE	" = ", 0
decimal			BYTE	".", 0
goodBye			BYTE	"Impressed? Bye!", 0
invalid_input	BYTE	"Invalid Input. Try Again.", 0
invalid_nums	BYTE	"Please make sure the second number is less than the first.", 0

.code
main PROC

start_menu:
;Introduce programmer and program title
	call	CrLf
	mov		edx, OFFSET intro_1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET ec1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET ec2
	call	WriteString
	call	CrLf
	mov		edx, OFFSET ec3
	call	WriteString
	call	CrLf

;Display menu to start or quit
	mov		edx, OFFSET start_prompt
	call	WriteString
	call	CrLf
	mov		edx, OFFSET quit_prompt
	call	WriteString
	call	CrLf

;Get choice from user to start or quit
	call	ReadInt
	mov		choice, eax

;start loop if user selects start
	mov		eax, choice
	cmp		eax, START
	je		startLoop
	cmp		eax, QUIT
	je		end_program
	mov		edx, OFFSET invalid_input
	call	WriteString
	call	CrLf
	jmp		start_menu

startLoop:
;Display instructions
	call	CrLf
	mov		edx, OFFSET intro_2
	call	WriteString
	call	CrLf

getNumbers:
;Get 2 numbers
	call	CrLf
	mov		edx, OFFSET prompt_1
	call	WriteString
	call	ReadInt
	mov		num1, eax
	mov		edx, OFFSET prompt_2
	call	WriteString
	call	ReadInt
	mov		num2, eax
;Validate second number is less than first
	mov		eax, num1
	cmp		eax, num2
	jbe		invalidNums
	jmp		calculate

invalidNums:
	mov		edx, OFFSET invalid_nums
	call	WriteString
	call	CrLf
	jmp		getNumbers

calculate:
;Calculate sum
	mov		eax, num1
	add		eax, num2
	mov		sum, eax

;Calculate difference
	mov		eax, num1
	sub		eax, num2
	mov		difference, eax

;Calculate product
	mov		eax, num1
	mul		num2
	mov		product, eax

;Calculate (integer) quotient and remainder
	mov		eax, num1
	div		num2
	mov		quotient, eax
	mov		remainder, edx

;Display the results
;sum results
	call	CrLf
	mov		eax, num1
	call	WriteDec
	mov		edx, OFFSET result_sum
	call	WriteString
	mov		eax, num2
	call	WriteDec
	mov		edx, OFFSET result_eq
	call	WriteString
	mov		eax, sum
	call	WriteDec
	call	CrLf
;difference results
	mov		eax, num1
	call	WriteDec
	mov		edx, OFFSET result_diff
	call	WriteString
	mov		eax, num2
	call	WriteDec
	mov		edx, OFFSET result_eq
	call	WriteString
	mov		eax, difference
	call	WriteDec
	call	CrLf
;product results
	mov		eax, num1
	call	WriteDec
	mov		edx, OFFSET result_prod
	call	WriteString
	mov		eax, num2
	call	WriteDec
	mov		edx, OFFSET result_eq
	call	WriteString
	mov		eax, product
	call	WriteDec
	call	CrLf
;quotient/remainder results (int)
	mov		eax, num1
	call	WriteDec
	mov		edx, OFFSET result_div
	call	WriteString
	mov		eax, num2
	call	WriteDec
	mov		edx, OFFSET result_eq
	call	WriteString
	mov		eax, quotient
	call	WriteDec
	mov		edx, OFFSET result_rem
	call	WriteString
	mov		eax, remainder
	call	WriteDec
	call	CrLf
;quotient calculations and results(float)
	mov		eax, num1					;display problem set up
	call	WriteDec
	mov		edx, OFFSET result_div
	call	WriteString
	mov		eax, num2
	call	WriteDec
	mov		edx, OFFSET result_eq
	call	WriteString
	mov		eax, quotient				;display quotient w/o decimal
	call	WriteDec
	mov		edx, OFFSET decimal
	call	WriteString
	mov		eax, remainder
	mul		ten
	div		num2						;tenth
	mov		quotient, eax
	call	WriteDec
	mov		remainder, edx
	mov		eax, remainder
	mul		ten		
	div		num2						;hundredth
	mov		quotient, eax
	call	WriteDec
	mov		remainder, edx
	mov		eax, remainder	
	mul		ten		
	div		num2						;thousandth
	mov		lastNum, eax
	mov		remainder, edx
	mov		eax, remainder	
	mul		ten		
	div		num2						;ten-thousandth
	mov		quotient, eax
	cmp		eax, round					;rounding
	jge		roundUp
	mov		eax, lastNum
	call	WriteDec
	jmp		skipRound
roundUp:
	mov		eax, lastNum
	inc		eax
	call	WriteDec
skipRound:
	call	CrLf


;repeat program
	jmp start_menu

end_program:
;Say "Goodbye"
	call	CrLf
	mov		edx, OFFSET goodBye
	call	WriteString
	call	CrLf

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
