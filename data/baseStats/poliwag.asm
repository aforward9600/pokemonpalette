db DEX_POLIWAG ; pokedex id
db 40 ; base hp
db 50 ; base attack
db 40 ; base defense
db 90 ; base speed
db 40 ; base special
db WATER ; species type 1
db WATER ; species type 2
db 255 ; catch rate
db 77 ; base exp yield
INCBIN POLIWAG_FR,0,1 ; 55, sprite dimensions
dw PoliwagPicFront
dw PoliwagPicBack
; attacks known at lvl 0
db BUBBLE
db 0
db 0
db 0
db 3 ; growth rate
; learnset
	tmlearn 6,8
	tmlearn 10,11,13,14
	tmlearn 0
	tmlearn 29,31,32
	tmlearn 0
	tmlearn 44,46
	tmlearn 50,53
;	db 0 ; padding
	db BANK(PoliwagPicFront)
	assert BANK(PoliwagPicFront) == BANK(PoliwagPicBack)
