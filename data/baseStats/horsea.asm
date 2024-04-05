db DEX_HORSEA ; pokedex id
db 30 ; base hp
db 40 ; base attack
db 70 ; base defense
db 60 ; base speed
db 70 ; base special
db WATER ; species type 1
db WATER ; species type 2
db 225 ; catch rate
db 83 ; base exp yield
INCBIN HORSEA_FR,0,1 ; 55, sprite dimensions
dw HorseaPicFront
dw HorseaPicBack
; attacks known at lvl 0
db BUBBLE
db LEER
db 0
db 0
db 0 ; growth rate
; learnset
	tmlearn 6
	tmlearn 9,10,11,12,13,14
	tmlearn 23
	tmlearn 31,32
	tmlearn 39
	tmlearn 44
	tmlearn 50,53
;	db 0 ; padding
	db BANK(HorseaPicFront)
	assert BANK(HorseaPicFront) == BANK(HorseaPicBack)
