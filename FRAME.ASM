.model tiny
.code 

org 100h

locals @@

;===========================================================================
;DESTR: ax, bx, cx, di
;===========================================================================

; можно передавать аргументом символа его адрес в памяти

; надо написать процедуру, которая считывает число из командной строки

INF_T struc 
	length dw 30
	height dw 7
	pos_x  dw 10
	pos_y  dw 3
INF_T ends

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
	
	call get_num_from_command

	shl dx, 1 ; arr of words
	lea bx, Symbol_arr
	add bx, dx

	push cx
	push [bx]
	
	DRAW_STR length, pos_x, pos_y, symbol
	DRAW_COL height, pos_x, pos_y, symbol

	; Sum_y = pos_y + height - 1 ; make in func
;=====================================================================
	mov di, pos_y
	add di, height
	dec di
;===================================================================== 
	; Sum_x = pos_x + length - 1 ; make in func
	; push di
	DRAW_STR length, pos_x, di, symbol
	; pop di
;=====================================================================
	mov cx, pos_x
	add cx, length
	dec cx
;=====================================================================

	DRAW_COL height, cx, pos_y, symbol

	pop bx
	pop cx
 
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

	call print_mona_lisa

	; call get_num_from_command
	; mov  Inf_frame.length, dx

	; call get_num_from_command
	; mov  Inf_frame.height, dx

	; DRAW_FRAME Inf_frame.length, Inf_frame.height , Inf_frame.pos_x, Inf_frame.pos_y, 2

	; and bx, 0ff00h
	; mov dx, bx

	; push cx
	; call make_fill
	; pop cx

	; push dx
	; call print_word_in_frame
	; pop dx

	mov ah, 4ch
	int 21h
;=================================================================================================
	Symbol_arr   dw 1F03h, 4E03h, 8B55h, 04C5h
; Строка 1: "o8%8888," +20 пробелов
row1 db 04h,04h,20h,20h,20h,20h,20h,20h,6Fh,38h,25h,38h,38h,38h,38h,2Ch,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,04h,04h 

; Строка 2: "      o88%8888888." +10 пробелов
row2 db 04h,20h,20h,20h,20h,20h,6Fh,38h,38h,25h,38h,38h,38h,38h,38h,38h,38h,2Eh,20h,20h,20h,20h,20h,20h,20h,20h,04h,04h

; Строка 3: "     8'-    -:8888b" +10 пробелов
row3 db 04h,20h,20h,20h,20h,20h,38h,27h,2Dh,20h,20h,20h,20h,2Dh,3Ah,38h,38h,38h,38h,62h,20h,20h,20h,20h,20h,20h,04h,04h

; Строка 4: "    8'         8888" +10 пробелов
row4 db 04h,20h,20h,20h,20h,38h,27h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,38h,38h,38h,38h,20h,20h,20h,20h,20h,20h,04h

; Строка 5: "   d8.-=. ,==-.:888b" +8 пробелов
row5 db 04h,20h,20h,64h,38h,2Dh,2Eh,3Dh,20h,2Ch,3Dh,3Dh,2Dh,2Eh,3Ah,38h,38h,38h,62h,20h,20h,20h,20h,20h,20h,20h,20h,20h

; Строка 6: "   >8 `~` :`~' d8888" +8 пробелов
row6 db 04h,20h,20h,3Eh,38h,20h,60h,7Eh,60h,20h,3Ah,60h,7Eh,27h,20h,64h,38h,38h,38h,38h, 20h,20h,20h,20h,20h,20h,20h,20h

; Строка 7: "   88         ,88888" +9 пробелов
row7 db 04h,20h,20h,20h,38h,38h,20h,20h,20h,20h,20h,20h,20h,20h,20h,2Ch,38h,38h,38h,38h,38h, 20h,20h,20h,20h,20h,20h,20h

; Строка 8: "   88b. `-~  :'88888" +8 пробелов
row8 db 04h,20h,20h,20h,38h,38h,62h,2Eh,20h,60h,2Dh,7Eh,20h,20h,3Ah,27h,38h,38h,38h,38h,38h, 20h,20h,20h,20h,20h,20h,20h

; Строка 9: "   888b ~==~ .:88888" +8 пробелов
row9 db 20h,20h,20h,20h,38h,38h,38h,62h,20h,7Eh,3Dh,3Dh,7Eh,20h,2Eh,3Ah,38h,38h,38h,38h,38h, 20h,20h,20h,20h,20h,20h,20h

; Строка 10: "   88888o--:':::8888" +8 пробелов
row10 db 20h,20h,20h,20h,38h,38h,38h,38h,38h,6Fh,2Dh,2Dh,3Ah,27h,27h,27h,3Ah,38h,38h,38h,38h, 20h,20h,20h,20h,20h,20h,20h

; Строка 11: "   `88888| :::' 8888b" +7 пробелов
row11 db 20h,20h,20h,60h,38h,38h,38h,38h,38h,7Ch,20h,3Ah,3Ah,3Ah,27h,20h,38h,38h,38h,38h,62h, 20h,20h,20h,20h,20h,20h,20h

; Строка 12: "   8888^^'       8888b" +6 пробелов
row12 db 20h,20h,20h,20h,38h,38h,38h,38h,5Eh,5Eh,27h,20h,20h,20h,20h,20h,20h,20h,38h,38h,38h,38h,62h, 20h,20h,20h,20h,20h

