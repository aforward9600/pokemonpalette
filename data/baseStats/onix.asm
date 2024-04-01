db DEX_ONIX ; pokedex id
db 65 ; base hp
db 85 ; base attack
db 130 ; base defense
db 70 ; base speed
db 30 ; base special
db ROCK ; species type 1
db GROUND ; species type 2
db 45 ; catch rate
db 108 ; base exp yield
INCBIN ONIX_FR,0,1 ; 77, sprite dimensions
dw OnixPicFront
dw OnixPicBack
; attacks known at lvl 0
db TACKLE
db SCREECH
db 0
db 0
db 0 ; growth rate
; learnset
	tmlearn 6,8
	tmlearn 9,10
	tmlearn 0
	tmlearn 26,27,28,31,32
	tmlearn 34,36
	tmlearn 44,47,48
	tmlearn 50,54
;	db 0 ; padding
	db BANK(OnixPicFront)
	assert BANK(OnixPicFront) == BANK(OnixPicBack)
