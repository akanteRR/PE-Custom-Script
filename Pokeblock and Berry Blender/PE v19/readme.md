# Audio
Put `Audio` in `Audio\SE`

# Graphics

###### Pokeblock
Put graphics of pokeblock in `Graphics\Pictures\PokeBlock`

###### Berry blender
Put graphics of pokeblock in `Graphics\Pictures\Berry Blender`

# Script

Put `Scripts` in `\Plugins\Pokeblock and Berry Blender`

# How to use

##### Berry blender
> Call: `BerryBlender.show`

You can change players with this method `BerryBlender.show(number)`. number can be
* 0 is single mode (just you)
* 1 is multiple mode (you + 1 player)
* 2 is multiple mode (you + 2 player)
* 3 is multiple mode (you + 3 player)
* 4 is multiple mode (you + 1 player (he is master blender))

##### PokeNav / Pokeblock
You can call like this
> Call: `Pokeblock.show(0)` -> Pokeblock

> Call: `Pokeblock.show(1)` -> PokeNav

Or create items like this
> Pokeblock: `637,POKEBLOCK,Pokeblock,Pokeblock,8,0,"A case for holding Pokeblocks made with a Berry Blender.",2,0,6`

> PokeNav: `638,POKENAV,PokeNav,PokeNav,8,0,"A item for checking Condition's stat.",2,0,6`

##### Change values
Find in folder `1 - Berry blender\Module berry`
* File `1 - Berry.rb` -> Edit berries of master
* Find file `2 - Store method.rb` -> Edit flavor, smooth of berries

If you want to change name of items, find file `1 - Set.rb` of folder `2 - Pokeblock`