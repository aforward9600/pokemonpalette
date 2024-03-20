_RunPaletteCommand:
	call GetPredefRegisters
	ld a, b	;b holds the address of the pal command to run
	cp $ff
	jr nz, .next
	ld a, [wDefaultPaletteCommand] ; use default command if command ID is $ff
.next
	cp UPDATE_PARTY_MENU_BLK_PACKET
	jp z, UpdatePartyMenuBlkPacket
	ld l, a
	ld h, 0
	add hl, hl
	ld de, SetPalFunctions
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, SendSGBPackets
	push de	;by pushing de, the next 'ret' command encountered will jump to SendSGBPackets
	jp hl

SetPal_BattleBlack:
	ld hl, PalPacket_Black
	ld de, BlkPacket_Battle
	ret

; uses PalPacket_Empty to build a packet based on mon IDs and health color
SetPal_Battle:
	ld hl, PalPacket_Empty
	ld de, wPalPacket
	ld bc, $10
	call CopyData
	ld a, [wPlayerBattleStatus3]
	ld hl, wBattleMonSpecies

	bit TRANSFORMED, a
	jr z, .transformcheck
	ld hl, wBattleMonSpecies2	;joenote - Fixing a gamefreak typo. Needed for transformed mon's to retain their palette.
.transformcheck	
	
	call DeterminePaletteID
	ld b, a		;player mon pal in b
	ld a, [wEnemyBattleStatus3]
	ld hl, wEnemyMonSpecies2
	call DeterminePaletteID
	ld c, a		;enemy mon pal in c
	ld hl, wPalPacket + 1
	ld a, [wPlayerHPBarColor]
	add PAL_GREENBAR
	;now at wPalPacket + 1
	ld [hli], a
	inc hl
	ld a, [wEnemyHPBarColor]
	add PAL_GREENBAR
	;now at wPalPacket + 3
	ld [hli], a
	inc hl
	ld a, b
	;now at wPalPacket + 5
	ld [hli], a
	inc hl
	ld a, c
	;now at wPalPacket + 7
	ld [hl], a	

	ld hl, wPalPacket
	ld de, BlkPacket_Battle
	ld a, SET_PAL_BATTLE
	ld [wDefaultPaletteCommand], a
	ret

SetPal_TownMap:
	ld hl, PalPacket_TownMap
	ld de, BlkPacket_WholeScreen
	ret

; uses PalPacket_Empty to build a packet based the mon ID
SetPal_StatusScreen:
	ld hl, PalPacket_Empty
	ld de, wPalPacket
	ld bc, $10
	call CopyData
	ld a, [wcf91]
	cp VICTREEBEL + 1
	jr c, .pokemon
	ld a, $1 ; not pokemon
.pokemon
	call DeterminePaletteIDOutOfBattle
	push af
	ld hl, wPalPacket + 1
	ld a, [wStatusScreenHPBarColor]
	add PAL_GREENBAR
	ld [hli], a
	inc hl
	pop af
	ld [hl], a


	ld hl, wPalPacket
	ld de, BlkPacket_StatusScreen
	ret

SetPal_PartyMenu:
	ld hl, PalPacket_PartyMenu
	ld de, wPartyMenuBlkPacket
	ret

SetPal_Pokedex:
	ld hl, PalPacket_Pokedex
	ld de, wPalPacket
	ld bc, $10
	call CopyData
	ld a, [wcf91]
	call DeterminePaletteIDOutOfBattle
	ld hl, wPalPacket + 3
	ld [hl], a
	ld hl, wPalPacket
	ld de, BlkPacket_Pokedex
	ret

SetPal_Slots:
	ld hl, PalPacket_Slots
	ld de, BlkPacket_Slots
	ret

SetPal_TitleScreen:
	ld hl, PalPacket_Titlescreen
	ld de, BlkPacket_Titlescreen
	ret

; used mostly for menus and the Oak intro
SetPal_Generic:
	ld hl, PalPacket_Generic
	ld de, BlkPacket_WholeScreen
	ret

SetPal_NidorinoIntro:
	ld hl, PalPacket_NidorinoIntro
	ld de, BlkPacket_NidorinoIntro
	ret

SetPal_GameFreakIntro:
	ld hl, PalPacket_GameFreakIntro
	ld de, BlkPacket_GameFreakIntro
	ld a, SET_PAL_GENERIC
	ld [wDefaultPaletteCommand], a
	ret

