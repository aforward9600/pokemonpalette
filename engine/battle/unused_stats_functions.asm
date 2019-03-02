
;Putting some useful functions into this file that are in fact used now

;joenote - custom functions for determining which trainerAI pkmn have already been sent out before
;a=party position of pkmn (like wWhichPokemon). If checking, zero flag gives bit state (1 means sent out already)
CheckAISentOut:
	cp $05
	jr z, .party5
	cp $04
	jr z, .party4
	cp $03
	jr z, .party3
	cp $02
	jr z, .party2
	cp $01
	jr z, .party1
	jr .party0
.party5
	ld a, [wFontLoaded]
	bit 6, a
	jr .partyret
.party4
	ld a, [wFontLoaded]
	bit 5, a
	jr .partyret
.party3
	ld a, [wFontLoaded]
	bit 4, a
	jr .partyret
.party2
	ld a, [wFontLoaded]
	bit 3, a
	jr .partyret
.party1
	ld a, [wFontLoaded]
	bit 2, a
	jr .partyret
.party0
	ld a, [wFontLoaded]
	bit 1, a
.partyret
	ret
	
SetAISentOut:
	cp $05
	jr z, .party5
	cp $04
	jr z, .party4
	cp $03
	jr z, .party3
	cp $02
	jr z, .party2
	cp $01
	jr z, .party1
	jr .party0
.party5
	ld a, [wFontLoaded]
	set 6, a
	ld [wFontLoaded], a
	jr .partyret
.party4
	ld a, [wFontLoaded]
	set 5, a
	ld [wFontLoaded], a
	jr .partyret
.party3
	ld a, [wFontLoaded]
	set 4, a
	ld [wFontLoaded], a
	jr .partyret
.party2
	ld a, [wFontLoaded]
	set 3, a
	ld [wFontLoaded], a
	jr .partyret
.party1
	ld a, [wFontLoaded]
	set 2, a
	ld [wFontLoaded], a
	jr .partyret
.party0
	ld a, [wFontLoaded]
	set 1, a
	ld [wFontLoaded], a
.partyret
	ret

;joenote - this function puts 648 statexp per enemy pkmn level into de
;requires a, b, de, and wCurEnemyLVL
CalcEnemyStatEXP:
;note that 648 in hex is the two-byte $0288
	ld a, [wCurEnemyLVL]
	ld b, a	;put the enemy's level into b. it will be used as a loop counter
	xor a	;make a = 0
	ld d, a	;clear d (use for MSB)
	ld e, a ;clear e (use for LSB)
.loop
	ld a, d
	cp a, $FF	;see if the current value of de is 65280 or more
	jr z, .skipadder
	ld a, e ;put e into a 
	add $88	;add $88 to a (if this overflows the c flag is set)
	ld e, a ;put a back into e
	ld a, d ;put d into a 
	adc $02 ;add $02 + carry bit to a (carry bit adds an extra 1 if e overflowed)
	ld d, a ;put a back into d 
.skipadder
	dec b; decrement b 
	jr nz, .loop	;loop back if b is not zero
	ret
	








; does nothing since no stats are ever selected (barring glitches)
DoubleSelectedStats:
	ld a, [H_WHOSETURN]
	and a
	ld a, [wPlayerStatsToDouble]
	ld hl, wBattleMonAttack + 1
	jr z, .notEnemyTurn
	ld a, [wEnemyStatsToDouble]
	ld hl, wEnemyMonAttack + 1
.notEnemyTurn
	ld c, 4
	ld b, a
.loop
	srl b
	call c, .doubleStat
	inc hl
	inc hl
	dec c
	ret z
	jr .loop

.doubleStat
	ld a, [hl]
	add a
	ld [hld], a
	ld a, [hl]
	rl a
	ld [hli], a
	ret

; does nothing since no stats are ever selected (barring glitches)
HalveSelectedStats:
	ld a, [H_WHOSETURN]
	and a
	ld a, [wPlayerStatsToHalve]
	ld hl, wBattleMonAttack
	jr z, .notEnemyTurn
	ld a, [wEnemyStatsToHalve]
	ld hl, wEnemyMonAttack
.notEnemyTurn
	ld c, 4
	ld b, a
.loop
	srl b
	call c, .halveStat
	inc hl
	inc hl
	dec c
	ret z
	jr .loop

.halveStat
	ld a, [hl]
	srl a
	ld [hli], a
	rr [hl]
	or [hl]
	jr nz, .nonzeroStat
	ld [hl], 1
.nonzeroStat
	dec hl
	ret
