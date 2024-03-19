

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
	db 1,2,THUNDER_WAVE
	db 2,3,BIDE
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
	db 4,3,TOXIC
	db 0
	
	db SABRINA,$1
	db 4,3,PSYWAVE
	db 0
	
	db BLAINE,$1
	db 4,3,FIRE_BLAST
	db 0
	
	db GIOVANNI,$3
	db 5,3,FISSURE
	db 0
	
	db LORELEI,$1
	db 5,3,BLIZZARD
	db 0

	db BRUNO,$1
	db 1,3,ROCK_SLIDE
	db 2,1,SUBMISSION
	db 2,2,ROCK_SLIDE
	db 2,3,EARTHQUAKE
	db 2,4,REST
	db 3,1,HI_JUMP_KICK
	db 3,2,ROCK_SLIDE
	db 3,3,EARTHQUAKE
	db 3,4,REST
	db 4,1,SURF
	db 4,2,SUBMISSION
	db 4,3,BLIZZARD
	db 4,4,EARTHQUAKE
	db 5,1,SUBMISSION
	db 5,2,ROCK_SLIDE
	db 5,3,EARTHQUAKE
	db 5,4,HYPER_BEAM
	db 0

	db AGATHA,$1
	db 5,3,TOXIC
	db 0

	db LANCE,$1
	db 5,3,BARRIER
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