; uses PalPacket_Empty to build a packet based on the current map
SetPal_Overworld:
	ld a, [wLastMap]
	cp CELADON_CITY
	jr z, .celadon
	ld hl, PalPacket_Empty
	ld de, wPalPacket
	ld bc, $10
	call CopyData
	ld a, [wCurMapTileset]
	cp CEMETERY
	jr z, .PokemonTowerOrAgatha
	cp CAVERN
	jr z, .caveOrBruno
	ld a, [wCurMap]
	cp REDS_HOUSE_1F
	jr c, .townOrRoute
	cp UNKNOWN_DUNGEON_2
	jr c, .normalDungeonOrBuilding
	cp NAME_RATERS_HOUSE
	jr c, .caveOrBruno
	cp LORELEIS_ROOM
	jr z, .Lorelei
	cp BRUNOS_ROOM
	jr z, .caveOrBruno
.normalDungeonOrBuilding
	ld a, [wLastMap] ; town or route that current dungeon or building is located
.townOrRoute
	cp SAFFRON_CITY + 1
	jr c, .town
	ld a, PAL_ROUTE - 1
.town
	inc a ; a town's palette ID is its map ID + 1
	ld hl, wPalPacket + 1
	ld [hld], a
	ld de, BlkPacket_WholeScreen
	ld a, SET_PAL_OVERWORLD
	ld [wDefaultPaletteCommand], a
	ret
.PokemonTowerOrAgatha
	ld a, PAL_GREYMON - 1
	jr .town
.celadon
	ld hl, PalPacket_Celadon
	ld de, wPalPacket
	ld bc, $10
	call CopyData
	ld hl, PalPacket_Celadon
	ld de, BlkPacket_Celadon
	ld a, SET_PAL_OVERWORLD
	ld [wDefaultPaletteCommand], a
	ret
.caveOrBruno
	ld a, PAL_CAVE - 1
	jr .town
.Lorelei
	xor a
	jr .town

; used when a Pokemon is the only thing on the screen
; such as evolution, trading and the Hall of Fame
SetPal_PokemonWholeScreen:
	push bc
	ld hl, PalPacket_Empty
	ld de, wPalPacket
	ld bc, $10
	call CopyData
	pop bc
	ld a, c
	and a
	ld a, PAL_BLACK
	jr nz, .next
	ld a, [wWholeScreenPaletteMonSpecies]
	call DeterminePaletteIDOutOfBattle
.next
	ld [wPalPacket + 1], a
	ld hl, wPalPacket
	ld de, BlkPacket_WholeScreen
	ret

SetPal_TrainerCard:
	ld hl, BlkPacket_TrainerCard
	ld de, wTrainerCardBlkPacket
	ld bc, $40
	call CopyData
	ld de, BadgeBlkDataLengths
	ld hl, wTrainerCardBlkPacket + 2
	ld a, [wObtainedBadges]
	ld c, 8
.badgeLoop
	srl a
	push af
	jr c, .haveBadge
; The player doens't have the badge, so zero the badge's blk data.
	push bc
	ld a, [de]
	ld c, a
	xor a
.zeroBadgeDataLoop
	ld [hli], a
	dec c
	jr nz, .zeroBadgeDataLoop
	pop bc
	jr .nextBadge
.haveBadge
; The player does have the badge, so skip past the badge's blk data.
	ld a, [de]
.skipBadgeDataLoop
	inc hl
	dec a
	jr nz, .skipBadgeDataLoop
.nextBadge
	pop af
	inc de
	dec c
	jr nz, .badgeLoop
	ld hl, PalPacket_TrainerCard
	ld de, wTrainerCardBlkPacket
	ret
;gbcnote - added more pal functions
SendUnknownPalPacket_7205d::
	ld hl, UnknownPalPacket_72811
	ld de, BlkPacket_WholeScreen
	ret

SendUnknownPalPacket_72064::
	ld hl, UnknownPalPacket_72821
	ld de, UnknownPacket_72751
	ret

