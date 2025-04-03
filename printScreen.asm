; %ifndef printScreen_asm
; %define printScreen_asm

; %include "clrscr.asm"
; %include "printPillars.asm"
; %include "printGrass.asm"

; %include "batt.asm"

; print_scr:		push bp
				; mov bp, sp
				
				; pusha
				; push es

				; push word[bp+10]			; ax = 0x0000
				; push word[bp+34]			; cx = 320*190 = 64,000
				; push word[bp+6]				; es = 0xA000
				; push word[bp+4]				; di = 0x0000
				; call clrscr

				; push word[bp+16]			; attribute (color) = 0x02 (green)
				; push word[bp+8]				; total bytes = 320*200 = 64,000
				; push word[bp+14]			; row number = 194
				; push word[bp+12]			; cx = width (columns) = 320
				; push word[bp+6]				; es = 0xA000
				; call grass
				; mov ax,0xA000
				; mov es,ax
				; mov ax,0
				; mov cx,8
				; mov di,60920
; rep stosw
				
				; push word [bp+36]			; grass height
				; push word [bp+22]			; space between pillars
				; push word [bp+38]			; height = 200
				
				; push word [bp+40]			; rectangle height = 72
				; push word [bp+26]			; rectangle width = 30
				; push word [bp+24]			; attribute (color) = 0x04 (red)
				; push word [bp+12]			; width (columns) = 320
				; push word [bp+20]			; x = 0
				; push word [bp+18]			; y = 260
				; push word [bp+6]			; es = 0xA000
				; call printPillars

			
				; push word[bp+32]
				; push word[bp+30]
			; push word 0x04
		
				; call printBirdy

			
				; pop es
				; popa
				; mov sp, bp
				; pop bp
				; ret 38

; %endif
%ifndef printScreen_asm
%define printScreen_asm
%include "palette.asm"
%include "clrscr.asm"
%include "printPillars.asm"
%include "printGrass.asm"
%include "batt.asm"
  %include "renderImage.asm"

print_scr:		push bp
				mov bp, sp
				
				pusha
				push es
				push word 2
				call set_palette1
				push word [bp+48]
				push word[bp+46]
push word[bp+44]
call renderImage
				; push word[bp+10]			; ax = 0x0000
				; push word[bp+34]			; cx = 320*190 = 64,000
				; push word[bp+6]				; es = 0xA000
				; push word[bp+4]				; di = 0x0000
				; call clrscr

				push word[bp+16]			; attribute (color) = 0x02 (green)
				push word[bp+8]				; total bytes = 320*200 = 64,000
				push word[bp+14]			; row number = 194
				push word[bp+12]			; cx = width (columns) = 320
				push word[bp+6]				; es = 0xA000
				call grass

				push word [bp+40]			; pillar count
				push word [bp+36]			; grass height
				push word [bp+22]			; space between pillars
				push word [bp+38]			; height = 200
				push word [bp+28]			; rectangle height = 72
				push word [bp+26]			; rectangle width = 30
				push word [bp+24]			; attribute (color) = 0x04 (red)
				push word [bp+12]			; width (columns) = 320
				push word [bp+20]			; x = 0
				push word [bp+18]			; rectangle_y = 260
				push word [bp+6]			; es = 0xA000
				call printPillars

				push word[bp+32]
				push word[bp+30]
				push word 0x0000
				call printBirdy

				pop es
				popa
				mov sp, bp
				pop bp
				ret 40

%endif
