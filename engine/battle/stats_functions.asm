
;Putting some useful functions into this file that are in fact used now

;joenote - custom functions for determining which trainerAI pkmn have already been sent out before
;a=party position of pkmn (like wWhichPokemon). If checking, zero flag gives bit state (1 means sent out already)
CheckAISentOut:
	ld a, [wWhichPokemon]	
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
	ld a, [wWhichPokemon]	
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

CheckAISwitched:
	ld a, [wEnemyMonPartyPos]	
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
	ld a, [wUnusedD366]
	bit 6, a
	jr .partyret
.party4
	ld a, [wUnusedD366]
	bit 5, a
	jr .partyret
.party3
	ld a, [wUnusedD366]
	bit 4, a
	jr .partyret
.party2
	ld a, [wUnusedD366]
	bit 3, a
	jr .partyret
.party1
	ld a, [wUnusedD366]
	bit 2, a
	jr .partyret
.party0
	ld a, [wUnusedD366]
	bit 1, a
.partyret
	ret
	
SetAISwitched:
	ld a, [wEnemyMonPartyPos]	
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
	ld a, [wUnusedD366]
	set 6, a
	ld [wUnusedD366], a
	jr .partyret
.party4
	ld a, [wUnusedD366]
	set 5, a
	ld [wUnusedD366], a
	jr .partyret
.party3
	ld a, [wUnusedD366]
	set 4, a
	ld [wUnusedD366], a
	jr .partyret
.party2
	ld a, [wUnusedD366]
	set 3, a
	ld [wUnusedD366], a
	jr .partyret
.party1
	ld a, [wUnusedD366]
	set 2, a
	ld [wUnusedD366], a
	jr .partyret
.party0
	ld a, [wUnusedD366]
	set 1, a
	ld [wUnusedD366], a
.partyret
	ret
	
SwapTurn:
	ld a, [H_WHOSETURN]
	and a
	jr z, .make_one
	xor a
	jr .leave
.make_one
	inc a
.leave
	ld [H_WHOSETURN], a
	ret

;joenote - check if enemy mon has gen2 shiny DVs	
CheckEnemyShinyDVs:
	push hl
	ld hl, wEnemyMonDVs
	ld a, [hl]	;load MSB
	bit 5, a	;bit 5 of the MSB need to be a 1 for shininess
	jr z, .end
	and $0F	;now mask out the lesser nybble of the MSB
	cp $0A	;need to be a DV of 10 for shininess
	jr nz, .end
	inc hl
	ld a, [hl]	;load LSB
	cp a, $AA	;need to be a DVs of 10 for shininess
	jr nz, .end
	push de
	ld d, $01
	callba PlayShinyAnimation
	pop de
.end
	pop hl
	ret

CheckPlayerShinyDVs:
	push hl
	ld hl, wBattleMonDVs
	ld a, [hl]	;load MSB
	bit 5, a	;bit 5 of the MSB need to be a 1 for shininess
	jr z, .end
	and $0F	;now mask out the lesser nybble of the MSB
	cp $0A	;need to be a DV of 10 for shininess
	jr nz, .end
	inc hl
	ld a, [hl]	;load LSB
	cp a, $AA	;need to be a DVs of 10 for shininess
	jr nz, .end
	push de
	ld d, $00
	callba PlayShinyAnimation
	pop de
.end
	pop hl
	ret