SetPalFunctions:
	dw SetPal_BattleBlack
	dw SetPal_Battle
	dw SetPal_TownMap
	dw SetPal_StatusScreen
	dw SetPal_Pokedex
	dw SetPal_Slots
	dw SetPal_TitleScreen
	dw SetPal_NidorinoIntro
	dw SetPal_Generic
	dw SetPal_Overworld
	dw SetPal_PartyMenu
	dw SetPal_PokemonWholeScreen
	dw SetPal_GameFreakIntro
	dw SetPal_TrainerCard
	;gbctest - adding packets from yellow
	dw SendUnknownPalPacket_7205d
	dw SendUnknownPalPacket_72064

; The length of the blk data of each badge on the Trainer Card.
; The Rainbow Badge has 3 entries because of its many colors.
BadgeBlkDataLengths:
	db 6     ; Boulder Badge
	db 6     ; Cascade Badge
	db 6     ; Thunder Badge
	db 6 * 3 ; Rainbow Badge
	db 6     ; Soul Badge
	db 6     ; Marsh Badge
	db 6     ; Volcano Badge
	db 6     ; Earth Badge

DeterminePaletteID:
	;joenote - Don't bother checking. Let a transformed 'mon retain its original palette.
	;bit TRANSFORMED, a ; a is battle status 3
	;ld a, PAL_GREYMON  ; if the mon has used Transform, use Ditto's palette
	;ret nz
	ld a, [hl]
DeterminePaletteIDOutOfBattle:
	ld [wd11e], a
	and a ; is the mon index 0?
	jr z, .skipDexNumConversion
	push bc
	predef IndexToPokedex
	pop bc
	ld a, [wd11e]
.skipDexNumConversion
	ld e, a
	ld d, 0
	ld hl, MonsterPalettes ; not just for Pokemon, Trainers use it too
	add hl, de
	ld a, [hl]
	ret

InitPartyMenuBlkPacket:
	ld hl, BlkPacket_PartyMenu
	ld de, wPartyMenuBlkPacket
	ld bc, $30
	jp CopyData

UpdatePartyMenuBlkPacket:
; Update the blk packet with the palette of the HP bar that is
; specified in [wWhichPartyMenuHPBar].
	ld hl, wPartyMenuHPBarColors
	ld a, [wWhichPartyMenuHPBar]
	ld e, a
	ld d, 0
	add hl, de
	ld e, l
	ld d, h
	ld a, [de]
	and a
	ld e, (1 << 2) | 1 ; green
	jr z, .next
	dec a
	ld e, (2 << 2) | 2 ; yellow
	jr z, .next
	ld e, (3 << 2) | 3 ; red
.next
	push de
	ld hl, wPartyMenuBlkPacket + 8 + 1
	ld bc, 6
	ld a, [wWhichPartyMenuHPBar]
	call AddNTimes
	pop de
	ld [hl], e
	ret

SendSGBPacket: ;gbcnote - shifted joypad polling around
; disable ReadJoypad to prevent it from interfering with sending the packet
	ld a, 1
	ld [hDisableJoypadPolling], a ; don't poll joypad while sending packet
	call _SendSGBPacket
;re-enable joypad polling
	xor a
	ld [hDisableJoypadPolling], a
	ret

_SendSGBPacket:
;check number of packets
	ld a, [hl]
	and $07
	ret z
; store number of packets in B
	ld b, a
.loop2
; save B for later use
	push bc
; send RESET signal (P14=LOW, P15=LOW)
	xor a
	ld [rJOYP], a
; set P14=HIGH, P15=HIGH
	ld a, $30
	ld [rJOYP], a
;load length of packets (16 bytes)
	ld b, $10
.nextByte
;set bit counter (8 bits per byte)
	ld e, $08
; get next byte in the packet
	ld a, [hli]
	ld d, a
.nextBit0
	bit 0, d
; if 0th bit is not zero set P14=HIGH,P15=LOW (send bit 1)
	ld a, $10
	jr nz, .next0
; else (if 0th bit is zero) set P14=LOW,P15=HIGH (send bit 0)
	ld a, $20
.next0
	ld [rJOYP], a
; must set P14=HIGH,P15=HIGH between each "pulse"
	ld a, $30
	ld [rJOYP], a
; rotation will put next bit in 0th position (so  we can always use command
; "bit 0,d" to fetch the bit that has to be sent)
	rr d
; decrease bit counter so we know when we have sent all 8 bits of current byte
	dec e
	jr nz, .nextBit0
	dec b
	jr nz, .nextByte
