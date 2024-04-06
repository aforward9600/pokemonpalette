db DEX_FEAROW ; pokedex id
db 65 ; base hp
db 90 ; base attack
db 65 ; base defense
db 100 ; base speed
db 61 ; base special
db NORMAL ; species type 1
db FLYING ; species type 2
db 90 ; catch rate
db 162 ; base exp yield
INCBIN FEAROW_FR,0,1 ; 77, sprite dimensions
dw FearowPicFront
dw FearowPicBack
; attacks known at lvl 0
db PECK
db GROWL
db LEER
db 0
db 0 ; growth rate
; learnset
	tmlearn 2,6
	tmlearn 10,15
	tmlearn 0
	tmlearn 31,32
	tmlearn 39,40
	tmlearn 43,44
	tmlearn 50,52
;	db 0 ; padding
	db BANK(FearowPicFront)
	assert BANK(FearowPicFront) == BANK(FearowPicBack)
