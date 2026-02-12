.model tiny
.code 

org 100h

DRAW_COL macro height, pos_x, pos_y
	mov bx, height
	mov cx, pos_x
	mov di, pos_y
	call draw_column
ENDM

MUL_R macro mlp1, mlp2
	push ax
	mov ax, mlp1
	mul mlp2
	mov mlp1, ax
	pop ax
ENDM

DRAW_STR macro length, pos_x, pos_y
	mov bx, length
	mov cx, pos_x
	mov di, pos_y
	call draw_string
ENDM
	
DRAW macro length, height, pos_x, pos_y
	
	DRAW_STR length, pos_x, pos_y
	DRAW_COL height, pos_x, pos_y

	Sum_y = pos_y + height - 1
	Sum_x = pos_x + length - 1

	DRAW_STR length, pos_x, Sum_y 
	DRAW_COL height, Sum_x, pos_y

	BEG = (Sum_y + pos_y) / 2 * 160 + pos_x * 2 + length - 6 + (length and 1) ; -6 + остаток от деления на 2
	ENDM

;очистка дисплея
;INT 10H 006H

Start: 
	;переход в сегмент видеопамяти
	mov ax, 0B800h
	mov es, ax					
	
	DRAW 30, 5, 10, 3

;	DRAW_STR 10, 5, 3
;	DRAW_COL 6,  10, 0
;
;	DRAW_STR 29, 10, 5
;	DRAW_COL 6,  40, 0

	
	push cx
	push di
	xor cx, cx
	xor di, di  	
	mov cl, ds:80h
	dec cl
	mov si, 82h ; вот тут могут быть проблемы
	;BEG equ 5 * 160 + 40
	mov di, cx
	shr di, 2
	shl di, 1
	neg di
	add di, 2
	add di, BEG
	;mov di, BEG ; начало вывода
	mov ah, (1Fh or 88h) ;задаем цвет на все ячейки
	L:
		lodsb	
		stosw
		loop L

	pop di 
	pop cx

	DRAW 8, 3, 1, 1

	mov ah, 4ch
	int 21h

	

	draw_string proc																																																																									 																																																																						 																																																										

		;mov word ptr es: [bx+160*4l + 80], (4e03h or 8000h)	
		;mov bx, 80 ;счетчик

		;cx pos_x
		;di pos_y
		dec bx
		shl cx, 1	; умножение на 2 (2 байта на символ)	
		shl bx, 1	; умножение на 2 (2 байта на символ)

	;=====умножение смещения y на 160=======
		shl di, 5 
		push bx
		mov bx, di
		shl di, 2
		add di, bx
		pop bx
	;=================================
		add di, cx
		;add bx, cx
		; переписать вывод строки!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		string:
			mov word ptr es:[bx + di], (1F03h or 8000h)
			dec bx
			dec bx
			cmp bx, 0
			jge string

		ret;
	draw_string endp

	draw_column proc
		;cx pos_x
		;di pos_y
		dec bx
		shl cx, 1	; умножение на 2 (2 байта на символ)
		shl bx, 1	; умножение на 2 (2 байта на символ)

		;=====умножение смещения на 160=======
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
		print_column:
			mov word ptr es:[bx + di], (1F03h or 8000h)
			sub bx, 160
			;dec bx   
			cmp bx, 0
			jge print_column

		ret;

	draw_column endp

end 	Start