; send bit 1 as a "stop bit" (end of parameter data)
	ld a, $20
	ld [rJOYP], a
; set P14=HIGH,P15=HIGH
	ld a, $30
	ld [rJOYP], a
; wait for about 70000 cycles
	call Wait7000
; restore (previously pushed) number of packets
	pop bc
	dec b
; return if there are no more packets
	ret z
; else send 16 more bytes
	jr .loop2

LoadSGB:	;gbcnote - adjust for GBC
	xor a
	ld [wOnSGB], a
	call CheckSGB
	jr c, .onSGB
	ld a, [hGBC]
	and a
	jr z, .onDMG
	;if on gbc, set SGB flag but skip all the SGB vram stuff
	ld a, $1
	ld [wOnSGB], a
.onDMG
	ret
.onSGB
	ld a, $1
	ld [wOnSGB], a
	di
	call PrepareSuperNintendoVRAMTransfer
	ei
	ld a, 1
	ld [wCopyingSGBTileData], a
	ld de, ChrTrnPacket
	ld hl, SGBBorderGraphics
	call CopyGfxToSuperNintendoVRAM
	xor a
	ld [wCopyingSGBTileData], a
	ld de, PctTrnPacket
	ld hl, BorderPalettes
	call CopyGfxToSuperNintendoVRAM
	xor a
	ld [wCopyingSGBTileData], a
	ld de, PalTrnPacket
	ld hl, SuperPalettes
	call CopyGfxToSuperNintendoVRAM
	call ClearVram
	ld hl, MaskEnCancelPacket
	jp SendSGBPacket

PrepareSuperNintendoVRAMTransfer:
	ld hl, .packetPointers
	ld c, 9
.loop
	push bc
	ld a, [hli]
	push hl
	ld h, [hl]
	ld l, a
	call SendSGBPacket
	pop hl
	inc hl
	pop bc
	dec c
	jr nz, .loop
	ret

.packetPointers
; Only the first packet is needed.
	dw MaskEnFreezePacket
	dw DataSnd_72548
	dw DataSnd_72558
	dw DataSnd_72568
	dw DataSnd_72578
	dw DataSnd_72588
	dw DataSnd_72598
	dw DataSnd_725a8
	dw DataSnd_725b8

CheckSGB:
; Returns whether the game is running on an SGB in carry.
	ld hl, MltReq2Packet
	di
	call SendSGBPacket
	ld a, 1
	ld [hDisableJoypadPolling], a
	ei
	call Wait7000
	ld a, [rJOYP]
	and $3
	cp $3
	jr nz, .isSGB
	ld a, $20
	ld [rJOYP], a
	ld a, [rJOYP]
	ld a, [rJOYP]
	call Wait7000
	call Wait7000
	ld a, $30
	ld [rJOYP], a
	call Wait7000
	call Wait7000
	ld a, $10
	ld [rJOYP], a
	ld a, [rJOYP]
	ld a, [rJOYP]
	ld a, [rJOYP]
	ld a, [rJOYP]
	ld a, [rJOYP]
	ld a, [rJOYP]
	call Wait7000
	call Wait7000
	ld a, $30
	ld [rJOYP], a
	ld a, [rJOYP]
	ld a, [rJOYP]
	ld a, [rJOYP]
	call Wait7000
	call Wait7000
	ld a, [rJOYP]
	and $3
	cp $3
	jr nz, .isSGB
	call SendMltReq1Packet
	and a
	ret
.isSGB
	call SendMltReq1Packet
	scf
	ret

SendMltReq1Packet:
	ld hl, MltReq1Packet
	call SendSGBPacket
	jp Wait7000

CopyGfxToSuperNintendoVRAM:
	di
	push de
	call DisableLCD
	ld a, $e4
	ld [rBGP], a
	call UpdateGBCPal_BGP
	ld de, vChars1
	ld a, [wCopyingSGBTileData]
	and a
	jr z, .notCopyingTileData
	call CopySGBBorderTiles
	jr .next
.notCopyingTileData
	ld bc, $1000
	call CopyData
.next
	ld hl, vBGMap0
	ld de, $c
	ld a, $80
	ld c, $d
.loop
	ld b, $14
