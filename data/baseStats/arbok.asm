db DEX_ARBOK ; pokedex id
db 60 ; base hp
db 95 ; base attack
db 69 ; base defense
db 80 ; base speed
db 65 ; base special
db POISON ; species type 1
db POISON ; species type 2
db 90 ; catch rate
db 147 ; base exp yield
INCBIN ARBOK_FR,0,1 ; 77, sprite dimensions
dw ArbokPicFront
dw ArbokPicBack
; attacks known at lvl 0
db WRAP
db LEER
db POISON_STING
db 0
db 0 ; growth rate
; learnset
	tmlearn 6,8
	tmlearn 10,15
	tmlearn 21
	tmlearn 26,27,28,31,32
	tmlearn 36
	tmlearn 41,44,48
	tmlearn 50,54
;	db 0 ; padding
	db BANK(ArbokPicFront)
	assert BANK(ArbokPicFront) == BANK(ArbokPicBack)
