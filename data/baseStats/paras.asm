db DEX_PARAS ; pokedex id
db 35 ; base hp
db 70 ; base attack
db 55 ; base defense
db 25 ; base speed
db 55 ; base special
db BUG ; species type 1
db GRASS ; species type 2
db 190 ; catch rate
db 70 ; base exp yield
INCBIN PARAS_FR,0,1 ; 55, sprite dimensions
dw ParasPicFront
dw ParasPicBack
; attacks known at lvl 0
db SCRATCH
db 0
db 0
db 0
db 0 ; growth rate
; learnset
	tmlearn 3,6,8
	tmlearn 10,16
	tmlearn 21,22,23
	tmlearn 28,31,32
	tmlearn 33,36
	tmlearn 41,44
	tmlearn 50,51
;	db 0 ; padding
	db BANK(ParasPicFront)
	assert BANK(ParasPicFront) == BANK(ParasPicBack)
