VermilionDockObject:
	db $f ; border block

	db 2 ; warps
	warp 14, 0, 5, -1
	warp 14, 2, 1, SS_ANNE_1

	db 0 ; signs

	db 1 ; objects
	db SPRITE_GIRL, 4, 27, WALK, 2, 2, OPP_LASS, 18	;joenote - adding orange leage champ special battle 
	
	; warp-to
	warp_to 14, 0, VERMILION_DOCK_WIDTH
	warp_to 14, 2, VERMILION_DOCK_WIDTH ; SS_ANNE_1
