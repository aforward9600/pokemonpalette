db DEX_ELECTRODE ; pokedex id
db 60 ; base hp
db 50 ; base attack
db 70 ; base defense
db 140 ; base speed
db 90 ; base special
db ELECTRIC ; species type 1
db ELECTRIC ; species type 2
db 60 ; catch rate
db 150 ; base exp yield
INCBIN ELECTRODE_FR,0,1 ; 55, sprite dimensions
dw ElectrodePicFront
dw ElectrodePicBack
; attacks known at lvl 0
db TACKLE
db SCREECH
db SONICBOOM
db THUNDERSHOCK
db 0 ; growth rate
; learnset
	tmlearn 6
	tmlearn 15
	tmlearn 23,24
	tmlearn 25,31,32
	tmlearn 33,39
	tmlearn 44,45,47
	tmlearn 50,55
	;db 0 ; padding
	db BANK(ElectrodePicFront)
	assert BANK(ElectrodePicFront) == BANK(ElectrodePicBack)
