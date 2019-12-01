;joenote - adding in support for the missingno shore encounter

Route20Script:
	CheckAndResetEvent EVENT_IN_SEAFOAM_ISLANDS
	call nz, Route20Script_50cc6
	call EnableAutoTextBoxDrawing
	call MissingnoShore
	ld hl, Route20TrainerHeader0
	ld de, Route20ScriptPointers
	ld a, [wRoute20CurScript]
	call ExecuteCurMapScriptInTable
	ld [wRoute20CurScript], a
	ret

MissingnoShore:
	ld a, [wUnusedD721]	;check if old man has been talked to to activate the shore
	bit 1, a
	jr z, .return	;leave if it hasn't
	ld hl, MissingnoCoordsData	;load the table of coordinates defining the infamous cinnabar shore
	call ArePlayerCoordsInArray	;check player coordinates and set the carry flag if a match is found
	jr nc, .return	;leave if the carry flag is not set
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;everything checks out, so do stuff
	ld a, [wUnusedD721]
	res 1, a
	ld [wUnusedD721], a	;clear cinnabar shore activation
	call Random
	and a 
	jr nz, .return
	call Random
	nop
	cp $0C
	jr nc, .return
	nop
	ld hl, wd72d;set the bits for triggering battle
	set 6, [hl]	;
	set 7, [hl]	;
	ld hl, ExclamationText	;load text for when you win
	ld de, ExclamationText	;load text for when you lose
	call SaveEndBattleTextPointers	;save the win/lose text
	ld a, $9
	ld [wGymLeaderNo], a	;set bgm to champion music
	ld a, OPP_CHIEF	;load the trainer type
	ld [wCurOpponent], a	;set as the current opponent
	ld a, 2	;get the right roster
	ld [wTrainerNo], a
	xor a
	ld [hJoyHeld], a
	jp TextScriptEnd
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.return
	ret
	
MissingnoCoordsData:
		;Y,X
	db $02,$00
	db $03,$00
	db $04,$00
	db $05,$00
	db $06,$00
	db $07,$00
	db $08,$00
	db $09,$00
	db $0A,$00
	db $0B,$00
	db $0C,$00
	db $0D,$00
	db $ff

Route20Script_50cc6:
	CheckBothEventsSet EVENT_SEAFOAM3_BOULDER1_DOWN_HOLE, EVENT_SEAFOAM3_BOULDER2_DOWN_HOLE
	jr z, .asm_50cef
	ld a, HS_SEAFOAM_ISLANDS_1_BOULDER_1
	call Route20Script_50d0c
	ld a, HS_SEAFOAM_ISLANDS_1_BOULDER_2
	call Route20Script_50d0c
	ld hl, .MissableObjectIDs
.asm_50cdc
	ld a, [hli]
	cp $ff
	jr z, .asm_50cef
	push hl
	call Route20Script_50d14
	pop hl
	jr .asm_50cdc

.MissableObjectIDs:
	db HS_SEAFOAM_ISLANDS_2_BOULDER_1
	db HS_SEAFOAM_ISLANDS_2_BOULDER_2
	db HS_SEAFOAM_ISLANDS_3_BOULDER_1
	db HS_SEAFOAM_ISLANDS_3_BOULDER_2
	db HS_SEAFOAM_ISLANDS_4_BOULDER_3
	db HS_SEAFOAM_ISLANDS_4_BOULDER_4
	db $FF

.asm_50cef
	CheckBothEventsSet EVENT_SEAFOAM4_BOULDER1_DOWN_HOLE, EVENT_SEAFOAM4_BOULDER2_DOWN_HOLE
	ret z
	ld a, HS_SEAFOAM_ISLANDS_4_BOULDER_1
	call Route20Script_50d0c
	ld a, HS_SEAFOAM_ISLANDS_4_BOULDER_2
	call Route20Script_50d0c
	ld a, HS_SEAFOAM_ISLANDS_5_BOULDER_1
	call Route20Script_50d14
	ld a, HS_SEAFOAM_ISLANDS_5_BOULDER_2
	call Route20Script_50d14
	ret

Route20Script_50d0c:
	ld [wMissableObjectIndex], a
	predef_jump ShowObject

Route20Script_50d14:
	ld [wMissableObjectIndex], a
	predef_jump HideObject

Route20ScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle

