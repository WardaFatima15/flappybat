[org 0x0100]
				jmp start
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
                            ja exittt
                            inc word [bx]
                            jmp exit

        moveUp:             cmp word [bx], 3
                            jbe exit
                            sub word [bx], 3
                            mov byte [si], 'W'
							
						
                           
        exit: 
	
		popA
                            mov sp, bp
                            pop bp
                            ret 4
							down :
							add word[bx],10
							

moveBirddown:
    push bp
    mov bp, sp
    pusha
    mov bx, [bp+4]          ; bird y position

check_ground:
    cmp word [bx], 150      ; Check if bird is already at the ground
    je exittt               ; If yes, exit

    add word [bx], 50       ; Move the bird down by 1
    cmp word [bx], 150      ; Check again if the bird has reached the ground
    jne check_ground        ; If not, continue moving down


exittt:
    popa
mov ah,0
int 16h
    call exitProgramFunction1
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

    cmp byte [es:di], 0x0f  ; Check if the pixel is background (0x07)
    je collision           ; If yes, handle collision

        
   jmp exitt
   ; down:
   ; add word[bx],5
   ; cmp word[bx],150
   ; j
   ; jne down

collision:

; push byte 'W'
; push word bx
; call moveBird
;      ; Set flag to 'D' (for moving down)
    ; push bx                 ; Push bird's position
    ; call moveBirddown 
    
jmp exittt
             

exitt:
    popa
    mov sp, bp
    pop bp
    ret 4
%endif

	

                        %include "printScreen.asm"
                        %include "printAnimation.asm"
                        %include "pillar_height.asm"
                        %include "moveBird.asm"
                        %include "renderImage.asm"
                        %include "palette.asm"
%include "mus2.asm"
divisor : dw 11931
is_paused:              db 0
segment1:               dw 0xA000
offset1:                dw 0
word_count:             dw 32000
byte_count:             dw 64000
bg_byte_count:          dw 320*190                  ;
clr_attribute1:         dw 0x00
clr_attribute2:         dw 0x07
clr_attribute3:         dw 0x0f
bg_attribute:           dw 0x4040
height:                 dw 200
width:                  dw 320
grass_row:              dw 190
grass_height:           dw 10
rectangle_height:       dw 70, 10, 110, 30, 90      ;
current_pillar_height:  times 3 dw 0                ;
rectangle_width:        dw 20 
pillar_count:           dw 2                      ;
space_pillars:          dw 70
rectangle_x1:           dw 0
rectangle_x2:           dw 120
rectangle_y :           dw 170, 300, 210, 0
bird_x:                 dw 155
bird_y:                 dw 84       
bird_row:               dw 85
bird_column:            dw 70
birdDirection:          db 'D'
lower_limit:            dw 0
upper_limit:            dw 5
result:                 dw 0
;seed:                   dw 0
buffer_offset           dw 64000                    ; after 64000 bytes in 0xA000
pillar_start_pos:       dw 290
pillar_update_speed:    dw 1
starting_message:       db "WARDA 23L-0601         EZAAN 23L-0676                                                   FALL 2024", '$'
ending_message:         db "You have exited!", '$'
exitProgram:            dd 0
moveBirdFunction:       dd 0
original_isr:           dd 0
start_screen:           db "st.raw", 0
 exit_screen:            db "end.raw", 0
escape_screen:          db "tryy.raw", 0
instr_screen:           db "instr.raw", 0
back_screen : db "fin.raw",0
up_release_tick_count:  dw 0
scoreBuffer db "SCORE  ", '$'
old_timer :dd 0
score db "0",'$'
pcb			dw 0, 0, 0,0,0,0, 0 ; task0 regs[cs:pcb + 0]
		dw 0, 0, 0,0,0,0, 0 ; task1 regs start at [cs:pcb + 10]
		dw 0, 0, 0,0,0, 0, 0 ;;ask2 regs start at [cs:pcb + 20]

current:	dw 0 

