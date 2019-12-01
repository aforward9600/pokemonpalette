
;Putting some useful functions into this file that are in fact used now
	
	

;joenote - custom functions to handle move priority. Sets zero flag if priority lowered/raised.
CheckLowerPlayerPriority:	
	ld a, [wPlayerSelectedMove]
	call LowPriorityMoves
	ret
CheckLowerEnemyPriority:
	ld a, [wEnemySelectedMove]
	call LowPriorityMoves
	ret
LowPriorityMoves:
	cp COUNTER
;	ret z
;	cp BIND
;	ret z
;	cp WRAP
;	ret z
;	cp FIRE_SPIN
;	ret z
;	cp CLAMP
	ret

CheckHigherPlayerPriority:	
	ld a, [wPlayerSelectedMove]
	call HighPriorityMoves
	ret
CheckHigherEnemyPriority:
	ld a, [wEnemySelectedMove]
	call HighPriorityMoves
	ret
HighPriorityMoves:
	cp QUICK_ATTACK
;	ret z
;	cp DUMMY_MOVE1
;	ret z
;	cp DUMMY_MOVE2
;	ret z
;	cp DUMMY_MOVE3
;	ret z
;	cp DUMMY_MOVE4
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

	
	
;joenote - custom functions for determining which trainerAI pkmn have already been switched out before
;a=party position of pkmn (like wEnemyMonPartyPos). If checking, zero flag gives bit state (1 means switched out already)	
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
	
SwapTurn:	;a simple custom function for swapping whose turn it is in the battle engine
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

	

;custom function to determin the DVs of wild pokemon with an option for forcing shiny DVs
DetermineWildMonDVs:
	ld a, [wFontLoaded]
	bit 7, a
	jr z, .do_random
	ld b, $AA
	call Random	;get random number into a
	or $20	;set only bit 5
	and $F0 ; clear the lower nybble
	or $0A	;set the lower nyble to $A
	jr .load
.do_random
	call IsInSafariZone
	jr nz, .do_random_safari	;safari zone pokemon have better DVs
	call Random
	ld b, a
	call Random
	jr .load
.do_random_safari
	call Random
	or $88
	ld b, a
	call Random
	or $98
.load
	push hl
	ld hl, wEnemyMonDVs
	ld [hli], a
	ld [hl], b
	pop hl
	ld a, [wFontLoaded]
	res 7, a 
	ld [wFontLoaded], a
	ret

	

;replace random mew encounters with ditto if dex diploma not attained
DisallowMew:
	CheckEvent EVENT_90B
	ret nz	;if event 90B is set, then diploma has been granted so return from this function. mew is allowed.
	ld a, [wcf91]	;else get the current pokemon in question
	cp MEW	;is it mew? zet zero flag if true
	ret nz	;if not mew, then return
	ld a, [wIsInBattle]	;else we have a mew. now load the battle type (1 is wild battle, 2+ is trainer battle)
	dec a	;zero flag set here if in wild battle
	ld a, DITTO	;load the ditto constant
	ld [wcf91], a	;overwrite mew with ditto
	ret nz	
	ld [wEnemyMonSpecies2], a
	ret

	
	
;Custom functions to handle shiny pokemon
	
ShinyAttractFunction:
;only if the party leader is lvl 100 or more
	ld a, [wPartyMon1Level]
	cp 100	;do wPartyMon1Level - 100. set carry if result < 0
	ret c	;return if wPartyMon1Level < 100
;and only if it's a chansey
	ld a, [wPartyMon1Species]
	cp CHANSEY
	ret nz
;make a 1 in 255 chance to force shiny DVs on a wild pokemon 
	call Random
	ret nz
	ld a, [wFontLoaded]
	set 7, a 
	ld [wFontLoaded], a
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
	ld a, PAL_MEWMON
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
	ld a, PAL_REDMON
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

