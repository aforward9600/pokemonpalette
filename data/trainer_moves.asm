

;joenote - commenting this all out because yellow's method is now being used
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;LoneMoves:
;; these are used for gym leaders.
;; this is not automatic! you have to write the number you want to wLoneAttackNo
;; first. e.g., erika's script writes 4 to wLoneAttackNo to get mega drain,
;; the fourth entry in the list.
;
;; first byte:  pokemon in the trainer's party that gets the move
;; second byte: move
;; unterminated
;	db 1,BIDE
;	db 1,BUBBLEBEAM
;	db 2,THUNDERBOLT
;	db 2,MEGA_DRAIN
;	db 3,TOXIC
;	db 3,PSYWAVE
;	db 3,FIRE_BLAST
;	db 4,FISSURE
;
;TeamMoves:
;; these are used for elite four.
;; this is automatic, based on trainer class.
;; don't be confused by LoneMoves above, the two data structures are
;	; _completely_ unrelated.
;
;; first byte: trainer (all trainers in this class have this move)
;; second byte: move
;; ff-terminated
;	db LORELEI,BLIZZARD
;	db BRUNO,FISSURE
;	db AGATHA,TOXIC
;	db LANCE,BARRIER
;	db $FF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; yellow has its own format.

; entry = trainerclass, trainerid, moveset+, 0
; moveset = partymon location, partymon's move, moveid
SpecialTrainerMoves:
	db BUG_CATCHER,$2
	db 2,2,POISON_STING
	db 2,3,STRING_SHOT
	db 0

	db BUG_CATCHER,$5
	db 2,2,POISON_STING
	db 2,3,STRING_SHOT
	db 4,2,TACKLE
	db 4,3,STRING_SHOT
	db 0

	db BUG_CATCHER,$6
	db 1,2,TACKLE
	db 1,3,STRING_SHOT
	db 0

	db BUG_CATCHER,$7
	db 2,2,POISON_STING
	db 2,3,STRING_SHOT
	db 0

	db BUG_CATCHER,$8
	db 2,2,TACKLE
	db 2,3,STRING_SHOT
	db 0

	db BUG_CATCHER,$9
	db 1,2,TACKLE
	db 1,3,STRING_SHOT
	db 2,2,POISON_STING
	db 2,3,STRING_SHOT
	db 0

	db BUG_CATCHER,$11
	db 2,1,CONFUSION
	db 0

	db BUG_CATCHER,$12
	db 1,1,CONFUSION
	db 0

	db BUG_CATCHER,$13
	db 1,1,CONFUSION
	db 0

	db BROCK,$1
	db 1,2,THUNDER_WAVE
	db 2,3,ROCK_THROW
	db 0
	
	db MISTY,$1
	db 2,3,BUBBLEBEAM
	db 0
	
	db LT_SURGE,$1
	db 1,4,POISON_STING
	db 2,2,WATER_GUN
	db 3,4,THUNDERBOLT
	db 0
	
	db ERIKA,$1
	db 1,4,THUNDERBOLT
	db 2,1,BODY_SLAM
	db 3,3,MEGA_DRAIN
	db 0
	
	db KOGA,$1
	db 1,1,BODY_SLAM
	db 1,2,SING
	db 1,3,PSYCHIC_M
	db 1,4,THUNDERBOLT
	db 2,1,REFLECT
	db 2,2,THUNDERBOLT
	db 3,1,SURF
	db 3,2,PSYCHIC_M
	db 3,3,ICE_BEAM
	db 3,4,THUNDER_WAVE
	db 4,1,REFLECT
	db 4,2,ICE_BEAM
	db 4,3,TOXIC
	db 0
	
	db SABRINA,$1
	db 1,2,SAND_ATTACK
	db 1,4,ROCK_SLIDE
	db 2,1,HYPNOSIS
	db 2,4,DREAM_EATER
	db 3,1,HYPNOSIS
	db 3,3,DREAM_EATER
	db 4,1,SEISMIC_TOSS
	db 0
	
	db BLAINE,$1
	db 1,4,THUNDER
	db 3,1,LOVELY_KISS
	db 3,2,PSYCHIC_M
	db 4,1,PSYCHIC_M
	db 4,2,FIRE_BLAST
	db 0
	
	db GIOVANNI,$3
	db 2,4,EARTHQUAKE
	db 3,1,BODY_SLAM
	db 3,2,LEECH_SEED
	db 4,1,LEECH_SEED
	db 4,2,PSYCHIC_M
	db 4,3,SOLARBEAM
	db 4,4,STUN_SPORE
	db 5,1,BLIZZARD
	db 5,2,EARTHQUAKE
	db 5,3,FISSURE
	db 0
	
	db LORELEI,$1
	db 1,1,THUNDERBOLT
	db 1,2,HYPER_BEAM
	db 1,3,BUBBLEBEAM
	db 2,1,KARATE_CHOP
	db 2,2,ROCK_SLIDE
	db 2,3,EARTHQUAKE
	db 2,4,MEGA_PUNCH
	db 3,3,SURF
	db 3,4,EARTHQUAKE
	db 4,2,BLIZZARD
	db 4,3,REST
	db 4,4,BODY_SLAM
	db 5,1,SURF
	db 5,3,BODY_SLAM
	db 0

	db BRUNO,$1
	db 1,1,SWORDS_DANCE
	db 1,2,LEECH_LIFE
	db 1,3,ROCK_SLIDE
	db 2,2,HYPER_BEAM
	db 3,1,EARTHQUAKE
	db 4,1,SUBMISSION
	db 4,2,PIN_MISSILE
	db 5,1,MEDITATE
	db 5,2,ROCK_SLIDE
	db 5,4,EARTHQUAKE
	db 0

	db AGATHA,$1
	db 1,1,SURF
	db 1,2,BLIZZARD
	db 1,3,EXPLOSION
	db 1,4,DOUBLE_EDGE
	db 2,1,FIRE_BLAST
	db 2,3,SLUDGE
	db 3,1,PSYCHIC_M
	db 3,2,HYDRO_PUMP
	db 3,3,RECOVER
	db 3,4,BLIZZARD
	db 4,2,MINIMIZE
	db 4,3,DIG
	db 5,1,THUNDERBOLT
	db 0

	db LANCE,$1
	db 1,1,DIG
	db 1,2,HYPER_BEAM
	db 1,3,QUICK_ATTACK
	db 2,1,EARTHQUAKE
	db 2,3,FIRE_BLAST
	db 2,4,SLASH
	db 3,1,FIRE_BLAST
	db 3,2,DIG
	db 3,3,HYPER_BEAM
	db 3,4,AGILITY
	db 4,1,SWORDS_DANCE
	db 4,2,DIG
	db 4,4,HYPER_BEAM
	db 5,1,THUNDER_WAVE
	db 5,2,WRAP
	db 5,3,EARTHQUAKE
	db 0

	db SONY2,$10
	db 3,1,ROCK_SLIDE
	db 4,1,MEGA_DRAIN
	db 6,1,SURF
	db 6,3,BLIZZARD
	db 0

	db SONY2,$11
	db 3,1,ROCK_SLIDE
	db 4,1,BODY_SLAM
	db 4,3,ICE_BEAM
	db 4,4,SURF
	db 6,1,MEGA_DRAIN
	db 6,2,LEECH_SEED
	db 0

	db SONY2,$12
	db 3,1,MEGA_DRAIN
	db 4,1,BODY_SLAM
	db 4,3,ICE_BEAM
	db 4,4,SURF
	db 6,3,FIRE_BLAST
	db 0

	db SONY3,$1
	db 1,3,SKY_ATTACK
	db 6,3,BLIZZARD
	db 0

	db SONY3,$2
	db 1,3,SKY_ATTACK
	db 6,3,MEGA_DRAIN
	db 0

	db SONY3,$3
	db 1,3,SKY_ATTACK
	db 6,3,FIRE_BLAST
	db 0


	
	db $ff