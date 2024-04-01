db DEX_LAPRAS ; pokedex id
db 130 ; base hp
db 85 ; base attack
db 80 ; base defense
db 60 ; base speed
db 95 ; base special
db WATER ; species type 1
db ICE ; species type 2
db 45 ; catch rate
db 219 ; base exp yield
INCBIN LAPRAS_FR,0,1 ; 77, sprite dimensions
dw LaprasPicFront
dw LaprasPicBack
; attacks known at lvl 0
db WATER_GUN
db GROWL
db 0
db 0
db 5 ; growth rate
; learnset
	tmlearn 6,7,8
	tmlearn 9,10,11,12,13,14,15
	tmlearn 22,24
	tmlearn 25,29,31,32
	tmlearn 33
	tmlearn 44
	tmlearn 50,53,54
;	db 0 ; padding
	db BANK(LaprasPicFront)
	assert BANK(LaprasPicFront) == BANK(LaprasPicBack)