;This function loads a random trainer class (value of $01 to $2F)
GetRandTrainer:
.reroll
	call Random
	and $30
	cp $30
	jr z, .reroll
	push bc
	ld b, a
	call Random
	and $0F
	add b
	pop bc
	and a
	jr z, .reroll
	add $C8
	ld [wEngagedTrainerClass], a
	ld a, 1
	ld [wEngagedTrainerSet], a
	ret

;gets a random pokemon and puts its hex ID in register a and wcf91
GetRandMonAny:
	ld de, ListRealPkmn
	;fall through
GetRandMon:
	push hl
	push bc
	ld h, d
	ld l, e
	call Random
	ld b, a
.loop
	ld a, b
	and a
	jr z, .endloop
	inc hl
	dec b
	ld a, [hl]
	and a
	jr nz, .loop
	ld h, d
	ld l, e
	jr .loop
.endloop
	ld a, [hl]
	pop bc
	pop hl
	ld [wcf91], a
	call DisallowMew
	ret
	
;generates a randomized 6-party enemy trainer roster
GetRandRoster:
	push bc
	ld b, 6
	jp GetRandRosterLoop
GetRandRoster3:	;3-mon party
	push bc
	ld b, 3
GetRandRosterLoop:
	ld a, [wPartyMon1Level]
	ld [wCurEnemyLVL], a
.loop	
	push bc
	push de
	ld de, ListRealPkmn
	call GetRandMon
	pop de
	ld a, ENEMY_PARTY_DATA
	ld [wMonDataLocation], a
	push hl
	call ScaleTrainer
	pop hl
	push hl
	call AddPartyMon
	call Random
	and $03
	ld b, a
	ld a, [wCurEnemyLVL]
	add b
	ld [wCurEnemyLVL], a
	pop hl
	pop bc
	dec b
	jr nz, .loop
;end of loop
	pop bc
	xor a	;set the zero flag before returning
	ret	
ListRealPkmn:
	db MEW          ; $15
	db MEWTWO       ; $83
	db MOLTRES      ; $49
	db ARTICUNO     ; $4A
	db ZAPDOS       ; $4B
ListNonLegendPkmn:
	db NIDORAN_M    ; $03
	db CLEFAIRY     ; $04
	db SPEAROW      ; $05
	db VOLTORB      ; $06
	db EXEGGCUTE    ; $0C
	db GRIMER       ; $0D
	db NIDORAN_F    ; $0F
	db CUBONE       ; $11
	db RHYHORN      ; $12
	db SHELLDER     ; $17
	db TENTACOOL    ; $18
	db GASTLY       ; $19
	db STARYU       ; $1B
	db GROWLITHE    ; $21
	db PIDGEY       ; $24
	db SLOWPOKE     ; $25
	db PSYDUCK      ; $2F
	db DROWZEE      ; $30
	db KOFFING      ; $37
	db MANKEY       ; $39
	db SEEL         ; $3A
	db DIGLETT      ; $3B
	db VENONAT      ; $41
	db DODUO        ; $46
	db POLIWAG      ; $47
	db MEOWTH       ; $4D
	db KRABBY       ; $4E
	db VULPIX       ; $52
	db PIKACHU      ; $54
	db DRATINI      ; $58
	db KABUTO       ; $5A
	db HORSEA       ; $5C
	db SANDSHREW    ; $60
	db OMANYTE      ; $62
	db JIGGLYPUFF   ; $64
	db EEVEE        ; $66
	db MACHOP       ; $6A
	db ZUBAT        ; $6B
	db EKANS        ; $6C
	db PARAS        ; $6D
	db WEEDLE       ; $70
	db KAKUNA       ; $71
	db CATERPIE     ; $7B
	db METAPOD      ; $7C
	db MAGIKARP     ; $85
	db ABRA         ; $94
	db BULBASAUR    ; $99
	db GOLDEEN      ; $9D
	db PONYTA       ; $A3
	db RATTATA      ; $A5
	db GEODUDE      ; $A9
	db MAGNEMITE    ; $AD
	db CHARMANDER   ; $B0
	db SQUIRTLE     ; $B1
	db ODDISH       ; $B9
	db BELLSPROUT   ; $BC
