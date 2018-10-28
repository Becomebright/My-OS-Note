assume cs:code
code segment

;安装do0，设置中断向量
start:  
        mov ax,cs
    	mov ds,ax
        mov si,offset do0  ;设置ds:si指向源地址
    	mov ax,0
    	mov es,ax
    	mov di,200h  ;设置es:di指向目的地址
        mov cx,offset do0end - offset do0  ;设置cx为传输长度
    	cld  ;设置传输方向为正
    	rep movsb  ;将do0的代码送到0:200处

    	mov ax,0
    	mov es,ax
    	mov word ptr es:[0*4],200h
    	mov word ptr es:[0*4+2],0  ;设置中断向量

    	mov ax,4c00h  ;返回DOS
    	int 21h

;中断处理程序do0，显示"overflow!"
do0:    
        jmp short do0start  ;占2字节
    	db "divide error!"  ;在0:202
    
do0start:      
		mov ax,cs
		mov ds,ax
		mov si,202h  ;设置ds:si指向字符串

	    mov ax,0b800h
	    mov es,ax
	    mov di,12*160+36*2  ;设置es:di指向显存空间的中间位置

		mov cx,13  ;设置cx为字符串长度
	s:  mov al,[si]
		mov es:[di],al
	    inc si
	    add di,2
	    loop s

	    mov ax,4c00h
	    int 21h

do0end:nop
code ends
end start
