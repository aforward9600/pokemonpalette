db DEX_RHYDON ; pokedex id
db 105 ; base hp
db 130 ; base attack
db 120 ; base defense
db 40 ; base speed
db 45 ; base special
db GROUND ; species type 1
db ROCK ; species type 2
db 60 ; catch rate
db 204 ; base exp yield
INCBIN RHYDON_FR,0,1 ; 77, sprite dimensions
dw RhydonPicFront
dw RhydonPicBack
; attacks known at lvl 0
db HORN_ATTACK
db STOMP
db TAIL_WHIP
db FURY_ATTACK
db 5 ; growth rate
; learnset
	tmlearn 1,4,5,6,7,8
	tmlearn 9,10,11,13,14,15
	tmlearn 17,18,19,24
	tmlearn 25,26,27,28,31,32
	tmlearn 34,35,37,38,40
	tmlearn 44,48
	tmlearn 50,53,54
;	db 0 ; padding
	db BANK(RhydonPicFront)
	assert BANK(RhydonPicFront) == BANK(RhydonPicBack)
