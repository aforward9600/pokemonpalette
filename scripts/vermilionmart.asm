VermilionMartScript:
	jp EnableAutoTextBoxDrawing

VermilionMartTextPointers:
	dw VermilionCashierText
	dw VermilionMartText2
	dw VermilionMartText3
	dw VermilionTMCashierText

VermilionMartText2:
	TX_FAR _VermilionMartText2
	db "@"

VermilionMartText3:
	TX_FAR _VermilionMartText3
	db "@"
