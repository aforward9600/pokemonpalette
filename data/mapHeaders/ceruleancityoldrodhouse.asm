CeruleanCityOldRodHouse_h:
	db HOUSE ; tileset
	db CERULEAN_CITY_OLD_ROD_HOUSE_HEIGHT, CERULEAN_CITY_OLD_ROD_HOUSE_WIDTH ; dimensions (y, x)
	dw CeruleanCityOldRodHouseBlocks, CeruleanCityOldRodHouseTextPointers, CeruleanCityOldRodHouseScript ; blocks, texts, scripts
	db 0 ; connections
	dw CeruleanCityOldRodHouseObject ; objects
