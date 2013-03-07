
; nasm -f bin -o acid acid.S
; chmod +x acid
; 209 bytes

BITS	32

%define lines			13
%define max_shift		6
%define columns			( 13 + max_shift )
%define term_clr_size	10
%define data_size		( lines * ( columns + 1 ) )


	org		0x00200000

	db		0x7F, "ELF", 1, 1, 1			; e_ident

main:
	xor		esi, esi						; Base shift index

f_loop:
	mov		edi, datasection				; Data address
	jmp		short resumeLoop
	dw      2								; e_type
	dw      3								; e_machine
    dd      1								; e_version
    dd      main							; e_entry
    dd      phdr - $$						; e_phoff

phdr:
	dd      1								; e_shoff		; p_type
    dd      0								; e_flags		; p_offset
    dd      $$								; e_ehsize		; p_vaddr
											; e_phentsize
	dw      1								; e_phnum		; p_paddr
	dw		0								; e_shentsize

resumeLoop:
	mov		ebp, lines - 1					; e_shnum		; p_filesz
											; e_shstrndx
	jmp		short y_loop									; p_memsz
	db		1
    dd      7												; p_flags
    dd      0x1000											; p_align

y_loop:
 	mov		dl, columns - 1					; Column counter
	lea		ecx, [ ebp + esi ]				; Look up shift value
 	and		ecx, 0xF
	mov		cl, [ ecx + shift_t ]
	movzx	ebx, word [ ebp * 2 + acid ]	; Prepare acid 1 bpp line
 	shl		ebx, cl							; Must use cl register in shift:(

x_loop:
	mov		al, ' '							; Space character
	shr		ebx, 1
	jae		space
	mov		al, '*'							; Star character

space:
	mov		[ edi ], al
	inc		edi
	sub		dl, 1
	jae		x_loop
	mov		byte [ edi ], 0xA 				; Line feed
	inc		edi
	sub		ebp, 1
	jae		y_loop

	xor		eax, eax             			; Write acid:)
	mov		al, 0x4
	mov		bl, 1
	mov		ecx, term_clr
	mov		edx, data_size + term_clr_size
	int		0x80

	xor		eax, eax             			; nanosleep()
	mov		al, 0xA2
	mov    	ebx, nano_t
	int		0x80
	inc		esi
	jmp		f_loop

	;xor		eax, eax						; Exit program.
	;inc		eax
	;int		0x80

; DATA

shift_t:
	db	3,4,5,6,6,6,5,4						; Shift table
	db	3,2,1,0,0,0,1,2

acid:
	dw	0b0000111110000
	dw	0b0011000001100
	dw	0b0100000000010
	dw	0b0100111110010
	dw	0b1001100011001
	dw	0b1001000001001
	dw	0b1000000000001
	dw	0b1000000000001
	dw	0b1000110110001
	dw	0b0100110110010
	dw	0b0100000000010
	dw	0b0011000001100
	dw	0b0000111110000

nano_t:
	dd	0,50000000							; Input to nanosleep()

term_clr:
	db	27,91,50,74,27,91,49,59,49,72		; Clear screen VT100 codes

datasection:
	;times 260	db	0
