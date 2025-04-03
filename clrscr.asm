%ifndef clrscr_asm
%define clrscr_asm

clrscr:         push bp
                mov bp, sp
                
                push ax
                push cx

                push es

                push di

                les di, [bp+4]

                mov ax, [bp+10]
                mov cx, [bp+8]
                shr cx, 1

                cld
                rep stosw

                pop di

                pop es

                pop cx
                pop ax

                pop bp

                ret 8

%endif