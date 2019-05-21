ZoneMons3:;joenote - added mr mime & tweaked encounter tables
	db $1E
	IF DEF(_RED)
		db 25,NIDORAN_M
		db 26,DODUO
		db 23,VENONAT
		db 24,EXEGGCUTE
		db 33,NIDORINO
		db 25,NIDORAN_F
		db 31,VENOMOTH
		db 26,MR_MIME
		db 26,TAUROS
		db 28,KANGASKHAN
	ENDC
	IF DEF(_BLUE)
		db 25,NIDORAN_F
		db 26,DODUO
		db 23,VENONAT
		db 24,EXEGGCUTE
		db 33,NIDORINA
		db 25,NIDORAN_M
		db 26,MR_MIME
		db 31,VENOMOTH
		db 26,TAUROS
		db 28,KANGASKHAN
	ENDC
	db $00
