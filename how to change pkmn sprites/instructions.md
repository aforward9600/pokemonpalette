By default, this rom hack uses the sprites from USA red/blue versions (japanese blue) that are stored in the pic/bmon folder.
The default Gen 1 back sprites are stored in the pic/monback folder

You may want to recompile using the japanese red/green sprites in the pic/rgmon folder 
or even the yellow version sprites in the pic/ymon folder
or even the starworld gold beta sprites in the pic/swmon folder. 
Maybe you also want to change the back sprites to something else like the starworld back sprites in the pic/swmonback folder.

Since these sprites take up more space than the default sprites, some shuffling of data in the rom banks is in order.
Included is a modified main.asm and modified pokered.link that does just this.
You can run a comparison yourself between these files and the originals to see what has changed and why.
Simply rename and replace the two files (overwriting the original main.asm and pokered.link).

In the new main.asm you must use replace-all to change every instance of xxxx to your desired front sprite folder in /pic/.
For example, replace-all xxxx with ymon to use Yellow version front sprites.
Do the same with yyyy to point to a back sprite folder in /pic/.
For example, replace-all yyyy with monback to use the default back sprites.

You should now be able to recompile.
