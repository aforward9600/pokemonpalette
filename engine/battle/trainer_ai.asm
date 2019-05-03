; creates a set of moves that may be used and returns its address in hl
; unused slots are filled with 0, all used slots may be chosen with equal probability
AIEnemyTrainerChooseMoves:
	ld a, $a
	ld hl, wBuffer ; init temporary move selection array. Only the moves with the lowest numbers are chosen in the end
	ld [hli], a   ; move 1
	ld [hli], a   ; move 2
	ld [hli], a   ; move 3
	ld [hl], a    ; move 4
	ld a, [wEnemyDisabledMove] ; forbid disabled move (if any)
	swap a
	and $f
	jr z, .noMoveDisabled
	ld hl, wBuffer
	dec a
	ld c, a
	ld b, $0
	add hl, bc    ; advance pointer to forbidden move
	ld [hl], $50  ; forbid (highly discourage) disabled move
.noMoveDisabled
	ld hl, TrainerClassMoveChoiceModifications
	ld a, [wTrainerClass]
	ld b, a
.loopTrainerClasses
	dec b
	jr z, .readTrainerClassData
.loopTrainerClassData
	ld a, [hli]
	and a
	jr nz, .loopTrainerClassData
	jr .loopTrainerClasses
.readTrainerClassData
	ld a, [hl]
	and a
	jp z, .useOriginalMoveSet
	push hl
.nextMoveChoiceModification
	pop hl
	ld a, [hli]
	and a
	jr z, .loopFindMinimumEntries
	push hl
	ld hl, AIMoveChoiceModificationFunctionPointers
	dec a
	add a
	ld c, a
	ld b, 0
	add hl, bc    ; skip to pointer
	ld a, [hli]   ; read pointer into hl
	ld h, [hl]
	ld l, a
	ld de, .nextMoveChoiceModification  ; set return address
	push de
	jp hl         ; execute modification function
.loopFindMinimumEntries ; all entries will be decremented sequentially until one of them is zero
	ld hl, wBuffer  ; temp move selection array
	ld de, wEnemyMonMoves  ; enemy moves
	ld c, NUM_MOVES
.loopDecrementEntries
	ld a, [de]
	inc de
	and a
	jr z, .loopFindMinimumEntries
	dec [hl]
	jr z, .minimumEntriesFound
	inc hl
	dec c
	jr z, .loopFindMinimumEntries
	jr .loopDecrementEntries
.minimumEntriesFound
	ld a, c
.loopUndoPartialIteration ; undo last (partial) loop iteration
	inc [hl]
	dec hl
	inc a
	cp NUM_MOVES + 1
	jr nz, .loopUndoPartialIteration
	ld hl, wBuffer  ; temp move selection array
	ld de, wEnemyMonMoves  ; enemy moves
	ld c, NUM_MOVES
.filterMinimalEntries ; all minimal entries now have value 1. All other slots will be disabled (move set to 0)
	ld a, [de]
	and a
	jr nz, .moveExisting
	ld [hl], a
.moveExisting
	ld a, [hl]
	dec a
	jr z, .slotWithMinimalValue
	xor a
	ld [hli], a     ; disable move slot
	jr .next
.slotWithMinimalValue
	ld a, [de]
	ld [hli], a     ; enable move slot
.next
	inc de
	dec c
	jr nz, .filterMinimalEntries
	ld hl, wBuffer    ; use created temporary array as move set
	ret
.useOriginalMoveSet
	ld hl, wEnemyMonMoves    ; use original move set
	ret

AIMoveChoiceModificationFunctionPointers:
	dw AIMoveChoiceModification1
	dw AIMoveChoiceModification2
	dw AIMoveChoiceModification3
	dw AIMoveChoiceModification4 ; ;joenote - repurposed unused routine for trainer switching

; discourages moves that cause no damage but only a status ailment if player's mon already has one
AIMoveChoiceModification1:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;joenote - kick out if no-attack bit is set
	ld a, [wUnusedC000]
	bit 2, a
	ret nz
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ld a, [wBattleMonStatus]
	and a
	;joenote - don't return yet. going to check for dream eater. will do this later
	;ret z ; return if no status ailment on player's mon
	ld hl, wBuffer - 1 ; temp move selection array (-1 byte offset)
	ld de, wEnemyMonMoves ; enemy moves
	ld b, NUM_MOVES + 1
.nextMove
	dec b
	ret z ; processed all 4 moves
	inc hl
	ld a, [de]
	and a
	ret z ; no more moves in move set
	inc de
	call ReadMove
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;joenote - do not use effects that end battle because this is a trainer battle and they do not work
	ld a, [wEnemyMoveEffect]	;load the move effect
	cp SWITCH_AND_TELEPORT_EFFECT	;see if it is a battle-ending effect
	jp z, .heavydiscourage	;heavily discourage if so
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;joenote - do not use disable on a pkmn that is already disabled
	ld a, [wEnemyMoveEffect]	;load the move effect
	cp DISABLE_EFFECT
	jr nz, .notdisable
	ld a, [wPlayerDisabledMove]	
	and a
	jp nz, .heavydiscourage	
.notdisable
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;joenote - do not use dream eater if enemy not asleep, otherwise encourage it
	ld a, [wEnemyMoveEffect]	;load the move effect
	cp DREAM_EATER_EFFECT	;see if it is dream eater
	jr nz, .notdreameater	;skip out if move is not dream eater
	ld a, [wBattleMonStatus]	;load the player pkmn non-volatile status
	and $7	;check bits 0 to 2 for sleeping turns
	jp z, .heavydiscourage	;heavily discourage using dream eater on non-sleeping pkmn
	dec [hl]	;else slightly encourage dream eater's use on a sleeping pkmn
	jp .nextMove
.notdreameater	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;joenote - do not use counter against a non-applicable move
	ld a, [wEnemyMoveNum]	
	cp COUNTER
	jr nz, .countercheck_end	;if this move is not counter then jump out
	ld a, [wPlayerMovePower]
	and a
	jp z, .heavydiscourage	;heavily discourage counter if enemy is using zero-power move
	ld a, [wPlayerMoveType]
	cp NORMAL
	jr z, .countercheck_end	; continue on if countering a normal move
	cp FIGHTING
	jr z, .countercheck_end	; continue on if countering a fighting move
	cp BIRD
	jr z, .countercheck_end	; continue on if countering STRUGGLE or other typeless move
	jp .heavydiscourage	;else heavily discourage since the player move type is not applicable to counter
