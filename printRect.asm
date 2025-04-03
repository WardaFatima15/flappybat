%ifndef printRect_asm
%define printRect_asm

printRect:	
                push bp
		        mov bp, sp

		        pusha
		        push es

		        mov ax, [bp+4]              ; segment = 0xA000
		        mov es, ax		

		        mov dx, [bp+8]              ; x = 0 and 48
		        mov ax, [bp+10]             ; columns per row = 320
		        mul dx
                mov dx, [bp+6]              ; y = 260
		        add ax, dx
		        mov dx, ax

		        cld

		        mov ax, [bp+12]             ; attribute = 0x04
		        mov bx, [bp+16]             ; rectangle height = 72

loop1:	        	
		        add dx, [bp+10]
                mov di, dx                  ; columns per row = 320
		        mov cx, [bp+14]             ; rectangle width = 30

		        rep stosb

		        sub bx, 1
		        jnz loop1

		        pop es
		        popa
		        pop bp
		        ret 14

%endif