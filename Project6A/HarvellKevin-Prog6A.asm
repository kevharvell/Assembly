TITLE Program #6A     (HarvellKevin-Prog6A.asm)

; Author: Kevin Harvell
; Last Modified: 11/24/2018
; OSU email address: harvellk@oregonstate.edu
; Course number/section: CS271/400
; Project Number: Program #6A         Due Date: 11/24/2018
; Description: This program implements ReadVal/WriteVal procedures for unsigned integers.
; It also implements macros for getString/displayString. It tests these functions using 10
; valid integers from the user and stores the numeric values in an array. It then displays
; the integers, their sum and average.

INCLUDE Irvine32.inc

ARRAY_SIZE = 10
MAX_LENGTH = 10				;Variable for the max length of a 32-bit number

;--------------------------------------------------------------------------------------------
;MACRO: displayString
;Displays the string in a memory location
;borrowed/modified from Lecture #26
;Receives: @strRef
;--------------------------------------------------------------------------------------------
displayString MACRO strRef
	push	edx
	mov		edx, strRef
	call	WriteString
	pop		edx
ENDM

;--------------------------------------------------------------------------------------------
;MACRO: getString
;Gets a string from a user and stores it in inputVarRef. Takes a reference to the input 
;variable and size of the variable; borrowed/modified from Lecture #26
;Receives: @inputVarRef, @varSize
;--------------------------------------------------------------------------------------------
getString MACRO inputVarRef, varSize
	push	ecx
	push	edx
	push	ebx
	mov		edx, inputVarRef
	mov		ebx, [varSize]
	dec		ebx
	mov		ecx, [ebx]
	call	ReadString
	pop		ebx
	pop		edx
	pop		ecx
ENDM


.data
userInput	BYTE	33 DUP(?)			;string for user input
inputSize	DWORD	SIZEOF userInput-1	;variable to keep track of SIZE OF userInput
validNum	DWORD	0					;number converted from string
reverseStr	BYTE	11 DUP(?)			;string to handle reversed string
stringNum	BYTE	11 DUP(?)			;string for number conversion
array		DWORD	ARRAY_SIZE DUP(?)	;array for the 10 integers entered by user
sum			DWORD	0					;sum variable for the sum of the 10 integers
avg			DWORD	?					;average variable for the average of the 10 integers
intro_1		BYTE	"PROGRAMMING ASSIGNMENT 6A: Designing low-level I/O procedures", 0
intro_2		BYTE	"Written by: Kevin Harvell", 0
instruct_1	BYTE	"Please provide 10 unsigned decimal integers.", 0
instruct_2	BYTE	"Each number needs to be small enough to fit inside a 32 bit register.", 0
instruct_3	BYTE	"After you have finished inputting the raw numbers I will display a list", 0
instruct_4	BYTE	"of the integers, their sum, and their average value.", 0
prompt_1	BYTE	"Please enter an unsigned number: ", 0
prompt_2	BYTE	"Please try again: ", 0
errMsg		BYTE	"ERROR: You did not enter an unsigned number or your number was too big.", 0
results_1	BYTE	"You entered the following numbers: ", 0
results_2	BYTE	"The sum of these numbers is: ", 0
results_3	BYTE	"The average is: ", 0
comma		BYTE	", ", 0
thanks		BYTE	"Thanks for playing!", 0

.code
main PROC

; introduction 
	push	OFFSET intro_1
	push	OFFSET intro_2
	call	introduction
; instructions
	push	OFFSET instruct_1
	push	OFFSET instruct_2
	push	OFFSET instruct_3
	push	OFFSET instruct_4
	call	instructions
; get 10 valid integers from user and store in an array
	push	OFFSET array
	push	OFFSET validNum
	push	OFFSET userInput
	push	OFFSET inputSize
	push	OFFSET prompt_1
	push	OFFSET prompt_2
	push	OFFSET errMsg
	call	fillArray
;test display string
	displayString OFFSET userInput
;test display validNum
	call	CrLf
	mov		eax, validNum
	call	WriteDec
;test writeVal
	call	CrLf
	push	OFFSET reverseStr
	push	OFFSET validNum
	push	OFFSET stringNum
	call	writeVal
; display the integers
; display the sum of integers

; display the average of integers


	exit	; exit to operating system
main ENDP

;--------------------------------------------------------------------------------------------
;introduction
;Introduces Program and Programmer
;Receives: @intro_1, @intro_2
;Returns: N/A
;--------------------------------------------------------------------------------------------
introduction PROC
	push	ebp
	mov		ebp, esp
	displayString [ebp + 12]
	call	CrLf
	displayString [ebp + 8]
	call	CrLf
	call	CrLf
	pop		ebp
	ret		8
introduction ENDP

;--------------------------------------------------------------------------------------------
;instructions
;Displays instructions to user
;Receives: @instruct_1, @instruct_2, @instruct_3, @instruct_4
;Returns: N/A
;--------------------------------------------------------------------------------------------
instructions PROC
	push	ebp
	mov		ebp, esp
	displayString [ebp + 20]
	call	CrLf
	displayString [ebp + 16]
	call	CrLf
	displayString [ebp + 12]
	call	CrLf
	displayString [ebp + 8]
	call	CrLf
	call	CrLf
	pop		ebp
	ret		16
instructions ENDP

;--------------------------------------------------------------------------------------------
;readVal
;Prompts user for unsigned integers. Validates to ensure that the string is a number and
;not too large. Stores validated integer in validNum.
;Receives: @validNum, @userInput, @inputSize, @prompt_1, @prompt_2, @errMsg 
;Returns: N/A
;--------------------------------------------------------------------------------------------
readVal PROC
	push	ebp
	mov		ebp, esp
	pushad
	displayString [ebp + 16]				;ask for a string to convert to number
	getString [ebp + 24], [ebp + 20]		;store string in userInput variable
	
