assume cs:code

stack segment
	db 128 dup (0)  ;定义一个128字节的栈，全部初始化为0
stack ends

code segment
start:
		mov ax, stack
		mov ss, ax
		mov sp, 128  ;设置栈帧

		push cs
		pop ds  ;设置数据段与代码段为同一段

		mov ax, 0
		mov es, ax 
		mov si, offset int9
		mov di, 204h  ;设置es:di指向目的地址
		mov cx, offset int9end - offset int9
		cld
		rep movsb  ;传送代码至0:204h

		push es:[9*4]
		pop es:[200h]
		push es:[9*4+2]
		pop es:[202h]  ;将原来的int9开始地址保存到0:200

		cli
		mov word ptr es:[9*4], 204h
		mov word ptr es:[9*4+2], 0
		sti  ;设置新的int入口地址

		mov ax, 4c00h
		int 21h
int9:
		push ax
		push bx
		push cx
		push es  ;保护现场

		in al, 60h  ;从端口60h读入键盘的输入

		pushf
		call dword ptr cs:[200h]  ;调用原int9中断例程

		cmp al, 9eh
		jne int9ret  ;判断是否为A的断码

		mov ax, 0b800h  ;是文本模式下显存的起始地址
		mov es, ax
		mov bx, 0
		mov cx, 2000
	s:	
		mov byte ptr es:[bx], 'A'
		;inc byte ptr es:[bx+1]  ;改变颜色
		add bx, 2
		loop s  ;显示满屏幕的'A'
int9ret:
		pop es
		pop cx
		pop bx
		pop ax  ;恢复现场
		iret
int9end:nop
code ends
end start