ListMidEvolvedPkmn:
	db IVYSAUR      ; $09
	db KADABRA      ; $26
	db GRAVELER     ; $27
	db MACHOKE      ; $29
	db POLIWHIRL    ; $6E
	db HAUNTER      ; $93
	db PIDGEOTTO    ; $96
	db NIDORINO     ; $A7
	db NIDORINA     ; $A8
	db CHARMELEON   ; $B2
	db WARTORTLE    ; $B3
	db GLOOM        ; $BA
	db WEEPINBELL   ; $BD
ListNonEvolvingPkmn:
	db PORYGON      ; $AA
	db AERODACTYL   ; $AB
	db SNORLAX      ; $84
	db DITTO        ; $4C
	db JYNX         ; $48
	db TAUROS       ; $3C
	db FARFETCHD    ; $40
	db MAGMAR       ; $33
	db ELECTABUZZ   ; $35
	db MR_MIME      ; $2A
	db HITMONLEE    ; $2B
	db HITMONCHAN   ; $2C
	db CHANSEY      ; $28
	db ONIX         ; $22
	db FEAROW       ; $23
ListMostEvolvedPkmn:
	db VICTREEBEL   ; $BE
	db VILEPLUME    ; $BB
	db CHARIZARD    ; $B4
	db RATICATE     ; $A6
	db RAPIDASH     ; $A4
	db VENUSAUR     ; $9A
	db TENTACRUEL   ; $9B
	db SEAKING      ; $9E
	db PIDGEOT      ; $97
	db STARMIE      ; $98
	db ALAKAZAM     ; $95
	db MUK          ; $88
	db KINGLER      ; $8A
	db CLOYSTER     ; $8B
	db ELECTRODE    ; $8D
	db CLEFABLE     ; $8E
	db WEEZING      ; $8F
	db PERSIAN      ; $90
	db MAROWAK      ; $91
	db BUTTERFREE   ; $7D
	db MACHAMP      ; $7E
	db GOLDUCK      ; $80
	db HYPNO        ; $81
	db GOLBAT       ; $82
	db BEEDRILL     ; $72
	db DODRIO       ; $74
	db PRIMEAPE     ; $75
	db DUGTRIO      ; $76
	db VENOMOTH     ; $77
	db DEWGONG      ; $78
	db POLIWRATH    ; $6F
	db FLAREON      ; $67
	db JOLTEON      ; $68
	db VAPOREON     ; $69
	db WIGGLYTUFF   ; $65
	db OMASTAR      ; $63
	db SANDSLASH    ; $61
	db SEADRA       ; $5D
	db KABUTOPS     ; $5B
	db DRAGONAIR    ; $59
	db RAICHU       ; $55
	db NINETALES    ; $53
	db DRAGONITE    ; $42
	db GOLEM        ; $31
	db MAGNETON     ; $36
	db ARBOK        ; $2D
	db PARASECT     ; $2E
	db BLASTOISE    ; $1C
	db RHYDON       ; $01
	db NIDOKING     ; $07
	db SLOWBRO      ; $08
	db EXEGGUTOR    ; $0A
	db GENGAR       ; $0E
	db NIDOQUEEN    ; $10
	db ARCANINE     ; $14
	db GYARADOS     ; $16
	db $00


;implement a function to scale trainer levels
ScaleTrainer:
	CheckEvent EVENT_90C
	ret z
	push bc
	ld a, [wCurEnemyLVL]
	ld b, a
	ld a, [wPartyMon1Level]
	cp b
	jr c, .nolvlincrease
	jr z, .nolvlincrease
	ld [wCurEnemyLVL], a
	call Random
	and $03
	ld b, a
	ld a, [wGymLeaderNo]
	and a
	jr z, .notboss
	ld a, [wCurEnemyLVL]
	add b
	ld [wCurEnemyLVL], a
	call Random
	and $03
	ld b, a
