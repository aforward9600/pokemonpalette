Mansion3_h:
	db CINNABAR ; tileset
	db MANSION_3_HEIGHT, MANSION_3_WIDTH ; dimensions (y, x)
	dw Mansion3Blocks, Mansion3TextPointers, Mansion3Script ; blocks, texts, scripts
	db 0 ; connections
	dw Mansion3Object ; objects
