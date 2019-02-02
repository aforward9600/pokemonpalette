# Pokémon Shin Red and Blue

This is a rom hack of pokemon red & blue based on the Pret team's disassembly.
This is a mostly-vanilla hack that focuses on fixing glitches from the original game.
Additionally, trainer AI routines are also improved and includes minimal quality-of-life improvements.

#Bugfixes:
-----------
- Fixed mistakes in the game text
  - man in cinnabar won't mention raichu evolving
  - Koga correctly says soul badge increases speed
  - Lt. Surge correctly says thunder badge increases defense
  - correct type effectiveness information & sfx should now be displayed when attacking dual-type pkmn
  - viridian girl's notebook 2nd page revised for pkmn-catching effectiveness
  - viridian blackboard BRN info corrected (BRN does not reduce speed)
  - viridian Blackboard PAR info updated
  - Made cinnabar mansion notes more true to the original japanese text

- Battle engine fixes
  - moves no longer have a default 1/256 chance to miss
  - Fixed freeze that occurs in defense stat scaling (def < 4 glitch)
  - Enemy ai ignores type effectiveness for moves that have zero power
  - Enemy ai ignores super-effectiveness for moves that do static amounts of damage
     - prevents things like spamming agility against poison pokemon
  - Fixed skipping move-learn on level-up glitch. 
     - when gaining multiple levels at a time, each in-between level is incrementaly checked for moves learned
     - this prevents a pkmn from skipping learnable moves if gaining multiple levels in battle
  - Burn & Paralyze stat penalties are now properly applied after Speed & Attack stats get updated/recalculated
  - Badge stat-ups don't get stacked anymore
  - If player is frozen, the hyperbeam recharge bit is now cleared
     - now matches how enemy mon's recharge bit is cleared upon being frozen
     - this prevents getting stuck in a loop unable to do anything on your turn
  - Blaine will not use a healing item at full HP
  - Move slots cannot be rearranged when transformed (prevents acquiring glitch moves).
  - The BIRD type has been reinstated and renamed to TYPELESS. It acts as a universally neutral type (particularly for Struggle)
  - AI trainers have priority on switching or using a move
  - AI type effectiveness function now takes type 1 and 2 into account together 
	 - Before AI would only look at the type it encountered first in a list search
     - AI will now treat a move as neutral if type 1 makes it supereffective but type 2 makes it not effective

- Move fixes
  - dire hit/focus energy now quadruples crit rate instead of quarters
  - sleep now normal-chance hits a pkmn recharging from hyperbeam, but has no effect if it's already status-effected
  - the fly/dig invulnerability bit is cleared when a pkmn hurts itself from confusion or is fully paralyzed
  - psywave damage is always min 1 be it an opponent or yourself (prevents desync)
  - all hp drain moves (including dream eater and leech seed) miss against substitute
  - substitute will not work if it would bring you to exactly 0 hp
  - zero power moves that inflict stat-downs, sleep, or paralyze will not affect a substitute
  - the confusion side-effect of damaging moves is blocked by a substitute
  - healing moves work with restoring exactly 255 or 511 hp 
  - light screen and reflect now have a cap of 999
  - haze removing sleep/freeze will not prevent a multi-turn move from getting stuck
     - Fixed by allowing sleeping/frozen pkmn to use a move after haze restores them
     - on the plus size, haze now retores both opponent and user's status conditions as was intended in gen 1
  - Rest now does the following:
     - clears the toxic bit and toxic counter
     - if burn is removed, attack is doubled to undo its stat detriment (not perfect for atk values < 4)
     - if paralyze is removed, speed is quadrupled to undo its stat detriment (not perfect for atk values < 8)
  - fixed-damage moves (seismic toss, dragon rage, etc) can no longer critically hit
  - fixed-damage moves now obey type immunities
  - Transform will no longer copy the opponent's Transform move. It's swapped-out for Struggle
  - Struggle is now TYPELESS so that it can always neutrally damage something
  - Metronome & mirror move will not increment PP if the user is transformed
     - This prevents adding PP to hidden dummy moves that prevent a pkmn from going into Struggle
     - This also prevents Disable from freezing the game by targeting a dummy move
  - Mirror Move is checked against partial trapping moves in a link battle to prevent desync

- Misc. fixes
  - great ball has a ball factor of 12 now
  - Cinnabar/seafoam islands coast glitch fixed (no more missingo or artificially loading pokemon data)
  - Stone evolutions cannot be triggered via level-up anymore

- Bugfixes & tweaks involving Counter...oh boy here we go:
  - now works against all physical types, not just normal & fighting


#TWEAKS:
-----------
- Stat-down moves no longer have a 25% miss chance in AI matches.
- A pkmn plays its cry to signal the last turn of using a trapping move like wrap/clamp/etc
- Trainer ai routine #1 (status recognition) has been modified
  - using a move with a dream eater effect is heavily discouraged against non-sleeping opponents
  - using a move with a dream eater effect is slightly encouraged against a sleeping opponent
  - using a zero-power confusion effect move is heavily discouraged against confused opponents
  - moves that would miss against an active substitute are heavily discouraged
  - stat buff/debuffs are heavily discouraged if it would have no effect due to hitting the buff/debuff stage limit
  - heavily discourage double-using lightscreen, reflect, mist, substitute, focus energy, and leech seed
  - leech seed won't be used against grass pkmn
  - do not use moves that would be blocked by an active mist effect
