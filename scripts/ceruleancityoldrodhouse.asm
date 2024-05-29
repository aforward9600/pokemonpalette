CeruleanCityOldRodHouseScript:
	jp EnableAutoTextBoxDrawing

CeruleanCityOldRodHouseTextPointers:
	dw CeruleanCityOldRodHouseText1

CeruleanCityOldRodHouseText1:
	TX_ASM
	ld a, [wd728]
	bit 3, a
	jr nz, .asm_03ef5
	ld hl, CeruleanCityOldRodHouseText7
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .asm_eb1b7
	lb bc, OLD_ROD, 1
	call GiveItem
	jr nc, .BagFull
	ld hl, wd728
	set 3, [hl]
	ld hl, CeruleanCityOldRodHouseText2
	jr .asm_5dd95
.BagFull
	ld hl, CeruleanCityOldRodHouseText3
	jr .asm_5dd95
.asm_eb1b7
	ld hl, CeruleanCityOldRodHouseText4
	jr .asm_5dd95
.asm_03ef5
	ld hl, CeruleanCityOldRodHouseText5
.asm_5dd95
	call PrintText
	jp TextScriptEnd

CeruleanCityOldRodHouseText7:
	TX_FAR _CeruleanCityOldRodHouseText1
	db "@"

CeruleanCityOldRodHouseText2:
	TX_FAR _CeruleanCityOldRodHouseText2
	TX_SFX_ITEM_1
	TX_FAR _CeruleanCityOldRodHouseText6
	db "@"

CeruleanCityOldRodHouseText4:
	TX_FAR _CeruleanCityOldRodHouseText4
	db "@"

CeruleanCityOldRodHouseText5:
	TX_FAR _CeruleanCityOldRodHouseText5
	db "@"

CeruleanCityOldRodHouseText3:
	TX_FAR _CeruleanCityOldRodHouseText3
	db "@"