.innerLoop
	ld [hli], a
	inc a
	dec b
	jr nz, .innerLoop
	add hl, de
	dec c
	jr nz, .loop
	ld a, $e3
	ld [rLCDC], a
	pop hl
	call SendSGBPacket
	xor a
	ld [rBGP], a
	call UpdateGBCPal_BGP
	ei
	ret

Wait7000:
; Each loop takes 9 cycles so this routine actually waits 63000 cycles.
	ld de, 7000
.loop
	nop
	nop
	nop
	dec de
	ld a, d
	or e
	jr nz, .loop
	ret

SendSGBPackets:
	ld a, [hGBC]	;gbcnote - replaced wGBC
	and a
	jr z, .notGBC
	push de
	call InitGBCPalettes
	pop hl
	;gbcnote - initialize the second pal packet in de (now in hl) then enable the lcd
	call InitGBCPalettes
	ld a, [rLCDC]
	and rLCDC_ENABLE_MASK
	ret z
	call Delay3
	ret
.notGBC
	push de
	call SendSGBPacket
	pop hl
	jp SendSGBPacket

InitGBCPalettes:	;gbcnote - updating this to work with the Yellow code
	ld a, [hl]
	and $f8
	cp $20	;check to see if hl points to a blk pal packet
	jp z, TranslatePalPacketToBGMapAttributes	;jump if so
	;otherwise hl points to a different pal packet or wPalPacket
	inc hl
index = 0
	REPT NUM_ACTIVE_PALS
		IF index > 0
			pop hl
		ENDC

		ld a, [hli]	;get palette ID into 'A'
		inc hl

		IF index < (NUM_ACTIVE_PALS + -1)
			push hl
		ENDC

		call GetGBCBasePalAddress	;get palette address into de
		ld a, e
		ld [wGBCBasePalPointers + index * 2], a
		ld a, d
		ld [wGBCBasePalPointers + index * 2 + 1], a

		ld a, CONVERT_BGP
		call DMGPalToGBCPal
		ld a, index
		call TransferCurBGPData

		ld a, CONVERT_OBP0
		call DMGPalToGBCPal
		ld a, index
		call TransferCurOBPData

		ld a, CONVERT_OBP1
		call DMGPalToGBCPal
		ld a, index + 4
		call TransferCurOBPData
index = index + 1
	ENDR
	ret

GetGBCBasePalAddress:: ;gbcnote - new function
; Input: a = palette ID
; Output: de = palette address
	push hl
	ld l, a
	xor a
	ld h, a
	add hl, hl
	add hl, hl
	add hl, hl
	ld de, GBCBasePalettes
	add hl, de
	ld a, l
	ld e, a
	ld a, h
	ld d, a
	pop hl
	ret
	
DMGPalToGBCPal::	;gbcnote - new function
; Populate wGBCPal with colors from a base palette, selected using one of the
; DMG palette registers.
; Input:
; a = which DMG palette register
; de = address of GBC base palette
	and a
	jr nz, .notBGP
	ld a, [rBGP]
	ld [wLastBGP], a
	jr .convert
.notBGP
	dec a
	jr nz, .notOBP0
	ld a, [rOBP0]
	ld [wLastOBP0], a
	jr .convert
.notOBP0
	ld a, [rOBP1]
	ld [wLastOBP1], a
.convert
;"A" now holds the palette data
color_index = 0
	REPT NUM_COLORS
		ld b, a	;"B" now holds the palette data
		and %11	;"A" now has just the value for the shade of palette color 0
		call .GetColorAddress
		push de
		;get the palett color value in de
		ld a, [hli]
		ld e, a
		ld a, [hl]
		ld d, a
		predef GBCGamma
		;now load the value that HL points to into wGBCPal offset by the loop
		ld a, e
		ld [wGBCPal + color_index * 2], a
		ld a, d
		ld [wGBCPal + color_index * 2 + 1], a
		pop de

		IF color_index < (NUM_COLORS + -1)
			ld a, b	;restore the palette data back into "A"
			;rotate the palette data bits twice to the right so the next color in line becomes color 0
			rrca
			rrca
		ENDC
color_index = color_index + 1
	ENDR
	ret
.GetColorAddress:
	add a	;double the value of the shade in "A"
	ld l, a	;load 2x shade value into "L"
	xor a	;zero "A"
	ld h, a	;and load it to "H", so HL is now [00|2x shade]
	add hl, de	;HL now holds the base palette address offset by 2x shade in bytes (base, base+2, base+4, or base+6)
	ret

