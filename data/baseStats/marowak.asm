db DEX_MAROWAK ; pokedex id
db 60 ; base hp
db 80 ; base attack
db 110 ; base defense
db 45 ; base speed
db 50 ; base special
db GROUND ; species type 1
db GROUND ; species type 2
db 75 ; catch rate
db 124 ; base exp yield
INCBIN MAROWAK_FR,0,1 ; 66, sprite dimensions
dw MarowakPicFront
dw MarowakPicBack
; attacks known at lvl 0
db BONE_CLUB
db GROWL
db LEER
db FOCUS_ENERGY
db 0 ; growth rate
; learnset
	tmlearn 1,5,6,8
	tmlearn 9,10,11,12,13,14,15
	tmlearn 17,18,19
	tmlearn 26,27,28,31,32
	tmlearn 34,35,38
	tmlearn 44,48
	tmlearn 50,54
;	db 0 ; padding
	db BANK(MarowakPicFront)
	assert BANK(MarowakPicFront) == BANK(MarowakPicBack)
