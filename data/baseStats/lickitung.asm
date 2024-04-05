db DEX_LICKITUNG ; pokedex id
db 100 ; base hp
db 85 ; base attack
db 85 ; base defense
db 30 ; base speed
db 60 ; base special
db NORMAL ; species type 1
db NORMAL ; species type 2
db 45 ; catch rate
db 127 ; base exp yield
INCBIN LICKITUNG_FR,0,1 ; 77, sprite dimensions
dw LickitungPicFront
dw LickitungPicBack
; attacks known at lvl 0
db WRAP
db SUPERSONIC
db LICK
db 0
db 0 ; growth rate
; learnset
	tmlearn 1,3,5,6,8
	tmlearn 9,10,11,13,14,15
	tmlearn 17,18,19,24
	tmlearn 25,26,27,30,31,32
	tmlearn 35,38
	tmlearn 44,48
	tmlearn 50,51,53,54
;	db 0 ; padding
	db BANK(LickitungPicFront)
	assert BANK(LickitungPicFront) == BANK(LickitungPicBack)