Route20TextPointers:
	dw Route20Text1
	dw Route20Text2
	dw Route20Text3
	dw Route20Text4
	dw Route20Text5
	dw Route20Text6
	dw Route20Text7
	dw Route20Text8
	dw Route20Text9
	dw Route20Text10
	dw Route20Text11
	dw Route20Text12

Route20TrainerHeader0:
	dbEventFlagBit EVENT_BEAT_ROUTE_20_TRAINER_0
	db ($4 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROUTE_20_TRAINER_0
	dw Route20BattleText1 ; TextBeforeBattle
	dw Route20AfterBattleText1 ; TextAfterBattle
	dw Route20EndBattleText1 ; TextEndBattle
	dw Route20EndBattleText1 ; TextEndBattle

Route20TrainerHeader1:
	dbEventFlagBit EVENT_BEAT_ROUTE_20_TRAINER_1
	db ($4 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROUTE_20_TRAINER_1
	dw Route20BattleText2 ; TextBeforeBattle
	dw Route20AfterBattleText2 ; TextAfterBattle
	dw Route20EndBattleText2 ; TextEndBattle
	dw Route20EndBattleText2 ; TextEndBattle

Route20TrainerHeader2:
	dbEventFlagBit EVENT_BEAT_ROUTE_20_TRAINER_2
	db ($2 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROUTE_20_TRAINER_2
	dw Route20BattleText3 ; TextBeforeBattle
	dw Route20AfterBattleText3 ; TextAfterBattle
	dw Route20EndBattleText3 ; TextEndBattle
	dw Route20EndBattleText3 ; TextEndBattle

Route20TrainerHeader3:
	dbEventFlagBit EVENT_BEAT_ROUTE_20_TRAINER_3
	db ($4 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROUTE_20_TRAINER_3
	dw Route20BattleText4 ; TextBeforeBattle
	dw Route20AfterBattleText4 ; TextAfterBattle
	dw Route20EndBattleText4 ; TextEndBattle
	dw Route20EndBattleText4 ; TextEndBattle

Route20TrainerHeader4:
	dbEventFlagBit EVENT_BEAT_ROUTE_20_TRAINER_4
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROUTE_20_TRAINER_4
	dw Route20BattleText5 ; TextBeforeBattle
	dw Route20AfterBattleText5 ; TextAfterBattle
	dw Route20EndBattleText5 ; TextEndBattle
	dw Route20EndBattleText5 ; TextEndBattle

Route20TrainerHeader5:
	dbEventFlagBit EVENT_BEAT_ROUTE_20_TRAINER_5
	db ($4 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROUTE_20_TRAINER_5
	dw Route20BattleText6 ; TextBeforeBattle
	dw Route20AfterBattleText6 ; TextAfterBattle
	dw Route20EndBattleText6 ; TextEndBattle
	dw Route20EndBattleText6 ; TextEndBattle

Route20TrainerHeader6:
	dbEventFlagBit EVENT_BEAT_ROUTE_20_TRAINER_6
	db ($2 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROUTE_20_TRAINER_6
	dw Route20BattleText7 ; TextBeforeBattle
	dw Route20AfterBattleText7 ; TextAfterBattle
	dw Route20EndBattleText7 ; TextEndBattle
	dw Route20EndBattleText7 ; TextEndBattle

Route20TrainerHeader7:
	dbEventFlagBit EVENT_BEAT_ROUTE_20_TRAINER_7, 1
	db ($4 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROUTE_20_TRAINER_7, 1
	dw Route20BattleText8 ; TextBeforeBattle
	dw Route20AfterBattleText8 ; TextAfterBattle
	dw Route20EndBattleText8 ; TextEndBattle
	dw Route20EndBattleText8 ; TextEndBattle

Route20TrainerHeader8:
	dbEventFlagBit EVENT_BEAT_ROUTE_20_TRAINER_8, 1
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROUTE_20_TRAINER_8, 1
	dw Route20BattleText9 ; TextBeforeBattle
	dw Route20AfterBattleText9 ; TextAfterBattle
	dw Route20EndBattleText9 ; TextEndBattle
	dw Route20EndBattleText9 ; TextEndBattle

Route20TrainerHeader9:
	dbEventFlagBit EVENT_BEAT_ROUTE_20_TRAINER_9, 1
	db ($4 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROUTE_20_TRAINER_9, 1
	dw Route20BattleText10 ; TextBeforeBattle
	dw Route20AfterBattleText10 ; TextAfterBattle
	dw Route20EndBattleText10 ; TextEndBattle
	dw Route20EndBattleText10 ; TextEndBattle

	db $ff

Route20Text1:
	TX_ASM
	ld hl, Route20TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

Route20Text2:
	TX_ASM
	ld hl, Route20TrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

Route20Text3:
	TX_ASM
	ld hl, Route20TrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

Route20Text4:
	TX_ASM
	ld hl, Route20TrainerHeader3
	call TalkToTrainer
	jp TextScriptEnd

Route20Text5:
	TX_ASM
	ld hl, Route20TrainerHeader4
	call TalkToTrainer
	jp TextScriptEnd

Route20Text6:
	TX_ASM
	ld hl, Route20TrainerHeader5
	call TalkToTrainer
	jp TextScriptEnd

Route20Text7:
	TX_ASM
	ld hl, Route20TrainerHeader6
	call TalkToTrainer
	jp TextScriptEnd

Route20Text8:
	TX_ASM
	ld hl, Route20TrainerHeader7
	call TalkToTrainer
	jp TextScriptEnd

Route20Text9:
	TX_ASM
	ld hl, Route20TrainerHeader8
	call TalkToTrainer
	jp TextScriptEnd

Route20Text10:
	TX_ASM
	ld hl, Route20TrainerHeader9
	call TalkToTrainer
	jp TextScriptEnd

Route20BattleText1:
	TX_FAR _Route20BattleText1
	db "@"

Route20EndBattleText1:
	TX_FAR _Route20EndBattleText1
	db "@"

Route20AfterBattleText1:
	TX_FAR _Route20AfterBattleText1
	db "@"

Route20BattleText2:
	TX_FAR _Route20BattleText2
	db "@"

Route20EndBattleText2:
	TX_FAR _Route20EndBattleText2
	db "@"

Route20AfterBattleText2:
	TX_FAR _Route20AfterBattleText2
	db "@"

Route20BattleText3:
	TX_FAR _Route20BattleText3
	db "@"

Route20EndBattleText3:
	TX_FAR _Route20EndBattleText3
	db "@"

Route20AfterBattleText3:
	TX_FAR _Route20AfterBattleText3
	db "@"

Route20BattleText4:
	TX_FAR _Route20BattleText4
	db "@"

Route20EndBattleText4:
	TX_FAR _Route20EndBattleText4
	db "@"

Route20AfterBattleText4:
	TX_FAR _Route20AfterBattleText4
	db "@"

Route20BattleText5:
	TX_FAR _Route20BattleText5
	db "@"

Route20EndBattleText5:
	TX_FAR _Route20EndBattleText5
	db "@"

Route20AfterBattleText5:
	TX_FAR _Route20AfterBattleText5
	db "@"

Route20BattleText6:
	TX_FAR _Route20BattleText6
	db "@"

Route20EndBattleText6:
	TX_FAR _Route20EndBattleText6
	db "@"

Route20AfterBattleText6:
	TX_FAR _Route20AfterBattleText6
	db "@"

Route20BattleText7:
	TX_FAR _Route20BattleText7
	db "@"

Route20EndBattleText7:
	TX_FAR _Route20EndBattleText7
	db "@"

Route20AfterBattleText7:
	TX_FAR _Route20AfterBattleText7
	db "@"

Route20BattleText8:
	TX_FAR _Route20BattleText8
	db "@"

Route20EndBattleText8:
	TX_FAR _Route20EndBattleText8
	db "@"

Route20AfterBattleText8:
	TX_FAR _Route20AfterBattleText8
	db "@"

Route20BattleText9:
	TX_FAR _Route20BattleText9
	db "@"

Route20EndBattleText9:
	TX_FAR _Route20EndBattleText9
	db "@"

Route20AfterBattleText9:
	TX_FAR _Route20AfterBattleText9
	db "@"

Route20BattleText10:
	TX_FAR _Route20BattleText10
	db "@"

Route20EndBattleText10:
	TX_FAR _Route20EndBattleText10
	db "@"

Route20AfterBattleText10:
	TX_FAR _Route20AfterBattleText10
	db "@"

Route20Text12:
Route20Text11:
	TX_FAR _Route20Text11
	db "@"
