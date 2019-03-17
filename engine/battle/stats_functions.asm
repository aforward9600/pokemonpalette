
;Putting some useful functions into this file that are in fact used now

CheckLowerPlayerPriority:	;joenote - custom functions to handle lower move priority. Sets zero flag if priority lowered.
	ld a, [wPlayerSelectedMove]
	call LowPriorityMoves
	ret
CheckLowerEnemyPriority:
	ld a, [wEnemySelectedMove]
	call LowPriorityMoves
	ret
LowPriorityMoves:
	cp COUNTER
	ret z
	cp BIND
	ret z
	cp WRAP
	ret z
	cp FIRE_SPIN
	ret z
	cp CLAMP
	ret
	
	
;joenote - custom functions for determining which trainerAI pkmn have already been sent out before
;a=party position of pkmn (like wWhichPokemon). If checking, zero flag gives bit state (1 means sent out already)
CheckAISentOut:
	ld a, [wWhichPokemon]	
	cp $05
	jr z, .party5
	cp $04
	jr z, .party4
	cp $03
	jr z, .party3
	cp $02
	jr z, .party2
	cp $01
	jr z, .party1
	jr .party0
.party5
	ld a, [wFontLoaded]
	bit 6, a
	jr .partyret
.party4
	ld a, [wFontLoaded]
	bit 5, a
	jr .partyret
.party3
	ld a, [wFontLoaded]
	bit 4, a
	jr .partyret
.party2
	ld a, [wFontLoaded]
	bit 3, a
	jr .partyret
.party1
	ld a, [wFontLoaded]
	bit 2, a
	jr .partyret
.party0
	ld a, [wFontLoaded]
	bit 1, a
.partyret
	ret
	
SetAISentOut:
	ld a, [wWhichPokemon]	
	cp $05
	jr z, .party5
	cp $04
	jr z, .party4
	cp $03
	jr z, .party3
	cp $02
	jr z, .party2
	cp $01
	jr z, .party1
	jr .party0
.party5
	ld a, [wFontLoaded]
	set 6, a
	ld [wFontLoaded], a
	jr .partyret
.party4
	ld a, [wFontLoaded]
	set 5, a
	ld [wFontLoaded], a
	jr .partyret
.party3
	ld a, [wFontLoaded]
	set 4, a
	ld [wFontLoaded], a
	jr .partyret
.party2
	ld a, [wFontLoaded]
	set 3, a
	ld [wFontLoaded], a
	jr .partyret
.party1
	ld a, [wFontLoaded]
	set 2, a
	ld [wFontLoaded], a
	jr .partyret
.party0
	ld a, [wFontLoaded]
	set 1, a
	ld [wFontLoaded], a
.partyret
	ret

	
	
; does nothing since no stats are ever selected (barring glitches)
DoubleSelectedStats:
	ld a, [H_WHOSETURN]
	and a
	ld a, [wPlayerStatsToDouble]
	ld hl, wBattleMonAttack + 1
	jr z, .notEnemyTurn
	ld a, [wEnemyStatsToDouble]
	ld hl, wEnemyMonAttack + 1
.notEnemyTurn
	ld c, 4
	ld b, a
.loop
	srl b
	call c, .doubleStat
	inc hl
	inc hl
	dec c
	ret z
	jr .loop

.doubleStat
	ld a, [hl]
	add a
	ld [hld], a
	ld a, [hl]
	rl a
	ld [hli], a
	ret

	
	
; does nothing since no stats are ever selected (barring glitches)
HalveSelectedStats:
	ld a, [H_WHOSETURN]
	and a
	ld a, [wPlayerStatsToHalve]
	ld hl, wBattleMonAttack
	jr z, .notEnemyTurn
	ld a, [wEnemyStatsToHalve]
	ld hl, wEnemyMonAttack
.notEnemyTurn
	ld c, 4
	ld b, a
.loop
	srl b
	call c, .halveStat
	inc hl
	inc hl
	dec c
	ret z
	jr .loop

.halveStat
	ld a, [hl]
	srl a
	ld [hli], a
	rr [hl]
	or [hl]
	jr nz, .nonzeroStat
	ld [hl], 1
.nonzeroStat
	dec hl
	ret

	
	
	
	
