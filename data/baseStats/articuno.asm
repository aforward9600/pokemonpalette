db DEX_ARTICUNO ; pokedex id
db 90 ; base hp
db 85 ; base attack
db 100 ; base defense
db 85 ; base speed
db 125 ; base special
db ICE ; species type 1
db FLYING ; species type 2
db 3 ; catch rate
db 215 ; base exp yield
INCBIN ARTICUNO_FR,0,1 ; 77, sprite dimensions
dw ArticunoPicFront
dw ArticunoPicBack
; attacks known at lvl 0
db PECK
db ICE_BEAM
db 0
db 0
db 5 ; growth rate
; learnset
	tmlearn 2,6
	tmlearn 10,11,13,14,15.16
	tmlearn 23
	tmlearn 31,32
	tmlearn 33,39,40
	tmlearn 43,44
	tmlearn 50,52
;	db 0 ; padding
	db BANK(ArticunoPicFront)
	assert BANK(ArticunoPicFront) == BANK(ArticunoPicBack)
