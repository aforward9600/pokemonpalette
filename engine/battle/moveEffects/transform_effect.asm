TransformEffect_:
	ld hl, wBattleMonSpecies
	ld de, wEnemyMonSpecies
	ld bc, wEnemyBattleStatus3
	ld a, [wEnemyBattleStatus1]
	ld a, [H_WHOSETURN]
	and a
	jr nz, .hitTest
	ld hl, wEnemyMonSpecies
	ld de, wBattleMonSpecies
	ld bc, wPlayerBattleStatus3
	ld [wPlayerMoveListIndex], a
	ld a, [wPlayerBattleStatus1]
.hitTest
	bit INVULNERABLE, a ; is mon invulnerable to typical attacks? (fly/dig)
	jp nz, .failed
	push hl
	push de
	push bc
	ld hl, wPlayerBattleStatus2
	ld a, [H_WHOSETURN]
	and a
	jr z, .transformEffect
	ld hl, wEnemyBattleStatus2
.transformEffect
; animation(s) played are different if target has Substitute up
	bit HAS_SUBSTITUTE_UP, [hl]
	push af
	ld hl, HideSubstituteShowMonAnim
	ld b, BANK(HideSubstituteShowMonAnim)
	call nz, Bankswitch
	ld a, [wOptions]
	add a
	ld hl, PlayCurrentMoveAnimation
	ld b, BANK(PlayCurrentMoveAnimation)
	jr nc, .gotAnimToPlay
	ld hl, AnimationTransformMon
	ld b, BANK(AnimationTransformMon)
.gotAnimToPlay
	call Bankswitch
	ld hl, ReshowSubstituteAnim
	ld b, BANK(ReshowSubstituteAnim)
	pop af
	call nz, Bankswitch
	pop bc
	ld a, [bc]
	set TRANSFORMED, a ; mon is now transformed
	ld [bc], a
	pop de
	pop hl
	push hl
; transform user into opposing Pokemon
; species
	ld a, [hl]
	ld [de], a
; type 1, type 2, catch rate, and moves
	ld bc, $5
	add hl, bc
	inc de	;point to hp low byte
	inc de	;point to hp high byte
	inc de	;point to party position
	inc de	;point to status
	inc de	;point to type 1
	inc bc
	inc bc
	;call CopyData
	call CopyDataTransform	;joenote - want to do a special copy that doesn't copy the transform move and replaces it
	;de is now pointing to DVs
	ld a, [H_WHOSETURN]
	and a
	jr z, .next
; save enemy mon DVs at wTransformedEnemyMonOriginalDVs
; joenote - there is a bug here. It assumes the enemy mon is not transformed already.
; If the enemy has already transformed once before, then the DVs for that form 
; end up getting written to wTransformedEnemyMonOriginalDVs.
; This causes the true original untransformed DVs to be overwritten with the DVs of 
; the prior form. Further transformations will continue to overwrite this with the DVs
; of the last form  utilized.
; Therefore, a check is needed to skip this if the enemy is already transformed.
	ld a, [wEnemyBattleStatus3]
	bit 3, a 	;check the state of the enemy transformed bit
	jr nz, .next	;skip ahead if bit is set
	ld a, [de]
	ld [wTransformedEnemyMonOriginalDVs], a
	inc de
	ld a, [de]
	ld [wTransformedEnemyMonOriginalDVs + 1], a
	dec de
.next
; DVs
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
; Attack, Defense, Speed, and Special stats
	inc hl
	inc hl
	inc hl
	inc de
	inc de
	inc de
	ld bc, $8
	call CopyData
	ld bc, wBattleMonMoves - wBattleMonPP
	add hl, bc ; ld hl, wBattleMonMoves
	ld b, NUM_MOVES
.copyPPLoop
; 5 PP for all moves
	ld a, [hli]
	and a
	jr z, .lessThanFourMoves
	ld a, $5
	ld [de], a
	inc de
	dec b
	jr nz, .copyPPLoop
	jr .copyStats
.lessThanFourMoves
; 0 PP for blank moves
	xor a
	ld [de], a
	inc de
	dec b
	jr nz, .lessThanFourMoves
.copyStats
; original (unmodified) stats and stat mods
	pop hl
	ld a, [hl]
	ld [wd11e], a
	call GetMonName
	ld hl, wEnemyMonUnmodifiedAttack
	ld de, wPlayerMonUnmodifiedAttack
	call .copyBasedOnTurn ; original (unmodified) stats
	ld hl, wEnemyMonStatMods
	ld de, wPlayerMonStatMods
	call .copyBasedOnTurn ; stat mods
	ld hl, TransformedText
	jp PrintText

.copyBasedOnTurn
	ld a, [H_WHOSETURN]
	and a
	jr z, .gotStatsOrModsToCopy
	push hl
	ld h, d
	ld l, e
	pop de
.gotStatsOrModsToCopy
	ld bc, $8
	jp CopyData

.failed
	ld hl, PrintButItFailedText_
	jp BankswitchEtoF

TransformedText:
	TX_FAR _TransformedText
	db "@"

;joenote - custom-edited function just for copying transform moves.
;Insted of copying the move Transform, it will replace it with Struggle.
;This prevents endless battles between two pokemon with Transform
CopyDataTransform:
; Copy bc bytes from hl to de.
	ld a, c	;load counter into a
	cp $5 ;is a < 5? set carry if true
	ld a, [hli] ;load current byte into a. increment to next byte
	jr nc, .notatrans	;skip down if carry not set
	cp TRANSFORM	;is the current byte the transform move?
	jr nz, .notatrans	; if not, then skip down
	ld a, STRUGGLE	;if transform move, replace it with Struggle
.notatrans
	ld [de], a	;load a into de
	inc de	;increment de to next byte
	dec bc	;decrement the counter
	ld a, c
	or b	;is counter zero?
	jr nz, CopyDataTransform
	ret	