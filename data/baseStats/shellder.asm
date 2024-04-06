db DEX_SHELLDER ; pokedex id
db 30 ; base hp
db 65 ; base attack
db 100 ; base defense
db 40 ; base speed
db 45 ; base special
db WATER ; species type 1
db WATER ; species type 2
db 190 ; catch rate
db 97 ; base exp yield
INCBIN SHELLDER_FR,0,1 ; 55, sprite dimensions
dw ShellderPicFront
dw ShellderPicBack
; attacks known at lvl 0
db TACKLE
db WITHDRAW
db 0
db 0
db 5 ; growth rate
; learnset
	tmlearn 6
	tmlearn 10,11,13,14
	tmlearn 0
	tmlearn 31,32
	tmlearn 33,36,39
	tmlearn 44,47
	tmlearn 49,50,53
;	db 0 ; padding
	db BANK(ShellderPicFront)
	assert BANK(ShellderPicFront) == BANK(ShellderPicBack)
