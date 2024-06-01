SSAnne11Script:
	call EnableAutoTextBoxDrawing
	ret

SSAnne11TextPointers:
	dw SSAnne11Text1

SSAnne11Text1:
	TX_ASM
	ld hl, SSAnneHealText1
	call PrintText
	call GBFadeOutToWhite
	call ReloadMapData
	predef HealParty
	ld a, MUSIC_PKMN_HEALED
	ld [wNewSoundID], a
	call PlaySound
.next
	ld a, [wChannelSoundIDs]
	cp MUSIC_PKMN_HEALED
	jr z, .next
	ld a, [wMapMusicSoundID]
	ld [wNewSoundID], a
	call PlaySound
	call GBFadeInFromWhite
	ld hl, SSAnneHealText2
	call PrintText
	jp TextScriptEnd

SSAnneHealText1:
	TX_FAR _SSAnneHealText1
	db "@"

SSAnneHealText2:
	TX_FAR _SSAnneHealText2
	db "@"
