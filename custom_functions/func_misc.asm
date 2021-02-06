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

	

;joenote - Consolidate horizontal scrolling that uses SCX (such as title screen mons scrolling)
;this is prevents two vblanks from happening when waiting on scrolling to update
;prevents some artifacts when 'mons are panning across the screen
BGLayerScrollingUpdate:
	call GetPredefRegisters
	ld a, NOT_VBLANKED	;set H_VBLANKOCCURRED to a non-zero value ; it becomes zero to indicate vblank happened
	ld [H_VBLANKOCCURRED], a
.wait
	ld a, [rLY] ; rLY
	cp l
	jr z, .update	;update SCX if we have reached the line specified in 'l'
	ld a, [H_VBLANKOCCURRED]	;otherwise see if vblank happened in the meantime
	and a
	jr nz, .wait	;if vblank hasn't happened, then keep waiting to reach the needed line
	ld a, [rLY]	;otherwise vblank happened already while waiting; get the current line
	cp l	;is the current line still less than the needed line?
	jr c, .wait	;if so keep waiting; otherwise just go ahead and update SCX to head off another vblank
.update
	ld a, h
	ld [rSCX], a
	ret
