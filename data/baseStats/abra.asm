db DEX_ABRA ; pokedex id
db 25 ; base hp
db 20 ; base attack
db 15 ; base defense
db 90 ; base speed
db 105 ; base special
db PSYCHIC ; species type 1
db PSYCHIC ; species type 2
db 200 ; catch rate
db 73 ; base exp yield
INCBIN ABRA_FR,0,1 ; 55, sprite dimensions
dw AbraPicFront
dw AbraPicBack
; attacks known at lvl 0
db TELEPORT
db 0
db 0
db 0
db 3 ; growth rate
; learnset
	tmlearn 1,4,5,6,8
	tmlearn 9,10,16
	tmlearn 17,18,19
	tmlearn 29,30,31,32
	tmlearn 33,37
	tmlearn 44,45,46
	tmlearn 49,50,55
;	db 0 ; padding
	db BANK(AbraPicFront)
	assert BANK(AbraPicFront) == BANK(AbraPicBack)
