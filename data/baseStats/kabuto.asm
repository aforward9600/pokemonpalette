db DEX_KABUTO ; pokedex id
db 30 ; base hp
db 80 ; base attack
db 90 ; base defense
db 55 ; base speed
db 45 ; base special
db ROCK ; species type 1
db WATER ; species type 2
db 45 ; catch rate
db 119 ; base exp yield
INCBIN KABUTO_FR,0,1 ; 55, sprite dimensions
dw KabutoPicFront
dw KabutoPicBack
; attacks known at lvl 0
db SCRATCH
db HARDEN
db 0
db 0
db 0 ; growth rate
; learnset
	tmlearn 6,8
	tmlearn 10,11,13,14
	tmlearn 21
	tmlearn 31,32
	tmlearn 33,34
	tmlearn 41,44,48
	tmlearn 50,53
;	db 0 ; padding
	db BANK(KabutoPicFront)
	assert BANK(KabutoPicFront) == BANK(KabutoPicBack)
