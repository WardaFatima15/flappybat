
%ifndef batt_asm
%define batt_asm
%include "moveBird.asm"
printBirdy: 
    push bp
    mov bp, sp
    pusha

    mov ax, 0xA000       ; Set VGA segment
    mov es, ax

    mov bx, [bp+8]          ; row number (address)
    mov ax, [bx]    
    mov si, 320	
    mul si      
    mov bx, [bp+6]          ; column number (value)
    add ax, bx        
    mov dx, ax     
mov di,dx
add di,9
sub di,640
mov byte [es:di],0x00	
    mov ax, [bp+4]         ; attribute = 0x00
    mov bx, 9         ; Start with the widest width at the top
    ; add dx, 350
    add dx, 30
	
	
triangle_top:

    mov di, dx
	
	push word[bp+8]

	push di
	call collisioncheck

    mov cx, bx
    sub di, cx
	
mov byte [es:di],0x02
push word [bp+8]

push di

call collisioncheck
    rep stosb            ; Draw left side of the row

    ;mov cx, bx
    add di, cx
	
    mov cx, bx
	push word[bp+8]
	
	push di
	call collisioncheck
    rep stosb            ; Draw right side of the row

    add dx, 320          
    sub bx, 1  

; mov ax,di
; push ax
; call collisioncheck
    jg triangle_top
;rectangles are called from here on
    mov bx, [bp+8]
    mov ax, [bx]    
    mov si,320 
    mul si     
         
    sub ax, 1200

    push ax              

    mov bx, 10       ;len
	
    mov cx, 8   ;width
	;rectangles are called (hard coded hein accordingly mujhay khud bhool gaya he mein ne 2 sal pehlay idhr kya kiya tha)
    sub ax,1920
    sub ax,1

    call drawRectangle   ; Draw the left rectangle

    pop ax               
    add ax, 8        
    push ax              
    sub ax,642

    mov bx, 8            
    mov cx, 7  

    call drawRectangle  ;bottom left

    ; 
    pop ax              
    sub ax, 320        
    add ax, 18          
    push ax              

    mov bx, 8          
    mov cx, 7    

    call drawRectangle   ;bottom right

    ;
    pop ax               
    sub ax, 1600       
    add ax, 5            
    push ax              

    mov bx, 10          
    mov cx, 8   
	
    call drawRectangle 
mov ax,0x0A00
mov es,ax	
;mov byte [es:27275],0x00
;mov byte[es:2],0x00	;  top-right rectangle
    pop ax
    popa
    mov sp, bp
    pop bp
    ret 6

drawRectangle:
    ; Parameters: ax = starting address, bx = width, cx = height
    push dx
    push di
	mov si,[bp+4]
    mov dx, cx            ; Save height in dx, so cx isnâ€™t restored each row
drawRectangleLoopY:
    mov di, ax            ; Set DI to starting address of the current row

    ; Place a white pixel (0x0F) at the starting position
    mov byte [es:di], 0x0e
    inc di  
	push ax

push di	; Move to the next pixel
call collisioncheck
    ; Now draw the rest of the row
    mov cx, bx            ; Rectangle width
    dec cx                ; Decrement width by 1 to account for the already placed white pixel
drawRectangleLoopX:
    mov byte [es:di], 0x00 ; Draw rectangle body in light color (0x04)
    inc di
    loop drawRectangleLoopX
	  ;mov byte [es:di], 0x0e
	 
	 push ax

push di
call collisioncheck
    add ax, 320           ; Move to the next row
    dec dx                ; Decrement height counter
    jnz drawRectangleLoopY ; Repeat for all rows
    pop di
    pop dx
    ret 

; collisioncheck:
    ; push bp
    ; mov bp, sp
    ; pusha
 ; mov di,[bp+4]
 ; mov si,[bp+6]
 ; mov bx,[bp+8]
 ; cmp byte [es:di],0x07
   
    ; je collision 

; exitt:
    ; popa
    ; pop bp
    ; ret 6               ; Return, clean stack

; collision:
  
   ; push si
   ; push bx
  ; call  moveBird
%endif