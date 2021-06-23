#===============================================================================
# ? Sootgrass fix by KleinStudio
# http://kleinstudio.deviantart.com
#
# bo4p5687 (update)
#
# * The fix added a new feature, now you can warp the sootgrass tile with another
# one if you want. If you don't add that setting the tile will just be delete
# like in the original system. If you use different sootgrass tiles you can
# add a custom setting for all of them.
#
# There are 2 methods for adding tile id
# 1. If there are many tilesets in your project and set it in many maps, 
#    set SetMapForSoot = true
#
# To add a new setting, copy and paste this below #SootGrasses Settings
#
# SootGrasses.push([[[oldTileId, newTileId]], map id])
#
# If you want more in one map, use this
# SootGrasses.push([[[oldTileId, newTileId],[oldTileId, newTileId]], map id])
#
# 2. If you want like the old script, many maps but same tile id or one map
#    many tile id, set SetMapForSoot = false
# 
# To add a new setting, copy and paste this below #SootGrasses Settings
#
# SootGrasses.push([oldTileId, newTileId])
#
# * How to get the tile id 
#    Imagine this is a tileset, tiles id are like this
#    [00][01][02][03][04][05][06][07]
#    [08][09][10][11][12][13][14][15]
#    [16][17][18][19][20][21][22][23]...
#===============================================================================
PluginManager.register({
  :name => "Sootgrass fix",
  :credits => ["KleinStudio (original)","bo4p5687 (update)"]
})
#===============================================================================
SetMapForSoot = false
# Add in this
SootGrasses=[]
#SootGrasses Settings
# Add
 
 
# Gather soot from soot grass
Events.onStepTakenFieldMovement += proc { |_sender,e|
  event = e[0] # Get the event affected by field movement
  thistile = $MapFactory.getRealTilePos(event.map.map_id,event.x,event.y)
  mapid = event.map.map_id
  map = $MapFactory.getMap(thistile[0])
  sootlevel = -1
  for i in [2,1,0]
    tile_id = map.data[thistile[1],thistile[2],i]
    next if tile_id==nil
    if map.terrain_tags[tile_id]==PBTerrain::SootGrass
      sootlevel = i
      break
    end
  end
  if sootlevel>=0 && hasConst?(PBItems,:SOOTSACK)
    newTile = nil
    for tile in SootGrasses
      if SetMapForSoot
        for tile2 in tile[0]
          newTile = tile2[1]+384 if tile2[0]+384==map.data[thistile[1],thistile[2],sootlevel]
        end if mapid==tile[1]
      else
        for tile in SootGrasses
          newTile = tile[1]+384 if tile[0]+384==map.data[thistile[1],thistile[2],sootlevel]
        end
      end
    end
    $PokemonGlobal.sootsack = 0 if !$PokemonGlobal.sootsack
#    map.data[thistile[1],thistile[2],sootlevel]=0
    $game_map.setSootTileChange(thistile[1],thistile[2],sootlevel,map.data[thistile[1],thistile[2],sootlevel])
    map.data[thistile[1],thistile[2],sootlevel] = (newTile!=nil)? newTile : 0
    if event==$game_player && $PokemonBag.pbHasItem?(:SOOTSACK)
      $PokemonGlobal.sootsack += 1
    end
#    $scene.createSingleSpriteset(map.map_id)
    $scene.spriteset.reloadTiles if $scene.spriteset
  end
}
 
class Game_Map
  attr_accessor :sootTiles
  def getSootChanges
    @sootTiles=[] if !@sootTiles
    return @sootTiles
  end
  
  def setSootTileChange(x,y,l,old)
    @sootTiles=[] if !@sootTiles
    @sootTiles.push([x,y,l,old])
  end
end
 
class PokemonMapFactory
  def setCurrentMap
    return if $game_player.moving?
    return if $game_map.valid?($game_player.x,$game_player.y)
    newmap=getNewMap($game_player.x,$game_player.y)
    return if !newmap
    for soot in $game_map.getSootChanges
      $game_map.data[soot[0],soot[1],soot[2]] = soot[3]
    end
    if $game_map.getSootChanges.length!=0
      $scene.spriteset.reloadTiles if $scene.spriteset
      $game_map.sootTiles.clear
    end
    oldmap=$game_map.map_id
    if oldmap!=0 && oldmap!=newmap[0].map_id
      setMapChanging(newmap[0].map_id,newmap[0])
    end
    $game_map = newmap[0]
    @mapIndex = getMapIndex($game_map.map_id)
    $game_player.moveto(newmap[1],newmap[2])
    $game_map.update
    pbAutoplayOnTransition
    $game_map.refresh
    setMapChanged(oldmap)
  end
end
 
class Spriteset_Map
  def reloadTiles
    @tilemap.dispose
    @tilemap = TilemapLoader.new(@@viewport1)
    @tilemap.tileset = pbGetTileset(@map.tileset_name)
    for i in 0...7
      autotile_name = @map.autotile_names[i]
      @tilemap.autotiles[i] = pbGetAutotile(autotile_name)
    end
    @tilemap.map_data = @map.data
    @tilemap.priorities = @map.priorities
    @tilemap.terrain_tags = @map.terrain_tags
  end
end