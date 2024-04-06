db DEX_PORYGON ; pokedex id
db 75 ; base hp
db 80 ; base attack
db 80 ; base defense
db 50 ; base speed
db 95 ; base special
db NORMAL ; species type 1
db NORMAL ; species type 2
db 45 ; catch rate
db 130 ; base exp yield
INCBIN PORYGON_FR,0,1 ; 66, sprite dimensions
dw PorygonPicFront
dw PorygonPicBack
; attacks known at lvl 0
db TACKLE
db SHARPEN
db CONVERSION
db 0
db 0 ; growth rate
; learnset
	tmlearn 6
	tmlearn 10,13,14,15
	tmlearn 23,24
	tmlearn 25,29,30,31,32
	tmlearn 33,39
	tmlearn 44,45
	tmlearn 49,50,55
;	db 0 ; padding
	db BANK(PorygonPicFront)
	assert BANK(PorygonPicFront) == BANK(PorygonPicBack)