kbr:                    pushA

                        in al, 0x60               
                        cmp al, 0x19              ; p
                        je handle_escape
                        
                        cmp al, 0x39              ;  space 
                        je resume_game
						
						cmp al ,0x01
						je endgame

                        cmp al, 0x48              ; Check if up arrow is pressed
                        jne next_cmp
                        mov byte [cs:birdDirection], 'U'
                        jmp call_originalISR 

    next_cmp:           cmp al, 0x50              ; Check if down arrow is pressed
                        ;jne call_originalISR
                        mov byte [cs:birdDirection], 'W'
                        jmp call_originalISR

handle_escape:         
                        pushA                     

                         push word 3
						 call set_palette1
                        push word escape_screen
                        push word [byte_count]
                        push word [segment1]
                        call renderImage
  
                        mov byte [cs:is_paused], 1 
                        popA                      
                        jmp  call_originalISR

resume_game:            ; Resume the game if paused
                        cmp byte [cs:is_paused], 0
                        je call_originalISR       ;  return

                        pushA                    

                        

                        mov byte [cs:is_paused], 0 

                        popA                     
                        jmp call_originalISR
			endgame:
						push word  3
						call set_palette1					
						push word escape_screen 
						push word [byte_count]
						push word [segment1]
						call renderImage
					
											mov al, 0x20            
						out 0x20, al          
						jmp far [CS:exitProgram] 
						;jmp call_originalISR

call_originalISR:       popA
                        jmp far [cs:original_isr]
timer_interrupt:
								push ax
								push bx
								push cx
								push dx
								
								cmp byte [cs:birdDirection], 'W'
								jne skip_bird_flag_update
								inc word [CS:up_release_tick_count]
								cmp word [CS:up_release_tick_count], 9
								jne skip_bird_flag_update
								mov byte [cs:birdDirection], 'D'
								mov word [CS:up_release_tick_count], 0

skip_bird_flag_update:			mov bl, [cs:current]				; read index of current task ... bl = 0
								mov ax, 14							; space used by one task
								mul bl								; multiply to get start of task.. 10x0 = 0
								mov bx, ax							; load start of task in bx....... bx = 0
								
								pop ax								; read original value of bx
								mov [cs:pcb+bx+6], ax				; space for current task's DX
					
								pop ax								; read original value of bx
								mov [cs:pcb+bx+4], ax				; space for current task's CX
					
								pop ax								; read original value of bx
								mov [cs:pcb+bx+2], ax				; space for current task's BX
					
								pop ax								; read original value of ax
								mov [cs:pcb+bx+0], ax				; space for current task's AX
					
								pop ax								; read original value of ip
								mov [cs:pcb+bx+8], ax				; space for current task
					
								pop ax								; read original value of cs
							mov [cs:pcb+bx+10], ax				; space for current task
					
								pop ax								; read original value of flags
								mov [cs:pcb+bx+12], ax					; space for current task
					
								inc byte [cs:current]				; update current task index...1
								cmp byte [cs:current], 2			; is task index out of range
								jne skipreset						; no, proceed
								mov byte [cs:current], 0			; yes, reset to task 0
					
skipreset:						mov bl, [cs:current]				; read index of current task
								mov ax, 14							; space used by one task
								mul bl								; multiply to get start of task
								mov bx, ax							; load start of task in bx... 10
								
								mov al, 0x20
								out 0x20, al						; send EOI to PIC
					
								push word [cs:pcb+bx+12]				; flags of new task... pcb+10+8
								push word [cs:pcb+bx+10]				; cs of new task ... pcb+10+6
								push word [cs:pcb+bx+8]				; ip of new task... pcb+10+4
								mov ax, [cs:pcb+bx+0]				; ax of new task...pcb+10+0
								mov cx, [cs:pcb+bx+4]				; ax of new task...pcb+10+0
								mov dx, [cs:pcb+bx+6]				; ax of new task...pcb+10+0
								mov bx, [cs:pcb+bx+2]				; bx of new task...pcb+10+2
								
					
								iret								; return to new task


  ; Return to caller
           ; Return to caller

  ; Buffer to hold the score string


