db DEX_DUGTRIO ; pokedex id
db 35 ; base hp
db 100 ; base attack
db 50 ; base defense
db 120 ; base speed
db 70 ; base special
db GROUND ; species type 1
db GROUND ; species type 2
db 50 ; catch rate
db 153 ; base exp yield
INCBIN DUGTRIO_FR,0,1 ; 66, sprite dimensions
dw DugtrioPicFront
dw DugtrioPicBack
; attacks known at lvl 0
db SCRATCH
db GROWL
db DIG
db 0
db 0 ; growth rate
; learnset
	tmlearn 6,8
	tmlearn 10,15
	tmlearn 23
	tmlearn 26,27,28,31,32
	tmlearn 34,36
	tmlearn 44,48
	tmlearn 50
;	db 0 ; padding
	db BANK(DugtrioPicFront)
	assert BANK(DugtrioPicFront) == BANK(DugtrioPicBack)
