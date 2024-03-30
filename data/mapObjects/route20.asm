Route20Object:
	db $43 ; border block

	db 2 ; warps
	warp 48, 5, 0, SEAFOAM_ISLANDS_1
	warp 58, 9, 2, SEAFOAM_ISLANDS_1

	db 2 ; signs
	sign 51, 7, 11 ; Route20Text11
	sign 57, 11, 12 ; Route20Text12

	db 10 ; objects
	object SPRITE_SWIMMER, 87, 8, STAY, UP, 1, OPP_SWIMMER, 9
	object SPRITE_SWIMMER, 68, 11, STAY, UP, 2, OPP_BEAUTY, 14
	object SPRITE_SWIMMER, 45, 10, STAY, DOWN, 3, OPP_BEAUTY, 6
	object SPRITE_SWIMMER, 55, 14, STAY, RIGHT, 4, OPP_JR_TRAINER_F, 16
	object SPRITE_SWIMMER, 38, 13, STAY, DOWN, 5, OPP_SWIMMER, 10
	object SPRITE_SWIMMER, 87, 13, STAY, UP, 6, OPP_SWIMMER, 11
	object SPRITE_ROCKER, 34, 9, STAY, UP, 7, OPP_BIRD_KEEPER, 11
	object SPRITE_SWIMMER, 25, 7, STAY, UP, 8, OPP_BEAUTY, 7
	object SPRITE_SWIMMER, 24, 12, STAY, DOWN, 9, OPP_JR_TRAINER_F, 15
	object SPRITE_SWIMMER, 15, 8, STAY, UP, 10, OPP_BEAUTY, 8

	; warp-to
	warp_to 48, 5, ROUTE_20_WIDTH ; SEAFOAM_ISLANDS_1
	warp_to 58, 9, ROUTE_20_WIDTH ; SEAFOAM_ISLANDS_1
