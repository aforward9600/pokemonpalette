_DaisyInitialText::
	text "Hi <PLAYER>!"
	line "<RIVAL> is out at"
	cont "Grandpa's lab."
	done

_DaisyOfferMapText::
	text "Grandpa asked you"
	line "to run an errand?"
	cont "Here, this will"
	cont "help you!"
	prompt

_GotMapText::
	text "<PLAYER> got a"
	line "@"
	TX_RAM wcf4b
	text "!@@"

_DaisyBagFullText::
	text "You have too much"
	line "stuff with you."
	done

_DaisyUseMapText::
	text "Use the Town Map"
	line "to find out where"
	cont "you are."
	done

_BluesHouseText2::
	text "#mon are living"
	line "things! If they"
	cont "get tired, give"
	cont "them a rest!"
	done

_BluesHouseText3::
	text "It's a big map!"
	line "This is useful!"
	done

_DaisyGiveStarterText::
	text "Hey <PLAYER>!"

	para "<RIVAL> wanted me"
	line "to give you this!"

	para "He was too pride-"
	line "ful to give it"
	cont "you himself!"
	done

_TakeGoodCareOfItText::
	text "Take good care"
	line "of it!"
	done
