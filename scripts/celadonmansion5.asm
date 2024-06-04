CeladonMansion5Script:
	jp EnableAutoTextBoxDrawing

CeladonMansion5TextPointers:
	dw CeladonMansion5Text1
	dw CeladonMansion5Text2

CeladonMansion5Text1:
	TX_FAR _CeladonMansion5Text1
	db "@"

CeladonMansion5Text2:
	TX_ASM
	ld a, [wNuzlockeMode]
	and a
	jr z, .IgnoreNuzlocke
	ld hl, wNuzlockeRegions
	bit CELADON_CITY_NUZ, [hl]
	jr nz, .nuzNoGift
.IgnoreNuzlocke
	lb bc, EEVEE, 25
	call GivePokemon
	jr nc, .asm_24365
	ld a, [wNuzlockeMode]
	and a
	jr z, .IgnoreNuzlocke2
	ld hl, wNuzlockeRegions
	set CELADON_CITY_NUZ, [hl]
.IgnoreNuzlocke2
	ld a, HS_CELADON_MANSION_5_GIFT
	ld [wMissableObjectIndex], a
	predef HideObject
.asm_24365
	jp TextScriptEnd

.nuzNoGift
	ld hl, CeladonMansion5Text3
	call PrintText
	jp TextScriptEnd

CeladonMansion5Text3:
	TX_FAR _CeladonMansion5Text3
	db "@"

