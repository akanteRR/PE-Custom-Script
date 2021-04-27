#-------------------------------------------------------------------------------
# Mach & Acro Bike Script
# By Rei
# Credits required
# bo4p5687 (update)
#-------------------------------------------------------------------------------
# * Adds the Support for Acro Bikes and Mach Bikes!
#
# * How To Use (Acro Bike):
#    - Insert Script
#    - Edit the AcroBikeFileName Setting to what your Acro Bike Graphics would be
#    - ADD THE GRAPHICS INTO THE CHARACTERS FOLDER
#    - ADD THE ITEM "ACROBIKE" (The internal name must be ACROBIKE at the very
#       least)
#
# * How To Use (Mach Bike):
#   - ADD THE ITEM "MACHBIKE" (The internal name must be MACHBIKE at the very
#       least)
#
# * How to create Acro Bike Rails:
#   - Go into the Tileset Editor (through DEBUG mode or Essentials)
#   - Find your desired Acro Bike Rails and set their Terrain Tag to (18 for Up/Down Rails) or (19 for Left/Right Rails)
#   - Go into RMXP's tileset editor and set the passages (4dir) of the rails
#     to what it would normally be to pass (EG: Rails left and right need the
#     left and right passages open but the top and bottom closed)
#
#
# * How to create Acro Bike Stepping Stones:
#   - Go into the Tileset Editor (through DEBUG mode or Essentials)
#   - Find your desired Acro Bike Stepping Stones and set their Terrain Tag to 20
#   - Go into RMXP's tileset editor and set the passages of the stepping stones
#     to impassable (the script will allow you to move on them while hopping)
#
# * How to create Mach Bike Slopes:
#   - Go into the Tileset Editor (through DEBUG mode or Essentials)
#   - Find your desired Mach Bike Slopes and set their Terrain Tag to 21
#   - Go into RMXP's tileset editor and set the passages of the slope to passable
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------

if defined?(PluginManager)
  PluginManager.register({
    :name => "Mach & Acro Bike",
    :credits => ["Rei","bo4p5687 (update)"]
  })
end

module Settings
  AcroBikeFileName = [
  "boyAcro", # Player A
  "girlAcro", # Player B
  "", # Player C
  "", # Player D
  "", # Player E
  "", # Player F
  ]

  # Image when biking (without press Z in keyboard)
  NormalBikeFileName =
  [
  "boy_bike", # Player A
  "girl_bike", # Player B
  "", # Player C
  "", # Player D
  "", # Player E
  "", # Player F
  ]
end

module PBTerrain
  ACROBIKEUpDown = 18
  ACROBIKELeftRight = 19
  ACROBIKEHOP = 20
  MACHBIKE = 21

  def self.isAcroBike?(tag)
    return tag==PBTerrain::ACROBIKEUpDown ||
           tag==PBTerrain::ACROBIKELeftRight
  end

  def self.isUDAcroBike?(tag)
    return tag==PBTerrain::ACROBIKEUpDown
  end

  def self.isLRAcroBike?(tag)
    return tag==PBTerrain::ACROBIKELeftRight
  end

  def self.isAcroBikeHop?(tag)
    return tag==PBTerrain::ACROBIKEHOP
  end

  def self.isMachBike?(tag)
    return tag==PBTerrain::MACHBIKE
  end
end

