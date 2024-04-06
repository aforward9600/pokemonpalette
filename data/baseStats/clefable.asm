db DEX_CLEFABLE ; pokedex id
db 95 ; base hp
db 70 ; base attack
db 73 ; base defense
db 60 ; base speed
db 95 ; base special
db NORMAL ; species type 1
db NORMAL ; species type 2
db 25 ; catch rate
db 129 ; base exp yield
INCBIN CLEFABLE_FR,0,1 ; 66, sprite dimensions
dw ClefablePicFront
dw ClefablePicBack
; attacks known at lvl 0
db SING
db DOUBLESLAP
db MINIMIZE
db METRONOME
db 4 ; growth rate
; learnset
	tmlearn 1,4,5,6,8
	tmlearn 9,10,11,13,14,15,16
	tmlearn 17,18,19,22,24
	tmlearn 25,29,30,31,32
	tmlearn 33,35,37,38
	tmlearn 44,45
	tmlearn 49,50,54,55
;	db 0 ; padding
	db BANK(ClefablePicFront)
	assert BANK(ClefablePicFront) == BANK(ClefablePicBack)
