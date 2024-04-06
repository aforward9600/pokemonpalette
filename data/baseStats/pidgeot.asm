db DEX_PIDGEOT ; pokedex id
db 83 ; base hp
db 80 ; base attack
db 75 ; base defense
db 101 ; base speed
db 70 ; base special
db NORMAL ; species type 1
db FLYING ; species type 2
db 45 ; catch rate
db 172 ; base exp yield
INCBIN PIDGEOT_FR,0,1 ; 77, sprite dimensions
dw PidgeotPicFront
dw PidgeotPicBack
; attacks known at lvl 0
db TACKLE
db SAND_ATTACK
db QUICK_ATTACK
db 0
db 3 ; growth rate
; learnset
	tmlearn 2,6
	tmlearn 10,15
	tmlearn 0
	tmlearn 31,32
	tmlearn 33,39,40
	tmlearn 43,44
	tmlearn 50,52
;	db 0 ; padding
	db BANK(PidgeotPicFront)
	assert BANK(PidgeotPicFront) == BANK(PidgeotPicBack)
