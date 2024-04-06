db DEX_MACHAMP ; pokedex id
db 90 ; base hp
db 130 ; base attack
db 80 ; base defense
db 55 ; base speed
db 65 ; base special
db FIGHTING ; species type 1
db FIGHTING ; species type 2
db 45 ; catch rate
db 193 ; base exp yield
INCBIN MACHAMP_FR,0,1 ; 77, sprite dimensions
dw MachampPicFront
dw MachampPicBack
; attacks known at lvl 0
db KARATE_CHOP
db LOW_KICK
db LEER
db 0
db 3 ; growth rate
; learnset
	tmlearn 1,4,5,6,8
	tmlearn 9,10,15,16
	tmlearn 17,18,19
	tmlearn 26,27,28,31,32
	tmlearn 34,35,37,38
	tmlearn 44,48
	tmlearn 50,54
;	db 0 ; padding
	db BANK(MachampPicFront)
	assert BANK(MachampPicFront) == BANK(MachampPicBack)
