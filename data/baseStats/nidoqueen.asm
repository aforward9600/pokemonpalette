db DEX_NIDOQUEEN ; pokedex id
db 90 ; base hp
db 92 ; base attack
db 87 ; base defense
db 76 ; base speed
db 75 ; base special
db POISON ; species type 1
db GROUND ; species type 2
db 45 ; catch rate
db 194 ; base exp yield
INCBIN NIDOQUEEN_FR,0,1 ; 77, sprite dimensions
dw NidoqueenPicFront
dw NidoqueenPicBack
; attacks known at lvl 0
db TACKLE
db SCRATCH
db TAIL_WHIP
db BODY_SLAM
db 3 ; growth rate
; learnset
	tmlearn 1,4,5,6,7,8
	tmlearn 9,10,11,12,13,14,15
	tmlearn 17,18,19,24
	tmlearn 25,26,27,30,31,32
	tmlearn 33,34,35,36,37,38,40
	tmlearn 44,48
	tmlearn 50,53,54
;	db 0 ; padding
	db BANK(NidoqueenPicFront)
	assert BANK(NidoqueenPicFront) == BANK(NidoqueenPicBack)
