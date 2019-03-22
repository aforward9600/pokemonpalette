
;joenote - adding scripts for random trainer battle

UndergroundPathEntranceRoute7Script:
	ld a, ROUTE_7
	ld [wLastMap], a
	jp EnableAutoTextBoxDrawing

UndergroundPathEntranceRoute7TextPointers:
	dw UndergroundPathEntranceRoute7Text1
	dw RandTrainerText2

UndergroundPathEntranceRoute7Text1:
	TX_FAR _UndergroundPathEntRoute7Text1
	db "@"

RandTrainerText2:
	TX_ASM
	ld hl, RandTrainerIntro
	CheckEvent EVENT_908	;has elite 4 been beaten?
	jr nz, .ready	;jump if beaten
	ld hl, RandTrainerNotReady
	call PrintText
	jr .textend
.ready
	call PrintText
	call ManualTextScroll
	ld hl, RandTrainerChallenge
	call PrintText
	call YesNoChoice	;prompt a yes/no choice
	ld a, [wCurrentMenuItem]	;load the player choice
	and a	;check the player choice
	jr nz, .goodbye	;if no, jump
	;otherwise begin loading battle
	SetEvent EVENT_90A
	ld hl, RandTrainerPre
	call PrintText
	ld hl, wd72d;set the bits for triggering battle
	set 6, [hl]	;
	set 7, [hl]	;
	ld hl, RandTrainerPost	;load text for when you win
	ld de, RandTrainerPost	;load text for when you lose
	call SaveEndBattleTextPointers	;save the win/lose text
	ld a, [H_SPRITEINDEX]
	ld [wSpriteIndex], a
	callba GetRandTrainer
	;call EngageMapTrainer
	call InitBattleEnemyParameters
	;ld a, $09	;load 9 into the gym leader value to play final battle music 
	;ld [wGymLeaderNo], a
	xor a
	ld [hJoyHeld], a
	jr .textend
.goodbye
	ld hl, RandTrainerBye
	call PrintText
.textend
	jp TextScriptEnd
	
RandTrainerNotReady:
	TX_FAR _RandTrainerNotReady
	db "@"
RandTrainerIntro:
	TX_FAR _RandTrainerIntro
	db "@"
RandTrainerChallenge:
	TX_FAR _RandTrainerChallenge
	db "@"
RandTrainerBye:
	TX_FAR _RandTrainerBye
	db "@"
RandTrainerPre:
	TX_FAR _RandTrainerPre
	db "@"
RandTrainerPost:
	TX_FAR _RandTrainerPost
	db "@"

