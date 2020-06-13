;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; wispnote - This function called to store PKMN Levels at the Beggining of the Battle.
; Used letter for correctly perform the evolution routine.
StorePKMNLevels:
	xor a
	ld [wMonDataLocation], a
	ld [wWhichPokemon], a
	ld hl, wPartyCount
	ld de, wStartBattleLevels
	push de
	push hl
.loopStorePKMNLevels
	pop hl
	inc hl
	ld a, [hl]
	cp $ff
	jp z, .doneStorePKMNLevels
	push hl
	call LoadMonData
	pop hl
	pop de
	ld a, [wWhichPokemon]
	inc a
	ld [wWhichPokemon], a
	ld a, [wLoadedMonLevel]
	ld [de], a
	inc de
	push de
	push hl
	jp .loopStorePKMNLevels
.doneStorePKMNLevels
	pop de
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