; kbr:                    push bp
						; pushA

                        ; cmp byte [cs:birdDirection], 'W'
                        ; jne first_cmp
                        ; inc word [CS:up_release_tick_count]
                        ; cmp word [CS:up_release_tick_count], 9
                        ; jne first_cmp
                        ; mov byte [cs:birdDirection], 'D'
                        ; mov word [CS:up_release_tick_count], 0
                        
    ; first_cmp:          in al, 0x60

						 ; cmp al, 0x19              ; p
                        ; je handle_escape
                   
						; cmp al, 0x39              ;  space 
                        ; je resume_game
						; cmp al, 0x01
						; jne next_cmp  
                        ; mov al, 0x20
                        ; out 0x20, al
						; ; pushf 
						; mov word [bp+4], CS
						; mov word ax, exitProgramFunction1
						; mov word [bp+2], ax
						; popA
						; pop bp
						; iret
						

    ; next_cmp:           cmp al, 0x48
                        ; jne call_originalISR
                        ; mov byte [cs:birdDirection], 'U'
						; jmp call_originalISR         

    ; call_originalISR:   popA
						; pop bp
                        ; jmp far [cs:original_isr]
			; handle_escape:         
                        ; pushA                     

                        
                        ; push word escape_screen
                        ; push word [byte_count]      
                        ; push word [segment1]
                        ; call renderImage
  
                        ; mov byte [cs:is_paused], 1 
                        ; JMP call_originalISR

; resume_game:            ; Resume the game if paused
                        ; cmp byte [cs:is_paused], 0
                        ; je call_originalISR       ;  return

                        ; pushA                    

                        ; mov byte [cs:is_paused], 0 
						; jmp call_originalISR
; ; sukp:                  popA
						; ; ;pop bp
                        ; ; jmp far [cs:original_isr]

hookKeyboard:           pushA
                        push ES
 
                        mov ax, 0x3509
                        int 21h
                        mov word [cs:original_isr], bx
                        mov word [cs:original_isr+2], es
						
                        mov dx, kbr
                        mov ax, 0x2509
                        int 21h

                        pop ES
                        popA
                        ret

addMoveBirdAddress:     mov ax, moveBird
                        mov [cs:moveBirdFunction], ax
                        mov ax, DS
                        mov [cs:moveBirdFunction+2], ax
                        ret

exitProgramFunction1: 
						cli
						xor ax, ax
						mov es,ax  
                        mov ax, [original_isr]
                        mov [ES:9*4], ax
                        mov ax, [original_isr+2]
                        mov [ES:9*4+2], ax
						sti
						
						cli
						xor ax, ax
						mov es,ax  
                        mov ax, [old_timer]
                        mov [ES:8*4], ax
                        mov ax, [old_timer+2]
                        mov [ES:8*4+2], ax
						sti
									
						push word 4
						call set_palette1

                        push word exit_screen
                        push word [byte_count]
                        push word [segment1]

                        call renderImage
					
                    

					
						mov dx,scoreBuffer
						
    mov ah, 0x09
    int 21h
		mov dx,score
						
    mov ah, 0x09
    int 21h

    ; Display your name on the starting screen
    
    lodsb      
  
 mov ah, 0
                        int 16h
    ; Display your name on the starting screen
    
    ; lodsb                     ; Load next character from DS:SI into AL

    ; mov ah, 0
    ; int 16h
         
                        mov ax, 4c00h
                        int 21h
						
addExitAddress:   
	 
						mov ax, exitProgramFunction1
                        mov word [cs:exitProgram], ax
                        mov ax, cs
                        mov word [cs:exitProgram + 2], ax
                        ret
						
change_freq:
						push ax;
						mov al,0x36
						out 0x43,al
						mov ax,[divisor]
						out 0x40,al
						mov al,ah
						out 0x40,al
						pop bx
						ret