CheckAISwitched:
	ld a, [wEnemyMonPartyPos]	
	cp $05
	jr z, .party5
	cp $04
	jr z, .party4
	cp $03
	jr z, .party3
	cp $02
	jr z, .party2
	cp $01
	jr z, .party1
	jr .party0
.party5
	ld a, [wUnusedD366]
	bit 6, a
	jr .partyret
.party4
	ld a, [wUnusedD366]
	bit 5, a
	jr .partyret
.party3
	ld a, [wUnusedD366]
	bit 4, a
	jr .partyret
.party2
	ld a, [wUnusedD366]
	bit 3, a
	jr .partyret
.party1
	ld a, [wUnusedD366]
	bit 2, a
	jr .partyret
.party0
	ld a, [wUnusedD366]
	bit 1, a
.partyret
	ret
	
SetAISwitched:
	ld a, [wEnemyMonPartyPos]	
	cp $05
	jr z, .party5
	cp $04
	jr z, .party4
	cp $03
	jr z, .party3
	cp $02
	jr z, .party2
	cp $01
	jr z, .party1
	jr .party0
.party5
	ld a, [wUnusedD366]
	set 6, a
	ld [wUnusedD366], a
	jr .partyret
.party4
	ld a, [wUnusedD366]
	set 5, a
	ld [wUnusedD366], a
	jr .partyret
.party3
	ld a, [wUnusedD366]
	set 4, a
	ld [wUnusedD366], a
	jr .partyret
.party2
	ld a, [wUnusedD366]
	set 3, a
	ld [wUnusedD366], a
	jr .partyret
.party1
	ld a, [wUnusedD366]
	set 2, a
	ld [wUnusedD366], a
	jr .partyret
.party0
	ld a, [wUnusedD366]
	set 1, a
	ld [wUnusedD366], a
.partyret
	ret
	
SwapTurn:
	ld a, [H_WHOSETURN]
	and a
	jr z, .make_one
	xor a
	jr .leave
.make_one
	inc a
.leave
	ld [H_WHOSETURN], a
	ret

	
	
	
	
;joenote - check if enemy mon has gen2 shiny DVs
;zero flag is set if not shiny	
CheckEnemyShinyDVs:
	push hl
	ld hl, wEnemyMonDVs
	call ShinyDVsChecker
	jr z, .end
	ld a, $01
	and a 
.end
	pop hl
	ret

CheckPlayerShinyDVs:
	push hl
	ld hl, wBattleMonDVs
	call ShinyDVsChecker
	jr z, .end
	ld a, $01
	and a 
.end
	pop hl
	ret
	
CheckLoadedShinyDVs:
	push hl
	ld hl, wLoadedMonDVs
	call ShinyDVsChecker
	jr z, .end
	ld a, $01
	and a 
.end
	pop hl
	ret

ShinyDVsChecker:
	ld a, [hl]	;load MSB
	bit 5, a	;bit 5 of the MSB need to be a 1 for shininess
	jr z, .end_zero
	and $0F	;now mask out the lesser nybble of the MSB
	cp $0A	;need to be a DV of 10 for shininess
	jr nz, .end_zero
	inc hl
	ld a, [hl]	;load LSB
	cp a, $AA	;need to be DVs of 10 for shininess
	jr nz, .end_zero
	ld a, $01
	and a 
	ret
.end_zero
	xor a
	ret

ShinyPlayerAnimation:
	ld a, [wUnusedD366]
	bit 0, a
	jr nz, .noPlayerShiny
	call CheckPlayerShinyDVs
	jr z, .noPlayerShiny
	push de
	ld d, $00
	callba PlayShinyAnimation
	pop de
	call SkipPlayerShinybit
	push bc
	ld b, SET_PAL_BATTLE
	call RunPaletteCommand
	pop bc
.noPlayerShiny
	ret
	
ShinyEnemyAnimation:
	ld a, [wUnusedD366]
	bit 7, a
	jr nz, .noEnemyShiny
	call CheckEnemyShinyDVs
	jr z, .noEnemyShiny
	push de
	ld d, $01
	callba PlayShinyAnimation
	pop de
	call SkipEnemyShinybit
	push bc
	ld b, SET_PAL_BATTLE
	call RunPaletteCommand
	pop bc
