db DEX_RAICHU ; pokedex id
db 60 ; base hp
db 90 ; base attack
db 55 ; base defense
db 110 ; base speed
db 90 ; base special
db ELECTRIC ; species type 1
db ELECTRIC ; species type 2
db 75 ; catch rate
db 122 ; base exp yield
INCBIN RAICHU_FR,0,1 ; 77, sprite dimensions
dw RaichuPicFront
dw RaichuPicBack
; attacks known at lvl 0
db THUNDERSHOCK
db GROWL
db THUNDER_WAVE
db 0
db 0 ; growth rate
; learnset
	tmlearn 1,4,5,6,8
	tmlearn 10,15,16
	tmlearn 17,19,23,24
	tmlearn 25,31,32
	tmlearn 33,39
	tmlearn 44,45
	tmlearn 50,55
;	db 0 ; padding
	db BANK(RaichuPicFront)
	assert BANK(RaichuPicFront) == BANK(RaichuPicBack)