start:					;call change_freq

						xor 	ax,ax
						mov 	es,ax
			
			
						mov 	ax,[es:9*4]
						mov 	[original_isr],ax
						mov 	ax,[es:9*4+2]
						mov 	[original_isr+2],ax
						
						
						mov 	ax,[es:8*4]
						mov 	[old_timer],ax
						mov 	ax,[es:8*4+2]
						mov 	[old_timer+2],ax
						cli
						; mov 	word[es:9*4],kbr
						; mov 	[es:9*4+2],cs
						mov 	word[es:8*4], timer_interrupt
						mov 	[es:8*4+2], cs
						sti
			
				
						mov word [cs:pcb+14+8], play_music			; initialize ip
						mov [cs:pcb+14+10], cs						; initialize cs
						mov word [cs:pcb+14+12], 0x0200				; initialize flags
			
						; mov word [cs:pcb+20+4], play_music			; initialize ip
						; mov [cs:pcb+20+6], cs						; initialize cs
						; mov word [cs:pcb+20+8], 0x0200				; initialize flags
			
						mov byte [cs:current], 0						; set current task index
						xor ax, ax
						mov es, ax		
					
; mov ax, 600
; out 0x40, al
; mov al, ah
; out 0x40, al			
			
                        mov ax, 0x0013
                        int 10h
                        
						push word 0
                        call set_palette1
                       
			
                        ;;;starting screen
                        
                        push word start_screen
                        push word [byte_count]
                        push word [segment1]
                        call renderImage
						mov ah, 0
                        int 16h
						mov dx, starting_message
						mov ah, 0x09
						int 21h
					
						; Display your name on the starting screen
						
						lodsb                     ; Load next character from DS:SI into AL
						; Wait for a key press to continue
						mov ah, 0
						int 16h
				
									
						mov word [cs:pcb+14+8], play_music			; initialize ip
						mov [cs:pcb+14+10], cs						; initialize cs
						mov word [cs:pcb+14+12], 0x0200		
									; initialize flags
			
						; mov word [cs:pcb+20+4], music	
								
						; mov word [cs:pcb+14+8], play_music			; initialize ip
						; mov [cs:pcb+14+10], cs						; initialize cs
						; mov word [cs:pcb+14+12], 0x0200		   ;;;escape screen
						push word 1
						call set_palette1
                        push word instr_screen
                        push word [bg_byte_count]
                        push word [segment1]
                        call renderImage
						
					

                        mov ah, 0
                        int 16h
                        
				
						call addExitAddress
                        call hookKeyboard
										; initialize flags

						; push word 1
						; call set_palette1

                        push word [pillar_count]
                        push word rectangle_height
                        push word current_pillar_height
                        call set_pillar_height
						mov word  [current_pillar_height],70
                        push word back_screen
                        push word [byte_count]
                        push word [segment1]
                      

                        push word birdDirection
                        push word [pillar_count]
                        push word [height]
                        push word [grass_height]
                        push word [bg_byte_count]
                        push word bird_row
                        push word [bird_column]
                        push word current_pillar_height          ; passing address
                        push word [rectangle_width]
                        push word [clr_attribute3]
                        push word [space_pillars]
                        push word [rectangle_x1]
                        push word rectangle_y                    ; passing address
                        push word [clr_attribute2]
		                push word [grass_row]
		                push word [width]
                        push word [bg_attribute]
                        push word [byte_count]
                        push word [segment1]
                        push word [offset1]
		                call print_scr   

                        mov ah, 0
                        int 16h                 

    l1:       
	                    cmp byte [cs:is_paused], 1
                        je l1   
						 
                        push word back_screen
                        push word [bg_byte_count]
                        push word [segment1]
                    			; initialize flags


	                    push score
                        push word birdDirection
                        push word [buffer_offset]
                        push word rectangle_height
                        push word [pillar_start_pos]
                        push word [pillar_update_speed]
                        push word [pillar_count]
                        push word [height]
                        push word [grass_height]
                        push word [bg_byte_count]
                        push word bird_row
                        push word [bird_column]
                        push word current_pillar_height          ; passing address
                        push word [rectangle_width]
                        push word [clr_attribute3]
                        push word [space_pillars]
                        push word [rectangle_x1]
                        push word rectangle_y                    ; passing address
                        push word [clr_attribute2]
		                push word [grass_row]
		                push word [width]
                        push word [bg_attribute] 
                        push word [byte_count]
                        push word [segment1]
                        push word [offset1]
                        call printAnimation
						
                        mov ecx, 0xffffff
        l2:             loop l2

                        jmp l1

                        mov ax, 0x4C00 
                        int 21h