#Remember:
#Use 18 for the rails where player just goes up / down
#and 19 for the rails where player just goes left / right
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
class Game_Character
  def jumpAB(x_plus, y_plus)
    tag = $game_map.terrain_tag($game_player.x,$game_player.y)
    if !PBTerrain.isAcroBike?(tag)
      if x_plus != 0 or y_plus != 0
        if x_plus.abs > y_plus.abs
          (x_plus < 0) ? turn_left : turn_right
        else
          (y_plus < 0) ? turn_up : turn_down
        end
      end
    end
    if PBTerrain.isLRAcroBike?($game_map.terrain_tag($game_player.x,$game_player.y-1)) ||
      PBTerrain.isLRAcroBike?($game_map.terrain_tag($game_player.x,$game_player.y+1))
      if x_plus != 0 || y_plus != 0
        turn_right if $game_player.direction==8
        turn_left if $game_player.direction==2
      end
    elsif PBTerrain.isUDAcroBike?($game_map.terrain_tag($game_player.x-1,$game_player.y)) ||
      PBTerrain.isUDAcroBike?($game_map.terrain_tag($game_player.x+1,$game_player.y))
      if x_plus != 0 || y_plus != 0
        turn_down if ($game_player.direction==4 || $game_player.direction==6)
      end
    end
    new_x = @x + x_plus
    new_y = @y + y_plus
    if (x_plus == 0 and y_plus == 0) || passable?(new_x, new_y, 0)
      @x = new_x
      @y = new_y
      real_distance = Math::sqrt(x_plus * x_plus + y_plus * y_plus)
      distance = [1, real_distance].max
      @jump_peak = distance * Game_Map::TILE_HEIGHT * 3 / 8   # 3/4 of tile for ledge jumping
      @jump_distance = [x_plus.abs * Game_Map::REAL_RES_X, y_plus.abs * Game_Map::REAL_RES_Y].max
      @jump_distance_left = 0.5   # Just needs to be non-zero
      if real_distance > 0   # Jumping to somewhere else
        @jump_count = 0
      else   # Jumping on the spot
				@jump_speed_real = nil   # Reset jump speed
        @jump_count = Game_Map::REAL_RES_X / jump_speed_real   # Number of frames to jump one tile
      end
      @stop_count = 0
      if self.is_a?(Game_Player)
        $PokemonTemp.dependentEvents.pbMoveDependentEvents
      end
      triggerLeaveTile
    end
  end
end

class Game_Player
  alias old_up_command_new update_command_new
  def update_command_new
    dir = Input.dir4
    unless pbMapInterpreterRunning? || $game_temp.message_window_showing ||
           $PokemonTemp.miniupdate || $game_temp.in_menu
      tag = $game_map.terrain_tag($game_player.x,$game_player.y)
      if PBTerrain.isUDAcroBike?(tag)
        return if dir == 4 || dir == 6
      elsif PBTerrain.isLRAcroBike?(tag)
        return if dir == 2 || dir == 8
      end
    end
    old_up_command_new
  end
end

class PokemonGlobalMetadata
  attr_accessor :acrobike
  attr_accessor :machbike
  alias bikeini initialize
  def initialize
    bikeini
    @acrobike = false
    @machbike = false
  end
end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#
#
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
class Game_Map
  attr_accessor :acrobikejump
  attr_accessor :machbike_speed

  alias initialize_ab initialize
  def initialize
    # Old initialize
    initialize_ab
    # Set bike
    @acrobikejump = 0
    @machbike_speed = 0
  end

  def playerPassable?(x, y, d, self_event = nil)
    bit = (1 << (d / 2 - 1)) & 0x0f
    for i in [2, 1, 0]
      tile_id = data[x, y, i]
      terrain = @terrain_tags[tile_id]
      passage = @passages[tile_id]
      # Ignore bridge tiles if not on a bridge
      next if PBTerrain.isBridge?(terrain) && $PokemonGlobal.bridge==0
      # Make water tiles passable if player is surfing
      if $PokemonGlobal.surfing && PBTerrain.isPassableWater?(terrain)
        return true
      # Prevent cycling in really tall grass/on ice
      elsif $PokemonGlobal.bicycle && PBTerrain.onlyWalk?(terrain)
        return false
      # Acro bike
      elsif $PokemonGlobal.acrobike && PBTerrain.isAcroBike?(terrain)
        return (passage & bit == 0)
      elsif $PokemonGlobal.acrobike && PBTerrain.isAcroBikeHop?(terrain)
        if @acrobikejump==1
          return true
        else
          return false
        end
      elsif !$PokemonGlobal.acrobike && (PBTerrain.isAcroBike?(terrain) || PBTerrain.isAcroBikeHop?(terrain))
        return false
      # Depend on passability of bridge tile if on bridge
      elsif PBTerrain.isBridge?(terrain) && $PokemonGlobal.bridge>0
        return (passage & bit == 0 && passage & 0x0f != 0x0f)
      # Regular passability checks
      elsif terrain!=PBTerrain::Neutral
        if passage & bit != 0 || passage & 0x0f == 0x0f
          return false
        elsif @priorities[tile_id] == 0
          return true
        end
      end
    end
    return true
  end

  alias old_update_ab update
  def update
    # Old update
    old_update_ab
    if $PokemonGlobal.machbike
      if Input.dir4 > 0
        @machbike_speed += 0.1
        @machbike_speed = 3 if @machbike_speed > 3
        # Set speed
        $game_player.move_speed = 3 + @machbike_speed.floor
      else
        @machbike_speed = 0
        # Set speed
        $game_player.move_speed = 3
      end
    else
      @machbike_speed = 0
    end
  end