.countercheck_end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;joenote - do not use moves that are ineffective against substitute if a substitute is up
	push hl	;save hl register on the stack
	ld hl, wPlayerBattleStatus2
	bit HAS_SUBSTITUTE_UP, [hl]	;check hl for substitute bit
	pop hl	;restore original hl data from the stack
	jr z, .noSubImm	;if the substitute bit is not set, then skip out of this block
	ld a, [wEnemyMoveEffect]	;get the move effect into a
	push hl
	push de
	push bc
	ld hl, SubstituteImmuneEffects
	ld de, $0001
	call IsInArray	;see if a is found in the hl array (carry flag set if true)
	pop bc
	pop de
	pop hl
	jp c, .heavydiscourage	;carry flag means the move effect is blocked by substitute
	;else continue onward
.noSubImm	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ld a, [wEnemyMovePower]
	and a
	jp nz, .nextMove	;go to next move if the current move is not zero-power
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;At this line onward all moves are assumed to be zero power
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Heavily discourage healing moves if HP is full. Encourage if hp is low
	ld a, [wEnemyMoveEffect]	;load the move effect
	cp HEAL_EFFECT	;see if it is a healing move
	jr nz, .notahealingmove	;skip out if move is not a healing move
	ld a, 1	;
	call AICheckIfHPBelowFraction
	jp nc, .heavydiscourage	;if hp not below 1/1 max hp then heavily discourage
	inc [hl]	;slightly discourage by default (1/2 hp to max-1 hp)
	ld a, 2	;
	call AICheckIfHPBelowFraction
	jp nc, .nextMove	;if hp is 1/2 or more, get next move
	dec [hl]	;else return preference to neutral (1/3 to 1/2 hp)
	ld a, 3	;
	call AICheckIfHPBelowFraction
	jp nc, .nextMove	;if hp is 1/2 or more, get next move
	dec [hl]	;else slightly encourage
	jp .nextMove	;get next move
.notahealingmove
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;joenote - do not use moves that are blocked by mist
	push hl	;save hl register on the stack
	ld hl, wPlayerBattleStatus2
	bit PROTECTED_BY_MIST, [hl]	;check hl for mist bit
	pop hl	;restore original hl data from the stack
	jr z, .noMistImm	;if the mist bit is not set, then skip out of this block
	ld a, [wEnemyMoveEffect]	;get the move effect into a
	push hl
	push de
	push bc
	ld hl, MistBlockEffects
	ld de, $0001
	call IsInArray	;see if a is found in the hl array (carry flag set if true)
	pop bc
	pop de
	pop hl
	jp c, .heavydiscourage	;carry flag means the move effect is blocked by mist
	;else continue onward
.noMistImm	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;joenote - heavily discourage stat modifying moves if it would hit the mod limit and be ineffective
	;check for stat down effects
	ld a, [wEnemyMoveEffect]	;get the move effect
	cp ATTACK_DOWN1_EFFECT	
	jr c, .nostatdownmod	;if value is < the ATTACK_DOWN1_EFFECT value, jump out
	cp EVASION_DOWN2_EFFECT	+ $1
	jr nc, .nostatdownmod	;if value >= EVASION_DOWN2_EFFECT value + $1, jump out
	cp EVASION_DOWN1_EFFECT	+ $1
	jr c, .statdownmod	;if value < EVASION_DOWN1_EFFECT value + $1, there is a stat down move
	cp ATTACK_DOWN2_EFFECT	
	jr nc, .statdownmod	;if value is >= the ATTACK_DOWN2_EFFECT value, there is a stat down move
	jr .nostatdownmod; else the effect is something else in-between the target values
.statdownmod
	sub ATTACK_DOWN1_EFFECT	;normalize the effects from 0 to 5 to get an offset
	cp EVASION_DOWN1_EFFECT + $1 - ATTACK_DOWN1_EFFECT ; covers all -1 effects
	jr c, .statdowncheck
	sub ATTACK_DOWN2_EFFECT - ATTACK_DOWN1_EFFECT ; map -2 effects to corresponding -1 effect
.statdowncheck	
	push hl
	push bc
	ld hl, wPlayerMonStatMods	;load the player's stat mods
	ld c, a
	ld b, $0
	add hl, bc	;use offset to shift to the correct stat mod
	ld b, [hl]
	dec b ; decrement corresponding stat mod
	pop bc
	pop hl
	jr nz, .endstatmod ; if stat mod was > 1 before decrementing, then it's fine to lower
	;else can't be lowered anymore
	jp .heavydiscourage
.nostatdownmod
	;check for stat up effects
	ld a, [wEnemyMoveEffect]	;get the move effect
	cp ATTACK_UP1_EFFECT
	jr c, .endstatmod	;if value is < the ATTACK_UP1_EFFECT value, jump out
	cp EVASION_UP2_EFFECT + $1
	jr nc, .endstatmod	;if value >= EVASION_UP2_EFFECT value + $1, jump out
	cp EVASION_UP1_EFFECT + $1
	jr c, .statupmod	;if value < EVASION_UP1_EFFECT value + $1, there is a stat up move
	cp ATTACK_UP2_EFFECT	
	jr nc, .statupmod	;if value is >= the ATTACK_UP2_EFFECT value, there is a stat up move
	jr .endstatmod; else the effect is something else in-between the target values
.statupmod
	sub ATTACK_UP1_EFFECT	;normalize the effects from 0 to 5 to get an offset
	cp EVASION_UP1_EFFECT + $1 - ATTACK_UP1_EFFECT ; covers all +1 effects
	jr c, .statupcheck
	sub ATTACK_UP2_EFFECT - ATTACK_UP1_EFFECT ; map +2 effects to corresponding +1 effect
.statupcheck	
	push hl
	push bc
	ld hl, wEnemyMonStatMods	;load the enemy's stat mods
	ld c, a
	ld b, $0
	add hl, bc	;use offset to shift to the correct stat mod
	ld b, [hl]
	inc b ; increment corresponding stat mod
	ld a, $0d
	cp b ; can't raise stat past +6 ($0d or 13)
	pop bc
	pop hl
	jr nc, .endstatmod ; if stat mod was < $0d before incrementing, then it's fine to raise
	;else can't be raised anymore
	jp .heavydiscourage