; Строка 13: "  d888           ,%888b." +5 пробелов
row13 db 20h,20h,64h,38h,38h,38h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,2Ch,25h,38h,38h,38h,62h,2Eh, 20h,20h,20h,20h

; Строка 14: " d88%            %%%8--'-. " +4 пробела
row14 db 20h,64h,38h,38h,25h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,25h,25h,25h,38h,2Dh,2Dh,27h,2Dh

; Строка 15: "/88:.__ ,       _%-' ---  -" +1 пробел
row15 db 2Fh,38h,38h,3Ah,2Eh,5Fh,5Fh,20h,2Ch,20h,20h,20h,20h,20h,20h,20h,5Fh,25h,2Dh,27h,20h,2Dh,2Dh,2Dh,20h,2Dh,0Ah,20h

; Строка 16: "    '''::===..-'   =  --." +3 пробела
row16 db 20h,20h,20h,20h,27h,27h,27h,3Ah,3Ah,3Dh,3Dh,2Eh,2Dh,27h,20h,20h,20h,20h,3Dh,20h,2Dh,2Dh,2Eh,20h,20h,20h,20h,20h
	Inf_frame INF_T <> 

MonaLisa dw row1, row2, row3, row4, row5, row6, row7, row8, row9, row10, row11, row12, row13, row14, row15, row16, 0000h

Str db 41h, 41h, 41h
;=================================================================================================

	draw_string proc																																																																									 																																																																						 																																																										
		push cx
		push di
		push bx
		push bp
		mov bp, sp
		add bp, 10
		;mov word ptr es: [bx+160*4l + 80], (4e03h or 8000h)	
		;mov bx, 80 ;

		;cx pos_x
		;di pos_y
		dec bx
		shl cx, 1	;	
		shl bx, 1	;

	;===== Умножение смещения на 160 =======
		shl di, 5 
		push bx
		mov bx, di
		shl di, 2
		add di, bx
		pop bx
	;=======================================
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
		pop bx
		pop di
		pop cx
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
;Destr: cx, di, si, dx
;====================================================================

	print_word_in_frame proc
			; push cx
			push bp
			mov bp, sp
			add bp, 4

			push di
			;xor cx, cx
			xor di, di  	
			;mov cl, ds:80h
; 
			cmp cl, 0
			je @@return
; 
			dec cl
			;mov si, 82h 
			;BEG equ 5 * 160 + 40
			mov di, cx
			shr di, 2
			shl di, 1
			neg di
			sub di, 2
			call get_middle_frame
			add di, dx
			;mov di, BEG ;  
			mov ah, [bp + 1];
			L:
				lodsb	
				stosw
				loop L
; 
			@@return:
			pop di
			; pop cx 
			pop bp
			ret
	endp					

;====================================================================
; Start:  cx - number of symbols
;		  si - adress of string
; Destr:  cx, si, dx, ax
; Return: dx - число. dx = 0, если нет цифры
;====================================================================
	get_num_from_command proc
		xor dx, dx

		cmp byte ptr [si], ' '
		je @@return

		cmp byte ptr [si], '0'
		jb @@return

		cmp byte ptr [si], '9'
		jg @@return

		xor ax, ax

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

		dec cx
		add si, 1 ; skip_space

		@@return:
		ret
	endp

;====================================================================
; Start: Inf_struc
; Destr: dx
; Return: dx - число
;====================================================================

	get_middle_frame proc
		push bp
		mov bp, sp

		; xor dx, dx

		mov dx, Inf_frame.pos_x
		shl dx, 1
		add dx, Inf_frame.length
		dec dx
		shl dx, 1

		push ax
		mov ax, Inf_frame.pos_y
		shl ax, 1
		add ax, Inf_frame.height
		dec ax
		dec ax
		add ax, 1
		shr ax, 1
		shl ax, 1

		;===== Умножение ax на 80=======
		shl ax, 5
		push bx
		mov bx, ax
		shl ax, 2
		add ax, bx
		pop bx
		;=====================================

		add dx, ax

		pop ax

		shr dx, 2
		shl dx, 1

		pop bp
		ret
	endp
;====================================================================
; Start: data in struc, bx - symb
; Destr: cx, ax
;====================================================================

	make_fill proc
		push bp
		mov bp, sp

		mov ax, Inf_frame.height
		sub ax, 2

		push bx

		mov bx, Inf_frame.length
		sub bx, 2

		mov cx, Inf_frame.pos_x
		inc cx

		mov di, Inf_frame.pos_y
		inc di 

		@@print_string:

			call draw_string
			inc di 

			dec ax
			cmp ax, 0
			jne @@print_string

		pop bx
		pop bp

		ret
	endp
;=======================================================================
; Start: cx - количество символов в массиве, si - адресс начала массива, 
; di - адресс в видеопамяти
; Destr: ax, cx, si, di
; 
;=======================================================================

	print_arr proc
		mov ah, 0fh
		@@print:
			lodsb
			stosw
			loop @@print

		ret
	endp

	print_mona_lisa proc
		DRAW_FRAME 30, 17, 10, 0, 1

		mov di, 22 ; (10 + 1) * 2 ; можно подшаманить с отступом
		add di, 160 ; 4 * 160
		lea bx, MonaLisa 
		
		@@mona:
			mov si, [bx]
			mov cx, 28

			push di
			call print_arr
			pop di

			add di, 160
			add bx, 2
			
			cmp [bx], 0000h
			jne @@mona

		ret
	endp
end 	Start