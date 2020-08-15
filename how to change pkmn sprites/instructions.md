By default, this rom hack uses the sprites from USA red/blue versions (japanese blue) that are stored in the pic/bmon folder.
The default Gen 1 back sprites are stored in the pic/monback folder

You may want to recompile using the japanese red/green sprites in the pic/rgmon folder 
or even the yellow version sprites in the pic/ymon folder
or even the spaceworld gold beta sprites in the pic/swmon folder. 
Maybe you also want to change the back sprites to something else like the spaceworld back sprites in the pic/swmonback folder.

Since these sprites take up more space than the default sprites, some shuffling of data in the rom banks is in order.
The rom banks have already been moved around from retail in order to facilitate swapping sprites.
	
In the main.asm you must use replace-all to change every instance of bmon in Sections PICS_1 through PICS_7 to your desired 
front sprite folder in /pic/.
For example, replace-all bmon with ymon to use Yellow version front sprites.
Do the same with monback to point to a back sprite folder in /pic/.
For example, replace-all monback with swmonback to use the spaceworld back sprites.
Doing this makes the assembler include the graphics and lets the rgbgfx tool convert the png files into gameboy formats.

Now go to the constants/monfrontpic_constants.asm file.
You must do a replace-all to change all instances of bmon to your desired front sprite folder in /pic/.
For example, replace-all bmon with ymon to use the yellow version front sprites.
This will allow each pokemon's header structure to have the proper image size without needing to edit every baseStats file.

You should now be able to recompile.


Additional Instructions: 
The spaceworld back sprites are in a higher resolution than normal back sprites (48x48 instead of 32x32).
Therefore, further functions must be added and modified or else the back sprites will be interlaced wrong and garbled.


Go to engine/battle/scale_sprites.asm and add the following function at the bottom of the file:

LoadUncompressedBackPics:
	ld a, $66
	ld c, a
	ld de, vBackPic
	jp LoadUncompressedSpriteData
	
		
Now go to engine/battle/core.asm and paste over the LoadMonBackPic function with the following modified function

LoadMonBackPic:
; Assumes the monster's attributes have
; been loaded with GetMonHeader.
	ld a, [wBattleMonSpecies2]
	ld [wcf91], a
	coord hl, 1, 5
	ld b, 7
	ld c, 8
	call ClearScreenArea
	ld hl,  wMonHBackSprite - wMonHeader
	call UncompressMonSprite
	callba LoadUncompressedBackPics
	ld hl, vSprites
	ld de, vBackPic
	ld c, (2*SPRITEBUFFERSIZE)/16 ; count of 16-byte chunks to be copied
	ld a, [H_LOADEDROMBANK]
	ld b, a
	jp CopyVideoData


Recompile and the spaceworld back sprites will now display normally.
