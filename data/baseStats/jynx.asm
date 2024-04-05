db DEX_JYNX ; pokedex id
db 65 ; base hp
db 50 ; base attack
db 35 ; base defense
db 95 ; base speed
db 95 ; base special
db ICE ; species type 1
db PSYCHIC ; species type 2
db 45 ; catch rate
db 137 ; base exp yield
INCBIN JYNX_FR,0,1 ; 66, sprite dimensions
dw JynxPicFront
dw JynxPicBack
; attacks known at lvl 0
db POUND
db LOVELY_KISS
db 0
db 0
db 0 ; growth rate
; learnset
	tmlearn 1,5,6,8
	tmlearn 9,10,11,13,14,15,16
	tmlearn 17,18,19
	tmlearn 29,30,31,32
	tmlearn 33
	tmlearn 44,46
	tmlearn 50
;	db 0 ; padding
	db BANK(JynxPicFront)
	assert BANK(JynxPicFront) == BANK(JynxPicBack)
