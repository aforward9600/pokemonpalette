db DEX_HITMONLEE ; pokedex id
db 50 ; base hp
db 120 ; base attack
db 53 ; base defense
db 87 ; base speed
db 35 ; base special
db FIGHTING ; species type 1
db FIGHTING ; species type 2
db 45 ; catch rate
db 139 ; base exp yield
INCBIN HITMONLEE_FR,0,1 ; 77, sprite dimensions
dw HitmonleePicFront
dw HitmonleePicBack
; attacks known at lvl 0
db DOUBLE_KICK
db MEDITATE
db 0
db 0
db 0 ; growth rate
; learnset
	tmlearn 1,4,5,6,8
	tmlearn 9,10
	tmlearn 17,18,19
	tmlearn 26,27,31,32
	tmlearn 34,37,39
	tmlearn 44,48
	tmlearn 50,54
;	db 0 ; padding
	db BANK(HitmonleePicFront)
	assert BANK(HitmonleePicFront) == BANK(HitmonleePicBack)
