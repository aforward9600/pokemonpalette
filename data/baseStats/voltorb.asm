db DEX_VOLTORB ; pokedex id
db 40 ; base hp
db 30 ; base attack
db 50 ; base defense
db 100 ; base speed
db 55 ; base special
db ELECTRIC ; species type 1
db ELECTRIC ; species type 2
db 190 ; catch rate
db 103 ; base exp yield
INCBIN VOLTORB_FR,0,1 ; 55, sprite dimensions
dw VoltorbPicFront
dw VoltorbPicBack
; attacks known at lvl 0
db TACKLE
db SCREECH
db THUNDERSHOCK
db 0
db 0 ; growth rate
; learnset
	tmlearn 6
	tmlearn 16
	tmlearn 23,24
	tmlearn 25,31,32
	tmlearn 33,39
	tmlearn 44,45,47
	tmlearn 50,55
;	db 0 ; padding
	db BANK(VoltorbPicFront)
	assert BANK(VoltorbPicFront) == BANK(VoltorbPicBack)