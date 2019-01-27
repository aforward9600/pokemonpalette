DungeonMonsB1:;joenote - added moltres & default mewtwo
	db $19
	db 55,RHYDON
	db 55,MAROWAK
	db 55,ELECTRODE
	IF DEF(_RED)
		db 64,ARBOK
	ENDC
	IF DEF(_BLUE)
		db 64,SANDSLASH
	ENDC
	db 64,PARASECT
	db 64,RAICHU
	db 65,CHANSEY
	db 66,DITTO
	db 67,MOLTRES
	db 70,MEW
	db $00
