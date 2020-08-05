;joenote - implement RNG from Prism and Polished Crystal
Random_::
; Generate a random 16-bit value.
;	ld a, [rDIV]
;	ld b, a
;	ld a, [hRandomAdd]
;	adc b
;	ld [hRandomAdd], a
;	ld a, [rDIV]
;	ld b, a
;	ld a, [hRandomSub]
;	sbc b
;	ld [hRandomSub], a
;	ret

	; just like the stock RNG, this exits with the value in [hRandomSub]
	; it also stores a random value in [hRandomAdd]
	push hl
	push bc
	push de
	call UpdateDividerCounters
	ld hl, wRNGState
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld d, a
	ld e, [hl]
	ld a, e
	add a, a
	xor b
	ld b, a
	ld a, d
	rla
	ld l, c
	rl l
	ld h, b
	rl h
	sbc a
	and 1
	xor c
	ld c, a
	ld a, h
	xor d
	ld d, a
	ld a, l
	xor e
	ld e, a
	ld h, b
	ld l, c
	push hl
	ld h, d
	ld a, e
	rept 2
		sla e
		rl d
		rl c
		rl b
	endr
	xor e
	ld e, a
	ld a, h
	xor d
	ld d, a
	pop hl
	ld a, l
	xor c
	ld c, a
	ld a, h
	xor b
	ld hl, wRNGState
	ld [hli], a
	ld a, c
	ld [hli], a
	ld a, d
	ld [hli], a
	ld [hl], e
	ld a, [rDIV]
	add a, [hl]
	ld [hRandomAdd], a
	ld a, [hli]
	inc hl
	inc hl
	sub [hl]
	ld [hRandomSub], a
	pop de
	pop bc
	pop hl
	ret

UpdateDividerCounters::
	ld a, [rDIV]
	ld hl, wRNGCumulativeDividerMinus
	sbc [hl]
	ld [hld], a
	ld a, [rDIV]
	adc [hl]
	ld [hld], a
	ret nc
	inc [hl]
	ret

AdvanceRNGState::
	ld hl, wRNGState
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld l, [hl]
	ld h, a
	ld a, [rDIV]
	rra
	jr nc, .try_upper
.try_lower
	ld a, h
	cp d
	ld a, l
	jr nz, .lower
	cp e
	jr nz, .lower
.upper
	xor c
	ld c, a
	ld a, h
	xor b
	jr .done
.try_upper
	ld a, h
	cp b
	ld a, l
	jr nz, .upper
	cp c
	jr nz, .upper
.lower
	xor e
	ld e, a
	ld a, h
	xor d
	ld d, a
	ld a, b
.done
	ld hl, wRNGState
	ld [hli], a
	ld a, c
	ld [hli], a
	ld a, d
	ld [hli], a
	ld [hl], e
	ret