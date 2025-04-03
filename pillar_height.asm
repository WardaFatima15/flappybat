%ifndef pillar_height_asm
%define pillar_height_asm

%include "rand.asm"

set_pillar_height:                      push bp
                                        mov bp, sp
                                        pushA

                                        mov di, [bp+4]                              ; current pillar height address
                                        mov bx, [bp+6]                              ; pillar y coordinates
                                        mov cx, [bp+8]                              ; total pillars 

        set_pillar_height_loop:                 rand 0, 5
                                                pop si
                                                shl si, 1
                                                add si, bx
                                                mov ax, [si]
                                                mov [di], ax
                                                add di, 2
                                                push cx
                                                mov cx, 0xffff
                                                waste_time:     loop waste_time
                                                pop cx
                                                loop set_pillar_height_loop

                                        popA
                                        mov sp, bp
                                        pop bp
                                        ret 6

update_pillar_height:                   push bp
                                        mov bp, sp
                                        pushA

                                        mov di, [bp+4]                              ; current pillar height address
                                        mov bx, [bp+6]                              ; pillar y coordinates
                                        mov dx, [bp+8]                              ; current index of current pillar height

                                        rand 0, 5
                                        pop si
                                        shl si, 1
                                        add si, bx
                                        mov ax, [si]
                                        add di, dx
                                        mov [di], ax

                                        popA
                                        mov sp, bp
                                        pop bp
                                        ret 6

%endif