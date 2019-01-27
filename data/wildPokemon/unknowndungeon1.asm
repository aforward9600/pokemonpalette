DungeonMons1:;joenote - swapped sandslash/arbok
	db $0A
	db 46,GOLBAT
	db 46,HYPNO
	db 46,MAGNETON
	db 49,DODRIO
	db 49,VENOMOTH
	db 49,KADABRA
	IF DEF(_RED)
		db 52,SANDSLASH
	ENDC
	IF DEF(_BLUE)
		db 52,ARBOK
	ENDC
	db 52,PARASECT
	db 67,ARTICUNO
	db 53,RAICHU
	db $00
