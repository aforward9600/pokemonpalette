db DEX_GYARADOS ; pokedex id
db 95 ; base hp
db 125 ; base attack
db 79 ; base defense
db 81 ; base speed
db 100 ; base special
db WATER ; species type 1
db FLYING ; species type 2
db 45 ; catch rate
db 214 ; base exp yield
INCBIN GYARADOS_FR,0,1 ; 77, sprite dimensions
dw GyaradosPicFront
dw GyaradosPicBack
; attacks known at lvl 0
db BITE
db DRAGON_RAGE
db LEER
db HYDRO_PUMP
db 5 ; growth rate
; learnset
	tmlearn 6,8
	tmlearn 10,11,12,13,14,15
	tmlearn 24
	tmlearn 25,26,31,32
	tmlearn 33,35,38
	tmlearn 44
	tmlearn 50,52,53,54
;	db 0 ; padding
	db BANK(GyaradosPicFront)
	assert BANK(GyaradosPicFront) == BANK(GyaradosPicBack)
