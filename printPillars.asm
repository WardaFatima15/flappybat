%ifndef printPillars_asm
%define printPillars_asm

%include "printRect.asm"
;%include "rand.asm"

printPillars:               push bp
                            mov bp, sp

                            pushA
                            push ES
                            
                            mov bx, [bp+16]                 ; current pillar height
                            xor di, di
                           
     loop_pillars:          
                            push word [bx]                  ; rectangle height 
                            
                            push word [bp+14]               ; rectangle width = 20
                            push word [bp+12]               ; attribute (color)
                            push word [bp+10]               ; columns = 320
                            push word [bp+8]                ; x = 0
                            add di, [bp+6]
                            mov ax, [di]  
                            push ax                         ; rectangle_y
                            push word [bp+4]                ; es = 0xA000
                            call printRect  

                            mov ax, [bp+18]                 ; total height = 200
                            mov dx, [bx]                    ; first pillar height 
                            sub ax, dx                      ; total height - first pillar height
                            mov dx, [bp+20]                 ; space between pillars = 70
                            sub ax, dx  
                            mov dx, [bp+22]                 ; grass height = 10
                            sub ax, dx  

                            mov cx, [bx]                    ; first pillar height 
                            add cx, [bp+20]                 ; space between pillars + first pillar height

                            push ax                         ; rectangle height
                            push word [bp+14]               ; rectangle width
                            push word [bp+12]               ; attribute (color)
                            push word [bp+10]               ; columns = 320
                            push cx
                            push word [DS:di]               ; y
                            push word [bp+4]                ; es = 0xA000
                            call printRect

                            add bx, 2
                            sub di, [bp+6]
                            add di, 2
                            mov si, [bp+24]
                            shl si, 1
                            cmp di, si
                            jnz loop_pillars

                            pop ES
                            popA
                            pop bp

                            ret 22

%endif