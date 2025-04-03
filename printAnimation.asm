; %ifndef printAnimation_asm
; %define printAnimation_asm

; %include "batt.asm"
; %include "clrscr.asm"
; %include "printPillars.asm"

; %include "moveGrass.asm"
; %include "update_pillar_coordinates.asm"
; %include "moveBird.asm"

; printAnimation:         push bp
				        ; mov bp, sp

				        ; pusha
				        ; push es

						; push word [bp+46]
						; push word [bp+28]
						; push word [bp+44]							; pillar starting position
						; push word [bp+42]							; pillar update speed
						; push word [bp+40]							; pillar count
						; push word [bp+18]							; y
                        ; call update_pillar_coordinates

						
						; push word [bp+50]
						; push word [bp+32]
                        ; call moveBird

				        ; push word[bp+10]			; ax = 0x0000
				        ; push word[bp+34]			; cx = 320*190 
				        ; push word[bp+6]				; es = 0xA000
				        ; push word[bp+4]				; di = 0x0000
				        ; call clrscr

						; push word [bp+48]			; buffer offset
						; push word [bp+36]			; grass height
						; push word [bp+14]			; row number = 190
						; push word [bp+12]			; columns = 320
						; push word [bp+6]			; 0xA000
                        ; call moveGrass

				        ; push word [bp+36]			; grass height
				        ; push word [bp+22]			; space between pillars
				        ; push word [bp+38]			; height = 200

				        ; push word [bp+28]			; rectangle height = 72
				        ; push word [bp+26]			; rectangle width = 30
				        ; push word [bp+24]			; attribute (color) = 0x04 (red)
				        ; push word [bp+12]			; width (columns) = 320
				        ; push word [bp+20]			; x = 0
				        ; push word [bp+18]			; y = 260
				        ; push word [bp+6]			; es = 0xA000
				        ; call printPillars
	; push word [bp+50]
				        ; push word[bp+32]
				        ; push word[bp+30]
				        ; push word 0x04
					
					
				        ; call printBirdy

				      

				        ; pop es
				        ; popa
						; mov sp, bp
				        ; pop bp
				        ; ret 48
                                          

; %endif
%ifndef printAnimation_asm
%define printAnimation_asm

; ; ; screen has already been printed once in the main before the calling of this function
; ; ; prints background as it is
; ; ; updates birds coordinates and prints it
; ; ; updates pillar coordinates and prints it
; ; ; moves grass
%include "palette.asm"
%include "clrscr.asm"
%include "printPillars.asm"
  %include "renderImage.asm"
%include "moveGrass.asm"
%include "update_pillar_coordinates.asm"
%include "moveBird.asm"
%include "batt.asm"

printAnimation:         push bp
				        mov bp, sp

				        pusha
				        push es

						push word [bp+52]							; score (address)
						push word [bp+46]							; rectangle height address
						push word [bp+28]							; current pillar height
						push word [bp+44]							; pillar starting position
						push word [bp+42]							; pillar update speed
						push word [bp+40]							; pillar count
						push word [bp+18]							; y
                        call update_pillar_coordinates

						
						push word [bp+50]
						push word [bp+32]
                        call moveBird
						push word 2
						call set_palette1
						push word [bp+58]
						push word[bp+56]
						push word[bp+54]
						call renderImage

				        ; push word[bp+10]							; ax = 0x0000
				        ; push word[bp+34]							; cx = 320*190 
				        ; push word[bp+6]								; es = 0xA000
				        ; push word[bp+4]								; di = 0x0000
				        ; call clrscr				
				
						push word [bp+48]							; buffer offset
						push word [bp+36]							; grass height
						push word [bp+14]							; row number = 190
						push word [bp+12]							; columns = 320
						push word [bp+6]							; 0xA000
                        call moveGrass				
				
						push word [bp+40]							; pillar count
				        push word [bp+36]							; grass height
				        push word [bp+22]							; space between pillars
				        push word [bp+38]							; height = 200
				        push word [bp+28]							; rectangle height = 72
				        push word [bp+26]							; rectangle width = 30
				        push word [bp+24]							; attribute (color) = 0x04 (red)
				        push word [bp+12]							; width (columns) = 320
				        push word [bp+20]							; x = 0
				        push word [bp+18]							; y = 260
				        push word [bp+6]							; es = 0xA000
				        call printPillars

						push word [bp+32]
				        push word [bp+30]
						push word 0x0000
						call printBirdy
						

				        pop es
				        popa
						mov sp, bp
				        pop bp
				        ret 50
                                          

%endif