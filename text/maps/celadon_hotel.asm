_CeladonHotelText1::
	text "#MON? No, this"
	line "is a hotel for"
	cont "people."

	para "We're full up."
	done

_CeladonHotelText2::
	text "I'm on vacation"
	line "with my brother"
	cont "and boy friend."

	para "CELADON is such a"
	line "pretty city!"
	done

_CeladonHotelText3::
	text "Why did she bring"
	line "her brother?"
	done
	
;joenote - adding text for the coin guy

_CeladonHotelCoinGuyText_intro::
	text "I'm flushed with"
	line "COINS, yet seeing"
	cont "#MON is what I"
	cont "covet."
	
	para "Show me a "
	line "@"
	TX_RAM wcd6d
	db $0
	cont "and I will give a" 
	cont "nice reward."
	prompt

_CeladonHotelCoinGuyText_needcase::
	text "Oh, remember to"
	line "bring a COIN CASE."
	done

_CeladonHotelCoinGuyText_toomuch::
	text "Too bad your COIN"
	line "CASE is almost"
	cont "bursting as well."
	done

_CeladonHotelCoinGuyText_recieved::
	text "Oh, I see that you"
	line "have one!"
	
	para "I'll give you"
	line "@"
	TX_BCD hCoins, 2 | LEADING_ZEROES | LEFT_ALIGN
	text " coins!"
	done