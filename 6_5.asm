assume cs:code

a segment
	db 1,2,3,4,5,6,7,8
a ends

b segment
	db 1,2,3,4,5,6,7,8
b ends

c segment
	db 0,0,0,0,0,0,0,0
c ends

code segment

start:	mov ax,a
		mov ds,ax		;ds指向a段

		mov ax,b
		mov es,ax		;es指向b段

		mov ax,c
		mov ss,ax		;ss指向c段

		mov bx,0
		mov cx,8
	s:	mov al,ds:[bx]	;取出a段元素
		add al,es:[bx]	;加上b段元素
		mov ss:[bx],al	;存到c段
		add bx,1
		loop s

		mov ax,4c00h
		int 21h

code ends

end start