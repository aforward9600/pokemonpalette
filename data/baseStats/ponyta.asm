db DEX_PONYTA ; pokedex id
db 50 ; base hp
db 85 ; base attack
db 55 ; base defense
db 90 ; base speed
db 65 ; base special
db FIRE ; species type 1
db FIRE ; species type 2
db 190 ; catch rate
db 152 ; base exp yield
INCBIN PONYTA_FR,0,1 ; 66, sprite dimensions
dw PonytaPicFront
dw PonytaPicBack
; attacks known at lvl 0
db EMBER
db 0
db 0
db 0
db 0 ; growth rate
; learnset
	tmlearn 6,7,8
	tmlearn 10
	tmlearn 23
	tmlearn 31,32
	tmlearn 33,35,38,39
	tmlearn 44,46
	tmlearn 50
;	db 0 ; padding
	db BANK(PonytaPicFront)
	assert BANK(PonytaPicFront) == BANK(PonytaPicBack)
