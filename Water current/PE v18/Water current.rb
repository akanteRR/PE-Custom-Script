# Water current
# Credit: Michael, Marcello/Reborn Team, bo4p5687

PluginManager.register({
  :name => "Water current",
  :credits => ["Michael", "Marcello/Reborn Team", "bo4p5687"]
})

# You can find and add the different, if you don't know, just add above main
module PBTerrain
  CurrentLeft = 23
  CurrentUp = 24
  CurrentRight = 25
  CurrentDown = 26

  def self.isJustWater?(tag)
    return tag==PBTerrain::Water ||
           tag==PBTerrain::StillWater ||
           tag==PBTerrain::DeepWater ||
           tag==PBTerrain::CurrentDown ||
           tag==PBTerrain::CurrentLeft ||
           tag==PBTerrain::CurrentRight ||
           tag==PBTerrain::CurrentUp
  end

	def self.isWater?(tag)
    return tag==PBTerrain::Water ||
           tag==PBTerrain::StillWater ||
           tag==PBTerrain::DeepWater ||
           tag==PBTerrain::WaterfallCrest ||
           tag==PBTerrain::Waterfall ||
           tag==PBTerrain::CurrentDown ||
           tag==PBTerrain::CurrentLeft ||
           tag==PBTerrain::CurrentRight ||
           tag==PBTerrain::CurrentUp
  end

  def self.isPassableWater?(tag)
    return tag==PBTerrain::Water ||
           tag==PBTerrain::StillWater ||
           tag==PBTerrain::DeepWater ||
           tag==PBTerrain::WaterfallCrest ||
           tag==PBTerrain::CurrentDown ||
           tag==PBTerrain::CurrentLeft ||
           tag==PBTerrain::CurrentRight ||
           tag==PBTerrain::CurrentUp
  end

  def PBTerrain.isLeft?(tag)
    return tag==PBTerrain::CurrentLeft
  end

  def PBTerrain.isRight?(tag)
    return tag==PBTerrain::CurrentRight
  end

  def PBTerrain.isUp?(tag)
    return tag==PBTerrain::CurrentUp
  end

  def PBTerrain.isDown?(tag)
    return tag==PBTerrain::CurrentDown
  end

  def PBTerrain.isWaterCurrent?(tag)
    return tag==PBTerrain::CurrentDown ||
           tag==PBTerrain::CurrentLeft ||
           tag==PBTerrain::CurrentRight ||
           tag==PBTerrain::CurrentUp
  end
end
#-------------------------------------------------------------------------------
# You can find and add the different, if you don't know, just add above main
class PokemonEncounters
  def isEncounterPossibleHere?
    if $PokemonGlobal.surfing
      if PBTerrain.isWaterCurrent?($game_map.terrain_tag($game_player.x,$game_player.y))
        return false
      else
        return true
      end
    elsif PBTerrain.isIce?(pbGetTerrainTag($game_player))
      return false
    elsif self.isCave?
      return true
    elsif self.isGrass?
      return PBTerrain.isGrass?($game_map.terrain_tag($game_player.x,$game_player.y))
    end
    return false
  end
end
#-------------------------------------------------------------------------------
# Add below lines above Main
class Scene_Map
  alias old_update_wct update
  def update
    old_update_wct
    # Water current
    pbWaterCurrent
  end
end

def pbWaterCurrent
  if !pbMapInterpreterRunning?
    if $PokemonGlobal.surfing && !$game_player.moving?
      terrain = $game_map.terrain_tag($game_player.x,$game_player.y)
      if PBTerrain.isLeft?(terrain)
        pbUpdateSceneMap
        $game_player.move_left
      elsif PBTerrain.isRight?(terrain)
        pbUpdateSceneMap
        $game_player.move_right
      elsif PBTerrain.isUp?(terrain)
        pbUpdateSceneMap
        $game_player.move_up
      elsif PBTerrain.isDown?(terrain)
        pbUpdateSceneMap
        $game_player.move_down
      end
    end
  end
end

# Change repel
Events.onStepTaken += proc {
  if $PokemonGlobal.repel>0
    if !PBTerrain.isIce?($game_player.terrain_tag) && !PBTerrain.isWaterCurrent?($game_player.terrain_tag)   # Shouldn't count down if on ice, on water current
      $PokemonGlobal.repel -= 1
      if $PokemonGlobal.repel<=0
        if $PokemonBag.pbHasItem?(:REPEL) ||
           $PokemonBag.pbHasItem?(:SUPERREPEL) ||
           $PokemonBag.pbHasItem?(:MAXREPEL)
          if pbConfirmMessage(_INTL("The repellent's effect wore off! Would you like to use another one?"))
            ret = 0
            pbFadeOutIn {
              scene = PokemonBag_Scene.new
              screen = PokemonBagScreen.new(scene,$PokemonBag)
              ret = screen.pbChooseItemScreen(Proc.new { |item|
                isConst?(item,PBItems,:REPEL) ||
                isConst?(item,PBItems,:SUPERREPEL) ||
                isConst?(item,PBItems,:MAXREPEL)
              })
            }
            pbUseItem($PokemonBag,ret) if ret>0
          end
        else
          pbMessage(_INTL("The repellent's effect wore off!"))
        end
      end
    end
  end
}

# Change count steps egg
Events.onStepTaken += proc { |_sender,_e|
  if !PBTerrain.isWaterCurrent?($game_map.terrain_tag($game_player.x,$game_player.y)) && !PBTerrain.isIce?($game_map.terrain_tag($game_player.x,$game_player.y))
    for egg in $Trainer.party
      next if egg.eggsteps<=0
      egg.eggsteps -= 1
      for i in $Trainer.pokemonParty
        next if !isConst?(i.ability,PBAbilities,:FLAMEBODY) &&
                !isConst?(i.ability,PBAbilities,:MAGMAARMOR)
        egg.eggsteps -= 1
        break
      end
      if egg.eggsteps<=0
        egg.eggsteps = 0
        pbHatch(egg)
      end
    end
  end
}
