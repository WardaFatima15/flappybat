; %ifndef moveBird_asm
; %define moveBird_asm



; moveBird:                   push bp
                            ; mov bp, sp

                            ; pushA
                            ; mov bx, [bp+4]          ; bird y
                            ; mov si, [bp+6]          ; bird flag address

                            ; cmp byte [si], 'U'
                            ; je moveUp
                            ; cmp word [bx], 180
                            ; ja exit 
                            ; inc word [bx]
                            ; jmp exit

        ; moveUp:             cmp word [bx], 3
                            ; jbe exit
                            ; sub word [bx], 3
                            
        ; exit:               popA
                            ; mov sp, bp
                            ; pop bp
                            ; ret 4

							
							
; moveBirddown:
    ; push bp
    ; mov bp, sp
    ; pusha
    ; mov bx, [bp+4]          ; bird y position

; check_ground:
    ; cmp word [bx], 180      ; Check if bird is already at the ground
    ; ja exittt               ; If yes, exit

    ; add word [bx], 1        ; Move the bird down by 1
    ; cmp word [bx], 180      ; Check again if the bird has reached the ground
    ; jne check_ground        ; If not, continue moving down


; exittt:
    ; popa
    ; mov sp, bp
    ; pop bp
    ; ret 2

; collisioncheck:
    ; push bp
    ; mov bp, sp
    ; pusha
    ; mov di, [bp+4]
    ; mov si, [bp+6]
    ; mov bx, [bp+8]

    ; cmp byte [es:di], 0x07  ; Check if the pixel is background (0x07)
    ; je collision            ; If yes, handle collision

        
   ; jmp exitt

; collision:
    ; mov byte [si], 'D'      ; Set flag to 'D' (for moving down)
    ; push bx                 ; Push bird's position
    ; call moveBirddown 
    
; jmp exitt
             

; exitt:
    ; popa
    ; mov sp, bp
    ; pop bp
    ; ret 6
	
	
; %endif
%ifndef moveBird_asm
%define moveBird_asm

moveBird:                   push bp
                            mov bp, sp

                            pushA
                            mov bx, [bp+4]          ; bird y
                            mov si, [bp+6]          ; bird flag address

                            cmp byte [si], 'U'
                            je moveUp
                            cmp byte [si], 'W'
                            je exit
                            cmp word [bx], 180  ;terminationnnnnnnnnnnnnnn
                            ja exit 
                            inc word [bx]
                            jmp exit

        moveUp:             cmp word [bx], 3
                            jbe exit
                            sub word [bx], 3
                            mov byte [si], 'W'
                            
        exit:               popA
                            mov sp, bp
                            pop bp
                            ret 4
							moveBirddown:
    push bp
    mov bp, sp
    pusha
    mov bx, [bp+4]          ; bird y position

check_ground:
    cmp word [bx], 180      ; Check if bird is already at the ground
    ja exittt               ; If yes, exit

    add word [bx], 1        ; Move the bird down by 1
    cmp word [bx], 180      ; Check again if the bird has reached the ground
    jne check_ground        ; If not, continue moving down


exittt:
    popa
    mov sp, bp
    pop bp
    ret 2

collisioncheck:
    push bp
    mov bp, sp
    pusha
    mov di, [bp+4]
   ; mov si, [bp+6]
    mov bx, [bp+6]

    cmp byte [es:di], 0x00 ; Check if the pixel is background (0x07)
    je collision            ; If yes, handle collision

        
   jmp exitt

collision:
;      ; Set flag to 'D' (for moving down)
    push bx                 ; Push bird's position
    call moveBirddown 
    
jmp exitt
             

exitt:
    popa
    mov sp, bp
    pop bp
    ret 4
%endif
