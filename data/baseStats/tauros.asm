db DEX_TAUROS ; pokedex id
db 75 ; base hp
db 100 ; base attack
db 95 ; base defense
db 110 ; base speed
db 70 ; base special
db NORMAL ; species type 1
db NORMAL ; species type 2
db 45 ; catch rate
db 211 ; base exp yield
INCBIN TAUROS_FR,0,1 ; 77, sprite dimensions
dw TaurosPicFront
dw TaurosPicBack
; attacks known at lvl 0
db TACKLE
db 0
db 0
db 0
db 5 ; growth rate
; learnset
	tmlearn 6,7,8
	tmlearn 10,13,14,15
	tmlearn 24
	tmlearn 25,26,27,30,31,32
	tmlearn 34,38
	tmlearn 44,48
	tmlearn 50,54
;	db 0 ; padding
	db BANK(TaurosPicFront)
	assert BANK(TaurosPicFront) == BANK(TaurosPicBack)
