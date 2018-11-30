TITLE Program Template     (template.asm)

; Author: Kevin Harvell
; Last Modified: 10/8/2018
; OSU email address: harvellk@oregonstate.edu
; Course number/section: CS340/400
; Project Number: Project #2        Due Date: 10/14/2018
; Description: This program displays the title and my name, gets the user's name and greets him/her,
;	prompts the user to enter the number of Fibonacci terms to be displayed [1, 46],
;	validates input, calculates and displays all the Fibonacci numbers(5 terms per line),
;	then finally says goodbye including the user's name.

INCLUDE Irvine32.inc

LOWER_LIMIT = 0
UPPER_LIMIT = 46

.data
userName		BYTE	33 DUP(0)			;string for user's name
numFibs			DWORD	?					;number of Fibonacci terms to be displayed
randVal			DWORD	?					;random number for random colors
fibNum			DWORD	1					;n-1 fib number placeholder
buffer1			BYTE	"	", 0		;space buffer, 2 tabs
buffer2			BYTE	"		", 0	;space buffer, 3 tabs
column_count	DWORD	0					;counts columns for moving to new row
row_count		DWORD	1					;counts rows for column spacing
num_columns		DWORD	5					;# of columns per row
intro_1			BYTE	"Fibonacci Numbers by Kevin Harvell", 0
ec1				BYTE	"**EC#1: Display the numbers in aligned columns", 0
ec2				BYTE	"**EC#2: Do something incredible? Fib #'s are in random colors, and separate procedures(not required)", 0
prompt_1		BYTE	"What's your name? ", 0
greeting		BYTE	"Hello, ", 0
instructions_1	BYTE	"Enter the number of Fibonacci terms to be displayed", 0
instructions_2	BYTE	"Give the number as an integer in the range [1 .. 46].", 0
prompt_2		BYTE	"How many Fibonacci terms do you want? ", 0
range_err		BYTE	"Out of range. Enter a number in [1 .. 46]", 0
certified		BYTE	"Results certified by Kevin Harvell", 0
goodBye			BYTE	"Goodbye, ", 0


.code

main PROC
;Seed Random numbers
	call	Randomize

;Introduce programmer and program title
introduction:
	mov		edx, OFFSET intro_1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET ec1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET ec2
	call	WriteString
	call	CrLf
	call	CrLf

;Get user's name
	mov		edx, OFFSET prompt_1
	call	WriteString
	mov		edx, OFFSET userName
	mov		ecx, 32
	call	ReadString
	call	CrLf

;Greet user
	mov		edx, OFFSET greeting
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	call	CrLf

;Prompt user to enter # of Fibonacci terms to be displayed [1, 46]
userInstructions:
	mov		edx, OFFSET instructions_1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET	instructions_2
	call	WriteString
	call	CrLf
	call	CrLf
getUserData:
	mov		edx, OFFSET prompt_2
	call	WriteString
	call	ReadInt
	mov		numFibs, eax

;Validate user input
	cmp		numFibs, UPPER_LIMIT
	jg		rangeError
	cmp		numFibs, LOWER_LIMIT
	jle		rangeError
	jmp		displayFibs
rangeError:
	mov		edx, OFFSET range_err
	call	WriteString
	call	CrLf
	jmp		getUserData

;Calculate and display Fibonacci numbers
displayFibs:
	mov		ebx, 0
	mov		ecx, numFibs
L1:
	mov		eax, ebx
	add		eax, fibNum
	call	randomColor
	call	WriteDec				;Display fib #
	mov		fibNum, ebx
	mov		ebx, eax
	call	columnRowCheck
	loop	L1
	call	CrLf

;Say goodbye, including username
farewell:
	mov		eax, 15
	call	SetTextColor
	call	CrLf
	mov		edx, OFFSET certified
	call	WriteString
	call	CrLf
	mov		edx, OFFSET goodBye
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	call	CrLf

	exit	; exit to operating system
main ENDP

;--------------------------------------------------------------------
; columnRowCheck
; Keeps track of column count so that program knows to go to next
; line after 5 numbers, and skips to next line. Also controls the 
; buffer amount based on row # so that the columns are aligned.
; Receives: N/A
; Returns: N/A
;--------------------------------------------------------------------

columnRowCheck PROC USES eax edx
	inc		column_count
	mov		edx, 0
	mov		eax, column_count
	div		num_columns
	cmp		edx, 0
	jne		noNextLine
	inc		row_count
	call	CrLf
	jmp		finish
noNextLine:
	cmp		row_count, 7
	jle		bufferMore
bufferLess:
	mov		edx, OFFSET buffer1		;Buffer with tabs
	call	WriteString
	jmp		finish
bufferMore:
	mov		edx, OFFSET buffer2		;Buffer with tabs
	call	WriteString
finish:
	ret
columnRowCheck ENDP

;--------------------------------------------------------------------
; randomColor
; Assigns randVal a random color integer from 0-14, then adds 1. 
; Then sets the text color to that random color.
; Receives: N/A
; Returns: N/A
;--------------------------------------------------------------------

randomColor PROC USES eax
	mov		eax, 15
	call	RandomRange
	mov		randVal, eax
	inc		randVal
	mov		eax, randVal
	call	SetTextColor
	ret
randomColor	ENDP

END main