.endstatmod
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;joenote - heavily discourage moves that do not stack
	;check each of the stackabe effects one by one and jump to the corresponding section
	ld a, [wEnemyMoveEffect]
	cp FOCUS_ENERGY_EFFECT
	jr z, .checkfocus
	cp LIGHT_SCREEN_EFFECT
	jr z, .checkscreen
	cp REFLECT_EFFECT
	jr z, .checkreflect
	cp SUBSTITUTE_EFFECT
	jr z, .checksub
	cp MIST_EFFECT
	jr z, .checkmist
	cp LEECH_SEED_EFFECT
	jr z, .checkseed
	jr .endstacking
.checkfocus	;check status, and heavily discourage if bit is set
	ld a, [wEnemyBattleStatus2]
	bit GETTING_PUMPED, a
	jp nz, .heavydiscourage
	jr .endstacking
.checkscreen ;check status, and heavily discourage if bit is set
	ld a, [wEnemyBattleStatus3]
	bit HAS_LIGHT_SCREEN_UP, a
	jp nz, .heavydiscourage
	jr .endstacking
.checkreflect	;check status, and heavily discourage if bit is set
	ld a, [wEnemyBattleStatus3]
	bit HAS_REFLECT_UP, a
	jp nz, .heavydiscourage
	jr .endstacking
.checkmist	;check status, and heavily discourage if bit is set
	ld a, [wEnemyBattleStatus2]
	bit PROTECTED_BY_MIST, a
	jp nz, .heavydiscourage
	jr .endstacking
.checksub	;check status, and heavily discourage if bit is set
	ld a, [wEnemyBattleStatus2]
	bit HAS_SUBSTITUTE_UP, a
	jp nz, .heavydiscourage
	jr .endstacking
.checkseed
	;first check to make sure leech seed isn't used on a grass pokemon
	push bc
	push hl
	ld hl, wBattleMonType
	ld b, [hl]                 ; b = type 1 of player's pokemon
	inc hl
	ld c, [hl]                 ; c = type 2 of player's pokemon
	ld a, b		;load type 1 into a
	cp GRASS	;is type 1 grass?
	jr z, .seedgrasstest	;skip ahead if type1 is grass
	ld a, c		;load type 2 into a
.seedgrasstest
	pop hl
	pop bc
	cp GRASS	;a is either type 1 grass or it is type 2 yet to be confirmed
	jp z, .heavydiscourage	;heavily discourage if either of the types are grass
	;else, not to make sure it isn't already used
	;check status, and heavily discourage if bit is set
	ld a, [wPlayerBattleStatus2]
	bit SEEDED, a
	jp nz, .heavydiscourage
.endstacking
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;joenote - discourage using confuse-only moves on confused pkmn
	ld a, [wEnemyMoveEffect]
	cp CONFUSION_EFFECT	;see if the move has a confusion effect
	jr nz, .notconfuse	;skip out if move is not a zero-power confusion move
	ld a, [wPlayerBattleStatus1]	;load the player pkmn volatile status
	and $80	;check bit 7 for confusion bit
	jp nz, .heavydiscourage	;heavily discourage using zero-power confusion moves on confused pkmn
	jp .nextMove	;if opponent is not confused, then neither encourage or discourage and go to next move
.notconfuse
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ld a, [wEnemyMoveEffect]
	push hl
	push de
	push bc
	ld hl, StatusAilmentMoveEffects
	ld de, $0001
	call IsInArray
	pop bc
	pop de
	pop hl
	jp nc, .nextMove
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;joenote - if player pkmn has no nonvolatile status, then don't encourage/discourage and get next move
	ld a, [wBattleMonStatus]
	and a
	jp z, .nextMove
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.heavydiscourage	;joenote - added marker
	ld a, [hl]
	add $5 ; heavily discourage move
	ld [hl], a
	jp .nextMove

StatusAilmentMoveEffects:
	db $01 ; unused sleep effect
	db SLEEP_EFFECT
	db POISON_EFFECT
	db PARALYZE_EFFECT
	db $FF

SubstituteImmuneEffects:	;joenote - added this table to track for substitute immunities
	db $01 ; unused sleep effect
	db SLEEP_EFFECT
	db POISON_EFFECT
	db PARALYZE_EFFECT
	db CONFUSION_EFFECT
	db ATTACK_DOWN1_EFFECT
	db DEFENSE_DOWN1_EFFECT
	db SPEED_DOWN1_EFFECT
	db SPECIAL_DOWN1_EFFECT
	db ACCURACY_DOWN1_EFFECT
	db EVASION_DOWN1_EFFECT
	db ATTACK_DOWN2_EFFECT
	db DEFENSE_DOWN2_EFFECT
	db SPEED_DOWN2_EFFECT
	db SPECIAL_DOWN2_EFFECT
	db ACCURACY_DOWN2_EFFECT
	db EVASION_DOWN2_EFFECT
	db DRAIN_HP_EFFECT
	db LEECH_SEED_EFFECT
	db DREAM_EATER_EFFECT
	db $FF

MistBlockEffects:	;joenote - added this table to track for things blocked by mist
	db ATTACK_DOWN1_EFFECT
	db DEFENSE_DOWN1_EFFECT
	db SPEED_DOWN1_EFFECT
	db SPECIAL_DOWN1_EFFECT
	db ACCURACY_DOWN1_EFFECT
	db EVASION_DOWN1_EFFECT
	db ATTACK_DOWN2_EFFECT
	db DEFENSE_DOWN2_EFFECT
	db SPEED_DOWN2_EFFECT
	db SPECIAL_DOWN2_EFFECT
	db ACCURACY_DOWN2_EFFECT
	db EVASION_DOWN2_EFFECT
	db $FF
	
; slightly encourage moves with specific effects.
; in particular, stat-modifying moves and other move effects
; that fall in-between
AIMoveChoiceModification2:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;joenote - kick out if no-attack bit is set
	ld a, [wUnusedC000]
	bit 2, a
	ret nz
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ld a, [wAILayer2Encouragement]
	cp $1
	ret nz
	ld hl, wBuffer - 1 ; temp move selection array (-1 byte offset)
	ld de, wEnemyMonMoves ; enemy moves
	ld b, NUM_MOVES + 1
