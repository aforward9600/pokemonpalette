By default, this rom hack uses the sprites from USA red/blue versions (japanese blue) that are stored in the pic/bmon folder.
The default Gen 1 back sprites are stored in the pic/monback folder

You may want to recompile using the japanese red/green sprites in the pic/rgmon folder 
or even the yellow version sprites in the pic/ymon folder
or even the spaceworld gold beta sprites in the pic/swmon folder. 
Maybe you also want to change the back sprites to something else like the spaceworld back sprites in the pic/swmonback folder.

Since these sprites take up more space than the default sprites, some shuffling of data in the rom banks is in order.
Included is a modified main.asm and pokered.link that does just this.
You can run a comparison yourself between these files and the originals to see what has changed and why.
Simply rename and replace the files (overwriting the originals).


You must now go into home.asm and paste over the UncompressMonSprite function with the following function.

UncompressMonSprite::
	ld bc, wMonHeader
	add hl, bc
	ld a, [hli]
	ld [wSpriteInputPtr], a    ; fetch sprite input pointer
	ld a, [hl]
	ld [wSpriteInputPtr+1], a
;joenote - expanding this to use 7 rom banks to fit the spaceworld back sprites
; define (by index number) the bank that a pokemon's image is in
; index = Mew, bank 1
; index < $19, bank PICS_1
; $19 ≤ index < $32, bank PICS_2
; $32 ≤ index < $58, bank PICS_3
; $58 ≤ index < $76, bank PICS_4
; $76 ≤ index < $95, bank PICS_5
; $95 ≤ index < $B4, bank PICS_6
; $B4 ≤ index,       bank PICS_7
	ld a, [wcf91] ; XXX name for this ram location
	ld b, a
	cp MEW
	ld a, BANK(MewPicFront)
	jr z, .GotBank
	ld a, b
	cp TENTACOOL + 1
	ld a, BANK(TentacoolPicFront)
	jr c, .GotBank
	ld a, b
	cp GOLEM + 1
	ld a, BANK(GolemPicFront)
	jr c, .GotBank
	ld a, b
	cp RAICHU + 3
	ld a, BANK(RaichuPicFront)
	jr c, .GotBank
	ld a, b
	cp PRIMEAPE + 1
	ld a, BANK(PrimeapePicFront)
	jr c, .GotBank
	ld a, b
	cp ABRA + 1
	ld a, BANK(AbraPicFront)
	jr c, .GotBank
	ld a, b
	cp WARTORTLE + 1
	ld a, BANK(WartortlePicFront)
	jr c, .GotBank
	ld a, BANK(VictreebelPicFront)
.GotBank
	jp UncompressSpriteData

	
In the new main.asm you must use replace-all to change every instance of xxxx to your desired back sprite folder in /pic/.
For example, replace-all xxxx with monback to use the default back sprites.

Now go to the constants/monfrontpic_constants.asm file.
You must do a replace-all to change all instances of bmon to your desired front sprite folder in /pic/.
For example, replace-all bmon with ymon to use the yellow version front sprites.

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