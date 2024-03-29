MoveDeletersHouseObject:
	db $a ; border block

	db 2 ; warps
	warp 2, 7, 1, -1
	warp 3, 7, 1, -1

	db 0 ; signs

	db 1 ; objects
	object SPRITE_BALDING_GUY, 2, 3, STAY, RIGHT, 1 ; person

	; warp-to
	warp_to 2, 7, FUCHSIA_HOUSE_1_WIDTH
	warp_to 3, 7, FUCHSIA_HOUSE_1_WIDTH