.noEnemyShiny
	ret
	
DoPlayerShinybit:
	ld a, [wUnusedD366]
	res 0, a
	ld [wUnusedD366], a
	ret
SkipPlayerShinybit:
	ld a, [wUnusedD366]
	set 0, a
	ld [wUnusedD366], a
	ret
DoEnemyShinybit:
	ld a, [wUnusedD366]
	res 7, a
	ld [wUnusedD366], a
	ret
SkipEnemyShinybit:
	ld a, [wUnusedD366]
	set 7, a
	ld [wUnusedD366], a
	ret


ShinyStatusScreen:
	ld a, [wPalPacket + 3]
	call ShinyDVConvert
	ld [wPalPacket + 3], a
	ret
ShinyPlayerMon:
	ld a, [wPalPacket + 5]
	call ShinyDVConvert
	ld [wPalPacket + 5], a
	ret
ShinyEnemyMon:
	ld a, [wPalPacket + 7]
	call ShinyDVConvert
	ld [wPalPacket + 7], a
	ret
	
ShinyDVConvert:	;'a' holds the default value
	
	cp PAL_MEWMON
	jr nz, .next1
	ld a, PAL_BLUEMON
	jr .endConvert
	
.next1
	cp PAL_BLUEMON
	jr nz, .next2
	ld a, PAL_REDMON
	jr .endConvert
	
.next2
	cp PAL_REDMON
	jr nz, .next3
	ld a, PAL_GREYMON
	jr .endConvert

.next3
	cp PAL_CYANMON
	jr nz, .next4
	ld a, PAL_PURPLEMON
	jr .endConvert
	
.next4
	cp PAL_PURPLEMON
	jr nz, .next5
	ld a, PAL_BROWNMON
	jr .endConvert

.next5
	cp PAL_BROWNMON
	jr nz, .next6
	ld a, PAL_MEWMON
	jr .endConvert

.next6
	cp PAL_GREENMON
	jr nz, .next7
	ld a, PAL_PINKMON
	jr .endConvert

.next7
	cp PAL_PINKMON
	jr nz, .next8
	ld a, PAL_YELLOWMON
	jr .endConvert
	
.next8
	cp PAL_YELLOWMON
	jr nz, .next9
	ld a, PAL_GREENMON
	jr .endConvert
	
.next9
	cp PAL_GREYMON
	jr nz, .endConvert
	ld a, PAL_CYANMON

.endConvert
	ret
	
	

	
	

CheckIfPkmnReal:
;set the carry if pokemon number in 'a' is found on the list of legit pokemon
	push hl
	push de
	push bc
	ld hl, ListRealPkmn
	ld de, $0001
	call IsInArray
	pop bc
	pop de
	pop hl
	
