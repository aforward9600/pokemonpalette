db DEX_MEWTWO ; pokedex id
db 106 ; base hp
db 110 ; base attack
db 90 ; base defense
db 130 ; base speed
db 154 ; base special
db PSYCHIC ; species type 1
db PSYCHIC ; species type 2
db 3 ; catch rate
db 220 ; base exp yield
INCBIN MEWTWO_FR,0,1 ; 77, sprite dimensions
dw MewtwoPicFront
dw MewtwoPicBack
; attacks known at lvl 0
db CONFUSION
db DISABLE
db SWIFT
db PSYCHIC_M
db 5 ; growth rate
; learnset
	tmlearn 1,4,5,6,8
	tmlearn 9,10,11,13,14,15,16
	tmlearn 17,18,19,22,24
	tmlearn 25,29,30,31,32
	tmlearn 33,35,37,38,39
	tmlearn 44,45
	tmlearn 49,50,54,55
;	db 0 ; padding
	db BANK(MewtwoPicFront)
	assert BANK(MewtwoPicFront) == BANK(MewtwoPicBack)
