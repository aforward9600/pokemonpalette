SetDefaultNames:
	ld a, [wLetterPrintingDelayFlags]
	push af
	ld a, [wOptions]
	push af
	ld a, [wd732]
	push af
	ld a, [wUnusedD721]	;joenote - preserve extra options
	push af
	ld hl, wPlayerName
	ld bc, wBoxDataEnd - wPlayerName
	xor a
	call FillMemory
	ld hl, wSpriteStateData1
	ld bc, $200
	xor a
	call FillMemory
	pop af
	ld [wUnusedD721], a	;joenote - restore extra options
	pop af
	ld [wd732], a
	pop af
	ld [wOptions], a
	pop af
	ld [wLetterPrintingDelayFlags], a
	ld a, [wOptionsInitialized]
	and a
	call z, InitOptions
	ld hl, NintenText
	ld de, wPlayerName
	ld bc, NAME_LENGTH
	call CopyData
	ld hl, SonyText
	ld de, wRivalName
	ld bc, NAME_LENGTH
	jp CopyData

OakSpeech:
	call ClearScreen
	call LoadTextBoxTilePatterns
	call SetDefaultNames
	predef InitPlayerData2
	call RunDefaultPaletteCommand	;gbcnote - reinitialize the default palette in case the pointers got cleared
	ld a, $FF
	call PlaySound ; stop music
	ld a, BANK(Music_Routes2)
	ld c, a
	ld a, MUSIC_ROUTES2
	call PlayMusic
	ld hl, wNumBoxItems
	ld a, POTION
	ld [wcf91], a
	ld a, 1
	ld [wItemQuantity], a
	call AddItemToInventory  ; give one potion
	ld a, [wDefaultMap]
	ld [wDestinationMap], a
	call SpecialWarpIn
	xor a
	ld [hTilesetType], a
	ld a, [wd732]
	bit 1, a ; possibly a debug mode bit
	jp nz, .skipChoosingNames
	ld hl, BoyGirlText  ; added to the same file as the other oak text
	call PrintText     ; show this text
	call BoyGirlChoice ; added routine at the end of this file
	ld a, [wCurrentMenuItem]
	ld [wPlayerGender], a ; store player's gender. 00 for boy, 01 for girl
	call ClearScreen ; clear the screen before resuming normal intro
	ld a, $0
	ld [wCurrentMenuItem], a
	ld hl, NuzlockeChoiceText
	call PrintText
	call NuzlockeChoice
	ld a, [wCurrentMenuItem]
	ld b,b
	ld [wNuzlockeMode], a
	call ClearScreen
	ld de, ProfOakPic
	lb bc, Bank(ProfOakPic), $00
	call IntroDisplayPicCenteredOrUpperRight
	call FadeInIntroPic
	ld hl, OakSpeechText1
	call PrintText
	call GBFadeOutToWhite
	call ClearScreen
	ld a, [wPlayerGender]
	and a
	jr z, .AreBoyNidorino
	ld a, NIDORINA
	ld [wd0b5], a
	ld [wcf91], a
	jr .ReconveneNido
.AreBoyNidorino
	ld a, NIDORINO
	ld [wd0b5], a
	ld [wcf91], a
.ReconveneNido
	call GetMonHeader
	coord hl, 6, 4
	call LoadFlippedFrontSpriteByMonIndex
	;call MovePicLeft
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;gbcnote - Nidorino needs its pal
	ld a, %11100100
	ld [rBGP], a
	call UpdateGBCPal_BGP
	
	push af
	push bc
	push hl
	push de
	ld d, CONVERT_BGP
	ld e, 0
	callba TransferMonPal 
	pop de
	pop hl
	pop bc
	pop af
	
	call MovePicLeft_NoPalUpdate
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ld a, [wPlayerGender]
	and a
	jr z, .AreBoyNidorinoText
	ld hl, OakSpeechText4
	jr .ReconveneNidoText
.AreBoyNidorinoText
	ld hl, OakSpeechText2
.ReconveneNidoText
	call PrintText
	call GBFadeOutToWhite
	call ClearScreen
	ld de, RedPicFront
	lb bc, BANK(RedPicFront), $00
	ld a, [wPlayerGender]
	and a
	jr z, .NotGreen1
	ld de, GreenPicFront
	lb bc, BANK(GreenPicFront), $00
.NotGreen1
	call IntroDisplayPicCenteredOrUpperRight
	call MovePicLeft
	ld hl, IntroducePlayerText
	call PrintText
	call ChoosePlayerName
	call GBFadeOutToWhite
	call ClearScreen
	ld de, Rival1Pic
	lb bc, Bank(Rival1Pic), $00
	call IntroDisplayPicCenteredOrUpperRight
	call FadeInIntroPic
	ld hl, IntroduceRivalText
	call PrintText
	call ChooseRivalName
.skipChoosingNames
	call GBFadeOutToWhite
	call ClearScreen
	ld de, RedPicFront
	lb bc, BANK(RedPicFront), $00
	ld a, [wPlayerGender]
	and a
	jr z, .NotGreen2
	ld de, GreenPicFront
	lb bc, BANK(GreenPicFront), $00
.NotGreen2:
	call IntroDisplayPicCenteredOrUpperRight
	call GBFadeInFromWhite
	ld a, [wd72d]
	and a
	jr nz, .next
	ld hl, OakSpeechText3
	call PrintText
