.model tiny
.code 

org 100h

local @@

;===========================================================================
;DESTR: ax, bx, cx, di
;===========================================================================

; можно передавать аргументом символа его адрес в памяти

; надо написать процедуру, которая считывает число из командной строки

DRAW_COL macro height, pos_x, pos_y, symbol
	mov bx, height
	mov cx, pos_x
	mov di, pos_y

	; mov ax, symbol
	; push ax

	call draw_column
ENDM

;===========================================================================
;DESTR: ax, bx, cx, di
;===========================================================================
; 9F96
DRAW_STR macro length, pos_x, pos_y, symbol
	mov  bx, length
	mov  cx, pos_x
	mov  di, pos_y

	; mov  ax, symbol
	; push ax

	call draw_string
ENDM
	
DRAW_FRAME macro length, height, pos_x, pos_y, symbol
	
	shl dx, 1 ; arr of words
	lea bx, Symbol_arr
	add bx, dx

	push cx
	push [bx]
	
	DRAW_STR length, pos_x, pos_y, symbol
	DRAW_COL height, pos_x, pos_y, symbol

	Sum_y = pos_y + height - 1
	Sum_x = pos_x + length - 1

	DRAW_STR length, pos_x, Sum_y, symbol 
	DRAW_COL height, Sum_x, pos_y, symbol

	add sp, 2
	pop cx
 
ENDM

DRAW_FRAME_WORD macro length, height, pos_x, pos_y, symbol

	call get_num_from_command ; получаем индекс в массиве символов
	DRAW_FRAME length, height, pos_x, pos_y, symbol
	BEG = (Sum_y + pos_y) / 2 * 160 + pos_x * 2 + length

ENDM

;очистка экрана
;INT 10H 006H

Start: 
	;
	mov ax, 0B800h
	mov es, ax					
	
	; Подумать как можно передавать символ для всех рамок


	mov cl, ds:80h
	mov si, 82h
	;mov di, cx

	DRAW_FRAME_WORD 30, 5, 10, 3, 2

	call print_word_in_frame

	;pop bx
;	DRAW_STR 10, 5, 3, 1F03h
;	DRAW_COL 6,  10, 0, 1F03h
;
;	DRAW_STR 29, 10, 5
;	DRAW_COL 6,  40, 0	




	;DRAW_FRAME 8, 3, 1, 1, 1F03h or 8080h

	mov ah, 4ch
	int 21h

	Symbol_arr dw 1F03h, 4E03h, 8B55h, 04C5h


	draw_string proc																																																																									 																																																																						 																																																										
		push bp
		mov bp, sp
		add bp, 4
		;mov word ptr es: [bx+160*4l + 80], (4e03h or 8000h)	
		;mov bx, 80 ;

		;cx pos_x
		;di pos_y
		dec bx
		shl cx, 1	;	
		shl bx, 1	;

	;===== Умножение смещения на 160=======
		shl di, 5 
		push bx
		mov bx, di
		shl di, 2
		add di, bx
		pop bx
	;=================================
		add di, cx
		;add bx, cx
		
		push cx
		xor cx, cx
		mov word ptr cx, [bp]

		string:
			mov word ptr es:[bx + di], cx
			dec bx
			dec bx
			cmp bx, 0
			jge string

		pop cx

		pop bp

		ret 

	draw_string endp

	draw_column proc
		push bp
		mov bp, sp
		add bp, 4 ; пропускаем адрес возврата

		;cx pos_x
		;di pos_y
		dec bx
		shl cx, 1	; 2 байта на символ
		shl bx, 1	; 2 байта на символ

		;===== Умножение смещения y на 160=======
		shl di, 5 
		push bx
		mov bx, di
		shl di, 2
		add di, bx
		pop bx
		;=====================================

		push ax
		push cx
		mov ax, bx
		mov cx, 80
		mul cx
		mov bx, ax
		pop cx
		pop ax

		add di, cx

		push cx
		mov word ptr cx, [bp]

		print_column:
			mov word ptr es:[bx + di], cx
			sub bx, 160
			;dec bx   
			cmp bx, 0
			jge print_column

		pop cx
		pop bp

		ret


	draw_column endp
;====================================================================
;Start:	
;   cx - counter of symbols 
;	si - adress of string
;Return: ax - число
;Destr: cx, di, si
;====================================================================
	print_word_in_frame proc
			; push cx
			dec cx
			push di
			add si, 1 ; skip_space
			;xor cx, cx
			xor di, di  	
			;mov cl, ds:80h

			cmp cl, 0
			je @@return

			dec cl
			;mov si, 82h 
			;BEG equ 5 * 160 + 40
			mov di, cx
			shr di, 2
			shl di, 1
			neg di
			sub di, 2
			add di, BEG
			;mov di, BEG ;  
			mov ah, (1Fh or 88h) ;
			L:
				lodsb	
				stosw
				loop L

			@@return:
			pop di
			; pop cx 
			ret
	endp					

;====================================================================
; Start:  cx - number of symbols
;		  si - adress of string
; Destr:  cx, si, dx, ax
; Return: dx - число
;====================================================================
	get_num_from_command proc
		cmp byte ptr[si], ' '
		je @@return
		xor ax, ax
		xor dx, dx

		 @@digit:
			lodsb

			push cx
			mov cx, dx
			shl dx, 3
			add dx, cx
			add dx, cx
			pop cx

			;sub ax, '0'
			and al, 0fh
			add dx, ax
			dec cx

			cmp byte ptr [si], ' '
			jne @@digit

		@return:
		ret
	endp


end 	Start