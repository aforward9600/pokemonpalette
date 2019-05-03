StartSlotMachine:
	ld a, [wHiddenObjectFunctionArgument]
	cp $fd
	jr z, .printOutOfOrder
	cp $fe
	jr z, .printOutToLunch
	cp $ff
	jr z, .printSomeonesKeys
	callba AbleToPlaySlotsCheck
	ld a, [wCanPlaySlots]
	and a
	ret z
;	ld a, [wLuckySlotHiddenObjectIndex]
;	ld b, a
;	ld a, [wHiddenObjectIndex]
;	inc a
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;joenote - increase number of lucky machines to four
	ld a, [wLuckySlotHiddenObjectIndex]
	and $07
	ld b, a
	ld a, [wHiddenObjectIndex]
	inc a
	and $07
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
	cp b
	jr z, .match
	;ld a, 253
	ld a, 250	;joenote - slightly increase odds of fever mode
	jr .next
.match
	callba LuckySlotDetect	;joenote - play cry for the lucky slot if the ist pokemon has payday
	;ld a, 250
	ld a, 240	;joenote - slightly increase odds of fever mode
	
.next
	ld [wSlotMachineSevenAndBarModeChance], a
	ld a, [H_LOADEDROMBANK]
	ld [wSlotMachineSavedROMBank], a
	call PromptUserToPlaySlots
	ret
.printOutOfOrder
	tx_pre_id GameCornerOutOfOrderText
	jr .printText
.printOutToLunch
	tx_pre_id GameCornerOutToLunchText
	jr .printText
.printSomeonesKeys
	tx_pre_id GameCornerSomeonesKeysText
.printText
	push af
	call EnableAutoTextBoxDrawing
	pop af
	call PrintPredefTextID
	ret

GameCornerOutOfOrderText:
	TX_FAR _GameCornerOutOfOrderText
	db "@"

GameCornerOutToLunchText:
	TX_FAR _GameCornerOutToLunchText
	db "@"

GameCornerSomeonesKeysText:
	TX_FAR _GameCornerSomeonesKeysText
	db "@"