end
#-------------------------------------------------------------------------------
class Scene_Map
  alias old_update_ab update
  def update
    old_update_ab
    # Mach Bike
    pbMachBikeMove
    # Acro Bike
    pbAcroBike
  end
end
#-------------------------------------------------------------------------------
def pbMachBikeMove
  return if pbMapInterpreterRunning?
  fterrain = $game_map.terrain_tag($game_player.x,$game_player.y)
  return if $game_map.machbike_speed >= 2 || !PBTerrain.isMachBike?(fterrain)
  if $game_player.direction == 8
    m = 0
    loop do
      Graphics.update
      Input.update
      pbUpdateSceneMap
      m += 0.2
      break if m == 2.6
      # Move
      $game_player.move_down if m == 2.4
    end
    # Reset
    $game_map.machbike_speed = 0
  elsif $game_player.direction == 2 || $game_player.direction == 4 || $game_player.direction == 6
    # Move
    $game_player.move_down
    # Reset
    $game_map.machbike_speed = 0
  end
end
#-------------------------------------------------------------------------------
# Set graphic for using acro bike
def changePlayerAcroBike
  graphic = Settings::AcroBikeFileName[$PokemonGlobal.playerID]
  $game_player.character_name = graphic if File.exist?("Graphics/Characters/#{graphic}.png")
end
# Set graphic for normal bike but you still use acro bike
def returnPlayerAcroBike
  graphic = Settings::NormalBikeFileName[$PokemonGlobal.playerID]
  $game_player.character_name = graphic if File.exist?("Graphics/Characters/#{graphic}.png")
