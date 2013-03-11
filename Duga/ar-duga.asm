

BITS	32

	org     0x00200000

	db      0x7F, "ELF"             ; e_ident

Main:
	mov    	ebx, NanoData
	mov		esi, 370
	jmp		short ResumeMain

	dw      2						; e_type
	dw      3						; e_machine
	dd      1						; e_version
	dd      Main					; e_entry
	dd      phdr - $$				; e_phoff

phdr:
	dd      1						; e_shoff       ; p_type
	dd      0						; e_flags       ; p_offset
	dd      $$						; e_ehsize      ; p_vaddr
									; e_phentsize
	dw      1						; e_phnum       ; p_paddr
	dw      0						; e_shentsize
	dd      fileSize				; e_shnum       ; p_filesz
									; e_shstrndx
	dd      fileSize								; p_memsz
	dd      7										; p_flags

ResumeMain:
	mov		al, 0xA2
	int		0x80

	push	1
	push	4
	push	10
	pop		edx
	pop		eax
	pop		ebx
	mov		ecx, ClearScreenCodes
	int		0x80

UpdateColor:
	test	ebp, ebp
	jz		PrintLine
	not		ebp
	mov		al, byte [ NanoData + 6 ]
	xor		dx, dx
	add		eax, edi
	push	7
	pop		ebx
	div		bx
	add		edx, 0x31
	mov		byte [ String + 3 ], dl

PrintLine:
	xor		dx, dx
	mov		eax, esi
	push	8
	pop		ebx
	div		bx
	mov		cx, dx
	mov		dl, 0x80
	shr		dl, cl
	test	byte [ TextTable + eax ], dl
	mov		al, '#'
	jz		SetSpace
	jmp		CheckForNewLine

SetSpace:
	mov		al, ' '

CheckForNewLine:
	mov		byte [ String + 5 ], al
	xor		dx, dx
	mov		eax, esi
	dec		ax
	push	74
	pop		ebx
	div		bx
	movzx 	ecx, dx
	mov		byte [ NanoData + 6 ], cl
	test	dx, dx
	push	1
	push	4
	push	6
	pop		edx
	pop		eax
	pop		ebx
	jnz		PrintString
	inc		dx
	not		ebp

PrintString:
	mov		ecx, String
	int		0x80

	inc		edi
	dec		esi
	jnz		UpdateColor
	jmp		Main

; DATA

TextTable:
	db	0x44, 0x88, 0xE0, 0x84, 0x4F, 0x84, 0x39, 0x12,
	db	0x24, 0x51, 0x12, 0x44, 0x20, 0x90, 0x21, 0x04,
	db	0x44, 0x49, 0x17, 0xC7, 0x91, 0x08, 0x1C, 0x38,
	db	0x41, 0x1F, 0x1E, 0x7D, 0x12, 0x24, 0x42, 0x09,
	db	0x02, 0x10, 0x44, 0x48, 0x91, 0x38, 0x79, 0x13,
	db	0xE4, 0x4F, 0x9F, 0x39, 0x11, 0xE3, 0x9F

String:
	db	0x1B, 0x5B, 0x33, 0x31, 0x6D, 0x23, 0x0A

NanoData:
	dd	0, 70000000

ClearScreenCodes:
	db	27, 91, 50, 74, 27, 91, 72

fileSize	equ	$ - $$

