#-------------------------------------------------------------------------------
# Credit: bo4p5687
#-------------------------------------------------------------------------------
PluginManager.register({
  :name => "Display name on map",
  :credits => "bo4p5687"
})
#-------------------------------------------------------------------------------
# If you want to change value for changing Name, call newVdisplay(value)
#     value is value of the name which you want to change
# Example: ["Jack",0],["Picke",1]
#   You want to change Picke, set value = 1
#   Call: newVdisplay(1)
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
# Store Name
#-------------------------------------------------------------------------------
class PokemonGlobalMetadata
  attr_accessor :storeDisplayName

  alias display_name_ini initialize
  def initialize
    @storeDisplayName = {}
    display_name_ini
  end
end

class StoreNameForDisplay
  def storeValue(id,mapid)
    $PokemonGlobal.storeDisplayName = {} if !$PokemonGlobal.storeDisplayName
    if !$PokemonGlobal.storeDisplayName["#{id} #{mapid}"]
      $PokemonGlobal.storeDisplayName["#{id} #{mapid}"] = 0
    end
    return $PokemonGlobal.storeDisplayName["#{id} #{mapid}"]
  end

  def checkValue(id,mapid)
    return $PokemonGlobal.storeDisplayName["#{id} #{mapid}"]
  end

  def setNewValue(value)
    event = pbMapInterpreter.get_character(0)
    $PokemonGlobal.storeDisplayName["#{event.id} #{event.map_id}"] = value
  end
end

def newVdisplay(value)
  s = StoreNameForDisplay.new
  s.setNewValue(value)
end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
class DisplayName
  # Set game switch
  DisplayNameVariable = 100

  SetNameForDisplay =
  [
  # Map id, id of event, name for display
  [2,17,
  # You can set new name if you want to change bitmap, you can delete the name, too.
  # [Name, Value set this name], [Name, Value set this name]
  # Value should start at 0, the next number you can set any numbers but differents.
  [
  ["Jack",0],["Picke",1]
  ]
  ],
  # Map id, id of event, name for display
  [2,21,
  [
  ["Kido",0],["",5]
  ]
  ],
  # Map id, id of event, name for display
  [2,13,
  [
  ["Running man",0]
  ]
  ],
  # Map id, id of event, name for display
  [2,20,
  [
  ["Paul",0]
  ]
  ], # <- this comma
  # Map id, id of event, name for display
  [5,11,
  [
  ["Strange",0],["Rio",10]
  ]
  ]
  # Add , if you want to write next (You can see the lines above)
  # Next
  ]

  def initialize(viewport,event,z)
    @sprites = {}
    @viewport = viewport
    @z = z
    # Set event
    @event = event
    if @event.is_a?(Game_Event)
      @mapid = @event.map_id
      @id = @event.id
      @store = StoreNameForDisplay.new
      @value = @store.storeValue(@id,@mapid)
    end
    @lastframe = 0
  end

  def showName?
    if $game_switches[DisplayNameVariable]
      return true if @event.is_a?(Game_Player)
      if @event.is_a?(Game_Event)
        character = @event.character_name
        ret = false
        for value in SetNameForDisplay
          if @mapid==value[0] && @id==value[1]
            ret = true
            break
          end
        end
        ret = false if character==""
        return ret
      end
    else
      return false
    end
  end

  def create
    @sprites.clear
    drawText
    for sprite in @sprites.values
      sprite.z=9999
    end
    $game_map.update
  end

  BaseColor = Color.new(255,255,255)
  ShadowColor = Color.new(0,0,0)
  def drawText
    if @sprites.include?("overlay")
      @sprites["overlay"].bitmap.clear
    else
      width = Graphics.width; height = Graphics.height
      @sprites["overlay"] = BitmapSprite.new(width,height,@viewport)
      @sprites["overlay"].z = @z + 1
    end
    x = @event.screen_x
    y = @event.screen_y - 70
    if @event.is_a?(Game_Event)
      for value in SetNameForDisplay
        if @mapid==value[0] && @id==value[1]
          for value2 in value[2]
            string = value2[0] if value2[1]==@store.checkValue(@id,@mapid)
          end
        end
      end
    elsif @event.is_a?(Game_Player)
      string = $Trainer.name
    end
    text = [[string,x,y,2,BaseColor,ShadowColor]]
    bitmap = @sprites["overlay"].bitmap
    pbSetSystemFont(bitmap)
    pbDrawTextPositions(bitmap,text)
  end

  def set_visible(value)
    @sprites["overlay"].visible = value if @sprites.include?("overlay")
  end

  def update
    if showName?
      if @sprites.empty?
        create
      else
        if Graphics.frame_count-@lastframe>Graphics.frame_rate/20
          @lastframe = Graphics.frame_count
          drawText
        end
      end
      pbUpdateSpriteHash(@sprites)
    else
      dispose if !@sprites.empty?
    end
  end

  def dispose
    pbDisposeSpriteHash(@sprites)
  end
end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
class Sprite_Character
  alias ini_display_name initialize
  alias visible_display_name visible=
  alias dispose_display_name dispose
  alias update_display_name update

  def initialize(viewport,character=nil)
    @viewport = viewport
    ini_display_name(viewport,character)
  end

  def visible=(value)
    visible_display_name(value)
    @display.set_visible(value) if @display
  end

  def dispose
    dispose_display_name
    @display.dispose if @display
    @display = nil
  end

  def update
    update_display_name
    @display = DisplayName.new(@viewport,@character,self.z) if !@display
    @display.update
  end
end