%ifndef renderImage_asm
%define renderImage_asm

renderImage:                push bp
                            mov bp, sp
                            pushA
                            push DS

                            mov ah, 0x3D                ; open file service of int 21h
                            mov al, 0x00                ; read mode
                            mov dx, [bp+8]              ; point dx to the file name
                            int 21h

                            ; carry flag indicates whether the file has been opened successfully or not
                            ; if the file has been opened successfully then ax will contain the file handle
                            ; otherwise, it will contain the error code

                            jc file_error               ; if the file hasn't been opened successfully

                            
                            mov bx, ax                  ; move file handle to bx
                            mov ax, [bp+4]              ; vram segment = 0xA000
                            mov DS, ax
                            mov cx, [bp+6]              ; byte count = 64000
                            mov dx, 0
                            mov ah, 0x3F
                            int 21h

                            jc file_error

                            mov ah, 0x3E
                            int 21h

                            pop DS
                            popA
                            mov sp, bp
                            pop bp
                            ret 6

        file_error:         mov ah, 0x4C
                            mov ah, 1
                            int 21h

%endif