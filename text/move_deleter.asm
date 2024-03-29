
_MoveDeleterGreetingText::
	text "Uh... Oh, yes, I'm"
	line "the Move Deleter."
	
	para "I can make"
	line "#mon forget"
	cont "their moves."

	para "Would you like me"
	line "to do that?"
	done

_MoveDeleterSaidYesText::
	text "Which #mon"
	line "should forget a"
	cont "move?"
	prompt

_MoveDeleterWhichMoveText::
	text "Which move should"
	line "be forgotten?"
	done

_MoveDeleterConfirmText::
	text "Make it forget"
	line "@"
	TX_RAM wcf4b
	text "?"
	prompt

_MoveDeleterForgotText::
	text "@"
	TX_RAM wcf4b
	text " was"
	line "forgotten!"
	prompt

_MoveDeleterByeText::
	text "Come again if"
	line "there are other"
	cont "moves to be"
	cont "forgotten."
	done

_MoveDeleterOneMoveText::
	text "That #mon"
	line "has one move."
	cont "Pick another?"
	done
