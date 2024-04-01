db DEX_HITMONCHAN ; pokedex id
db 50 ; base hp
db 105 ; base attack
db 79 ; base defense
db 76 ; base speed
db 35 ; base special
db FIGHTING ; species type 1
db FIGHTING ; species type 2
db 45 ; catch rate
db 140 ; base exp yield
INCBIN HITMONCHAN_FR,0,1 ; 66, sprite dimensions
dw HitmonchanPicFront
dw HitmonchanPicBack
; attacks known at lvl 0
db COMET_PUNCH
db AGILITY
db 0
db 0
db 0 ; growth rate
; learnset
	tmlearn 1,5,6,8
	tmlearn 9,10
	tmlearn 17,18,19,23
	tmlearn 26,27,31,32
	tmlearn 34,39
	tmlearn 44,48
	tmlearn 50,54
;	db 0 ; padding
	db BANK(HitmonchanPicFront)
	assert BANK(HitmonchanPicFront) == BANK(HitmonchanPicBack)
