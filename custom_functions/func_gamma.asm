;This function tries to apply gamma correction to a GBC palette color
;de holds pointer to the color
;returns value in de
;bits 0 and 1 of b give the pointed color's number within its palette
GBCGamma:
	call GetPredefRegisters
	
	;do not apply the gamma shader if hGBC is !=2
	ld a, [hGBC]
	cp 2
	ret nz
	
	push hl
	push bc
	
	call GetRGB	;store the RGB values at hRGB
	
	call .isBlack
	jr c, .return	;don't do gamma correction on a black color
	
	call MixColorMatrix
		
	call GammaConv

	call WriteRGB
	
.return
	pop bc
	pop hl
	ret
.isBlack	;Check if the current color is a type of black. Return carry if black.
	;check red value
	ld a, [hRGB + 0]
	cp 4	
	ret nc ;not a black if value > 3
	
	;check blue value
	ld a, [hRGB + 2]
	cp 4	
	ret nc ;not a black if value > 3

	;check green value
	ld a, [hRGB + 1]
	cp 4	
	ret

;get the RGB values out of color in de into a spots pointed to by hRGB
GetRGB:
;GetRed:	
	;red bits in e are %00011111
	ld a, e
	and %00011111	;mask to get just the color value
	ld [hRGB + 0], a
;GetGreen:
	;green bits in de are %00000011 11100000
	ld a, e
	and %11100000
	;a is now xxx00000
	ld b, a
	srl b
	srl b
	srl b
	srl b
	srl b
	;b is now 00000xxx
	ld a, d
	and %00000011
	sla a
	sla a
	sla a
	;a is now 000xx000
	or b
	;a is now 000xxxxx
	ld [hRGB + 1], a
;GetBlue:
	;blue bits in d are %01111100
	ld a, d
	rra
	rra
	and %00011111	;mask to get just the color value
	ld [hRGB + 2], a
	ret

;write a colors at hRGB into their proper bit placement in de
WriteRGB:
;writeRed:
	ld a, [hRGB + 0]
	ld b, a
	ld a, e
	and %11100000
	or b
	ld e, a
;writeGreen:
	ld a, [hRGB + 1]
	;					d		e
	;green bits are 00000011 11100000
	;bits in a are 00011111
	rrca
	rrca
	rrca
	ld b, a
	;bits in b are 11100011	
	;now load into d
	and %00000011
	ld c, a
	;bits in c are 00000011
	ld a, d
	and %11111100
	or c
	ld d, a
	;bits in b are still 11100011	
	;now load into e
	ld a, b
	and %11100000
	ld c, a
	;bits in c are 11100000
	ld a, e
	and %00011111
	or c
	ld e, a
;writeBlue:
	ld a, [hRGB + 2]
	ld b, a	;blue bits are 00011111
	ld a, d
	and %10000011
	sla b	;blue bits are 00111110
	sla b	;blue bits are 01111100
	or b
	ld d, a
	ret

;This is does gamma conversions of hRGB color values via lookup list.
GammaConv:
	ld hl, hRGB
	ld c, 3
.loop
	ld a, [hl]
	push hl
	ld hl, GammaList
	push bc
	ld b, $00
	ld c, a
	add hl, bc
	pop bc
	ld a, [hl]
	pop hl
	ld [hli], a
	dec c
	jr nz, .loop
	ret	
GammaList:	;gamma=2 conversion
	db 0	; color value 0
	db 6	; color value 1
	db 8	; color value 2
	db 10	; color value 3
	db 11	; color value 4
	db 12	; color value 5
	db 14	; color value 6
	db 15	; color value 7
	db 16	; color value 8
	db 17	; color value 9
	db 18	; color value 10
	db 18	; color value 11
	db 19	; color value 12
	db 20	; color value 13
	db 21	; color value 14
	db 22	; color value 15
	db 22	; color value 16
	db 23	; color value 17
	db 24	; color value 18
	db 24	; color value 19
	db 25	; color value 20
	db 26	; color value 21
	db 26	; color value 22
	db 27	; color value 23
	db 27	; color value 24
	db 28	; color value 25
	db 28	; color value 26
	db 29	; color value 27
	db 29	; color value 28
	db 30	; color value 29
	db 30	; color value 30
	db 31	; color value 31
	
;Applies the color-mixing matrix to colors at hRGB
;Doing as few calculations as possible to increase speed because a matrix multiply causes lag
MixColorMatrix:
;calculate red row and store it
	ld hl, $0000
	;multiply red value by 13 and add to hl
	ld a, [hRGB + 0]
	ld b, 0
	ld c, a
	push hl
	ld hl, Table5Bx13
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hl]
	ld b, a
	pop hl
	add hl, bc
	;multiply green value by 2 and add to hl
	ld a, [hRGB + 1]
	ld b, 0
	ld c, a
	add hl, bc
	add hl, bc
	;multiply blue value by 1 and add to hl
	ld a, [hRGB + 2]
	ld b, 0
	ld c, a
	add hl, bc
	;shift 4 bits to the right
	srl h
	rr l
	srl h
	rr l
	srl h
	rr l
	srl h
	rr l
	ld a, l
	push af
	
;calculate green row and store it
	ld hl, $0000
	;multiply red value by 0 and add to hl
	;no actions for this
	;multiply green value by 3 and add to hl
	ld a, [hRGB + 1]
	ld b, 0
	ld c, a
	add hl, bc
	add hl, bc
	add hl, bc
	;multiply blue value by 1 and add to hl
	ld a, [hRGB + 2]
	ld b, 0
	ld c, a
	add hl, bc
	;shift 2 bits to the right
	srl h
	rr l
	srl h
	rr l
	ld a, l
	push af
	
;calculate blue row and store it
	ld hl, $0000
	;multiply red value by 0 and add to hl
	;no actions for this
	;multiply green value by 2 and add to hl
	ld a, [hRGB + 1]
	ld b, 0
	ld c, a
	add hl, bc
	add hl, bc
	;multiply blue value by 14 and add to hl
	ld a, [hRGB + 2]
	ld b, 0
	ld c, a
	add hl, bc
	push hl
	ld hl, Table5Bx13
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hl]
	ld b, a
	pop hl
	add hl, bc
	;shift 4 bits to the right
	srl h
	rr l
	srl h
	rr l
	srl h
	rr l
	srl h
	rr l
	ld a, l
	
;now store the color-mixed values
	ld [hRGB + 2], a
	pop af
	ld [hRGB + 1], a
	pop af
	ld [hRGB + 0], a
	
	ret

;lookup table for multiplying a 5-bit number by 13
Table5Bx13:
	dw $0000
	dw $000D
	dw $001A
	dw $0027
	dw $0034
	dw $0041
	dw $004E
	dw $005B
	dw $0068
	dw $0075
	dw $0082
	dw $008F
	dw $009C
	dw $00A9
	dw $00B6
	dw $00C3
	dw $00D0
	dw $00DD
	dw $00EA
	dw $00F7
	dw $0104
	dw $0111
	dw $011E
	dw $012B
	dw $0138
	dw $0145
	dw $0152
	dw $015F
	dw $016C
	dw $0179
	dw $0186
	dw $0193
