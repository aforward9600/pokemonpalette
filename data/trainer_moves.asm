

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
	db BROCK,$1
	db 2,4,BIDE
	db 0
	
	db MISTY,$1
	db 2,3,HARDEN
	db 2,4,BUBBLEBEAM
	db 0
	
	db LT_SURGE,$1
	db 3,1,THUNDERBOLT
	db 0
	
	db ERIKA,$1
	db 2,1,GROWTH
	db 2,2,SLEEP_POWDER
	db 2,3,WRAP
	db 2,4,RAZOR_LEAF
	db 3,1,POISONPOWDER
	db 3,2,MEGA_DRAIN
	db 3,3,SLEEP_POWDER
	db 3,4,PETAL_DANCE
	db 0
	
	db KOGA,$1
	db 1,1,EXPLOSION
	db 3,1,SUBSTITUTE
	db 4,1,TOXIC
	db 4,4,MIMIC
	db 0
	
	db SABRINA,$1
	db 1,1,REFLECT
	db 2,4,MEGA_PUNCH
	db 3,1,SUPERSONIC
	db 4,1,PSYWAVE
	db 0
	
	db BLAINE,$1
	db 1,1,SWIFT
	db 2,1,STRENGTH
	db 3,3,TAKE_DOWN
	db 4,2,AGILITY
	db 4,3,FIRE_BLAST
	db 0
	
	db GIOVANNI,$3
	db 2,1,FISSURE
	db 3,1,EARTHQUAKE
	db 3,3,THUNDER
	db 4,1,EARTHQUAKE
	db 4,3,ICE_BEAM
	db 5,1,ROCK_SLIDE
	db 5,4,EARTHQUAKE
	db 0
	
	db LORELEI,$1
	db 1,1,BUBBLEBEAM
	db 2,3,ICE_BEAM
	db 3,1,SURF
	db 4,1,PSYCHIC_M
	db 4,3,LOVELY_KISS
	db 5,3,BLIZZARD
	db 0

	db BRUNO,$1
	db 1,1,ROCK_SLIDE
	db 1,2,SCREECH
	db 1,4,DIG
	db 2,3,FIRE_PUNCH
	db 2,4,SUBMISSION
	db 3,1,ROLLING_KICK
	db 4,1,ROCK_SLIDE
	db 4,2,SCREECH
	db 4,4,EARTHQUAKE
	db 5,1,KARATE_CHOP
	db 5,3,DOUBLE_EDGE
	db 0

	db AGATHA,$1
	db 1,2,MIMIC
	db 2,2,SUBSTITUTE
	db 2,3,THUNDERBOLT
	db 2,4,MEGA_DRAIN
	db 3,3,SCREECH
	db 3,4,TOXIC
	db 4,4,EARTHQUAKE
	db 5,2,PSYCHIC_M
	db 0

	db LANCE,$1
	db 1,3,FIRE_BLAST
	db 2,1,THUNDER_WAVE
	db 2,3,THUNDERBOLT
	db 3,1,SURF
	db 3,2,BODY_SLAM
	db 3,3,ICE_BEAM
	db 4,1,WING_ATTACK
	db 4,2,SWIFT
	db 4,3,FLY
	db 5,1,BLIZZARD
	db 5,2,FIRE_BLAST
	db 5,3,THUNDER
	db 0

	db SONY3,$1
	db 1,1,SKY_ATTACK
	db 1,2,TRI_ATTACK
	db 1,3,MIMIC
	db 1,4,DOUBLE_TEAM
	db 2,1,THUNDER_WAVE
	db 3,1,THUNDERBOLT
	db 3,2,EARTHQUAKE
	db 3,3,ROCK_SLIDE
	db 3,4,TAKE_DOWN
	db 4,1,FLAMETHROWER
	db 4,2,REST
	db 4,3,DOUBLE_EDGE
	db 4,4,TOXIC
	db 5,1,STOMP
	db 5,2,SLEEP_POWDER
	db 5,3,SOLARBEAM
	db 5,4,LEECH_SEED
	db 6,1,HYDRO_PUMP
	db 6,2,BLIZZARD
	db 6,3,REFLECT
	db 6,4,SKULL_BASH
	db 0

	db SONY3,$2
	db 1,1,SKY_ATTACK
	db 1,2,TRI_ATTACK
	db 1,3,MIMIC
	db 1,4,DOUBLE_TEAM
	db 2,1,THUNDER_WAVE
	db 3,1,THUNDERBOLT
	db 3,2,EARTHQUAKE
	db 3,3,ROCK_SLIDE
	db 3,4,TAKE_DOWN
	db 4,1,ICE_BEAM
	db 4,2,BODY_SLAM
	db 5,1,FLAMETHROWER
	db 5,2,REST
	db 5,3,DOUBLE_EDGE
	db 5,4,TOXIC
	db 6,1,MEGA_DRAIN
	db 0

	db SONY3,$3
	db 1,1,SKY_ATTACK
	db 1,2,TRI_ATTACK
	db 1,3,MIMIC
	db 1,4,DOUBLE_TEAM
	db 2,1,THUNDER_WAVE
	db 3,1,THUNDERBOLT
	db 3,2,EARTHQUAKE
	db 3,3,ROCK_SLIDE
	db 3,4,TAKE_DOWN
	db 4,1,STOMP
	db 4,2,SLEEP_POWDER
	db 4,3,SOLARBEAM
	db 4,4,LEECH_SEED
	db 5,1,ICE_BEAM
	db 5,2,BODY_SLAM
	db 6,1,SWORDS_DANCE
	db 4,2,LEER
	db 0
	
	;mr fuji battle
	db GENTLEMAN,$5
	db 1,1,BONEMERANG
	db 1,2,BODY_SLAM
	db 1,3,SEISMIC_TOSS
	db 1,4,BLIZZARD
	db 2,1,HYDRO_PUMP
	db 2,2,ICE_BEAM
	db 2,3,REFLECT
	db 2,4,TOXIC
	db 3,1,SWORDS_DANCE
	db 3,2,SURF
	db 3,3,SLASH
	db 3,4,DOUBLE_EDGE
	db 4,1,SKY_ATTACK
	db 4,2,REFLECT
	db 4,3,HYPER_BEAM
	db 4,4,SUPERSONIC
	db 5,1,FIRE_BLAST
	db 5,2,BODY_SLAM
	db 5,3,MIMIC
	db 5,4,HYPER_BEAM
	db 0
	
	;Chief battle
	db CHIEF,$1
	db 1,1,BODY_SLAM
	db 1,2,SUBMISSION
	db 1,3,FIRE_BLAST
	db 1,4,HYPER_BEAM
	db 2,1,THUNDERBOLT
	db 2,2,ROCK_SLIDE
	db 2,3,SUBSTITUTE
	db 2,4,EARTHQUAKE
	db 3,1,AMNESIA
	db 3,2,BLIZZARD
	db 3,3,SURF
	db 3,4,MIMIC
	db 4,1,SLASH
	db 4,2,SWORDS_DANCE
	db 4,3,SEISMIC_TOSS
	db 4,4,BODY_SLAM
	db 5,1,SWORDS_DANCE
	db 5,2,SLASH
	db 5,3,AGILITY
	db 5,4,DOUBLE_EDGE
	db 6,1,HYPER_BEAM
	db 6,2,DOUBLE_EDGE
	db 6,3,STOMP
	db 6,4,REST
	db 0
	
	;Seiga battle
	db LASS,$13
	db 1,1,PSYCHIC_M
	db 1,2,SING
	db 1,3,METRONOME
	db 1,4,DOUBLE_EDGE
	db 2,1,THUNDERBOLT
	db 2,2,HYPNOSIS
	db 2,3,MEGA_DRAIN
	db 2,4,CONFUSE_RAY
	db 3,1,SWORDS_DANCE
	db 3,2,RAZOR_LEAF
	db 3,3,SLEEP_POWDER
	db 3,4,BODY_SLAM
	db 4,1,FIRE_BLAST
	db 4,2,REFLECT
	db 4,3,HYPER_BEAM
	db 4,4,CONFUSE_RAY
	db 5,1,EARTHQUAKE
	db 5,2,ROCK_SLIDE
	db 5,3,SUBMISSION
	db 5,4,HYPER_BEAM
	db 6,1,SURF
	db 6,2,BLIZZARD
	db 6,3,SEISMIC_TOSS
	db 6,4,MIMIC
	db 0

	db $ff