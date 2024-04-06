db DEX_JIGGLYPUFF ; pokedex id
db 115 ; base hp
db 45 ; base attack
db 20 ; base defense
db 20 ; base speed
db 25 ; base special
db NORMAL ; species type 1
db NORMAL ; species type 2
db 170 ; catch rate
db 76 ; base exp yield
INCBIN JIGGLYPUFF_FR,0,1 ; 55, sprite dimensions
dw JigglypuffPicFront
dw JigglypuffPicBack
; attacks known at lvl 0
db SING
db 0
db 0
db 0
db 4 ; growth rate
; learnset
	tmlearn 1,4,5,6,8
	tmlearn 9,10,11,13,14,16
	tmlearn 17,18,19,22,24
	tmlearn 25,29,30,31,32
	tmlearn 33,35,37,38
	tmlearn 44,45
	tmlearn 49,50,54,55
;	db 0 ; padding
	db BANK(JigglypuffPicFront)
	assert BANK(JigglypuffPicFront) == BANK(JigglypuffPicBack)