.next
	ld a, [H_LOADEDROMBANK]
	push af
	ld a, SFX_SHRINK
	call PlaySound
	pop af
	ld [H_LOADEDROMBANK], a
	ld [MBC1RomBank], a
	ld c, 4
	call DelayFrames
	ld de, RedSprite
	ld hl, vSprites
	lb bc, BANK(RedSprite), $0C
	ld a, [wPlayerGender]
	and a
	jr z, .NotGreen3
	ld de, GreenSprite
	lb bc, BANK(GreenSprite), $0C
.NotGreen3:
	ld hl, vSprites
	call CopyVideoData
	ld de, ShrinkPic1
	lb bc, BANK(ShrinkPic1), $00
	call IntroDisplayPicCenteredOrUpperRight
	ld c, 4
	call DelayFrames
	ld de, ShrinkPic2
	lb bc, BANK(ShrinkPic2), $00
	call IntroDisplayPicCenteredOrUpperRight
	call ResetPlayerSpriteData
	ld a, [H_LOADEDROMBANK]
	push af
	ld a, BANK(Music_PalletTown)
	ld [wAudioROMBank], a
	ld [wAudioSavedROMBank], a
	ld a, 10
	ld [wAudioFadeOutControl], a
	ld a, $FF
	ld [wNewSoundID], a
	call PlaySound ; stop music
	pop af
	ld [H_LOADEDROMBANK], a
	ld [MBC1RomBank], a
	ld c, 20
	call DelayFrames
	coord hl, 6, 5
	ld b, 7
	ld c, 7
	call ClearScreenArea
	call LoadTextBoxTilePatterns
	ld a, 1
	ld [wUpdateSpritesEnabled], a
	ld c, 50
	call DelayFrames
	call GBFadeOutToWhite
	jp ClearScreen
OakSpeechText1:
	TX_FAR _OakSpeechText1
	db "@"
OakSpeechText2:
	TX_FAR _OakSpeechText2A
	TX_CRY_NIDORINO
	TX_FAR _OakSpeechText2B
	db "@"
IntroducePlayerText:
	TX_FAR _IntroducePlayerText
	db "@"
IntroduceRivalText:
	TX_FAR _IntroduceRivalText
	db "@"
OakSpeechText3:
	TX_FAR _OakSpeechText3
	db "@"
BoyGirlText:
	TX_FAR _BoyGirlText
	db "@"
OakSpeechText4:
	TX_FAR _OakSpeechText2A
	TX_CRY_NIDORINA
	TX_FAR _OakSpeechText2B
	db "@"
NuzlockeChoiceText:
	TX_FAR _NuzlockeChoiceText
	db "@"

FadeInIntroPic:
	ld hl, IntroFadePalettes
	ld b, 6
.next
	ld a, [hli]
	ld [rBGP], a
	call UpdateGBCPal_BGP
	ld c, 10
	call DelayFrames
	dec b
	jr nz, .next
	ret

IntroFadePalettes:
	db %01010100
	db %10101000
	db %11111100
	db %11111000
	db %11110100
	db %11100100

MovePicLeft:
	ld a, %11100100
	ld [rBGP], a
	call UpdateGBCPal_BGP
MovePicLeft_NoPalUpdate: ;gbcnote - need the option to skip updating if needed
	ld a, 119
	ld [rWX], a
	call DelayFrame
.next
	call DelayFrame
	ld a, [rWX]
	sub 8
	cp $FF
	ret z
	ld [rWX], a
	jr .next

DisplayPicCenteredOrUpperRight:
	call GetPredefRegisters
IntroDisplayPicCenteredOrUpperRight:
; b = bank
; de = address of compressed pic
; c: 0 = centred, non-zero = upper-right
	push bc
	ld a, b
	call UncompressSpriteFromDE
	ld hl, sSpriteBuffer1
	ld de, sSpriteBuffer0
	ld bc, $310
	call CopyData
	ld de, vFrontPic
	call InterlaceMergeSpriteBuffers
	pop bc
	ld a, c
	and a
	coord hl, 15, 1
	jr nz, .next
	coord hl, 6, 4
.next
	xor a
	ld [hStartTileID], a
	predef_jump CopyUncompressedPicToTilemap

	; displays boy/girl choice
BoyGirlChoice::
 	call SaveScreenTilesToBuffer1
 	call InitBoyGirlTextBoxParameters
 	jr DisplayBoyGirlChoice
    
InitBoyGirlTextBoxParameters::
	ld a, $1 ; loads the value for the unused North/West choice, that was changed to say Boy/Girl
 	ld [wTwoOptionMenuID], a
 	coord hl, 13, 7 
 	ld bc, $80e
 	ret
 	   
DisplayBoyGirlChoice::
   	ld a, $14
   	ld [wTextBoxID], a
   	call DisplayTextBoxID
   	jp LoadScreenTilesFromBuffer1

NuzlockeChoice::
	call SaveScreenTilesToBuffer1
	call InitNuzlockeTextBoxParameters
	jr DisplayNuzlockeChoice

InitNuzlockeTextBoxParameters::
	ld a, $2
	ld [wTwoOptionMenuID], a
	coord hl, 13, 7
	ld bc, $80e
	ret

DisplayNuzlockeChoice::
	ld a, $14
	ld [wTextBoxID], a
	call DisplayTextBoxID
	jp LoadScreenTilesFromBuffer1
