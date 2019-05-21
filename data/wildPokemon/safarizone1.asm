ZoneMons1:;joenote - added lickitung & tweaked encounter tables
	db $1E
	IF DEF(_RED)
		db 24,NIDORAN_M
		db 26,DODUO
		db 22,PARAS
		db 25,EXEGGCUTE
		db 33,NIDORINO
		db 24,NIDORAN_F
		db 28,SCYTHER
		db 22,LICKITUNG
		db 25,KANGASKHAN
		db 25,PARASECT
	ENDC
	IF DEF(_BLUE)
		db 24,NIDORAN_F
		db 26,DODUO
		db 22,PARAS
		db 25,EXEGGCUTE
		db 33,NIDORINA
		db 24,NIDORAN_M
		db 28,PINSIR
		db 22,LICKITUNG
		db 25,KANGASKHAN
		db 25,PARASECT
	ENDC
	db $00
