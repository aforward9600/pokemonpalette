; This function called to store PKMN Levels. Usually at the beginning of battle.
StorePKMNLevels:
	push hl
	push de
	ld a, [wPartyCount]	;1 to 6
	ld b, a	;use b for countdown
	ld hl, wPartyMon1Level
	ld de, wStartBattleLevels
.loopStorePKMNLevels
	ld a, [hl]
	ld [de], a	
	dec b
	jr z, .doneStorePKMNLevels
	push bc
	ld bc, wPartyMon2 - wPartyMon1
	add hl, bc
	inc de
	pop bc
	jr .loopStorePKMNLevels
.doneStorePKMNLevels
	pop de
	pop hl
	ret
