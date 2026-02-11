.model tiny
.code 

org 100h

DRAW macro length, pos_x, pos_y
	mov bx, length
	mov cx, pos_x
	mov di, pos_y
	call draw_string
ENDM
	
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
Start: 
	;переход в сегмент видеопамяти
	mov ax, 0B800h
	mov es, ax					
	
	DRAW 	 29, 10, 0
	DRAW_COL 6,  10, 0

	DRAW     29, 10, 5
	DRAW_COL 6,  40, 0

	mov ah, 4ch
	int 21h

	draw_string proc																																																																									 																																																																						 																																																										

		;mov word ptr es: [bx+160*4l + 80], (4e03h or 8000h)	
		;mov bx, 80 ;счетчик

		;cx pos_x
		;di pos_y

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
			mov word ptr es:[bx + di], (4e03h or 8000h)
			dec bx
			dec bx
			cmp bx, 0
			jg string

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
			mov word ptr es:[bx + di], (4e03h or 8000h)
			sub bx, 160
			;dec bx   
			cmp bx, 0
			jge print_column
			ret;

	draw_column endp

end 	Start