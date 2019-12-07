
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
;	cp DUMMY_MOVE1
;	ret z
;	cp DUMMY_MOVE2
;	ret z
;	cp DUMMY_MOVE3
;	ret z
;	cp DUMMY_MOVE4
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
	ld a, [wFontLoaded]	;force a wild pokemon with shiny DVs for Gen 2 if bin 7 is set
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
	jr nz, .do_random_safari	
	call Random
	ld b, a
	call Random
	jr .load
.do_random_safari
	call Random
;	or $88	;option to make safari zone pokemon have better DVs
	ld b, a
	call Random
;	or $98	;option to make safari zone pokemon have better DVs
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
	;call nz, IsRunning	;joenote - uncomment this line to make holding B do double-speeed while walking/surfing/biking
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
	

	




