_TM35PreReceiveText::
	text "Objection!"
	line "I made a cool TM!"

	para "It can cause all"
	line "kinds of fun!"
	prompt

_ReceivedTM35Text::
	text "<PLAYER> received "
	line "@"
	TX_RAM wcf4b
	text "!@@"

_TM35ExplanationText::
	text "Take that!"
	line "That's Counter!"

	para "It returns the"
	line "power of physical"
	cont "x2!"
	done

_TM35NoRoomText::
	text "Your pack is"
	line "crammed full!"
	done

_Lab3Text2::
	text "EEVEE can evolve"
	line "into 1 of 3 kinds"
	cont "of #mon."
	done

_Lab3Text3::
	text "There's an e-mail"
	line "message!"

	para "..."

	para "The 3 legendary"
	line "bird #mon are"
	cont "Articuno, Zapdos"
	cont "and Moltres."

	para "Their whereabouts"
	line "are unknown."

	para "We plan to explore"
	line "the cavern close"
	cont "to Cerulean."

	para "From: #mon"
	line "Research Team"

	para "..."
	done

_Lab3Text5::
	text "An amber pipe!"
	done