TransferCurBGPData::
; a = indexed offset of wGBCBasePalPointers
	push de
	;multiply index by 8 since each index represents 8 bytes worth of data
	add a
	add a
	add a
	or $80 ; set auto-increment bit of rBGPI
	ld [rBGPI], a
	ld de, rBGPD
	ld hl, wGBCPal
	ld a, [rLCDC]
	and rLCDC_ENABLE_MASK
	jr nz, .lcdEnabled
	rept NUM_COLORS
	call TransferPalColorLCDDisabled
	endr
	jr .done
.lcdEnabled
	rept NUM_COLORS
	call TransferPalColorLCDEnabled
	endr
.done
	pop de
	ret	

BufferBGPPal::
; Copy wGBCPal to palette a in wBGPPalsBuffer.
; a = indexed offset of wGBCBasePalPointers
	push de
	;multiply index by 8 since each index represents 8 bytes worth of data
	add a
	add a
	add a
	ld l, a
	xor a
	ld h, a
	ld de, wBGPPalsBuffer
	add hl, de	;hl now points to wBGPPalsBuffer + 8*index
	ld de, wGBCPal
	ld c, PAL_SIZE
.loop	;copy the 8 bytes of wGBCPal to its indexed spot in wBGPPalsBuffer
	ld a, [de]
	ld [hli], a
	inc de
	dec c
	jr nz, .loop
	pop de
	ret
	
TransferBGPPals::
; Transfer the buffered BG palettes.
	ld a, [rLCDC]
	and rLCDC_ENABLE_MASK
	jr z, .lcdDisabled
	; have to wait until LCDC is disabled
	; LCD should only ever be disabled during the V-blank period to prevent hardware damage
	di	;disable interrupts
.waitLoop
	ld a, [rLY]
	cp 144	;V-blank can be confirmed when the value of LY is greater than or equal to 144
	jr c, .waitLoop
.lcdDisabled
	call .DoTransfer
	ei	;enable interrupts
	ret
.DoTransfer:
	xor a
	or $80 ; set the auto-increment bit of rBPGI
	ld [rBGPI], a
	ld de, rBGPD
	ld hl, wBGPPalsBuffer
	ld c, 4 * PAL_SIZE
.loop
	ld a, [hli]
	ld [de], a
	dec c
	jr nz, .loop
	ret

TransferCurOBPData:
; a = indexed offset of wGBCBasePalPointers
	push de
	;multiply index by 8 since each index represents 8 bytes worth of data
	add a
	add a
	add a
	or $80 ; set auto-increment bit of OBPI
	ld [rOBPI], a
	ld de, rOBPD
	ld hl, wGBCPal
	ld a, [rLCDC]
	and rLCDC_ENABLE_MASK
	jr nz, .lcdEnabled
	rept NUM_COLORS
	call TransferPalColorLCDDisabled
	endr
	jr .done
.lcdEnabled
	rept NUM_COLORS
	call TransferPalColorLCDEnabled
	endr
.done
	pop de
	ret	

TransferPalColorLCDEnabled:
; Transfer a palette color while the LCD is enabled.
; In case we're already in H-blank or V-blank, wait for it to end. This is a
; precaution so that the transfer doesn't extend past the blanking period.
	ld a, [rSTAT]
	and %10 ; mask for non-V-blank/non-H-blank STAT mode
	jr z, TransferPalColorLCDEnabled	;repeat if still in h-blank or v-blank
; Wait for H-blank or V-blank to begin.
.notInBlankingPeriod
	ld a, [rSTAT]
	and %10 ; mask for non-V-blank/non-H-blank STAT mode
	jr nz, .notInBlankingPeriod
; fall through
TransferPalColorLCDDisabled:
; Transfer a palette color while the LCD is disabled.
	ld a, [hli]
	ld [de], a
	ld a, [hli]
	ld [de], a
	ret
	
_UpdateGBCPal_BGP::
index = 0
	REPT NUM_ACTIVE_PALS
		ld a, [wGBCBasePalPointers + index * 2]
		ld e, a
		ld a, [wGBCBasePalPointers + index * 2 + 1]
		ld d, a
		xor a ; CONVERT_BGP
		call DMGPalToGBCPal
		ld a, index
		call BufferBGPPal	; Copy wGBCPal to palette indexed in wBGPPalsBuffer.