- Trainer ai routine #3 (choosing effective moves) has been modified
  - It now heavily discourages moves that would have no effect due to type immunity
  - zero-power buffing/debuffing moves are randomly preferenced 12.5% of the time to spice things up
  - zero-power buffing/debuffing moves are randomly discouraged 50% of the time to let ai always have a damage option
  - OHKO moves are heavily discouraged if the ai pkmn is slower than the player pkmn (they would never hit)
  - Static damage moves are randomly preferenced 25% of the time to spice things up
- Trainer ai routine #3 added to the following trainer classes
  - jr trainer M, jr trainer F, hiker, supernerd, engineer, lass, chief, bruno, brock, gentleman, agatha
- Trainer ai routine #4 is no longer unused. It now does rudimentary trainer switching.
  - 25% chance to switch if active pkmn is below 1/3 HP
  - chance to switch based on power of incoming supereffective move
- Trainer ai routine #4 added to the following trainer classes
  -lass, jr trainer m/f, pokemaniac, supernerd, hiker, engineer, beauty, psychic, rocker, tamer, birdkeeper, cooltrainer m/f, gentleman
  -prof.oak, chief, gym leaders, e4
- Trainer stat DVs are now randomly generated to a degree
  - Attack DV is between 9 and 15 and always odd-numbered.
  - Defense, special, and speed DVs are between 8 and 14 and always even-numbered
  - HP DV is always 8 due to how ai trainer pkmn have their HP values set and HP bars drawn
- Special trainers, e4, and gym leaders are slightly adjusted in their item use
- Badge stat-ups are now temporary boosts
  - They are applied upon battle start or switching-in
  - They are not applied at all after stat recalculations, so any stat change on your pkmn cancels all of them
- Ghost moves (i.e. just Lick) do 2x against psychic as was always intended
- The effect of X Accuracy is no longer applied to one-hit K.O. moves (it originally made them auto-hit)
- Pay Day upped to 8x multiplier instead of 2x
  - It's 5x in later generations, but amulet coin doesn't exist in gen 1. 8x is a compromise.
- Pokemon have gained their TMs and Moves from yellow
- Raichu gains some attacks back via level
- Arcanine gains some attacks back via level
- Ninetails gains some attacks back via level
- Poliwrath gains some attacks back via level
- Cloyster gains some attacks back via level
- Starmie gains some attacks back via level
- Exeggcutor gains some attacks back via level
- Vileplume gains some attacks back via level
- Victreebel gains some attacks back via level
- Ditto has its base exp yield increased from 61 to 200
- pikachu and kadabra have their catch rates adjusted to yellow version
- Give haunter/machoke/kadabra/graveler an evo by level option (level 45 to 48)
- Game corner prize costs re-balanced
- Can rematch most non gym-leader trainers
- Rematch with Brock
- Rematch with Misty
- Rematch with Blaine
- Blaine has a touched-up battle sprite so he doesn't look like an alien
  - Snagged this off reddit, but original artist unknown (let me know if this is yours)
- The juggler rosters, especially in fuschia gym, have been slightly altered for flavor
- Just for fun, the last juggler in the fuschia gym is replaced with a cameo of Janine
  - Though at this point she's still just a cooltrainer and doesn't have a unique battle sprite
- Event bit 908 seems to be unused. This bit is now set to indicate the elite 4 have been beaten.
- S.S. Anne can be re-entered after defeating the elite 4.
  - minor text change indicating its return
  - the captain's text has been slightly altered for a more generic context
- Talking to prof oak after beating the elite 4 let's you challenge him to a battle


#Added Encounter Locations for the following pokemon (rare if not normally in the chosen version):
- charmander on route 25
- squirtle on route 6
- bulbasaur on route 4 
- sandshrew/ekans on route 3
- version-swapped sandslash/arbok in unknown dungeon 1f
- vulpix/growlithe on route 8
- oddish/bellsprout on route 24
- meowth/mankey on route 5
- farfetchd on route 12 & 13
- cubone added as rare encounter in rock tunnel
- dodrio is rare on route 17
- version-swapped pinser/scyther in safari zone main
- electabuzz in power plant in both versions (slightly more encountered in red version)
- magmar in pkmn mansion basement in both versions
- snorlax is a rare find in digletts cave
- eevee is a rare find in the route 21 grass
- mew is a rare find in unknown dungeon 2f
- unknown dungeon changes
  - encounter rates between pokemon slightly re-balanced
  - chansey is rarer
  - articuno is rare on 1f
  - zapdos is rare on 2f
  - moltres is rare on b1
  - mew is very rare on b1
  - dittos are rare and only on 2f & b1
  - scripted mewtwo is now at lvl 74
  - super rod in the unknown dungeon basement will yield either a lvl 70 mewtwo clone or glitch-level experiment dittos (a trap encounter)
- route 22 super rod data has changed to give psyduck & polywag
- hitmonchan & hitmonlee in victory road 3f
- lickitung in safari zone 1
- jynx in safari zone 2
- mr mime in safari zone 3
- lapras replaces krabby when using super rod in safari zone
- porygon is in the power plant in red version while blue has increased rate of raichu
- magnemite on route 10
- ponyta on route 7


#Changes to pokemart inventories:
- Celadon dept. store has moon stones
- indigo plateau has fossils/amber
- TMs of all kinds at all stores. All TMs are now re-purchaseable at various stages of the game.
- pewter city has ethers
- lavender town has max ethers
- saffron city has elixers
- cinnabar island has max elixers