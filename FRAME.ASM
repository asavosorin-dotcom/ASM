.model tiny
.code 

org 100h

DRAW macro length, pos_x, pos_y
	mov bx, length
	mov cx, pos_x
	mov di, pos_y
	call draw_string
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
	;xor bx, bx
	
	DRAW 30, 10, 0
	
	mov ah, 4ch
	int 21h

	draw_string proc																																																																									 																																																																						 																																																										

		;mov word ptr es: [bx+160*4l + 80], (4e03h or 8000h)	
		;mov bx, 80 ;счетчик

		shl cx, 1
		shl bx, 1

	; -1 и умножение на 160=======
		shl di, 5 
		push bx
		mov bx, di
		shl di, 2
		add di, bx
		pop bx
		
	;=================================

		add bx, cx
		string:
			mov word ptr es:[bx + di], (4e03h or 8000h)
			dec bx
			dec bx
			cmp bx, cx
			jge string

		ret;
	draw_string endp

end 	Start