db DEX_PRIMEAPE ; pokedex id
db 65 ; base hp
db 105 ; base attack
db 60 ; base defense
db 95 ; base speed
db 60 ; base special
db FIGHTING ; species type 1
db FIGHTING ; species type 2
db 75 ; catch rate
db 149 ; base exp yield
INCBIN PRIMEAPE_FR,0,1 ; 77, sprite dimensions
dw PrimeapePicFront
dw PrimeapePicBack
; attacks known at lvl 0
db SCRATCH
db LEER
db KARATE_CHOP
db FURY_SWIPES
db 0 ; growth rate
; learnset
	tmlearn 1,4,5,6,8
	tmlearn 9,10,15
	tmlearn 17,18,19,24
	tmlearn 25,26,28,31,32
	tmlearn 34,37,39
	tmlearn 44,48
	tmlearn 50,54
;	db 0 ; padding
	db BANK(PrimeapePicFront)
	assert BANK(PrimeapePicFront) == BANK(PrimeapePicBack)