.notboss
	ld a, [wCurEnemyLVL]
	add b
	ld [wCurEnemyLVL], a
.nolvlincrease
	pop bc
	callba EnemyMonEvolve
	ret

TrainerRematch:
	xor a
	CheckEvent EVENT_909
	jr nz, .skip_rematch_choice
	ld hl, RematchTrainerText
	call PrintText
	call NoYesChoice
	ld a, [wCurrentMenuItem]
	and a
	ret nz
.skip_rematch_choice
	ResetEvent EVENT_909
	xor a
	ret


	
; return a = 0 if not in safari zone, else a = 1 if in safari zone
IsInSafariZone:
	ld a, [wCurMap]
	cp SAFARI_ZONE_EAST
	jr c, .notSafari
	cp SAFARI_ZONE_REST_HOUSE_1
	jr nc, .notSafari
	ld a, $01
	jr .return
.notSafari
	ld a, $00
.return
	and a
	ret

;Generate a random mon for an expanded safari zone roster
GetRandMonSafari:
	;return if e4 not yet beaten
	CheckEvent EVENT_908
	ret z	
	;return if not in safari zone
	call IsInSafariZone
	ret z
	;else continue on
	call Random
	cp 26
	ret nc	;only a 26/256 chance to have an expanded encounter
	push hl
	push bc
	call GetSafariList
	call Random
	ld b, a
.loop
	ld a, b
	and a
	jr z, .endloop
	inc hl
	dec b
	ld a, [hl]
	and a
	jr nz, .loop
	call GetSafariList
	jr .loop
.endloop
	ld a, [hl]
	pop bc
	pop hl
	ld [wcf91], a
	ld [wEnemyMonSpecies2], a
	call DisallowMew
	ret	

GetSafariList:	
	ld a, [wCurMap]
	cp SAFARI_ZONE_CENTER
	ld hl, ListNonLegendPkmn
	ret z
	cp SAFARI_ZONE_EAST
	ld hl, ListMidEvolvedPkmn
	ret z
	cp SAFARI_ZONE_NORTH
	ld hl, ListNonEvolvingPkmn
	ret z
	ld hl, ListMostEvolvedPkmn
	ret
	
	
	
;play cry if the 1st pokemon has payday in its move set
LuckySlotDetect:
	push hl
	ld b, NUM_MOVES + 1
	ld hl, wPartyMon1Moves
.loop
	dec b
	jr z, .return
	ld a, [hli]
	cp PAY_DAY
	jr nz, .loop
	ld a, [wPartyMon1Species]
	call PlayCry
.return
	pop hl
	ret
	

;Convert the DVs of the ist party pkmn into a normalized BCD-value score stored in wcd6d
Mon1DVsBCDScore:
	push de
	push hl
	push bc
	xor a
	ld [hCoins], a
	ld [hCoins + 1], a
	ld [hItemPrice], a	
	ld [hItemPrice + 1], a	
	ld [hItemPrice + 2], a	
	
	ld de, hCoins + 1
	ld hl, hItemPrice + 1
	
	ld a, [wPartyMon1DVs]	;load first two nybbles of DVs
	srl a	;shift all bits to the right one time
	and $F7	; clear the highest bit of the low nybble in case the high nybble overflowed into the low nybble
	ld [de], a
	
	ld a, [wPartyMon1DVs + 1]	;load second two nybbles of DVs
	srl a	;shift all bits to the right one time
	and $F7	; clear the highest bit of the low nybble in case the high nybble overflowed into the low nybble
	ld [hl], a
	
	ld c, $2
	predef AddBCDPredef	;add value in hl location to value in de location
	;now store in wcd6d buffer
	ld a, [hCoins]
	ld [wcd6d], a
	ld a, [hCoins + 1]
	ld [wcd6d + 1], a

	xor a
	ld [hCoins], a
	ld [hCoins + 1], a
	ld [hItemPrice], a	
	ld [hItemPrice + 1], a	
	ld [hItemPrice + 2], a	
	pop bc
	pop hl
	pop de
	ret

	