tryAgain:
; Set up loop counter, put string addresses in source can index registers, and clear direction
; flag; code borrowed/modified from demo6.asm
	cmp		eax, MAX_LENGTH					; Check to see if string length is < 10 digits
	jg		notNum
	mov		ecx, eax						;set loop counter
	mov		ebx, 1							;tens multiplier to convert strings to decimal
	mov		esi, [ebp + 24]					;point to front of string
	add		esi, ecx						;add number of characters, pointing to '\0'
	dec		esi								;decrement to get to last character
	cld
	std										;move through string from back to front
counter:
	lodsb
	cmp		al, 48							; '0' is character 48
	jb		notNum
	cmp		al, 57							; '9' is character 57
	ja		notNum
	jmp		numGood
notNum:
	push	eax
	push	ebx
	mov		eax, [ebp + 28]					;move @validNum variable to edx
	mov		ebx, 0							;reset validNum to 0
	mov		[eax], ebx
	pop		ebx
	pop		eax

	displayString [ebp + 8]					;error message
	call	CrLf
	displayString [ebp + 12]				;ask for a number again
	getString [ebp + 24], [ebp + 20]		;store string in userInput variable
	jmp		tryAgain
numGood:
	mov		edi, [ebp + 28]					;move validNum variable to edx
	sub		al, 48							;convert string to integer
	movzx	eax, al
	mul		ebx								;multiply by 10s multiplier
	add		[edi], eax						;add number in eax to validNum variable
	mov		eax, ebx						;multiply 10s multiplier by 10
	jc		notNum							;check for carry flag, if so, error message
	mov		edx, 10
	mul		edx
	mov		ebx, eax
	loop	counter

	call	CrLf
	popad
	pop		ebp
	ret		24
readVal ENDP

;--------------------------------------------------------------------------------------------
;writeVal
;Converts a numeric value to a string of digits, and invokes the displayString macro to
;produce the output.
;Receives: @reverseStr, @validNum, @stringNum
;Returns: N/A
;--------------------------------------------------------------------------------------------
writeVal PROC
	push	ebp
	mov		ebp, esp
	pushad
	mov		edi, [ebp + 12]			;@validNum to convert to string
	mov		eax, [edi]				;validNum
	mov		edi, [ebp + 16]			;@reverseStr to store backwards converted number
	mov		ecx, 0					;digit count
	cld
convertNums:
	mov		edx, 0					;clear edx for division
	mov		ebx, MAX_LENGTH			;dividing by 10
	div		ebx						;divide number by 10
	mov		ebx, edx				;remainder
	add		ebx, 48					;get ASCII code
	push	eax						;push quotient to continue later
	mov		eax, ebx				;move char to eax for stosb
	stosb
	pop		eax						;carry on dividing
	inc		ecx						;increment digit count
	cmp		eax, 0					;if quotient is 0, done converting
	je		done
	jmp		convertNums				;repeat
done:
	stosb							;0 for end of string
  
	mov		esi, [ebp + 16]			;Reverse the string
	add		esi, ecx				;Code borrowed/modified from demo6.asm
	dec		esi
	mov		edi, [ebp + 8]
reverseString:
	std
	lodsb
	cld
	stosb
	loop	reverseString

	displayString [ebp + 8]
	popad
	pop		ebp
	ret		12
writeVal ENDP

;--------------------------------------------------------------------------------------------
;fillArray
;Fills the array with ARRAY_SIZE numbers.
;Code borrowed and modified from Lecture 19 video
;Receives: @array, @validNum, @userInput, @inputSize, @prompt_1, @prompt_2, @errMsg
;Returns: N/A
;--------------------------------------------------------------------------------------------
fillArray PROC
	push	ebp
	mov		ebp, esp
	mov		edi, [ebp + 32]				;@array in edi
	mov		ecx, ARRAY_SIZE				;value of request in ecx
more1:
	push	[ebp + 28]					;@validNum
	push	[ebp + 24]					;@userInput
	push	[ebp + 20]					;@inputSize
	push	[ebp + 16]					;@prompt_1
	push	[ebp + 12]					;@prompt_2
	push	[ebp + 8]					;@errMsg
	call	readVal
	mov		eax, [ebp + 28]				;store value from readVal into array
	mov		ebx, [eax]
	mov		[edi], ebx 
	add		edi, 4						;increment array

	mov		ebx, 0						;reset validNum to 0					
	mov		[eax], ebx
	loop	more1

	pop		ebp
	ret 28
fillArray ENDP


;--------------------------------------------------------------------------------------------
;displayList
;Displays the contents of an array 10 per line
;Code borrowed from Lecture 20 video
;Receives: @array, request, @results_1/@results_2(to display title), @spcBuff
;Returns: N/A
;--------------------------------------------------------------------------------------------
displayList PROC
	push	ebp
	mov		ebp, esp
	mov		ebx, 0						;counter for 10 numbers per line
	mov		esi, [ebp + 12]				;@array in esi
	mov		ecx, [ebp + 8]				;value of request in ecx
	mov		edx, [ebp + 20]				;display title for list of data
	call	WriteString
	call	CrLf
	mov		edx, [ebp + 16]				;move space buffer into edx to space numbers
more2:
	mov		eax, [esi]					;get current element
	call	WriteDec
	call	WriteString
	inc		ebx
	cmp		ebx, 10
	je		newLine
	jmp		continue
newLine:
	mov		ebx, 0						;reset counter to 0
	call	Crlf
continue:
	add		esi, 4						;next element
	loop	more2
endMore:
	call	CrLf
	call	CrLf
	pop		ebp
	ret 16
displayList ENDP

END main
