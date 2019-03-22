UndergroundPathEntranceRoute7Object:
	db $a ; border block

	db 3 ; warps
	warp 3, 7, 4, -1
	warp 4, 7, 4, -1
	warp 4, 4, 0, UNDERGROUND_PATH_WE

	db 0 ; signs

	db 2 ; objects
	object SPRITE_FAT_BALD_GUY, 2, 4, STAY, NONE, 1 ; person
	;joenote - adding a guy for random trainer battles
	object SPRITE_BIKE_SHOP_GUY, 4, 2, STAY, DOWN, 2, OPP_YOUNGSTER, 1 ; person (youngster #1 is a dummy value for the trainer)


	; warp-to
	warp_to 3, 7, PATH_ENTRANCE_ROUTE_7_WIDTH
	warp_to 4, 7, PATH_ENTRANCE_ROUTE_7_WIDTH
	warp_to 4, 4, PATH_ENTRANCE_ROUTE_7_WIDTH ; UNDERGROUND_PATH_WE
