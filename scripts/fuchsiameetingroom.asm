FuchsiaMeetingRoomScript:
	call EnableAutoTextBoxDrawing
	ret

FuchsiaMeetingRoomTextPointers:
	dw FuchsiaMeetingRoomText1
	dw FuchsiaMeetingRoomText2
	dw FuchsiaMeetingRoomText3
	dw FuchsiaMeetingRoomText4

FuchsiaMeetingRoomText1:
	TX_FAR _FuchsiaMeetingRoomText1
	db "@"

FuchsiaMeetingRoomText2:
	TX_FAR _FuchsiaMeetingRoomText2
	db "@"

FuchsiaMeetingRoomText3:
	TX_FAR _FuchsiaMeetingRoomText3
	db "@"

FuchsiaMeetingRoomText4:
	TX_ASM
	CheckEvent EVENT_GOT_SECOND_FOSSIL
	jr nz, .AlreadyGotFossil
	ld hl, FuchsiaCitySuperNerd1Text
	call PrintText
	CheckEventReuseA EVENT_GOT_DOME_FOSSIL
	jr nz, .GetHelixFossil
	CheckEventReuseA EVENT_GOT_HELIX_FOSSIL
	jr nz, .GetDomeFossil
.AlreadyGotFossil
	ld hl, FuchsiaCitySuperNerd2Text
	call PrintText
	jr .EndFuchsiaCitySuperNerd
.GetHelixFossil
	lb bc, HELIX_FOSSIL, 1
	call GiveItem
	jr nc, .BagFull
	jr .ReconveneFossil
.GetDomeFossil
	lb bc, DOME_FOSSIL, 1
	call GiveItem
	jr nc, .BagFull
.ReconveneFossil
	SetEvent EVENT_GOT_SECOND_FOSSIL
	ld hl, FuchsiaCityGotFossilText
	call PrintText
	jr .EndFuchsiaCitySuperNerd
.BagFull
	ld hl, FuchsiaCityNoRoomText
	call PrintText
.EndFuchsiaCitySuperNerd
	jp TextScriptEnd

FuchsiaCityNoRoomText:
	TX_FAR _FuchsiaCityNoRoomText
	db "@"

FuchsiaCitySuperNerd1Text:
	TX_FAR _FuchsiaCitySuperNerd1Text
	db "@"

FuchsiaCitySuperNerd2Text:
	TX_FAR _FuchsiaCitySuperNerd2Text
	db "@"

FuchsiaCityGotFossilText:
	TX_FAR _FuchsiaCityGotFossilText
	TX_SFX_KEY_ITEM
	TX_WAIT
	db "@"
