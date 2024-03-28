BluesHouseScript:
	call EnableAutoTextBoxDrawing
	ld hl, BluesHouseScriptPointers
	ld a, [wBluesHouseCurScript]
	jp CallFunctionInTable

BluesHouseScriptPointers:
	dw BluesHouseScript0
	dw BluesHouseScript1

BluesHouseScript0:
	SetEvent EVENT_ENTERED_BLUES_HOUSE

	; trigger the next script
	ld a, 1
	ld [wBluesHouseCurScript], a
	ret

BluesHouseScript1:
	ret

BluesHouseTextPointers:
	dw BluesHouseText1
	dw BluesHouseText2
	dw BluesHouseText3

BluesHouseText1:
	TX_ASM
	CheckEvent EVENT_GOT_TOWN_MAP
	jr nz, .GotMap
	CheckEvent EVENT_GOT_POKEDEX
	jr nz, .GiveMap
	ld hl, DaisyInitialText
	call PrintText
	jp .done

.GiveMap
	ld hl, DaisyOfferMapText
	call PrintText
	lb bc, TOWN_MAP, 1
	call GiveItem
	jr nc, .BagFull
	ld a, HS_TOWN_MAP
	ld [wMissableObjectIndex], a
	predef HideObject ; hide table map object
	ld hl, GotMapText
	call PrintText
	SetEvent EVENT_GOT_TOWN_MAP
	jr .done

.GotMap
	ld hl, DaisyUseMapText
	call PrintText
	jr .done

.BagFull
	ld hl, DaisyBagFullText
	call PrintText
.done
	jp TextScriptEnd

DaisyInitialText:
	TX_FAR _DaisyInitialText
	db "@"

DaisyOfferMapText:
	TX_FAR _DaisyOfferMapText
	db "@"

GotMapText:
	TX_FAR _GotMapText
	TX_SFX_KEY_ITEM
	db "@"

DaisyBagFullText:
	TX_FAR _DaisyBagFullText
	db "@"

DaisyUseMapText:
	TX_FAR _DaisyUseMapText
	db "@"

BluesHouseText2: ; Daisy, walking around
	TX_ASM
	CheckEvent EVENT_BEAT_POKEMON_LEAGUE
	jr z, .DontGetStarter
	CheckEventReuseA EVENT_GOT_STARTER_FROM_DAISY
	jr z, .GetStarter
	ld hl, TakeGoodCareOfItText
	call PrintText
	jr .done

.DontGetStarter
	ld hl, BluesHouseText2Text
	call PrintText
	jr .done

.GetStarter
	ld hl, GiveStarterText
	call PrintText
	ld a, [wRivalStarter]
	cp STARTER2
	jr nz, .NotSquirtle
	lb bc, SQUIRTLE, 5
	call GivePokemon
	jr nc, .done
	jr .finishstarter
.NotSquirtle
	cp STARTER3
	jr nz, .Charmander
	lb bc, BULBASAUR, 5
	call GivePokemon
	jr nc, .done
	jr .finishstarter
.Charmander
	lb bc, CHARMANDER, 5
	call GivePokemon
	jr nc, .done
.finishstarter
	ld a, [wSimulatedJoypadStatesEnd]
	and a
	call z, WaitForTextScrollButtonPress
	call EnableAutoTextBoxDrawing
	ld hl, TakeGoodCareOfItText
	call PrintText
	SetEvent EVENT_GOT_STARTER_FROM_DAISY
.done
	jp TextScriptEnd

BluesHouseText2Text:
	TX_FAR _BluesHouseText2
	db "@"

BluesHouseText3: ; map on table
	TX_FAR _BluesHouseText3
	db "@"

GiveStarterText:
	TX_FAR _DaisyGiveStarterText
	db "@"

TakeGoodCareOfItText:
	TX_FAR _TakeGoodCareOfItText
	db "@"
