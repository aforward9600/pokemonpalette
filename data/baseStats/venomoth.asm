db DEX_VENOMOTH ; pokedex id
db 70 ; base hp
db 65 ; base attack
db 60 ; base defense
db 90 ; base speed
db 90 ; base special
db BUG ; species type 1
db POISON ; species type 2
db 75 ; catch rate
db 138 ; base exp yield
INCBIN VENOMOTH_FR,0,1 ; 77, sprite dimensions
dw VenomothPicFront
dw VenomothPicBack
; attacks known at lvl 0
db TACKLE
db DISABLE
db POISONPOWDER
db CONFUSION
db 0 ; growth rate
; learnset
	tmlearn 2,6
	tmlearn 10,15
	tmlearn 21,22,23
	tmlearn 29,30,31,32
	tmlearn 33,36,39
	tmlearn 41,44
	tmlearn 50
;	db 0 ; padding
	db BANK(VenomothPicFront)
	assert BANK(VenomothPicFront) == BANK(VenomothPicBack)
