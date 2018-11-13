; 名称：divdw
; 功能：进行不会产生溢出的除法运算，被除数为dword型，除数为word型，结果为dword型。
; 参数：(ax)=dword型数据的低16位, (dx)=dword型数据的高16位, (cx)=除数
; 返回：(dx)=结果的高16位, (ax)为结果的低16位, (cx)=余数
assume cs:code
stack segment
	db 16 dup(0)
stack ends

code segment
start:	mov ax,4240H
		mov dx,000FH
		mov cx,0AH
		call divdw

		mov ax,4c00h
		int 21h

divdw:	push ax
		mov ax,dx
		mov dx,0
		div cx
		mov bx,ax
		pop ax
		div cx
		mov cx,dx
		mov dx,bx
		ret

code ends
end start