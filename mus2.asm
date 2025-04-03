%ifndef mus2_asm
%define mus2_asm



file incbin "getthem.imf"

len dw 18644

play_music:
    ; Initialize index
   mov si, 0 ; current index for music_data

.next_note:
 
    mov dx, 388h
    mov al, [si + file + 0]
    out dx, al

 
    mov dx, 389h
    mov al, [si + file + 1]
    out dx, al

   
    mov bx, [si + file + 2]

   
    add si, 4

  
.repeat_delay:
    mov cx, 2000;
	 shr bx,1

.delay:
    loop .delay 
    dec bx       
    jg .repeat_delay 

    ; Check if end of music_data is reached
    cmp si, [len]
    jb .next_note 
	jmp play_music
%endif