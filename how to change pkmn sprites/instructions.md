By default, this rom hack uses the sprites from USA red/blue versions (japanese blue) that are stored in the pic/bmon folder.

You may want to recompile using the japanese red/gree sprites in the pic/rgmon folder 
or even the yellow version sprit4es in the pic/ymon folder.

Since these sprites take up more space than the default sprites, some shuffling of data in the rom banks is in order.
Included is a modified main.asm for using ymon sprites and another main.asm for using rgmon sprites.
I've also included an adjusted pokered.link file that will work for both of them. 
You can run a comparison yourself between these files and the originals to see what has changed and why.

Moving on. Simply rename and replace the two files, overwriting the original main.asm and pokered.link, then recompile.