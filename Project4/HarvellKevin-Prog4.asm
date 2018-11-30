TITLE Program #4   (HarvellKevin-Prog4.asm)

; Author: Kevin Harvell
; Last Modified: 10/27/2018
; OSU email address: harvellk@oregonstate.edu
; Course number/section: CS271/400
; Project Number: Program #4         Due Date: 11/4/2018
; Description: This program calculates n composite numbers where n is specified by the user.

INCLUDE Irvine32.inc

UPPER_LIMIT = 400

.data
numCount		DWORD	?
tempNum			DWORD	4		;first valid composite number
divisor			DWORD	2		;divisor to check for composites, will increase
colCount		DWORD	0		;keeps track of how many numbers there are in a row
num_cols		DWORD	10		;constant to keep 10 numbers per row
buffer			BYTE	"	", 0
ec1				BYTE	"**EC1: Align the output columns", 0
intro_1			BYTE	"Composite Numbers		Programmed by Kevin Harvell", 0
instructions_1	BYTE	"Enter the number of composite numbers you would like to see.", 0
instructions_2	BYTE	"I'll accept orders for up to 400 composites.", 0
prompt_1		BYTE	"Enter the number of composites to display [1 .. 400]: ", 0
out_of_range	BYTE	"Out of range. Try again.", 0
goodBye			BYTE	"Results certified by Kevin Harvell. Goodbye.", 0

.code
main PROC
	call	introduction
	call	instructions
	call	getUserData
	call	showComposites
	call	farewell
	exit	; exit to operating system
main ENDP

;-------------------------------------------------------------
;introduction
;Introduces Program and Programmer
;Receives: N/A
;Returns: N/A
;-------------------------------------------------------------
introduction PROC
	mov		edx, OFFSET intro_1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET ec1
	call	WriteString
	call	CrLf
	call	CrLf
	ret
introduction ENDP

;-------------------------------------------------------------
;instructions
;Displays instructions to user
;Receives: N/A
;Returns: N/A
;-------------------------------------------------------------
instructions PROC
	mov		edx, OFFSET instructions_1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET instructions_2
	call	WriteString
	call	CrLf
	call	CrLf
	ret
instructions ENDP

;-------------------------------------------------------------
;getUserData
;Get user data - n composite numbers
;Receives: N/A
;Returns: N/A
;-------------------------------------------------------------
getUserData PROC
	mov		edx, OFFSET prompt_1
	call	WriteString
	call	ReadInt
	mov		numCount, eax
	call	validate
	call	CrLf
	ret
getUserData ENDP

;-------------------------------------------------------------
;validate
;Validates n is between [1, 400]
;Receives: numCount
;Returns: N/A
;-------------------------------------------------------------
validate PROC
	mov		eax, 1
	cmp		numCount, eax
	jl		invalid
	mov		eax, UPPER_LIMIT
	cmp		numCount, eax
	jg		invalid
	ret

	invalid:
		mov		edx, OFFSET out_of_range
		call	WriteString
		call	CrLf
		call	getUserData
	ret	
validate ENDP

;-------------------------------------------------------------
;showComposites
;Calculate and display all of the composite numbers up to n
;Receives: numCount
;Returns: N/A
;-------------------------------------------------------------
showComposites PROC
	mov		ecx, numCount
	L1:
		call	isComposite
		mov		eax, tempNum
		call	WriteDec
		mov		edx, OFFSET buffer
		call	WriteString
		inc		colCount
		inc		tempNum
		mov		edx, 0				;Check if there are 10 numbers in row
		mov		eax, colCount
		div		num_cols
		cmp		edx, 0
		jne		noNextLine
		call	CrLf
		noNextLine:
			loop	L1
		call	CrLf
		call	CrLf
	ret
showComposites ENDP

;-------------------------------------------------------------
;isComposite
;Determines if a number is composite
;Receives: tempNum
;Returns: tempNum
;-------------------------------------------------------------
isComposite PROC USES ecx
	mov		ecx, tempNum
	sub		ecx, 1
	compositeLoop:
		cmp		ecx, 1
		je		noComposite
		mov		eax, tempNum
		mov		edx, 0
		div		ecx
		cmp		edx, 0
		jz		exitLoop
		loop	compositeLoop
	noComposite:
		inc		tempNum
		call	isComposite
	exitLoop:
		ret
isComposite ENDP

;-------------------------------------------------------------
;farewell
;Say goodbye
;Recieves: N/A
;Returns: N/A
;-------------------------------------------------------------
farewell PROC
	mov		edx, OFFSET goodBye
	call	WriteString
	call	CrLf
	ret
farewell ENDP

END main
