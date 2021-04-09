;This function tries to apply gamma correction to a GBC palette color
;de holds pointer to the color
;returns value in de
;bits 0 and 1 of b give the pointed color's number within its palette
GBCGamma:
	call GetPredefRegisters
	ret
	
	push hl
	push bc
	
	call .isBlack
	jr c, .return	;don't do gamma correction on a black color
	
	;get the red in a then convert it to its gamma-corrected value
	call GetRed
;	call GammaConv
;	call writeRed
	
	;get the green in a then convert it to its gamma-corrected value
	call GetGreen
;	call GammaConv
;	call writeGreen
	
	;get the blue in a then convert it to its gamma-corrected value
	call GetBlue
;	call GammaConv
;	call writeBlue
	
.return
	pop bc
	pop hl
	ret
.isBlack	;Check if the current color is a type of black. Return carry if black.
	;check red value
	call GetRed
	cp 4	
	ret nc ;not a black if value > 3
	
	;check blue value
	call GetBlue
	cp 4	
	ret nc ;not a black if value > 3

	;check blue value
	call GetGreen
	cp 4	
	ret

;get the RGB values out of color in de into a	
GetRed:	
	;red bits in e are %00011111
	ld a, e
	and %00011111	;mask to get just the color value
	ret
GetGreen:
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
	ret
GetBlue:
	;blue bits in d are %01111100
	ld a, d
	rra
	rra
	and %00011111	;mask to get just the color value
	ret
	
GammaConv:
	ld hl, GammaList
	ld b, $00
	ld c, a
	add hl, bc
	ld a, [hl]
	ret
	
writeRed:
	ld b, a
	ld a, e
	and %11100000
	or b
	ld e, a
	ret
writeGreen:
	;					d		e
	;green bits are 00000011 11100000
	;bits in a are 00011111
	rrca
	rrca
	rrca
	ld b, a
	;bits in b are 11100011	
	
	and %00000011
	ld c, a
	;bits in c are 00000011
	ld a, d
	and %11111100
	or c
	ld d, a
	
	ld a, b
	and %11100000
	ld c, a
	;bits in c are 11100000
	ld a, e
	and %00011111
	or c
	ld e, a
	
	ret
writeBlue:
	ld b, a	;blue bits are 00011111
	ld a, d
	and %10000011
	sla b	;blue bits are 00111110
	sla b	;blue bits are 01111100
	or b
	ld d, a
	ret

	
;This is a lookup list for gamma conversions.
GammaList:	;effectively gamma=4 conversion
	db 0	; color value 0
	db 13	; color value 1
	db 16	; color value 2
	db 17	; color value 3
	db 19	; color value 4
	db 20	; color value 5
	db 21	; color value 6
	db 21	; color value 7
	db 22	; color value 8
	db 23	; color value 9
	db 23	; color value 10
	db 24	; color value 11
	db 24	; color value 12
	db 25	; color value 13
	db 25	; color value 14
	db 26	; color value 15
	db 26	; color value 16
	db 27	; color value 17
	db 27	; color value 18
	db 27	; color value 19
	db 28	; color value 20
	db 28	; color value 21
	db 28	; color value 22
	db 29	; color value 23
	db 29	; color value 24
	db 29	; color value 25
	db 30	; color value 26
	db 30	; color value 27
	db 30	; color value 28
	db 30	; color value 29
	db 31	; color value 30
	db 31	; color value 31
