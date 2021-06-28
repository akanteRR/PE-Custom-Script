#===============================================================================
# Photo Spot and Album by bo4p5687
#===============================================================================
# How to use:
#  if you want take a photo, call script: pbTakePhoto
#  if you want watch album, call script: pbWatchAlbum
#===============================================================================
#
# To this script works, put it above main.
#
#===============================================================================
PluginManager.register({
  :name    => "Photo Spot and Album",
  :credits => "bo4p5687"
})
#===============================================================================
class Album
#===============================================================================
#===============================================================================
# How to add a item.
=begin
ITEMS.push(
[:NAME ITEM],
[:NAME ITEM],
[:NAME ITEM]
# You can continue, just keep
# copying and pasting the previous line over and over...
)
=end
#===============================================================================
#===============================================================================
ITEMS = []
# This is an example:
ITEMS.push(
[:POTION],
[:SUPERPOTION],
[:FULLRESTORE],
[:REVIVE],
[:PPUP],
[:PPMAX],
[:RARECANDY],
[:REPEL],
[:MAXREPEL],
[:ESCAPEROPE]
)
#===============================================================================
#===============================================================================
# How to add a special item.
=begin
SPECIALITEMS.push(
[:NAME ITEM],
[:NAME ITEM],
[:NAME ITEM]
# You can continue, just keep
# copying and pasting the previous line over and over...
)
=end
#===============================================================================
#===============================================================================
SPECIALITEMS = []
# This is an example:
SPECIALITEMS.push(
[:MASTERBALL]
)
#===============================================================================
# Watch Album
#===============================================================================
  def initialize
    # Set viewport
    @viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z=99999
    @viewport1 = Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport1.z = 99999
    # Sprite
    @sprites={}
    # Set scene
    filename = ["FirstPic","LastPic","PicMid","OnlyOne"]
    (0...4).each{|i|
    spritename = "scene#{i+1}"
    # Create sprite
    create_sprite(spritename,filename[i],@viewport1)
    # Set visible (false)
    set_visible_sprite(spritename) }
    # Value
    @count = 0
    @other = 0
    @select = 0
    @special = 0
    @specialtwo = 0
    @specialthree = 0
    @specialfour = 0
    @push = 0
    @first = 1
    # Exit loop
    @exit = false
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  def pbStart
    if !safeExists?("Graphics/Album")
      pbMessage(_INTL("Oh! I see you don't have album!"))
      pbMessage(_INTL("Hmm! Ok! I will create one for you"))
      # Create folder
      Dir.mkdir("Graphics/Album")
    end  
    # Set picture
    takepic
    choice = [_INTL("View"),_INTL("Check reward"),_INTL("Cancel")]
    choose = pbMessage(_INTL("What do you want to do?"),choice)
    # View
    if choose == 0
      if !File.exist?("Graphics/Album/Album_screen001.png")
        pbMessage(_INTL("Let's see..."))
        pbWait(2)
        pbMessage(_INTL("You don't have any photo! Let's take a photo!"))
      else
        pbMessage(_INTL("Ok! Let's see it..."))
        # Set for message
        doneB = false
        loop do
          # Update
          update_ingame
          break if @exit == true
          # 
          photo
          if Input.trigger?(Input::B)
            if pbConfirmMessage("Are you sure you want to quit?")
              @exit = true; doneB = true
            end
          end
        end
      end
    # Check reward
    elsif choose == 1
      # Point reward
      reward = $game_variables[Reward_Points]
      special = $game_variables[Special_Points]
      # Choose
      request = [_INTL("Check reward points"),_INTL("Check special points"),_INTL("Cancel")]
      chooses = pbMessage(_INTL("Next, what do you want to do?"),request)
      # Item
      if chooses == 0
        pbMessage(_INTL("Let's see..."))
        pbWait(2)
        if reward >= 0 && reward < 100 # You can change this number (100)
          pbMessage(_INTL("You have...#{reward} point."))
          pbMessage(_INTL("I see you don't have enough points. Don't give up!"))
          pbMessage(_INTL("Okay?"))
        else 
          pbMessage(_INTL("You have...#{reward} points."))
          pbMessage(_INTL("Wow! Congratulation! Your point is full. You can get item. Take it!"))
          number = rand(ITEMS.length)
          pbReceiveItem(ITEMS[number][0])
          $game_variables[Reward_Points] = 0
          pbMessage(_INTL("That's all."))
        end
        pbMessage(_INTL("See you again!"))
      # Special item
      elsif chooses == 1
        pbMessage(_INTL("Let's see..."))
        pbWait(2)
        if special >= 0 && special < 200 # You can change this number (200)
          pbMessage(_INTL("You have...#{special} point."))
          pbMessage(_INTL("I see you don't have enough points. Don't give up!"))
          pbMessage(_INTL("Okay?"))
        else
          pbMessage(_INTL("You have...#{special} points."))
          pbMessage(_INTL("Wow! Congratulation! Your point is full. You can get item. Take it!"))
          numbertwo = rand(SPECIALITEMS.length)
          pbReceiveItem(SPECIALITEMS[numbertwo][0])
          $game_variables[Special_Points] = 0
          pbMessage(_INTL("That's all."))
        end
        pbMessage(_INTL("See you again!"))
      elsif chooses == 2
        pbMessage(_INTL("See you again!")) if pbConfirmMessage("Are you sure you want to quit?")
      end
    # Cancel
    elsif choose == 2
      pbMessage(_INTL("See you again!")) if pbConfirmMessage("Are you sure you want to quit?")
    end
    # End
    pbEndScene
    pbMessage(_INTL("See you again!")) if doneB
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  # Create sprite
  def create_sprite(spritename,filename,vp)
    @sprites["#{spritename}"] = Sprite.new(vp)
    @sprites["#{spritename}"].bitmap = Bitmap.new("Graphics/Pictures/Photo/SceneAbum/#{filename}")
  end
  
  # Set visible image
  def set_visible_sprite(spritename,vsb=false)
    @sprites["#{spritename}"].visible = vsb
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  # Set picture
  def takepic
    # Count
    p = Dir.glob("Graphics/Album/Album_screen*.png")
    @count = p.size
    if @count > 0
      @other = p.size - 1
      (0...@count).each{|i|
      screenname = sprintf("screen%03d.png",i + 1)
      if i > 0
        @specialthree = -1
        loop do
          @specialthree += 1
          screennameother = sprintf("screen%03d.png",@specialthree + i + 1)
          if File.exist?("Graphics/Album/Album_" + screennameother)
            File.rename("Graphics/Album/Album_" + screennameother,"Graphics/Album/Album_" + screenname) if !File.exist?("Graphics/Album/Album_" + screenname)
          end
          break if File.exist?("Graphics/Album/Album_" + screenname)
        end
      elsif i == 0
        @specialthree = 0
        loop do
          @specialthree += 1
          screennameother = sprintf("screen%03d.png",@specialthree + i + 1)
          if File.exist?("Graphics/Album/Album_" + screennameother)
            File.rename("Graphics/Album/Album_" + screennameother,"Graphics/Album/Album_" + screenname) if !File.exist?("Graphics/Album/Album_" + screenname)
          end
          break if File.exist?("Graphics/Album/Album_" + screenname)
        end
      end
      @sprites["#{i}"] = Sprite.new(@viewport)
      @sprites["#{i}"].bitmap = Bitmap.new("Graphics/Album/Album_" + screenname)
      @sprites["#{i}"].x = 0
      @sprites["#{i}"].y = 0
      @sprites["#{i}"].visible = false }
    end
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  def photo
    # 1 photo
    if @count == 1
      # Set visible
      set_visible_sprite("scene4",true)
      set_visible_sprite("0",true)
      if Input.trigger?(Input::A) # Press Z
        choices = [_INTL("Delete"),_INTL("Cancel")]
        choose_two = pbMessage(_INTL("Are you sure? If you want to do this, please come back again."),choices)
        if choose_two == 0
          # Delete
          if pbConfirmMessage("Are you sure, again?")
            File.delete("Graphics/Album/Album_screen001.png")
            pbMessage(_INTL("OK! It's done."))
            # Break loop
            @exit = true
          end
        end
      end
    # 2 photos
    elsif @count == 2
      # Set visible
      if @select == 0
        set_visible_sprite("scene1",true)
        set_visible_sprite("0",true)
        set_visible_sprite("scene2",false)
        set_visible_sprite("1",false)
      else
        set_visible_sprite("scene1",false)
        set_visible_sprite("0",false)
        set_visible_sprite("scene2",true)
        set_visible_sprite("1",true)
      end
      @select = 0 if Input.trigger?(Input::LEFT)
      @select = 1 if Input.trigger?(Input::RIGHT)
      if Input.trigger?(Input::A)
        choices = [_INTL("Delete"),_INTL("Cancel")]
        choose_two = pbMessage(_INTL("Are you sure? If you want to do this, please come back again."),choices)
        if choose_two == 0
          # Delete
          if pbConfirmMessage("Are you sure, again?")
            if @select == 1
              File.delete("Graphics/Album/Album_screen002.png")
            else
              File.delete("Graphics/Album/Album_screen001.png")
            end
            pbEndScene
            pbWait(2)
            pbMessage(_INTL("OK! It's done."))
            @exit = true
          end
        end
      end
    # 3 photos
    elsif @count == 3
      # Set visible
      if @special == 0 
        set_visible_sprite("scene1",true)
        set_visible_sprite("0",true)
        (1..2).each{|i|
        set_visible_sprite("scene#{i+1}",false)
        set_visible_sprite("#{i}",false) }
        @select = 0
      elsif @special == 1 
        set_visible_sprite("2",false)
        set_visible_sprite("scene3",true)
        set_visible_sprite("1",true)
        @select = 1
      elsif @special == 2
        set_visible_sprite("2",true)
        set_visible_sprite("scene2",true)
        set_visible_sprite("scene3",false)
        @select = 2
      end
      if Input.trigger?(Input::RIGHT)
        @special += 1
        @special = @other if @special >= @other
      elsif Input.trigger?(Input::LEFT)
        @special -= 1
        @special = 0 if @special <= 0
      end
      if Input.trigger?(Input::A)
        choices = [_INTL("Delete"),_INTL("Cancel")]
        choose_two = pbMessage(_INTL("Are you sure? If you want to do this, please come back again."),choices)
        if choose_two == 0
          # Delete
          if pbConfirmMessage("Are you sure, again?")
            if @select == 2
              File.delete("Graphics/Album/Album_screen003.png")
            elsif @select == 1
              File.delete("Graphics/Album/Album_screen002.png")
            else
              File.delete("Graphics/Album/Album_screen001.png")
            end
            pbEndScene
            pbMessage(_INTL("OK! It's done."))
            @exit = true
          end
        end
      end
    # 4+ photos
    elsif @count >= 4
      # Set visible
      set_visible_sprite("scene1",true)
      set_visible_sprite("0",true)
      @specialfour = -1
      if Input.trigger?(Input::RIGHT)
        @push += 1; @first += 1; @select += 1
        @specialfour = 0
        if @push > @other
          @push = @other
          @select = @other
        elsif @first > @other
          @first = @other + 1
        end
        if @push == @other
          @sprites["scene3"].visible = false
          @sprites["scene2"].visible = true
          @sprites["#@push"].visible = true
        elsif @push < @other
          @sprites["scene1"].visible = false
          @sprites["0"].visible = false
          @sprites["scene3"].visible = true
          @sprites["#@push"].visible = true
        end
      end
      if Input.trigger?(Input::LEFT) 
        @push -= 1; @first = @push + 1; @select = @push; @specialfour = 0
        if @push <= 0
          @push = 0
          @first = 1
        end
        if @push == 1
          @specialtwo = 1
        elsif @push == 0
          @specialtwo = 0
          @specialtwo -= 1
          @specialtwo = -2 if @specialtwo <= -2
        end
        if @push == @other - 1
          @sprites["scene2"].visible = false
          @sprites["#@other"].visible = false
          @sprites["scene3"].visible = true
          @sprites["#@push"].visible = true
        elsif @push <= @other - 2 && @push > 0 || @specialtwo == 1
          @sprites["#@first"].visible = false
          @sprites["scene3"].visible = true
          @sprites["#@push"].visible = true
        elsif @specialtwo < 0 
          @sprites["scene3"].visible = false
          @sprites["1"].visible = false
          @sprites["scene1"].visible = true
          @sprites["0"].visible = true
        end
      end
      if Input.trigger?(Input::A)
        choices = [_INTL("Delete"),_INTL("Cancel")]
        choose_two = pbMessage(_INTL("Are you sure? If you want to do this, please come back again."),choices)
        if choose_two == 0
          # Delete
          if pbConfirmMessage("Are you sure, again?")
            if @select == @other
              @select += 1
              if @other < 10
                File.delete("Graphics/Album/Album_screen00#{@select}.png")
              elsif @other < 100 && @other >= 10
                File.delete("Graphics/Album/Album_screen0#{@select}.png")
              elsif @other < 1000 && @other >= 100
                File.delete("Graphics/Album/Album_screen#{@select}.png")
              end
            elsif @select <= @other - 1 && @select > 0 || @specialtwo == 1
              @select += 1
              if @select < 10
                File.delete("Graphics/Album/Album_screen00#{@select}.png")
              elsif @other < 100 && @other >= 10
                File.delete("Graphics/Album/Album_screen0#{@select}.png")
              elsif @other < 1000 && @other >= 100
                File.delete("Graphics/Album/Album_screen#{@select}.png")
              end
            elsif @specialtwo < 0 || @specialfour == -1
              File.delete("Graphics/Album/Album_screen001.png")
            end
            @specialtwo = 0
            @push = 0
            @first = 1
            @select = 0
            pbMessage(_INTL("OK! It's done."))
            @exit = true
          end
        end
      end
    end
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  def update_ingame
    Graphics.update
    Input.update
    pbUpdateSpriteHash(@sprites)
  end
  
  def pbEndScene
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
    @viewport1.dispose
  end
  
end
#-------------------------------------------------------------------------------
def pbWatchAlbum
  scene = Album.new
  scene.pbStart
end