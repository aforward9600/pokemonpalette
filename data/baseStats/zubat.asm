db DEX_ZUBAT ; pokedex id
db 40 ; base hp
db 45 ; base attack
db 35 ; base defense
db 55 ; base speed
db 40 ; base special
db POISON ; species type 1
db FLYING ; species type 2
db 255 ; catch rate
db 54 ; base exp yield
INCBIN ZUBAT_FR,0,1 ; 55, sprite dimensions
dw ZubatPicFront
dw ZubatPicBack
; attacks known at lvl 0
db GUST
db 0
db 0
db 0
db 0 ; growth rate
; learnset
	tmlearn 2,6
	tmlearn 10
	tmlearn 21,23
	tmlearn 30,31,32
	tmlearn 36,39
	tmlearn 41,44,46
	tmlearn 50,52
;	db 0 ; padding
	db BANK(ZubatPicFront)
	assert BANK(ZubatPicFront) == BANK(ZubatPicBack)