;joenote - This fixes an issue with exp all where exp gets divided twice	
UndoDivision4ExpAll:
	ld hl, wEnemyMonBaseStats	;get first stat
	ld b, $7
.exp_stat_loop

	ld a, [wUnusedD155]	
	ld c, a		;get number of participating pkmn into c
	xor a	;clear a to zero
	
.exp_adder_loop
	add [hl]	; add the value of the current exp stat to 'a'
	dec c		; decrement participating pkmn
	jr nz, .exp_adder_loop
	
	ld [hl], a	;stick the exp values, now multiplied by the number of participating pkmn, back into the stat address
	
	inc hl	;get next stat 
	dec b
	
	jr nz, .exp_stat_loop
	ret

;joenote - fixes issues where exp all counts fainted pkmn for dividing exp
SetExpAllFlags:
	ld a, $1
	ld [wBoostExpByExpAll], a
	ld a, [wPartyCount]
	ld c, a
	ld b, 0
	ld hl, wPartyMon1HP
.gainExpFlagsLoop
	ld a, [hli]
	or [hl] ; is mon's HP 0?
	jp z, .setzeroexpflag
	scf
	rl b
	jp .nextmonforexpall
.setzeroexpflag
	sla b
.nextmonforexpall
	dec c
	jr z, .return
	ld a, [wPartyCount]
	sub c
	push bc
	ld bc, wPartyMon2HP - wPartyMon1HP
	ld hl, wPartyMon1HP
	call AddNTimes
	pop bc
	jr .gainExpFlagsLoop
.return
	ld a, b
	ld [wPartyGainExpFlags], a
	ret
	
	
;joenote - this function is meant to temporarily reduce a a pkmn's speed by 25% for using trapping moves until stats are recalculated
;"c" holds lower byte of speed and "b" holds upper byte of speed
ReduceSpeed:
	push bc
	push de
	ld hl, wBattleMonSpeed + 1	;assume it is the player's turn
	ld a, [H_WHOSETURN]
	and a
	jr z, .proceed
	ld hl, wEnemyMonSpeed + 1	;else it's the enemy's turn
.proceed
	;bc to hold regular speed and de to hold 25% of that
	ld a, [hld]
	ld c, a
	ld e, a
	ld a, [hl]
	ld b, a
	ld d, a
	;make de one-quarter of bc
	srl d
	rr e
	srl d
	rr e
	;now subtract e from c
	ld a, c
	sub e
	ld c, a
	;now subtract d from b with carry
	ld a, b
	sbc d
	ld b, a
	;a still holds upper speed byte, so save it back
	ld [hli], a
	;now OR the upper speed byte in a with the lower speed byte
	or c	;zero flag is set if speed is totally zero
	jr nz, .notzerospeed
	ld c, 1	;give minimum of at least 1 in speed
.notzerospeed
	ld [hl], c
	pop de
	pop bc
	ret

	
;This function is for teleporting you home from the start menu if you get stuck
SoftlockTeleport:
	ld a, [hJoyInput]
	cp D_DOWN + B_BUTTON + SELECT
	ret nz
	ld a, [wCurrentMenuItem]
	cp 6 
	ret nz
	ld a, PALLET_TOWN
	ld [wLastBlackoutMap], a
	ld a, [wd732]
	set 3, a 
	res 4, a 
	set 6, a 
	ld [wd732], a
	ret
	
	
