Route4Script:
	call EnableAutoTextBoxDrawing
	ld hl, Route4TrainerHeader0
	ld de, Route4ScriptPointers
	ld a, [wRoute4CurScript]
	call ExecuteCurMapScriptInTable
	ld [wRoute4CurScript], a
	ret

Route4ScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle

Route4TextPointers:
	dw Route4Text1
	dw Route4Text2
	dw PickUpItemText
	dw PokeCenterSignText
	dw Route4Text5
	dw Route4Text6

Route4TrainerHeader0:
	dbEventFlagBit EVENT_BEAT_ROUTE_4_TRAINER_0
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROUTE_4_TRAINER_0
	dw Route4BattleText1 ; TextBeforeBattle
	dw Route4AfterBattleText1 ; TextAfterBattle
	dw Route4EndBattleText1 ; TextEndBattle
	dw Route4EndBattleText1 ; TextEndBattle

	db $ff

Route4Text1:
	TX_FAR _Route4Text1
	db "@"

Route4Text2:
	TX_ASM
	CheckEvent EVENT_BEAT_ROUTE_4_TRAINER_0
	jr nz, .Rematch
	ld hl, Route4TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

.Rematch
	ld hl, Route4RematchText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	ld hl, Route4AfterBattleText1
	jr nz, .PrintText
	ld hl, Route4BattleText2
	call PrintText
	ld hl, wd72d
	set 6, [hl]
	set 7, [hl]
	ld hl, Route4EndBattleText1
	ld de, Route4EndBattleText1
	call SaveEndBattleTextPointers
	ld a, [H_SPRITEINDEX]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters
	jp TextScriptEnd

.PrintText
	call PrintText
	jp TextScriptEnd

Route4BattleText1:
	TX_FAR _Route4BattleText1
	db "@"

Route4EndBattleText1:
	TX_FAR _Route4EndBattleText1
	db "@"

Route4AfterBattleText1:
	TX_FAR _Route4AfterBattleText1
	db "@"

Route4RematchText:
	TX_FAR _Route4RematchText
	db "@"

Route4BattleText2:
	TX_FAR _Route4BattleText2
	db "@"

Route4Text5:
	TX_FAR _Route4Text5
	db "@"

Route4Text6:
	TX_FAR _Route4Text6
	db "@"
