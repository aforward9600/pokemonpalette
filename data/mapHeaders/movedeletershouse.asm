MoveDeletersHouse_h:
	db HOUSE ; tileset
	db MOVE_DELETERS_HOUSE_HEIGHT, MOVE_DELETERS_HOUSE_WIDTH ; dimensions (y, x)
	dw MoveDeletersHouseBlocks, MoveDeletersHouseTextPointers, MoveDeletersHouseScript ; blocks, texts, scripts
	db 0 ; connections
	dw MoveDeletersHouseObject ; objects
