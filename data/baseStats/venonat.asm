db DEX_VENONAT ; pokedex id
db 60 ; base hp
db 55 ; base attack
db 50 ; base defense
db 45 ; base speed
db 40 ; base special
db BUG ; species type 1
db POISON ; species type 2
db 190 ; catch rate
db 75 ; base exp yield
INCBIN VENONAT_FR,0,1 ; 55, sprite dimensions
dw VenonatPicFront
dw VenonatPicBack
; attacks known at lvl 0
db TACKLE
db DISABLE
db 0
db 0
db 0 ; growth rate
; learnset
	tmlearn 6
	tmlearn 10
	tmlearn 21,22,23
	tmlearn 29,31,32
	tmlearn 33,36
	tmlearn 41,44
	tmlearn 50
;	db 0 ; padding
	db BANK(VenonatPicFront)
	assert BANK(VenonatPicFront) == BANK(VenonatPicBack)
