TITLE Program #5    (HarvellKevin-Prog5.asm)

; Author: Kevin Harvell
; Last Modified: 11/11/2018
; OSU email address: harvellk@oregonstate.edu
; Course number/section: CS271/400
; Project Number: Program #5        Due Date: 11/18/18
; Description: This program gets a user request in [10, 200], then generates that many random integers in the user
; requested range [100, 999], storing them in consecutive elements in an array. It displays the array 10 numbers 
; per line, then sorts in descending order, and calculates the median.

INCLUDE Irvine32.inc

MIN = 10
MAX = 200
LO = 100
HI = 999

.data
request		DWORD	?
array		DWORD	MAX DUP(?)
intro_1		BYTE	"Sorting Random Integers		Programmed by Kevin Harvell", 0
intro_2		BYTE	"This program generates random numbers in the range [100 .. 999]", 0
intro_3		BYTE	"displays the original list, sorts the list, and calculates the", 0
intro_4		BYTE	"median value. Finally, it displays the list sorted in descending order.", 0
prompt_1	BYTE	"How many numbers should be generated? [10 .. 200]: ", 0
inpErr		BYTE	"Invalid Input", 0
results_1	BYTE	"The unsorted random numbers: ", 0
results_2	BYTE	"The median is ", 0
results_3	BYTE	"The sorted list: ", 0
spcBuff		BYTE	"	", 0

.code
main PROC
	call	Randomize					;seed random numbers

	push	OFFSET intro_1				;push introduction strings onto stack
	push	OFFSET intro_2
	push	OFFSET intro_3
	push	OFFSET intro_4
	call	introduction

	push	OFFSET request
	call	getData

	push	OFFSET array				;fill array with random numbers
	push	request
	call	fillArray

	push	OFFSET results_1			;display array contents after filled
	push	OFFSET spcBuff				
	push	OFFSET array				
	push	request
	call	displayList

	push	OFFSET array				;sort the array using bubble sort
	push	request
	call	sortList
	
	push	OFFSET results_2			;find the median of sorted array
	push	OFFSET array				
	push	request
	call	displayMedian

	push	OFFSET results_3			;display array contents after sorted
	push	OFFSET spcBuff				
	push	OFFSET array				
	push	request
	call	displayList

	exit	; exit to operating system
main ENDP

;--------------------------------------------------------------------------------------------
;introduction
;Introduces Program and Programmer
;Receives: @intro_1, @intro_2, @intro_3, @intro_4
;Returns: N/A
;--------------------------------------------------------------------------------------------
introduction PROC
	push	ebp
	mov		ebp, esp
	mov		edx, [ebp + 20]
	call	WriteString
	call	CrLf
	mov		edx, [ebp + 16]
	call	WriteString
	call	CrLf
	mov		edx, [ebp + 12]
	call	WriteString
	call	CrLf
	mov		edx, [ebp + 8]
	call	WriteString
	call	CrLf
	call	CrLf
	pop		ebp
	ret		16
introduction ENDP

;--------------------------------------------------------------------------------------------
;getData
;Gets a user request in the range [10, 200]
;Receives: @request
;Returns: N/A
;--------------------------------------------------------------------------------------------
getData PROC
	push	ebp
	mov		ebp, esp
	mov		ebx, [ebp + 8]				;set ebx = @request
tryAgain:
	mov		edx, OFFSET prompt_1
	call	WriteString					;ask for number of integers for array
	call	ReadInt
	cmp		eax, MIN
	jl		invalid
	cmp		eax, MAX
	jg		invalid
	jmp		inputGood

invalid:
	mov		edx, OFFSET inpErr
	call	WriteString
	call	CrLf
	jmp		tryAgain

inputGood:
	mov		[ebx], eax					;set request = input
	call	CrLf
	pop		ebp
	ret 4
getData ENDP


;--------------------------------------------------------------------------------------------
;fillArray
;Fills the array with random numbers [lo, hi]
;Code borrowed and modified from Lecture 19 video
;Receives: request, @array
;Returns: N/A
;--------------------------------------------------------------------------------------------
fillArray PROC
	push	ebp
	mov		ebp, esp
	mov		edi, [ebp + 12]				;@array in edi
	mov		ecx, [ebp + 8]				;value of request in ecx
more1:
	mov		eax, hi
	sub		eax, lo
	inc		eax
	call	RandomRange
	add		eax, lo
	mov		[edi], eax
	add		edi, 4
	loop	more1

	pop		ebp
	ret 8
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

;--------------------------------------------------------------------------------------------
;sortList
;Sorts list using a bubble sort
;Code borrowed from Kip Irvine - Assembly Language for x86 Processors
;Receives: @array, request
;Returns: N/A
;--------------------------------------------------------------------------------------------
sortList PROC
	push	ebp
	mov		ebp, esp
	mov		ecx, [ebp + 8]				;value of request in ecx
	dec		ecx							;decrement request by 1
L1:
	push	ecx
	mov		esi, [ebp + 12]				;point to first value of array
L2:
	mov		eax, [esi]					;get array value
	cmp		[esi + 4], eax				;compare a pair of values
	jl		L3							;if [ESI] >= [ESI + 4], no exchange
	push	esi
	call	exchange
L3:
	add		esi, 4						;move both pointers forward
	loop	L2							;inner loop

	pop		ecx							;retrieve outer loop count
	loop	L1							;else repeat outer loop
L4:
	pop		ebp
	ret 8
sortList ENDP

;--------------------------------------------------------------------------------------------
;exchange
;Exchanges two numbers
;Code borrowed from Kip Irvine - Assembly Language for x86 Processors
;Receives: esi
;Returns: N/A
;--------------------------------------------------------------------------------------------
exchange PROC
	push	ebp
	mov		ebp, esp
	mov		esi, [ebp + 8]				;move pointer to array value into esi
	mov		eax, [esi]					;get array value
	xchg	eax, [esi + 4]				;exchange the pair
	mov		[esi], eax
	pop		ebp
	ret		4
exchange ENDP


;--------------------------------------------------------------------------------------------
;displayMedian
;Find and displays the median of the array
;Receives: @array, request, @results_2(to display title)
;Returns: N/A
;--------------------------------------------------------------------------------------------
displayMedian PROC
	push	ebp
	mov		ebp, esp
	mov		edx, [ebp + 16]				;display "the median is" text
	call	WriteString

	mov		eax, [ebp + 8]				;move count into eax for division by 2 to check even/odd
	mov		edx, 0
	mov		ebx, 2
	div		ebx
	cmp		edx, 0
	je		isEven
	jmp		isOdd
isEven:
	sub		eax, 1						;subtract 1 from the quotient to get the zero-indexed ele
	mov		ebx, 4						;multiply quotient by DWORD byte size of 4
	mul		ebx
	mov		esi, [ebp + 12]				;point to first value of array
	add		esi, eax					;find the first middle element
	mov		eax, [esi]
	add		eax, [esi + 4]				;add two middle numbers together for average
	mov		edx, 0						;rounding
	mov		ebx, 2
	div		ebx
	cmp		edx, 0
	je		writeNum
	inc		eax							;round up
writeNum:
	call	WriteDec					;write the median
	jmp		medianFound
isOdd:
	mov		ebx, 4						;multiply quotient by DWORD byte size of 4
	mul		ebx
	mov		esi, [ebp + 12]				;point to first value of array
	add		esi, eax					;find the median element
	mov		eax, [esi]					;write the median
	call	WriteDec
medianFound:
	call	CrLf
	call	CrLf
	pop		ebp
	ret 12
displayMedian ENDP

END main