ListRealPkmn:
	db RHYDON       ; $01
	db KANGASKHAN   ; $02
	db NIDORAN_M    ; $03
	db CLEFAIRY     ; $04
	db SPEAROW      ; $05
	db VOLTORB      ; $06
	db NIDOKING     ; $07
	db SLOWBRO      ; $08
	db IVYSAUR      ; $09
	db EXEGGUTOR    ; $0A
	db LICKITUNG    ; $0B
	db EXEGGCUTE    ; $0C
	db GRIMER       ; $0D
	db GENGAR       ; $0E
	db NIDORAN_F    ; $0F
	db NIDOQUEEN    ; $10
	db CUBONE       ; $11
	db RHYHORN      ; $12
	db LAPRAS       ; $13
	db ARCANINE     ; $14
	db MEW          ; $15
	db GYARADOS     ; $16
	db SHELLDER     ; $17
	db TENTACOOL    ; $18
	db GASTLY       ; $19
	db SCYTHER      ; $1A
	db STARYU       ; $1B
	db BLASTOISE    ; $1C
	db PINSIR       ; $1D
	db TANGELA      ; $1E
	db GROWLITHE    ; $21
	db ONIX         ; $22
	db FEAROW       ; $23
	db PIDGEY       ; $24
	db SLOWPOKE     ; $25
	db KADABRA      ; $26
	db GRAVELER     ; $27
	db CHANSEY      ; $28
	db MACHOKE      ; $29
	db MR_MIME      ; $2A
	db HITMONLEE    ; $2B
	db HITMONCHAN   ; $2C
	db ARBOK        ; $2D
	db PARASECT     ; $2E
	db PSYDUCK      ; $2F
	db DROWZEE      ; $30
	db GOLEM        ; $31
	db MAGMAR       ; $33
	db ELECTABUZZ   ; $35
	db MAGNETON     ; $36
	db KOFFING      ; $37
	db MANKEY       ; $39
	db SEEL         ; $3A
	db DIGLETT      ; $3B
	db TAUROS       ; $3C
	db FARFETCHD    ; $40
	db VENONAT      ; $41
	db DRAGONITE    ; $42
	db DODUO        ; $46
	db POLIWAG      ; $47
	db JYNX         ; $48
	db MOLTRES      ; $49
	db ARTICUNO     ; $4A
	db ZAPDOS       ; $4B
	db DITTO        ; $4C
	db MEOWTH       ; $4D
	db KRABBY       ; $4E
	db VULPIX       ; $52
	db NINETALES    ; $53
	db PIKACHU      ; $54
	db RAICHU       ; $55
	db DRATINI      ; $58
	db DRAGONAIR    ; $59
	db KABUTO       ; $5A
	db KABUTOPS     ; $5B
	db HORSEA       ; $5C
	db SEADRA       ; $5D
	db SANDSHREW    ; $60
	db SANDSLASH    ; $61
	db OMANYTE      ; $62
	db OMASTAR      ; $63
	db JIGGLYPUFF   ; $64
	db WIGGLYTUFF   ; $65
	db EEVEE        ; $66
	db FLAREON      ; $67
	db JOLTEON      ; $68
	db VAPOREON     ; $69
	db MACHOP       ; $6A
	db ZUBAT        ; $6B
	db EKANS        ; $6C
	db PARAS        ; $6D
	db POLIWHIRL    ; $6E
	db POLIWRATH    ; $6F
	db WEEDLE       ; $70
	db KAKUNA       ; $71
	db BEEDRILL     ; $72
	db DODRIO       ; $74
	db PRIMEAPE     ; $75
	db DUGTRIO      ; $76
	db VENOMOTH     ; $77
	db DEWGONG      ; $78
	db CATERPIE     ; $7B
	db METAPOD      ; $7C
	db BUTTERFREE   ; $7D
	db MACHAMP      ; $7E
	db GOLDUCK      ; $80
	db HYPNO        ; $81
	db GOLBAT       ; $82
	db MEWTWO       ; $83
	db SNORLAX      ; $84
	db MAGIKARP     ; $85
	db MUK          ; $88
	db KINGLER      ; $8A
	db CLOYSTER     ; $8B
	db ELECTRODE    ; $8D
	db CLEFABLE     ; $8E
	db WEEZING      ; $8F
	db PERSIAN      ; $90
	db MAROWAK      ; $91
	db HAUNTER      ; $93
	db ABRA         ; $94
	db ALAKAZAM     ; $95
	db PIDGEOTTO    ; $96
	db PIDGEOT      ; $97
	db STARMIE      ; $98
	db BULBASAUR    ; $99
	db VENUSAUR     ; $9A
	db TENTACRUEL   ; $9B
	db GOLDEEN      ; $9D
	db SEAKING      ; $9E
	db PONYTA       ; $A3
	db RAPIDASH     ; $A4
	db RATTATA      ; $A5
	db RATICATE     ; $A6
	db NIDORINO     ; $A7
	db NIDORINA     ; $A8
	db GEODUDE      ; $A9
	db PORYGON      ; $AA
	db AERODACTYL   ; $AB
	db MAGNEMITE    ; $AD
	db CHARMANDER   ; $B0
	db SQUIRTLE     ; $B1
	db CHARMELEON   ; $B2
	db WARTORTLE    ; $B3
	db CHARIZARD    ; $B4
	db ODDISH       ; $B9
	db GLOOM        ; $BA
	db VILEPLUME    ; $BB
	db BELLSPROUT   ; $BC
	db WEEPINBELL   ; $BD
	db VICTREEBEL   ; $BE
