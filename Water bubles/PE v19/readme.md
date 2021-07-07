Puts 'Graphics.rar' in 'Graphics\Pictures\Water Bubles'
Puts 'Script.rar' in '\Plugins\Water bubles'

#** How to use **
You can set pokemon who can't have water bubles.
Set in FOLLOWING_NOT_BUBLES -> set number id of pokemon

Set terrain tag in :id_number of this...

GameData::TerrainTag.register({
  :id                     => :Beach,
  :id_number              => 25,
  :beach                  => true
})

...change 25 if you want

Set event can't have this animation, you can use one of these methods to set:
	1. set name of event, add /nowater/
	2. set comment: NoWater
	3. event doesn't have image