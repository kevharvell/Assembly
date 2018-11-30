TITLE Program 3    (HarvellKevin-Prog3.asm)

; Author: Kevin Harvell
; Last Modified: 10/20/2018
; OSU email address: harvellk@oregonstate.edu
; Course number/section: CS271/400
; Project Number: Project #3        Due Date: 10/28/2018
; Description: This program displays the program title and programmer's name, 
; gets user's name and greets them, repeatedly prompts the user to enter a number
; between -100 and -1(inclusive) and counts/accumulates until non-negative number
; is entered. It then calculates the average of the numbers. 

INCLUDE Irvine32.inc

LOWER_LIMIT = -100

.data
userName		BYTE	33 DUP(0)	;string for user's name
num				SDWORD	?			;number entered by user
numCount		SDWORD	0			;count of valid numbers
sum				SDWORD	0			;sum of all negative numbers
avg				SDWORD	?			;average of all negative numbers
remainder		SDWORD	?			
negTen			SDWORD	-10
ten				DWORD	10
round			DWORD	5
lastNum			DWORD	?
decimal			BYTE	".", 0
intro_1			BYTE	"Welcome to the Integer Accumulator by Kevin Harvell", 0
ec1				BYTE	"**EC1: Number the lines during user input", 0
ec2				BYTE	"**EC2: Program displays qutient as a floating-point number, rounded to the nearest .001", 0
prompt_1		BYTE	"What is your name? ", 0
greeting		BYTE	"Hello, ", 0
instructions_1	BYTE	"Enter numbers in [-100, -1]", 0
instructions_2	BYTE	"Enter a non-negative number when you are finished to see results.", 0
prompt_2		BYTE	" Enter number: ", 0
info_1			BYTE	"You entered ", 0
info_2			BYTE	" valid numbers.", 0
sum_info_1		BYTE	"The sum of your valid numbers is ", 0
round_info_1	BYTE	"The rounded average is ", 0
noNegs			BYTE	"You did not enter any valid negative numbers :(", 0
goodBye			BYTE	"Thank you for playing Integer Accumulator! It's been a pleasure to meet you, ", 0


.code
main PROC

;Display program title and name
	mov		edx, OFFSET intro_1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET	ec1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET ec2
	call	WriteString
	call	CrLf

;Get user's name
	mov		edx, OFFSET prompt_1
	call	WriteString
	mov		edx, OFFSET	userName
	mov		ecx, 32
	call	ReadString

;Greet user
	mov		edx, OFFSET greeting
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	call	CrLf
	call	CrLf

;Display instructions
instructions:
	mov		edx, OFFSET instructions_1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET instructions_2
	call	WriteString
	call	CrLf
	call	CrLf

;Repeatedly prompt user to enter number [-100, -1] while counting/accumulating
promptNumber:	
	mov		eax, numCount
	inc		eax
	call	WriteDec
	mov		edx, OFFSET prompt_2
	call	WriteString
	call	ReadInt
	mov		num, eax

	mov		eax, 0			;validate for negatives
	cmp		num, eax
	jl		negGood	
checkCount:
	cmp		numCount, 0		;check count, if 0 end program. If not, calculate based on numbers
	jnz		calculate
	mov		edx, OFFSET	noNegs
	call	WriteString
	call	CrLf
	jmp		bye

negGood:
	mov		eax, num		;number is negative, but is it less than -100? if so, repeat instructions
	cmp		eax, LOWER_LIMIT
	jl		instructions
	inc		numCount		;count the number as valid
	mov		eax, num		;add number to our sum
	add		sum, eax 
	jmp		promptNumber

;Calculate rounded integer average of negative numbers
calculate:
	mov		edx, 0
	mov		eax, sum
	cdq
	idiv	numCount
	mov		avg, eax
	mov		remainder, edx

;Display number of negative numbers entered
	mov		edx, OFFSET info_1
	call	WriteString
	mov		eax, numCount
	call	WriteDec
	mov		edx, OFFSET info_2
	call	WriteString
	call	CrLf

;Display sum of negative numbers entered
	mov		edx, OFFSET sum_info_1
	call	WriteString
	mov		eax, sum
	call	WriteInt
	call	CrLf

;Display average, rounded to .001
	mov		edx, OFFSET round_info_1
	call	WriteString
	mov		eax, avg
	call	WriteInt

	mov		edx, OFFSET decimal			;display manitissa
	call	WriteString
	mov		eax, remainder
	imul	negTen
	div		numCount					;tenth
	mov		avg, eax
	call	WriteDec
	mov		remainder, edx
	mov		eax, remainder
	mul		ten		
	div		numCount					;hundredth
	mov		avg, eax
	call	WriteDec
	mov		remainder, edx
	mov		eax, remainder	
	mul		ten		
	div		numCount					;thousandth
	mov		lastNum, eax
	mov		remainder, edx
	mov		eax, remainder	
	mul		ten		
	div		numCount					;ten-thousandth
	mov		avg, eax
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

;Display parting message w/ user's name
bye:
	mov		edx, OFFSET goodBye
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	call	CrLf

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