;this function handles tracking of how bast to go on or off a bike
;biking ORs with $2
;running by holding B ORs with $1
TrackRunBikeSpeed:
	xor a
	ld[wUnusedD119], a
	ld a, [wWalkBikeSurfState]
	dec a ; riding a bike? (0 value = TRUE)
	call z, IsRidingBike
	ld a, [hJoyHeld]
	and B_BUTTON	;holding B to speed up? (non-zero value = TRUE)
	call nz, IsRunning
	ld a, [wUnusedD119]
	cp 2	;is biking without speedup being done?
	jr z, .skip	;if not make the states a value from 1 to 4 (excluding biking without speedup, which needs to be 2)
	inc a	
.skip
	ld[wUnusedD119], a
	ret
IsRidingBike:
	ld a, [wUnusedD119]
	or $2
	ld[wUnusedD119], a
	ret
IsRunning:
	ld a, [wUnusedD119]
	or $1
	ld[wUnusedD119], a
	ret
	

;joenote - allows for using HMs on the overworld with just a button press
CheckForSmartHMuse:
	callba GetTileAndCoordsInFrontOfPlayer
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;check for cut
	ld a, [wObtainedBadges]
	bit 1, a ; does the player have the Cascade Badge?
	jr z, .nocut
	;does a party 'mon have CUT?
	ld c, CUT
	call PartyMoveTest
	jr z, .nocut
	;which tileset is being used?
	ld a, [wCurMapTileset]
	and a ; OVERWORLD
	jr z, .overworld
	;check gym tileset
	cp GYM
	jr nz, .nocut
	ld a, [wTileInFrontOfPlayer]
	cp $50 ; gym cuttable tree
	jr nz, .nocut
	jr .canCut
.overworld
	dec a
	ld a, [wTileInFrontOfPlayer]
	cp $3d ; cuttable tree
	jr z, .canCut
	cp $52 ; grass
	jr nz, .nocut
.canCut
	ld [wCutTile], a
	ld a, $ff
	ld [wUpdateSpritesEnabled], a
	callba InitCutAnimOAM
	ld de, CutTreeBlockSwaps
	callba ReplaceTreeTileBlock
	callba RedrawMapView
	callba AnimCut
	ld a, $1
	ld [wUpdateSpritesEnabled], a
	ld a, SFX_CUT
	call PlaySound
	ld a, $90
	ld [hWY], a
	call UpdateSprites
	callba RedrawMapView
	jp .return
.nocut
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;check for surfing
	ld a, [wObtainedBadges]
	bit 4, a ; does the player have the Soul Badge?
	jr z, .nosurf
	ld a, [wWalkBikeSurfState]
	ld [wWalkBikeSurfStateCopy], a
	cp 2 ; is the player already surfing?
	jr z, .nosurf	
	;surfing not allowed if forced to ride bike
	ld a, [wd732]
	bit 5, a
	jr nz, .nosurf
	callba IsSurfingAllowed
	ld hl, wd728
	bit 1, [hl]
	res 1, [hl]
	jr z, .nosurf
	callba IsNextTileShoreOrWater	;unsets carry if player is facing water or shore
	jr c, .nosurf
	ld hl, TilePairCollisionsWater
	call CheckForTilePairCollisions
	jr c, .nosurf
	;is the surfboard in the bag?
	;ld b, SURFBOARD
	;call IsItemInBag
	;jr nz, .beginsurfing
	;check if a party member has surf
	ld c, SURF
	call PartyMoveTest
	jr z, .nosurf
.beginsurfing
	;we can now initiate surfing
	ld hl, wd730
	set 7, [hl]
	ld a, 2
	ld [wWalkBikeSurfState], a ; change player state to surfing
	;update sprites
	call LoadPlayerSpriteGraphics
	call PlayDefaultMusic ; play surfing music
	;move player forward
	ld a, [wPlayerDirection] ; direction the player is going
	bit PLAYER_DIR_BIT_UP, a
	ld b, D_UP
	jr nz, .storeSimulatedButtonPress
	bit PLAYER_DIR_BIT_DOWN, a
	ld b, D_DOWN
	jr nz, .storeSimulatedButtonPress
	bit PLAYER_DIR_BIT_LEFT, a
	ld b, D_LEFT
	jr nz, .storeSimulatedButtonPress
	ld b, D_RIGHT
