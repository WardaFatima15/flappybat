%ifndef moveGrass_asm
%define moveGrass_asm

moveGrass:                  push bp
                            mov bp, sp
                            pushA
                            push ES
                            push DS

                            mov ax, [bp+4]              ; 0x0A000
                            mov ES, ax
                            mov DS, ax

                            mov ax, [bp+6]              ; columns = 320
                            mov bx, [bp+8]              ; line number = 190
                            mul bx
                            mov di, ax
                            mov dx, [bp+10]             ; height of grass = 10

        moveGrass_loop:             mov cx, [bp+6]              ; columns = 320
                                    dec cx
                                    mov bx, [bp+12]             ; buffer offset = 64000

                                    mov al, [ES:DI]
                                    mov [ES:bx], al

									mov si, di
									inc si

									cld
									rep movsb

									mov al, [ES:BX]
									mov [ES:DI], al
                                    
                                    inc di
                                    dec dx
                                    jnz moveGrass_loop

                            pop DS
                            pop ES
                            popA
                            pop bp

                            ret 10

%endif