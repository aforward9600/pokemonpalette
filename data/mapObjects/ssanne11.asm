SSAnne11Object:
	db $c ; border block

	db 1 ; warps
	warp 0, 0, 11, SS_ANNE_1

	db 0 ; signs

	db 1 ; objects
	object SPRITE_GIRL, 3, 3, STAY, LEFT, 1

	; warp-to
	warp_to 0, 0, SS_ANNE_11_WIDTH ; SS_ANNE_11