.storeSimulatedButtonPress
	ld a, b
	ld [wSimulatedJoypadStatesEnd], a
	xor a
	ld [wWastedByteCD39], a
	inc a
	ld [wSimulatedJoypadStatesIndex], a
	jp .return
.nosurf
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;check for flash
	ld a, [wObtainedBadges]
	bit 0, a ; does the player have the Boulder Badge?
	jr z, .noflash
	;check if the map pal offset is not zero
	ld a, [wMapPalOffset]
	and a 
	jr z, .noflash
	;check if a party member has strength
	ld c, FLASH
	call PartyMoveTest
	jr z, .noflash
	;restore the map pal offset to brighten it up
	xor a
	ld [wMapPalOffset], a
	jp .return
.noflash
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;else check for strength and enable it
	ld a, [wObtainedBadges]
	bit 3, a ; does the player have the Rainbow Badge?
	jr z, .nostrength
	;check if a party member has strength
	ld c, STRENGTH
	call PartyMoveTest
	jr z, .nostrength
	;set the usingStrength bit
	ld a, [wd728]
	set 0, a
	ld [wd728], a
	jp .return
.nostrength
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.return
	jpba OverworldLoop
	

;Check if any pokemon in the party has a certain move
;move ID should be in 'c'
;set zero flag if move not found
;clear zero flag if move found
PartyMoveTest:
	push hl
	push bc
	;;;;;
	ld hl, wPartyMon1Moves
	ld b, NUM_MOVES + 1
	call MoveTestLoop
	jr nz, .return_1
	;;;;;
	ld a, [wPartyCount]
	cp 2
	jr c, .return_0
	ld hl, wPartyMon2Moves
	ld b, NUM_MOVES + 1
	call MoveTestLoop
	jr nz, .return_1
	;;;;;
	ld a, [wPartyCount]
	cp 3
	jr c, .return_0
	ld hl, wPartyMon3Moves
	ld b, NUM_MOVES + 1
	call MoveTestLoop
	jr nz, .return_1
	;;;;;
	ld a, [wPartyCount]
	cp 4
	jr c, .return_0
	ld hl, wPartyMon4Moves
	ld b, NUM_MOVES + 1
	call MoveTestLoop
	jr nz, .return_1
	;;;;;
	ld a, [wPartyCount]
	cp 5
	jr c, .return_0
	ld hl, wPartyMon5Moves
	ld b, NUM_MOVES + 1
	call MoveTestLoop
	jr nz, .return_1
	;;;;;
	ld a, [wPartyCount]
	cp 6
	jr c, .return_0
	ld hl, wPartyMon6Moves
	ld b, NUM_MOVES + 1
	call MoveTestLoop
	jr nz, .return_1
.return_0
	xor a
.return_1
	pop bc
	pop hl
	ret
	
MoveTestLoop:
	dec b
	jr z, .return
	ld a, [hli]
	cp c
	jr nz, MoveTestLoop
	inc b
.return
	ret
	
	
	


;Overworld Female Sprite Functions
LoadRedSpriteToDE:
	ld de, RedFSprite
	ld a, [wUnusedD721]
	bit 0, a	;check if girl
	jr nz, .donefemale
	ld de, RedSprite
.donefemale
	res 2, a
	ld [wUnusedD721], a
	ret
	
LoadSeelSpriteToDE:
	ld de, SeelSprite
	ld a, [wUnusedD721]
	set 2, a	;regardless if boy or girl, need to set override bit to use the regular sprite bank
	ld [wUnusedD721], a
	ret

LoadRedCyclingSpriteToDE:
	ld de, RedFCyclingSprite
	ld a, [wUnusedD721]
	bit 0, a	;check if girl
	jr nz, .donefemale
	ld de, RedCyclingSprite
.donefemale
	res 2, a
	ld [wUnusedD721], a
	ret


