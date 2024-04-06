db DEX_MAGMAR ; pokedex id
db 65 ; base hp
db 95 ; base attack
db 57 ; base defense
db 93 ; base speed
db 85 ; base special
db FIRE ; species type 1
db FIRE ; species type 2
db 45 ; catch rate
db 167 ; base exp yield
INCBIN MAGMAR_FR,0,1 ; 66, sprite dimensions
dw MagmarPicFront
dw MagmarPicBack
; attacks known at lvl 0
db EMBER
db 0
db 0
db 0
db 0 ; growth rate
; learnset
	tmlearn 1,4,5,6,8
	tmlearn 10,15
	tmlearn 17,18,19
	tmlearn 29,31,32
	tmlearn 35,37,38,40
	tmlearn 44
	tmlearn 50,54
;	db 0 ; padding
	db BANK(MagmarPicFront)
	assert BANK(MagmarPicFront) == BANK(MagmarPicBack)