.nextMove
	dec b
	ret z ; processed all 4 moves
	inc hl
	ld a, [de]
	and a
	ret z ; no more moves in move set
	inc de
	call ReadMove
	ld a, [wEnemyMoveEffect]
	cp ATTACK_UP1_EFFECT
	jr c, .nextMove
	cp BIDE_EFFECT
	jr c, .preferMove
	cp ATTACK_UP2_EFFECT
	jr c, .nextMove
	cp POISON_EFFECT
	jr c, .preferMove
	jr .nextMove
.preferMove
	dec [hl] ; slightly encourage this move
	jr .nextMove

; encourages moves that are effective against the player's mon (even if non-damaging).
; discourage damaging moves that are ineffective or not very effective against the player's mon,
; unless there's no damaging move that deals at least neutral damage
AIMoveChoiceModification3:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;joenote - kick out if no-attack bit is set
	ld a, [wUnusedC000]
	bit 2, a
	ret nz
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ld hl, wBuffer - 1 ; temp move selection array (-1 byte offset)
	ld de, wEnemyMonMoves ; enemy moves
	ld b, NUM_MOVES + 1
.nextMove
	dec b
	ret z ; processed all 4 moves
	inc hl
	ld a, [de]
	and a
	ret z ; no more moves in move set
	inc de
	call ReadMove
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
;joenote: fix spamming of buff/debuff moves
	ld a, [wEnemyMovePower]	;get the base power of the enemy's attack
	and a	;check if it is zero
	jr nz, .skipout	;get out of this section if non-zero power
	ld a, [wEnemyMoveNum]
	cp THUNDER_WAVE
	jr z, .skipout ;get out of this section if the move is thunderwave (see if it's useful)
.backfromTwave
	call Random	;else get a random number between 0 and 255
	and $07	;get only bits 0 to 2
	jp z, .givepref	;if zero (12.5% chance) slightly encourage to spice things up
	cp $03	;don't set carry flag if number is >= this value
	jp nc, .notEffectiveMove	;75% chance to slightly discourage and would rather do damage
	jp .nextMove	;else neither encourage nor discourage
.skipout
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	push hl
	push bc
	push de
	;reset type-effectiveness bit before calling function
	ld a, [wUnusedC000]
	res 3, a 
	ld [wUnusedC000], a
	callab AIGetTypeEffectiveness
	pop de
	pop bc
	pop hl
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;joenote - heavily discourage attack moves that have no effect due to typing
	ld a, [wTypeEffectiveness]	;get the effectiveness
	and a 	;check if it's zero
	jr nz, .skipout2	;skip if it's not immune
.heavydiscourage2	;at this line the move has no effect due to immunity or other circumstance
	ld a, [hl]	
	add $5 ; heavily discourage move
	ld [hl], a
	jp .nextMove
.skipout2
	;if thunder wave is being used against a non-immune target, jump back a bit since it's not a damaging move
	ld a, [wEnemyMoveNum]
	cp THUNDER_WAVE
	jp z, .backfromTwave
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;joenote - do not use ohko moves on faster opponents, since they will auto-miss
	ld a, [wEnemyMoveEffect]	;load the move effect
	cp OHKO_EFFECT	;see if it is ohko move
	jr nz, .skipout3	;skip ahead if not ohko move
	push hl
	push bc
	push de
	call StrCmpSpeed	;do a speed compare
	pop de
	pop bc
	pop hl
	jp c, .nextMove	;ai is fast enough so ohko move viable
	;else ai is slower so don't bother
	jp .heavydiscourage2
.skipout3	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;joenote: static damage value moves should not be accounted for typing
;at the same type, randomly bump their preference to spice things up
	ld a, [wEnemyMovePower]	;get the base power of the enemy's attack
	cp $1	;check if it is 1. special damage moves assumed to have 1 base power
	jr nz, .skipout4	;skip down if it's not a special damage move
	call Random	;else get a random number between 0 and 255
	and $3	;get bits 0 to 1
	jp z, .givepref	;if zero (25% chance) slightly encourage
	jp .nextMove	;else neither encourage nor discourage
.skipout4
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ld a, [wTypeEffectiveness]
	cp $0A
	jp z, .nextMove
	jr c, .notEffectiveMove
	;at this line, move is super effective
.givepref	;joenote - added marker
	dec [hl] ; slightly encourage this move
	jp .nextMove
.notEffectiveMove ; discourages non-effective moves if better moves are available 
	push hl
	push de
	push bc
	ld a, [wEnemyMoveType]
	ld d, a
	ld hl, wEnemyMonMoves  ; enemy moves
	ld b, NUM_MOVES + 1
	ld c, $0
.loopMoves
	dec b
	jr z, .done
	ld a, [hli]
	and a
	jr z, .done
	call ReadMove
	ld a, [wEnemyMoveEffect]
	cp SUPER_FANG_EFFECT
	jr z, .betterMoveFound ; Super Fang is considered to be a better move
	cp SPECIAL_DAMAGE_EFFECT
	jr z, .betterMoveFound ; any special damage moves are considered to be better moves
	cp FLY_EFFECT
	jr z, .betterMoveFound ; Fly is considered to be a better move
	ld a, [wEnemyMoveType]
	cp d
	jr z, .loopMoves
	ld a, [wEnemyMovePower]
	and a
	jr nz, .betterMoveFound ; damaging moves of a different type are considered to be better moves
	jr .loopMoves
.betterMoveFound
	ld c, a
.done
	ld a, c
	pop bc
	pop de
	pop hl
	and a
	jp z, .nextMove
	inc [hl] ; slightly discourage this move
	jp .nextMove
	
AIMoveChoiceModification4:	;this unused routine now handles intelligent trainer switching
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;high chance to switch if afflicted with toxic-style poison
	ld a, [wEnemyBattleStatus3]
	bit 0, a	;check a for the toxic bit (sets or clears zero flag)
	jr z, .skipSwitchToxicEnd	;not badly poisoned if zero flag set
	call Random	;put a random number in 'a' between 0 and 255
	and $01	;use only bit 0
	jp z, .setSwitch	;switch if zero
.skipSwitchToxicEnd
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;chance to switch if stuck in a trapping move
	ld a, [wPlayerBattleStatus1]
	bit 5, a	;check a for trapping move bit (sets or clears zero flag)
	jr z, .skipSwitchTrapEnd	;not trapped if zero flag set
	call Random	;put a random number in 'a' between 0 and 255
	and $03	;use only bits 0 to 1 for a random number of 0 to 3
	jp z, .setSwitch	;switch if zero
.skipSwitchTrapEnd
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;chance to switch if afflicted with confusion
	ld a, [wEnemyBattleStatus1]
	bit 7, a	;check a for the confusion bit (sets or clears zero flag)
	jr z, .skipSwitchConfuseEnd	;not confused if zero flag set
	call Random	;put a random number in 'a' between 0 and 255
	and $03	;use only bits 0 to 1 for a random number of 0 to 3
	jp z, .setSwitch	;switch if zero
.skipSwitchConfuseEnd
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;slight chance to switch if afflicted with leech seed
	ld a, [wEnemyBattleStatus2]
	bit 7, a	;check a for the leech seed bit (sets or clears zero flag)
	jr z, .skipSwitchSeedEnd	;not seeded if zero flag set
	call Random	;put a random number in 'a' between 0 and 255
	and $07	;use only bits 0 to 2 for a random number of 0 to 7
	jp z, .setSwitch	;switch if zero
.skipSwitchSeedEnd
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;slight chance to switch if move disabled
	ld a, [wEnemyDisabledMove] ; get disabled move (if any)
	swap a
	and $f
	jr z, .skipSwitchDisableEnd	;no disabled moves if zero flag set
	call Random	;put a random number in 'a' between 0 and 255
	and $07	;use only bits 0 to 2 for a random number of 0 to 7
	jp z, .setSwitch	;if zero flag is set, switch pkmn because 'a' is zero
.skipSwitchDisableEnd
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;chance to switch if stat mods are too low
	push bc
	;use b for storage and a for loading
	ld a, [wEnemyMonAttackMod]	
	ld b, a 
	ld a, [wEnemyMonDefenseMod]
	cp b
	call c, CondLDBA	;if a < b, then load a into b
	ld a, [wEnemyMonSpeedMod]
	cp b
	call c, CondLDBA	;if a < b, then load a into b
	ld a, [wEnemyMonSpecialMod]
	cp b
	call c, CondLDBA	;if a < b, then load a into b
	ld a, [wEnemyMonAccuracyMod]
	cp b
	call c, CondLDBA	;if a < b, then load a into b
	ld a, [wEnemyMonEvasionMod]
	cp b
	call c, CondLDBA	;if a < b, then load a into b
	ld a, b	;but b back into a
	pop bc
	cp $07	;is the lowest stat mod the normal vale of 7?
	jr nc, .skipSwitchModEnd	;lowest stat mod is not negative (value below 7)
	push bc
	ld b, a	;put the lowest mod into b
	ld a, $07	; put 7 into a
	sub b	;a = 7 - b, so a becomes 6 (-6 stages) to 1 (-1 stage)
	ld b, a	;put a back into b
	call Random	;put a random number in 'a' between 0 and 255
	and $07	;use only bits 0 to 2 for a random number of 0 to 7
	cp b
	pop bc
	jp c, .setSwitch	;switch if random number < mod 1 (-1 stage) to 6 (-6 stages)
.skipSwitchModEnd
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;do not switch if this pkmn has been switched out before (trapping moves & other stuff prioritized above this)
	callba CheckAISwitched
	jp nz, .skipSwitchEnd
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;switch if HP is low. lower HP has higher chance of switching
	ld a, 3	;
	call AICheckIfHPBelowFraction
	jr nc, .skipSwitchHPend	;if hp not below 1/3 then skip to the end of this block
	call Random	;put a random number in 'a' between 0 and 255
	and $03	;use only bits 0 & 1 for a random number of 0 to 3
	jp z, .setSwitch	;if zero flag is set, switch pkmn because 'a' is zero
.skipSwitchHPend
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;switch if supereffective move is being used against enemy
	ld a, [wPlayerMovePower]	;get the power of the player's move
	cp $2	;regular damaging moves have power > 1
	jr c, .skipSwitchEffectiveEnd	;skip out if the move is not a normal damaging move
	push hl
	push bc
	push de
	;set type-effectiveness bit before calling function
	ld a, [wUnusedC000]
	set 3, a 
	ld [wUnusedC000], a
	callab AIGetTypeEffectiveness
	pop de
	pop bc
	pop hl
	ld a, [wTypeEffectiveness]	;get the multiplier effectiveness for the player's move
	cp $14	;is it < 20?
	jr c, .skipSwitchEffectiveEnd	;if so, skip to end of this block
	push bc
	ld a, [wPlayerMovePower]	;get the power of the player's move into a
	ld b, a	;put a into b
	call Random	;put a random number in 'a' 
	and $FF	;use only bits 0 to 7
	cp b; see if a < b and set carry if true
	pop bc
	jp c, .setSwitch	;if carry flag is set, switch pkmn
.skipSwitchEffectiveEnd
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;chance to switch if afflicted with non-volatile status
	ld a, [wEnemyMonStatus]
	and a	;check for any non-volatile status
	jr z, .skipSwitchNVstatEnd	;no NV status if zero flag set
	call Random	;put a random number in 'a' between 0 and 255
	and $03	;use only bits 0 to 1 for a random number of 0 to 3
	jp z, .setSwitch	;switch if zero
.skipSwitchNVstatEnd
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	jr .skipSwitchEnd	;jump to the end and get out of this line is reached.
.setSwitch	;this line will only be reached if a switch is confirmed.
	call SetSwitchBit
.skipSwitchEnd
	ret

;joenote - function for loading A into B so it can be called conditionally
CondLDBA:
	ld b, a
	ret
	
ReadMove:
	push hl
	push de
	push bc
	dec a
	ld hl, Moves
	ld bc, MoveEnd - Moves
	call AddNTimes
	ld de, wEnemyMoveNum
	call CopyData
	pop bc
	pop de
	pop hl
	ret

; move choice modification methods that are applied for each trainer class
; 0 is sentinel value
;1 - Do not use a move that only statuses (e.g., Thunder Wave) if the player's Pokémon already has a status.
;2 - On the second turn only the Pokémon is out, prefer a move that heals/buffs/debuffs
;3 - Try to do type-matching when selecting attacks
;4 - switch if active pkmn is in trouble
TrainerClassMoveChoiceModifications:
	db 0      ; YOUNGSTER
	db 1,0    ; BUG CATCHER
	db 1,3,4,0    ; LASS
	db 1,3,0  ; SAILOR
	db 1,3,4,0    ; JR_TRAINER_M
	db 1,3,4,0    ; JR_TRAINER_F
	db 1,2,3,4,0; POKEMANIAC
	db 1,2,3,4,0  ; SUPER_NERD
	db 1,3,4,0    ; HIKER
	db 1,0    ; BIKER
	db 1,3,0  ; BURGLAR
	db 1,3,4,0    ; ENGINEER
	db 1,2,0  ; JUGGLER_X
	db 1,3,0  ; FISHER
	db 1,3,0  ; SWIMMER
	db 0      ; CUE_BALL
	db 1,0    ; GAMBLER
	db 1,3,4,0  ; BEAUTY
	db 1,2,4,0  ; PSYCHIC_TR
	db 1,3,4,0  ; ROCKER
	db 1,0    ; JUGGLER
	db 1,4,0    ; TAMER
	db 1,4,0    ; BIRD_KEEPER
	db 1,0    ; BLACKBELT
	db 1,0    ; SONY1
	db 1,3,4,0  ; PROF_OAK
	db 1,2,3,4,0  ; CHIEF
	db 1,2,0  ; SCIENTIST
	db 1,3,4,0  ; GIOVANNI
	db 1,0    ; ROCKET
	db 1,3,4,0  ; COOLTRAINER_M
	db 1,3,4,0  ; COOLTRAINER_F
	db 1,3,4,0    ; BRUNO
	db 1,3,4,0    ; BROCK
	db 1,3,4,0  ; MISTY
	db 1,3,4,0  ; LT_SURGE
	db 1,3,4,0  ; ERIKA
	db 1,3,4,0  ; KOGA
	db 1,3,4,0  ; BLAINE
	db 1,3,4,0  ; SABRINA
	db 1,2,3,4,0  ; GENTLEMAN
	db 1,3,4,0  ; SONY2
	db 1,3,4,0  ; SONY3
	db 1,2,3,4,0; LORELEI
	db 1,0    ; CHANNELER
	db 1,3,4,0    ; AGATHA
	db 1,3,4,0  ; LANCE

INCLUDE "engine/battle/trainer_pic_money_pointers.asm"

INCLUDE "text/trainer_names.asm"

INCLUDE "engine/battle/bank_e_misc.asm"

;joenote - moving all this to bank $2D to free up space for trainer AI in bank $E
;		- This only gets called from a bank switch in core.asm anyway
;INCLUDE "engine/battle/read_trainer_party.asm"

;INCLUDE "data/trainer_moves.asm"

;INCLUDE "data/trainer_parties.asm"

TrainerAI:
	and a
	ld a, [wIsInBattle]
	dec a
	ret z ; if not a trainer, we're done here
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	ret z
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;joenote - switch if the switch bit is set	
	call CheckandResetSwitchBit
	jp nz, AISwitchIfEnoughMons	;switch if bit was initially set
	;jp AISwitchIfEnoughMons	;joedebug - use this to make trainer ai constantly switch
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
	ld a, [wTrainerClass] ; what trainer class is this?
	dec a
	ld c, a
	ld b, 0
	ld hl, TrainerAIPointers
	add hl, bc
	add hl, bc
	add hl, bc
	ld a, [wAICount]
	and a
	ret z ; if no AI uses left, we're done here
	inc hl
	inc a
	jr nz, .getpointer
	dec hl
	ld a, [hli]
	ld [wAICount], a
.getpointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call Random
	jp hl

TrainerAIPointers:
; one entry per trainer class
; first byte, number of times (per Pokémon) it can occur
; next two bytes, pointer to AI subroutine for trainer class
	dbw 3,GenericAI
	dbw 3,GenericAI
	dbw 3,GenericAI
	dbw 3,GenericAI
	dbw 3,GenericAI
	dbw 3,GenericAI
	dbw 3,GenericAI
	dbw 3,GenericAI
	dbw 3,GenericAI
	dbw 3,GenericAI
	dbw 3,GenericAI
	dbw 3,GenericAI
	dbw 3,JugglerAI ; juggler_x
	dbw 3,GenericAI
	dbw 3,GenericAI
	dbw 3,GenericAI
	dbw 3,GenericAI
	dbw 3,GenericAI
	dbw 3,GenericAI
	dbw 3,GenericAI
	dbw 3,JugglerAI ; juggler
	dbw 3,GenericAI
	dbw 3,GenericAI
	dbw 1,BlackbeltAI ; blackbelt
	dbw 3,GenericAI
	dbw 3,GenericAI
	dbw 1,GenericAI ; chief
	dbw 3,GenericAI
	dbw 1,GiovanniAI ; giovanni
	dbw 3,GenericAI
	dbw 2,CooltrainerMAI ; cooltrainerm
	dbw 2,CooltrainerFAI ; cooltrainerf
	dbw 2,BrunoAI ; bruno
	dbw 5,BrockAI ; brock
	dbw 1,MistyAI ; misty
	dbw 1,LtSurgeAI ; surge
	dbw 1,ErikaAI ; erika
	dbw 2,KogaAI ; koga
	dbw 1,BlaineAI ; blaine
	dbw 1,SabrinaAI ; sabrina
	dbw 3,GenericAI
	dbw 1,Sony2AI ; sony2
	dbw 1,Sony3AI ; sony3
	dbw 2,LoreleiAI ; lorelei
	dbw 3,GenericAI
	dbw 2,AgathaAI ; agatha
	dbw 1,LanceAI ; lance

;joenote - reorganizing these AI routines to jump on carry instead of returning on not-carry
;also adding recognition of a switch-pkmn bit

JugglerAI:
	cp $40
	jp c, AISwitchIfEnoughMons
	ret
	
BlackbeltAI:
	cp $20
	jp c, AIUseXAttack	
	ret
	
GiovanniAI:
	cp $20 
	jp c, AIUseDireHit
	cp $40
	jp c, AIUseGuardSpec
	ret

CooltrainerMAI:	;joenote - changed item to x-special and added switching
	cp $40
	jp c, AIUseXSpecial
	ld a, 5
	call AICheckIfHPBelowFraction
	jp c, AISwitchIfEnoughMons
	ret
	
CooltrainerFAI:
	cp $40
	jp c, AIUseXAccuracy	;uses x accuracy now
	ld a, 5
	call AICheckIfHPBelowFraction
	jp c, AISwitchIfEnoughMons
	ret
	
BrockAI:
; if his active monster has a status condition, use a full heal
	ld a, [wEnemyMonStatus]
	and a
	jp nz, AIUseFullHeal
	ret 

MistyAI:
	cp $40
	jp c, AIUseXDefend
	ret
	
LtSurgeAI:
	cp $40
	jp c, AIUseXSpeed
	ret
	
ErikaAI:
	cp $80
	jr nc, .erikareturn
	ld a, $A
	call AICheckIfHPBelowFraction
	jp c, AIUseSuperPotion
.erikareturn
	ret

KogaAI:
	cp $40
	jp c, AIUseXAttack
	ret
	
BlaineAI:	;blaine needs to check HP. this was an oversight	
	cp $40
	jr nc, .blainereturn
	ld a, $A
	call AICheckIfHPBelowFraction	
	jp c, AIUseHyperPotion	;joenote - changed to hyper potion
.blainereturn
	ret

SabrinaAI:
	cp $40
	jr nc, .sabrinareturn
	ld a, $A
	call AICheckIfHPBelowFraction
	jp c, AIUseHyperPotion
.sabrinareturn
	ret

Sony2AI:
	cp $20
	jr nc, .rival2return
	ld a, 5
	call AICheckIfHPBelowFraction
	jp c, AIUsePotion
.rival2return
	ret

Sony3AI:
	cp $20
	jr nc, .rival3return
	ld a, 5
	call AICheckIfHPBelowFraction
	jp c, AIUseFullRestore
.rival3return
	ret

LoreleiAI:
	cp $80
	jr nc, .loreleireturn
	ld a, 5
	call AICheckIfHPBelowFraction
	jp c, AIUseSuperPotion
.loreleireturn
	ret

BrunoAI:
	cp $40
	jp c, AIUseXDefend
	ret

AgathaAI:
	cp $14
	jp c, AISwitchIfEnoughMons
	cp $80
	jr nc, .agathareturn
	ld a, 4
	call AICheckIfHPBelowFraction
	jp c, AIUseSuperPotion
.agathareturn
	ret

LanceAI:
	cp $80
	jr nc, .lancereturn
	ld a, 5
	call AICheckIfHPBelowFraction
	jp c, AIUseHyperPotion
.lancereturn
	ret

GenericAI:
	and a ; clear carry
	ret

; end of individual trainer AI routines

;joenote - added these functions to check if the ai switching bit is set
;need to have 'a' accumulator and flag register freed up to use this function
CheckandResetSwitchBit:	
	ld a, [wUnusedC000]
	bit 0, a	;check a for switch pkmn bit (sets or clears zero flag)
	res 0, a ; resets the switch pkmn bit (does not affect flags)
	ld [wUnusedC000], a
	ret
SetSwitchBit:	
	ld a, [wUnusedC000]
	set 0, a ; sets the switch pkmn bit
	ld [wUnusedC000], a
	ret

DecrementAICount:
	ld hl, wAICount
	dec [hl]
	scf
	ret

AIPlayRestoringSFX:
	ld a, SFX_HEAL_AILMENT
	jp PlaySoundWaitForCurrent

AIUseFullRestore:
	call AICureStatus
	ld a, FULL_RESTORE
	ld [wAIItem], a
	ld de, wHPBarOldHP
	ld hl, wEnemyMonHP + 1
	ld a, [hld]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	inc de
	ld hl, wEnemyMonMaxHP + 1
	ld a, [hld]
	ld [de], a
	inc de
	ld [wHPBarMaxHP], a
	ld [wEnemyMonHP + 1], a
	ld a, [hl]
	ld [de], a
	ld [wHPBarMaxHP+1], a
	ld [wEnemyMonHP], a
	jr AIPrintItemUseAndUpdateHPBar

AIUsePotion:
; enemy trainer heals his monster with a potion
	ld a, POTION
	ld b, 20
	jr AIRecoverHP

AIUseSuperPotion:
; enemy trainer heals his monster with a super potion
	ld a, SUPER_POTION
	ld b, 50
	jr AIRecoverHP

AIUseHyperPotion:
; enemy trainer heals his monster with a hyper potion
	ld a, HYPER_POTION
	ld b, 200
	; fallthrough

AIRecoverHP:
; heal b HP and print "trainer used $(a) on pokemon!"
	ld [wAIItem], a
	ld hl, wEnemyMonHP + 1
	ld a, [hl]
	ld [wHPBarOldHP], a
	add b
	ld [hld], a
	ld [wHPBarNewHP], a
	ld a, [hl]
	ld [wHPBarOldHP+1], a
	ld [wHPBarNewHP+1], a
	jr nc, .next
	inc a
	ld [hl], a
	ld [wHPBarNewHP+1], a
.next
	inc hl
	ld a, [hld]
	ld b, a
	ld de, wEnemyMonMaxHP + 1
	ld a, [de]
	dec de
	ld [wHPBarMaxHP], a
	sub b
	ld a, [hli]
	ld b, a
	ld a, [de]
	ld [wHPBarMaxHP+1], a
	sbc b
	jr nc, AIPrintItemUseAndUpdateHPBar
	inc de
	ld a, [de]
	dec de
	ld [hld], a
	ld [wHPBarNewHP], a
	ld a, [de]
	ld [hl], a
	ld [wHPBarNewHP+1], a
	; fallthrough

AIPrintItemUseAndUpdateHPBar:
	call AIPrintItemUse_
	coord hl, 2, 2
	xor a
	ld [wHPBarType], a
	predef UpdateHPBar2
	jp DecrementAICount

AISwitchIfEnoughMons:
; enemy trainer switches if there are 2 or more unfainted mons in party
	ld a, [wEnemyPartyCount]
	ld c, a
	ld hl, wEnemyMon1HP

	ld d, 0 ; keep count of unfainted monsters

	; count how many monsters haven't fainted yet
.loop
	ld a, [hli]
	ld b, a
	ld a, [hld]
	or b
	jr z, .Fainted ; has monster fainted?
	inc d
.Fainted
	push bc
	ld bc, wEnemyMon2 - wEnemyMon1
	add hl, bc
	pop bc
	dec c
	jr nz, .loop

	ld a, d ; how many available monsters are there?
	cp 2 ; don't bother if only 1
	jp nc, SwitchEnemyMon
	and a
	ret

SwitchEnemyMon:
	callba DoEnemyShinybit ;joenote - reset shiny checker bits
;joenote - if player using trapping move, then end their move
	ld a, [wPlayerBattleStatus1]
	bit USING_TRAPPING_MOVE, a
	jr z, .preparewithdraw
	ld hl, wPlayerBattleStatus1
	res USING_TRAPPING_MOVE, [hl] 
	xor a
	ld [wPlayerNumAttacksLeft], a
	ld a, $FF
	ld [wPlayerSelectedMove], a
.preparewithdraw
	callba SetAISwitched ;joenote - track the pkmn as being switched out
; prepare to withdraw the active monster: copy hp, number, and status to roster

	ld a, [wEnemyMonPartyPos]
	ld hl, wEnemyMon1HP
	ld bc, wEnemyMon2 - wEnemyMon1
	call AddNTimes
	ld d, h
	ld e, l
	ld hl, wEnemyMonHP
	ld bc, 4
	call CopyData

	ld hl, AIBattleWithdrawText
	call PrintText

	; This wFirstMonsNotOutYet variable is abused to prevent the player from
	; switching in a new mon in response to this switch.
	ld a, 1
	ld [wFirstMonsNotOutYet], a
	callab EnemySendOut
	xor a
	ld [wFirstMonsNotOutYet], a
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	ret z
	scf
	ret

AIBattleWithdrawText:
	TX_FAR _AIBattleWithdrawText
	db "@"

AIUseFullHeal:
	call AIPlayRestoringSFX
	call AICureStatus
	ld a, FULL_HEAL
	jp AIPrintItemUse

AICureStatus:
; cures the status of enemy's active pokemon
	ld a, [wEnemyMonPartyPos]
	ld hl, wEnemyMon1Status
	ld bc, wEnemyMon2 - wEnemyMon1
	call AddNTimes
	xor a
	ld [hl], a ; clear status in enemy team roster
	ld [wEnemyMonStatus], a ; clear status of active enemy
	ld hl, wEnemyBattleStatus3
	res 0, [hl]
	ret

AIUseXAccuracy: 
	call AIPlayRestoringSFX
	ld hl, wEnemyBattleStatus2
	set 0, [hl]
	ld a, X_ACCURACY
	jp AIPrintItemUse

AIUseGuardSpec:
	call AIPlayRestoringSFX
	ld hl, wEnemyBattleStatus2
	set 1, [hl]
	ld a, GUARD_SPEC
	jp AIPrintItemUse

AIUseDireHit: 
	call AIPlayRestoringSFX
	ld hl, wEnemyBattleStatus2
	set 2, [hl]
	ld a, DIRE_HIT
	jp AIPrintItemUse

AICheckIfHPBelowFraction:
; return carry if enemy trainer's current HP is below 1 / a of the maximum
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;joenote - handle an 'a' value of 1
	cp 1
	jr nz, .not_one
	push bc
	ld a, [wEnemyMonMaxHP]
	ld b, a
	ld a, [wEnemyMonHP]
	cp b	;a = HP MSB an b = MAXHP MSB so do a - b and set carry if negative
	pop bc
	ret c
	push bc
	ld a, [wEnemyMonMaxHP + 1]
	ld b, a
	ld a, [wEnemyMonHP + 1]
	cp b	;a = HP LSB an b = MAXHP LSB so do a - b and set carry if negative
	pop bc
	ret
.not_one
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	push hl	;joenote - added this
	ld [H_DIVISOR], a
	ld hl, wEnemyMonMaxHP
	ld a, [hli]
	ld [H_DIVIDEND], a
	ld a, [hl]
	ld [H_DIVIDEND + 1], a
	ld b, 2
	call Divide
	ld a, [H_QUOTIENT + 3]
	ld c, a
	ld a, [H_QUOTIENT + 2]
	ld b, a
	ld hl, wEnemyMonHP + 1
	ld a, [hld]
	ld e, a
	ld a, [hl]
	pop hl	;joenote - added this
	ld d, a
	ld a, d
	sub b
	ret nz
	ld a, e
	sub c
	ret

AIUseXAttack:
	ld b, $A
	ld a, X_ATTACK
	jr AIIncreaseStat

AIUseXDefend:
	ld b, $B
	ld a, X_DEFEND
	jr AIIncreaseStat

AIUseXSpeed:
	ld b, $C
	ld a, X_SPEED
	jr AIIncreaseStat

AIUseXSpecial:
	ld b, $D
	ld a, X_SPECIAL
	; fallthrough

AIIncreaseStat:
	ld [wAIItem], a
	push bc
	call AIPrintItemUse_
	pop bc
	ld hl, wEnemyMoveEffect
	ld a, [hld]
	push af
	ld a, [hl]
	push af
	push hl
	ld a, ANIM_AF
	ld [hli], a
	ld [hl], b
	callab StatModifierUpEffect
	pop hl
	pop af
	ld [hli], a
	pop af
	ld [hl], a
	jp DecrementAICount

AIPrintItemUse:
	ld [wAIItem], a
	call AIPrintItemUse_
	jp DecrementAICount

AIPrintItemUse_:
; print "x used [wAIItem] on z!"
	ld a, [wAIItem]
	ld [wd11e], a
	call GetItemName
	ld hl, AIBattleUseItemText
	jp PrintText

AIBattleUseItemText:
	TX_FAR _AIBattleUseItemText
	db "@"

StrCmpSpeed:	;joenote - function for AI to compare pkmn speeds
	ld de, wBattleMonSpeed ; player speed value
	ld hl, wEnemyMonSpeed ; enemy speed value
	ld c, $2	;bytes to copy
.spdcmploop	
	ld a, [de]	
	cp [hl]
	ret nz
	inc de
	inc hl
	dec c
	jr nz, .spdcmploop
	;At this point:
	;zero flag set means speeds equal
	;carry flag not set means player pkmn faster
	;carry flag set means ai pkmn faster
	ret
