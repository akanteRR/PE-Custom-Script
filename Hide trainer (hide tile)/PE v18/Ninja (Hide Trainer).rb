#-------------------------------------------------------------------------------
# Credit: bo4p5687
#-------------------------------------------------------------------------------
#
# Remember: Add event in module HideTrainerCV
#
# Call: 
#   hideAllTile -> Show all layer in this map
#   hideSpeTile(x,y) -> Show only one layer in this map (x,y: coordinate of event)
#
#  If you want notice player,
#   Call: 
#    pbNoticeHidePlayer(event) do
#      something 
#    end
#   event: 
#      get_character(0) -> this event; get_character(number) -> number id of event
#   something: call script hideAllTile or hideSpeTile(x,y)
#
#  You can read the notes which are information when you want to do something
#-------------------------------------------------------------------------------
PluginManager.register({
  :name => "Ninja (hide trainer)",
  :credits => "bo4p5687"
})
#-------------------------------------------------------------------------------
# If you use this script: https://www.pokecommunity.com/showthread.php?t=445039 
#   set true and vice versa
UseSootGrassKlein = false
#-------------------------------------------------------------------------------
module PBTerrain
  # Set this terrain if you want to hide event
  # You can change this number
  # Note: You must set it which is the next number in module PBTerrain
  HideTerrain = 17
end
#-------------------------------------------------------------------------------
module HideTrainerCV
  # Use 2 layers: 
  #     Layer 1: new tile
  #     Layer 2: old tile
  # Priority of old tile is 2
  EventValue = []
  # Add like this line: 
  #   Case each map:
  #     Multiple: EventValue.push([ Map id, [ [x,y], [x,y] ]) 
  #     Single  : EventValue.push([ Map id, [ [x,y] ]) 
  
end
#-------------------------------------------------------------------------------
# Store value
class PokemonGlobalMetadata
  attr_accessor :hideTrainer
  
  alias hide_trainer_ini initialize
  def initialize
    @hideTrainer = {}
    hide_trainer_ini
  end
end
#-------------------------------------------------------------------------------
class HideTrainer
  def setTile(all,x=nil,y=nil)
    mapid = $game_map.map_id
    # Set all
    if all
      for tile in HideTrainerCV::EventValue
        for tile2 in tile[1]
          x = tile2[0]; y = tile2[1]
          $PokemonGlobal.hideTrainer["#{mapid} #{x} #{y}"] = true
        end if mapid==tile[0]
      end
    # Set only one tile (set x, y which are coordinate of the tile)
    # Note: you must add it in EventValue.
    else
      $PokemonGlobal.hideTrainer["#{mapid} #{x} #{y}"] = true
    end
  end
  
  def hideTile
    for tile in HideTrainerCV::EventValue
      for tile2 in tile[1]
        if $PokemonGlobal.hideTrainer["#{tile[0]} #{tile2[0]} #{tile2[1]}"]
          mapid = tile[0]; x = tile2[0]; y = tile2[1]
          thistile = $MapFactory.getRealTilePos(mapid,x,y)
          map = $MapFactory.getMap(thistile[0])
          layer = -1
          for i in [2,1,0]
            tile_id = map.data[thistile[1],thistile[2],i]
            next if tile_id.nil?
            if map.terrain_tags[tile_id]==PBTerrain::HideTerrain
              layer = i
              break
            end
          end
          if layer>=0 
            $game_map.setHideTileChange(thistile[1],thistile[2],layer,map.data[thistile[1],thistile[2],layer])
            map.data[thistile[1],thistile[2],layer] = 0
            $scene.spriteset.reloadTiles if $scene.spriteset
            $game_map.update
          end
        end
      end if $game_map.map_id==tile[0]
    end
  end
end
#-------------------------------------------------------------------------------
class Game_Map
  attr_accessor :hideTiles
  def getHideChanges
    @hideTiles=[] if !@hideTiles
    return @hideTiles
  end
  
  def setHideTileChange(x,y,layer,old)
    @hideTiles=[] if !@hideTiles
    @hideTiles.push([x,y,layer,old])
  end
end
#-------------------------------------------------------------------------------
class PokemonMapFactory
  def setCurrentMap
    return if $game_player.moving?
    return if $game_map.valid?($game_player.x,$game_player.y)
    newmap=getNewMap($game_player.x,$game_player.y)
    return if !newmap
    # Set it if you use Klein's script
    if UseSootGrassKlein
      for soot in $game_map.getSootChanges
        $game_map.data[soot[0],soot[1],soot[2]] = soot[3]
      end
      if $game_map.getSootChanges.length!=0
        $scene.spriteset.reloadTiles if $scene.spriteset
        $game_map.sootTiles.clear
      end
    end
    # Set hide tile
    for tile in $game_map.getHideChanges
      $game_map.data[tile[0],tile[1],tile[2]] = tile[3]
    end
    if $game_map.getHideChanges.length!=0
      $scene.spriteset.reloadTiles if $scene.spriteset
      $game_map.hideTiles.clear
      $PokemonGlobal.hideTrainer = {}
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
#-------------------------------------------------------------------------------
class Spriteset_Map
  # Check if use Soot Grass
  if !UseSootGrassKlein
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
end
#-------------------------------------------------------------------------------
# Set all
def hideAllTile
  tile = HideTrainer.new
  tile.setTile(true,nil,nil)
  tile.hideTile
end
 
# Set specicial tile
# x, y: coordinate of event
def hideSpeTile(x,y)
  tile = HideTrainer.new
  tile.setTile(false,x,y)
  tile.hideTile
end
#-------------------------------------------------------------------------------
# Call: 
#  pbNoticeHidePlayer(event) do
#    something 
#  end
# event: get_character(0) -> this event; get_character(number) -> number id of event
# something: call script hideAllTile or hideSpeTile(x,y)
def pbNoticeHidePlayer(event)
  pbExclaim(event) if !pbFacingEachOther(event,$game_player)
  yield
  pbTurnTowardEvent($game_player,event)
  pbMoveTowardPlayer(event)
end