%ifndef printGrass_asm
%define printGrass_asm

grass:
                    push bp
                    mov bp, sp

                    push ax
                    push bx
                    push cx
                    push di
                    push es

                    mov ax, [bp+4]
                    mov es, ax          ; es = 0xa000
                    mov ax, [bp+6]      ; columns in each row
                    mul word[bp+8]      ; for finding the address to start printing grass from

                    mov di, ax          ; 194*320 = 62,080  
                    mov cx, [bp+10]     ; 320*200 = 64,000
                    sub cx, ax          ; 64,000-62,080 = 1920

                    cld

                    ; Loop to draw random patches
draw_grass:
                    ; Generate a random color (0x02 for green, 0x06 for brown)
                    ; Alternate between brown and green patches using bx
                    mov bx, 3           ; arbitrary divisor to create pseudo-random effect
                    div bx              ; pseudo-randomize AL based on division by BX
                    cmp dx, 0
                    je texture       ; if dx = 0, use brown
                    mov al, 0x02        ; green
                    jmp store_pixel
texture:
                    mov al, 0x0e       
store_pixel:
                    stosb               ; store byte in es:[di] and advance di
                    loop draw_grass     ; repeat for each pixel

                    pop es
                    pop di
                    pop cx
                    pop bx
                    pop ax
                    pop bp

                    ret 10

%endif