index = index + 1
	ENDR
	call TransferBGPPals	;Transfer wBGPPalsBuffer contents to rBGPD
	ret

_UpdateGBCPal_OBP::
; d then c = CONVERT_OBP0 or CONVERT_OBP1
	ld a, d
	ld c, a
index = 0
	REPT NUM_ACTIVE_PALS
		ld a, [wGBCBasePalPointers + index * 2]
		ld e, a
		ld a, [wGBCBasePalPointers + index * 2 + 1]
		ld d, a
		ld a, c
		call DMGPalToGBCPal
		ld a, c
		dec a
		rlca
		rlca

		IF index > 0
			IF index == 1
				inc a
			ELSE
				add index
			ENDC
		ENDC
		;OBP0: a = 0, 1, 2, or 3
		;OBP1: a = 4, 5, 6, or 7
		call TransferCurOBPData
index = index + 1
	ENDR
	ret
	
;gbcnote - new function
TranslatePalPacketToBGMapAttributes::
; translate the SGB pals for blk packets into something usable for the GBC
	push hl
	pop de
	ld hl, PalPacketPointers
	ld a, [hli]
	ld c, a
.loop
	ld a, e
.innerLoop
	cp [hl]
	jr z, .checkHighByte
	inc hl
	inc hl
	dec c
	jr nz, .innerLoop
	ret
.checkHighByte
; the low byte of pointer matched, so check the high byte
	inc hl
	ld a, d
	cp [hl]
	jr z, .foundMatchingPointer
	inc hl
	dec c
	jr nz, .loop
	ret
.foundMatchingPointer
	push de
	ld d, c
	callba LoadBGMapAttributes
	pop de
	ret

;gbcnote - pointers from pokemon yellow
PalPacketPointers::
	db (palPacketPointersEnd - palPacketPointers) / 2
palPacketPointers:
	dw BlkPacket_WholeScreen
	dw BlkPacket_Battle
	dw BlkPacket_StatusScreen
	dw BlkPacket_Pokedex
	dw BlkPacket_Slots
	dw BlkPacket_Titlescreen
	dw BlkPacket_NidorinoIntro
	dw wPartyMenuBlkPacket
	dw wTrainerCardBlkPacket
	dw BlkPacket_GameFreakIntro
	dw wPalPacket
	dw UnknownPacket_72751
palPacketPointersEnd:

CopySGBBorderTiles:
; SGB tile data is stored in a 4BPP planar format.
; Each tile is 32 bytes. The first 16 bytes contain bit planes 1 and 2, while
; the second 16 bytes contain bit planes 3 and 4.
; This function converts 2BPP planar data into this format by mapping
; 2BPP colors 0-3 to 4BPP colors 0-3. 4BPP colors 4-15 are not used.
	ld b, 128

.tileLoop

; Copy bit planes 1 and 2 of the tile data.
	ld c, 16
.copyLoop
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .copyLoop

; Zero bit planes 3 and 4.
	ld c, 16
	xor a
.zeroLoop
	ld [de], a
	inc de
	dec c
	jr nz, .zeroLoop

	dec b
	jr nz, .tileLoop
	ret


;gbcnote - This function loads the palette for a given pokemon index in wcf91 into a specified palette register on the GBC
;d = CONVERT_OBP0, CONVERT_OBP1, or CONVERT_BGP
;e = palette register # (0 to 7)
TransferMonPal:
	ld a, [hGBC]
	and a
	ret z 
	ld a, e
	push af
	ld a, d
	push af
	ld a, [wcf91]
	cp VICTREEBEL+1
	jr c, .isMon
	sub VICTREEBEL+1
.back	
	call GetGBCBasePalAddress
	pop af
	cp CONVERT_BGP
	push af
	call DMGPalToGBCPal
	pop af
	jr z, .do_bgp
	pop af
	call TransferCurOBPData
	ret
.do_bgp
	pop af
	call TransferCurBGPData
	ret
.isMon	
	call DeterminePaletteIDOutOfBattle
	jr .back

INCLUDE "data/sgb_packets.asm"

INCLUDE "data/mon_palettes.asm"

INCLUDE "data/super_palettes.asm"
INCLUDE "data/gbc_palettes.asm"

INCLUDE "data/sgb_border.asm"
