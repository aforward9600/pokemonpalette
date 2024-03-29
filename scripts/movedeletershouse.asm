MoveDeletersHouseScript:
	call EnableAutoTextBoxDrawing
	ret

MoveDeletersHouseTextPointers:
	dw MoveDeleterText

MoveDeleterText:
	TX_FAR MoveDeleterText1
	db "@"
