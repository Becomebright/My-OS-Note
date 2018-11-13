; 名称：show_str
; 功能：在指定的位置，用指定的颜色，显示一个用0结束的字符串
; 参数：(dh)=行号(0~24)，(dl)=列号(0~79)，
;	(cl)=颜色，ds:si指向字符串的首地址
; 返回：无

assume cs:code
data segment
	db 'Welcome to masm!',0
data ends

code segment
start:		mov dh,8
			mov dl,3
			mov cl,2
			mov ax,data
			mov ds,ax
			mov si,0
			call show_str

			mov ax,4c00h
			int 21h

show_str:	push ax
			push bx
			push es
			push di

			mov ax,0b800h
			mov es,ax

			mov al,160	; 一行160字节
			dec dh	; 行号-1，因为从0开始
			mul dh	; 结果在ax中
			mov di,ax

			mov al,2	; 一个字符占2字节
			dec dl		; 列号-1，因为从0开始
			mul dl
			add di,ax	; 偏移地址计算完成

		s:	mov bl,ds:[si]
			test bl,bl ;判断bl是否为0
			jz ok
			mov byte ptr es:[di],bl
			mov byte ptr es:[di+1],cl
			add di,2
			inc si
			jmp short s

		ok:	pop di
			pop es
			pop bx
			pop ax
			ret

code ends
end start