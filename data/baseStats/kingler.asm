db DEX_KINGLER ; pokedex id
db 55 ; base hp
db 130 ; base attack
db 115 ; base defense
db 75 ; base speed
db 50 ; base special
db WATER ; species type 1
db WATER ; species type 2
db 60 ; catch rate
db 206 ; base exp yield
INCBIN KINGLER_FR,0,1 ; 77, sprite dimensions
dw KinglerPicFront
dw KinglerPicBack
; attacks known at lvl 0
db BUBBLE
db LEER
db VICEGRIP
db 0
db 0 ; growth rate
; learnset
	tmlearn 3,6,8
	tmlearn 10,11,13,14,15
	tmlearn 23
	tmlearn 26,28,31,32
	tmlearn 34
	tmlearn 44
	tmlearn 50,51,53,54
;	db 0 ; padding
	db BANK(KinglerPicFront)
	assert BANK(KinglerPicFront) == BANK(KinglerPicBack)
