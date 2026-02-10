.model tiny
.code 

org 100h

DRAW macro length
	mov bx, length
	call draw_string
ENDM
	
Start: 
	;переход в сегмент видеопамяти
	mov ax, 0B800h
	mov es, ax					
	;xor bx, bx
		
	DRAW 30
	
	mov ah, 4ch
	int 21h


	draw_string proc																																																																									 																																																																						 																																																										

		;mov word ptr es: [bx+160*4l + 80], (4e03h or 8000h)	
		;mov bx, 80 ;счетчик
		string:
			mov word ptr es:[bx + 160*4], (4e03h or 8000h)
			dec bx
			dec bx
			cmp bx, 0
			jge string

		ret;
	draw_string endp

end 	Start