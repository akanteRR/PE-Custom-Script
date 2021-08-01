# How to use:
1. About pokeblock
`pbPokeBlock` #-> open Pokeblock or you can use item PokeBlock

`pbPokeNav_Condition` #-> open "check party of PokeNav"

1. About berry blender
```
pbOneplayer #-> mode one player
pbTwoplayers #-> mode two players
pbThreeplayers #-> mode three players
pbFourplayers #-> mode four players
pbSpecialplayer #-> mode special player
```
# Note
1. About pokeblock, create item
532,POKEBLOCK,Pokeblock,Pokeblock,8,0,"A case for holding Pokeblocks made with a Berry Blender.",2,0,6,
1. About pokenav
533,POKENAV,PokeNav,PokeNav,8,0,"A item for checking Condition's stat.",2,0,6,
```
About Gold, there are 2 columns: first, this is create when the berry have 1 flavor and second, when a berry have 2 flavors.
About Black, this creates when you have same berries.
About Gray, there are 3 flavors in a berry and White, there are 4 flavors.
About 2 last color column, first, there are 1 flavor and second, there are 2 flavors in a berry.
```
1. About Berry blender
* You can give the name with the computer (AI).
* About berries of a player special (this is a master berry blender), you can give the name of berries what you want him to play with the player. (note: the name of these berries must is the name of the berries in your file item.txt)
Example:
```
You have this berry:
`389,CHERIBERRY,Cheri Berry,Cheri Berries,5,20,"It may be used or held by a Pokemon to recover from paralysis.",1,1,5,`
You must add Cherri Berry in BERRIES_SPECIAL like examples in my script.
```
* About flavors, this is a flavor of the berries in your file item.txt and each line is a serial flavor of each berry.
Moreover, it's a ascending order of your berries in your file item.txt

Example:
```
first line in my example: [1,0,0,0,-1], -> flavor of "Cheri Berry"
second: [-1,1,0,0,0], -> flavor of "Chesto Berry"
,etc.
```