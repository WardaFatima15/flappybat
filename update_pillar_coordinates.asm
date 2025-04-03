%ifndef update_pillar_coordinates_asm
%define update_pillar_coordinates_asm

%include "pillar_height.asm"

update_pillar_coordinates:              push bp
                                        mov bp, sp
                                        pushA

                                        mov cx, [bp+6]                  ; number of pillars
                                        mov bx, [bp+4]                  ; address of pillar coordinates
                                        mov dx, [bp+8]                  ; rotation speed
                                        mov si, [bp+10]                 ; pillar starting position = 290
                                        
                                        xor di, di

        update_pillar_loop:                     mov ax, [bx]
                                                cmp ax, 0
                                                ja skip_update_height
                                                mov si, [bp+10]
                                                mov [bx], si
                                                push di
                                                mov ax, [bp+14]
                                                push ax
                                                push word [bp+12]
                                                call update_pillar_height
                                                add word [bx], dx

        skip_update_height:                     sub word [bx], dx
                                                mov ax, [bx]
                                                cmp ax, 59
                                                jne chalo
                                                mov si, [bp+16]
                                                inc word [si]
                                                
                chalo:                          add bx, 2
                                                add di, 2
                                                loop update_pillar_loop

                                        popA 
                                        pop bp
                                        ret 14                                                      

%endif