
;joenote - adding new NPC to give coins for showing him pokemon

CeladonHotelScript:
	ld a, [wUnusedD5A3]	;this location gets cleared between area transistions.
	and a
	jr nz, .jump
	push hl
	callba GetRandMonAny	;get random pkmn in wcf91
	pop hl
	ld a, [wcf91]
	ld [wUnusedD5A3], a
.jump
	jp EnableAutoTextBoxDrawing

CeladonHotelTextPointers:
	dw CeladonHotelText1
	dw CeladonHotelText2
	dw CeladonHotelText3
	dw CeladonHotelCoinGuy	

CeladonHotelCoinGuy:
	TX_ASM
	ld hl, CeladonHotelCoinGuyText_intro	
	ld a, [wUnusedD5A3]
	ld [wd11e], a
	call GetMonName
	call PrintText
	ld b, COIN_CASE
	call IsItemInBag
	jr z, .need_coincase
	call Has9740Coins
	jr nc, .too_many_coins
	
	ld a, [wPartyMon1Species]
	ld b, a
	ld a, [wUnusedD5A3]
	cp b
	jr nz, .endscript
	
	callba Mon1DVsBCDScore

	;load 100 coins by default
	xor a
	ld [hUnusedCoinsByte], a
	ld [hCoins + 1], a
	ld a, $01
	ld [hCoins], a
	
	;add normalized BCD DV score to current coin payout
	ld de, hCoins + 1
	ld hl, wcd6d + 1
	ld c, $2	;make the addition 2 bytes long
	predef AddBCDPredef	;add value in hl location to value in de location
	
	ld de, wPlayerCoins + 1
	ld hl, hCoins + 1
	ld c, $2	;make the addition 2 bytes long
	predef AddBCDPredef	;add value in hl location to value in de location
	ld hl, CeladonHotelCoinGuyText_recieved
	call PrintText
	ld a, SFX_GET_ITEM_1
	call PlaySound
	xor a
	ld [wUnusedD5A3], a
	jr .endscript
.too_many_coins
	ld hl, CeladonHotelCoinGuyText_toomuch
	jr .endscript_print
.need_coincase
	ld hl, CeladonHotelCoinGuyText_needcase	
.endscript_print
	call PrintText
.endscript
	jp TextScriptEnd
	
Has9740Coins:
	ld a, $97
	ld [hCoins], a
	ld a, $40
	ld [hCoins + 1], a
	jp HasEnoughCoins

	
CeladonHotelText1:
	TX_FAR _CeladonHotelText1
	db "@"

CeladonHotelText2:
	TX_FAR _CeladonHotelText2
	db "@"

CeladonHotelText3:
	TX_FAR _CeladonHotelText3
	db "@"
	
CeladonHotelCoinGuyText_intro:
	TX_FAR _CeladonHotelCoinGuyText_intro
	db "@"

CeladonHotelCoinGuyText_needcase:
	TX_FAR _CeladonHotelCoinGuyText_needcase
	db "@"

CeladonHotelCoinGuyText_toomuch: 
	TX_FAR _CeladonHotelCoinGuyText_toomuch
	db "@"

CeladonHotelCoinGuyText_recieved:
	TX_FAR _CeladonHotelCoinGuyText_recieved
	db "@"