end
# Acro bike
def pbAcroBike
  return if pbMapInterpreterRunning?
  return if !$PokemonGlobal.acrobike
  if PBTerrain.isMachBike?($game_map.terrain_tag($game_player.x,$game_player.y))
    returnPlayerAcroBike
    return
  end
  if Input.press?(Input::A)
    # Change graphic
    changePlayerAcroBike
    $game_player.jump(0,0) if Input.dir4==0 && Input.count(Input::A)==1
    direction = nil if !direction
    case 1
    when Input.count(Input::DOWN)
      x = $game_player.x
      y = $game_player.y + 1
      d = $game_player.direction
      tag = $game_map.terrain_tag(x, y)
			direction = PBTerrain.isMachBike?(tag) ? nil : 2
    when Input.count(Input::UP)
			x = $game_player.x
      y = $game_player.y - 1
      d = $game_player.direction
      tag = $game_map.terrain_tag(x, y)
			direction = PBTerrain.isMachBike?(tag) ? nil : 8
    when Input.count(Input::LEFT)
			x = $game_player.x - 1
      y = $game_player.y
      d = $game_player.direction
      tag = $game_map.terrain_tag(x, y)
			direction = PBTerrain.isMachBike?(tag) ? nil : 4
    when Input.count(Input::RIGHT)
			x = $game_player.x + 1
      y = $game_player.y
      d = $game_player.direction
      tag = $game_map.terrain_tag(x, y)
			direction = PBTerrain.isMachBike?(tag) ? nil : 6
    end
    if !direction.nil? && !$game_player.pbFacingEvent && ( passableAB(x,y,d,tag) || PBTerrain.isAcroBikeHop?(tag) )
      $game_map.acrobikejump = 1 if PBTerrain.isAcroBikeHop?(tag)
			case direction
			when 2; x = 0; y = 1    # down
			when 4; x = -1; y = 0   # left
			when 6; x = 1; y = 0    # right
			when 8; x = 0; y =-1    # up
			end
			pbMoveRoute($game_player, [14, x, y], true)
			while $game_player.jumping?
				Graphics.update
				Input.update
				pbUpdateSceneMap
			end
      $game_map.acrobikejump = 0
      direction = nil
    end
    if PBTerrain.isLRAcroBike?($game_map.terrain_tag($game_player.x,$game_player.y))
      $game_player.turn_right if $game_player.direction==8
      $game_player.turn_left if $game_player.direction==2
    elsif PBTerrain.isUDAcroBike?($game_map.terrain_tag($game_player.x,$game_player.y))
      $game_player.turn_down if ($game_player.direction==4 || $game_player.direction==6)
    end
  else; returnPlayerAcroBike # Set normal bike (Acro bike)
  end
end
def passableAB(x,y,d,tag)
  return $game_map.passable?(x, y, d, $game_player) || PBTerrain.isAcroBike?(tag)
end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
def pbCancelVehicles(destination=nil)
  $PokemonGlobal.surfing = false
  $PokemonGlobal.diving  = false
  if !destination || !pbCanUseBike?(destination)
    $PokemonGlobal.bicycle = false
    $PokemonGlobal.machbike = false
    $PokemonGlobal.acrobike = false
  end
  pbUpdateVehicle
end
def pbDismountBike
  return if !$PokemonGlobal.bicycle
  $PokemonGlobal.bicycle = false
  $PokemonGlobal.machbike = false
  $PokemonGlobal.acrobike = false
  pbUpdateVehicle
  $game_map.autoplayAsCue
end
# Set player cant surf when he is on rail.
# If you use pokemon following of Golipod, copy this def and puts it below the script Following
alias ab_surf pbSurf
def pbSurf
  tag = $game_map.terrain_tag($game_player.x,$game_player.y)
  return false if PBTerrain.isAcroBikeHop?(tag) || PBTerrain.isAcroBike?(tag)
  return ab_surf
end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
ItemHandlers::UseInField.add(:BICYCLE,proc { |item|
  if pbBikeCheck
    $PokemonGlobal.machbike = false
    $PokemonGlobal.acrobike = false
    if $PokemonGlobal.bicycle
      pbDismountBike
    else
      pbMountBike
      # Add sound
      pbSEPlay('Bicycle Horn',100,100)
    end
    next 1
  end
  next 0
})
# Add Acro Bike Property
ItemHandlers::UseInField.add(:ACROBIKE,proc { |item|
  if pbBikeCheck
    $PokemonGlobal.machbike = false
    if $PokemonGlobal.acrobike
      pbDismountBike
    else
      pbMountBike
      $PokemonGlobal.acrobike = true
      # Add sound
      pbSEPlay('Bicycle Horn',100,100)
    end
    next 1
  end
  next 0
})
# Add Mach Bike Property
ItemHandlers::UseInField.add(:MACHBIKE,proc { |item|
  if pbBikeCheck
    $PokemonGlobal.acrobike = false
    if $PokemonGlobal.machbike
      pbDismountBike
    else
      pbMountBike
      $PokemonGlobal.machbike = true
      # Add sound
      pbSEPlay('Bicycle Horn',100,100)
    end
    next 1
  end
  next 0
})