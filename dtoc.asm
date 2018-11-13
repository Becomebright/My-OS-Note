; 名称：dtoc
; 功能：将word型数据转变为表示十进制数的字符串，字符串以0为结尾符。
; 参数：(ax)=word型数据，ds:si指向字符串的首地址
; 返回：无
; 应用举例：编程，将数据12666以十进制的形式在屏幕的8行3列，用绿色显示出来。
;          在显示时我们调用本次实验中的第一个子程序show_str
assume cs:code,ds:data
data segment
	db 10 dup(0)
data ends

code segment
start:		mov ax,12666
			mov bx,data
			mov ds,bx
			mov si,0
			call dtoc

			mov dh,8
			mov dl,3
			mov cl,2
			call show_str

			mov ax,4c00h
			int 21h

dtoc:		push ax
			push bx
			push cx
			push dx
			push si
			push di

			mov bx,0	; 计数
			mov di,10d	; d表示十进制

		s1:	mov dx,0
			div di		
			add dx,30H	; 求余数对应的ASCII
			push dx		; 将余数压栈
			inc bx		; 计数器增一
			mov cx,ax	; 将商赋给cx
			jcxz ok0	; 判断商是否为0，若是则跳转到ok0
			jmp short s1

	ok0:	mov cx,bx
		s2:	pop ax
			mov ds:[si],al
			inc si
			loop s2

			mov byte ptr ds:[si],0	; 在字符串末尾添加一个0
			pop di
			pop si
			pop dx
			pop cx
			pop bx
			pop ax
			ret

show_str:	push ax
			push bx
			push es
			push di

			mov ax,0b800h
			mov es,ax

			mov al,160	; 一行160字节
			mul dh	; 结果在ax中
			mov di,ax

			mov al,2	; 一个字符占2字节
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
