#===============================================================================
# Photo Spot and Album by bo4p5687
#===============================================================================
# How to use:
#  If you want take a photo, call script: pbTakePhoto(0)
#  0, it means the first graphic, see examples
#
#  If you want watch album, call script: pbWatchAlbum
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
Reward_Points = 199   # Variable should be reserved
Special_Points = 200  # Variable should be reserved
#===============================================================================
#===============================================================================
class Photo
#===============================================================================
# How to add a new graphic 
=begin
CONDITION = [
[MAP ID, "NAME GRAPHIC", NUMBER, SPECIALMAP, SCENE_EXTRA], 
[MAP ID, "NAME GRAPHIC", NUMBER, SPECIALMAP, SCENE_EXTRA],
[MAP ID, "NAME GRAPHIC", NUMBER, SPECIALMAP, SCENE_EXTRA]
# You can continue, just keep
# copying and pasting the previous line over and over...
# NAME GRAPHIC can be 1 or multi, 
# If you want in the same map, there are multi scene 
# Ex: "NAME GRAPHIC" -> ["NAME GRAPHIC","NAME GRAPHIC 1","NAME GRAPHIC 2"]
# NUMBER: if you set 0, the scene will change.
# SPECIALMAP: set true if it's a special map, you can get special item
# SCENE_EXTRA: if you set true, it will find image in Graphics\Pictures for
# show such as player, pokemon, just change it x, y for you in SCENE_EXTRA
]
=end
#===============================================================================
#===============================================================================
# * If you want change the scene (color) like the sky, set "true".
CHANGE_SCENE_TONE = true
#===============================================================================
#===============================================================================
CONDITION = [
# Condition
# This is an example:
# The color of scene will not change.
[2, ["Scene","Scene_1","Scene_2"], 1, false, true], 
# The color of scene will change.
[5, "Scene", 0, false, false], 
# The color of scene will not change.
[66, "Scene", 2, true, true]  
]
#===============================================================================
#===============================================================================
# You need to add for show
# If you don't want to show, set false in CONDITION adn set [] in SCENE_EXTRA
# Add graphics
# Just 2 graphics can add same map, if you want more, edit this script
# How to add
=begin
SCENE_EXTRA = [
[["NAME GRAPHIC", X, Y, ORIGIN GRAPHICS],["NAME GRAPHIC", X, Y]],
[], # There aren't graphics because in CONDITION  set false
[["NAME GRAPHIC", X, Y]]
]
# ORIGIN GRAPHICS don't change x, y when zoom, so, if you want the first is origin
# set true like below lines
=end
SCENE_EXTRA = [
# Map 2
[["introBoy",300,290,true],["introGirl",150,290]],
# Map 5
[],
# Map 66
[["introBoy",236,290]]
]
#===============================================================================
#===============================================================================
#===============================================================================
# Take a photo
#===============================================================================

  def initialize
    # Set viewport
    @viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z=99999
    @viewport1=Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport1.z=99998
    # Sprite
    @sprites={}
    # Value
    @count = 0
    @right = 0; @left = 0
    @up = 0; @down = 0
    @zoom = 0
    # Star
    @numberclone = 10
    @ratioappear = 0
    # Set zoom x, y for scene
    @zoom_x = 1.5; @zoom_y = 1.5
    # Person
    @sceneEx = false
  end
#-------------------------------------------------------------------------------
  def pbStart(scene)
    p = Dir.glob("Graphics/Album/Album_screen*.png")
    # Quantity
    @count = p.size
    if @count == 999
      pbMessage(_INTL("Oh! No! I see your album which is full, you must delete these photo before you take a photo."))
    elsif !check_map
      pbMessage(_INTL("It isn't photo spot!"))
    else
      # Choose
      choice = [_INTL("Take a Photo"),_INTL("Cancel")]
      choose = pbMessage(_INTL("What do you want to do?"),choice)
      # Take photo
      if choose == 0
        # Create a album (folder)
        Dir.mkdir("Graphics/Album") if !safeExists?("Graphics/Album")
        pbMessage(_INTL("Ok! Let's do it!"))
        # Set scene
        @scene = (CONDITION[set_i_img][1].size > 1)? scene : 0
        # Draw
        drawScene
        drawSky
        if CONDITION[set_i_img][4]
          @sceneEx = true
          draw_scene_extra
        end
        # Check for message
        doneT = false 
        doneQ = false
        loop do
          # Update
          update_ingame
          # Define
          define # Tone (if CHANGE_SCENE_TONE is true)
          define_sky
          setInput
          if Input.trigger?(Input::B)
            if pbConfirmMessage("Are you sure you want to quit?")
              doneQ = true
              break
            end
          end
          # Take Photo
          if Input.trigger?(Input::A)
            pbWait(2)
            pbCaptureScreenUpgrade
            pbWait(2)
            # Define
            define_reward
            define_special
            # Check take photo
            doneT = true
            break
          end
        end
      end
    end
    pbEndScene
    pbWait(2)
    pbMessage(_INTL("Bye! See you again!")) if doneQ 
    pbMessage(_INTL("Ok! It's done and you can see this photo in your album!")) if doneT
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  # Create sprite
  def create_sprite(spritename,filename,vp)
    @sprites["#{spritename}"] = Sprite.new(vp)
    @sprites["#{spritename}"].bitmap = Bitmap.new("Graphics/Pictures/Photo/ScenePhoto/#{filename}")
  end
  
  def create_sprite_2(spritename,filename,vp)
    @sprites["#{spritename}"] = Sprite.new(vp)
    @sprites["#{spritename}"].bitmap = Bitmap.new("Graphics/Pictures/#{filename}")
  end
  
  # Set x, y 
  def set_xy_sprite(spritename,x,y)
    @sprites["#{spritename}"].x = x
    @sprites["#{spritename}"].y = y
  end
  
  # Set tone
  def set_tone(spritename,tone)
    @sprites["#{spritename}"].tone = tone
  end
  
  # Set zoom
  def set_zoom_xy(spritename)
    @sprites["#{spritename}"].zoom_x = @zoom_x
    @sprites["#{spritename}"].zoom_y = @zoom_y
  end
  
  # Set ox, oy
  def set_oxoy_middle(spritename)
    bitmap = @sprites["#{spritename}"].bitmap
    @sprites["#{spritename}"].ox = bitmap.width/2
    @sprites["#{spritename}"].oy = bitmap.height/2
  end
  
  # Set visible image
  def set_visible_sprite(spritename,vsb=false)
    @sprites["#{spritename}"].visible = vsb
  end
  
  # Create animation sprite
  def create_ani_sprite(spritename,filename,vp)
    @sprites["#{spritename}"] = AnimatedPlane.new(vp)
    @sprites["#{spritename}"].bitmap = Bitmap.new("Graphics/Pictures/Photo/ScenePhoto/#{filename}")
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  # File exist
  def file_exst(name)
    (File.exist?(name))? true : false
  end
#-------------------------------------------------------------------------------
  # Scene spring
  def img_spring(name)
    (pbIsSpring && File.exist?(name))? true : false
  end
#-------------------------------------------------------------------------------
  # Scene summer
  def img_summer(name)
    (pbIsSummer && File.exist?(name))? true : false
  end
#-------------------------------------------------------------------------------
  # Scene autumn
  def img_autumn(name)
    (pbIsAutumn && File.exist?(name))? true : false
  end
#-------------------------------------------------------------------------------
  # Scene winter
  def img_winter(name)
    (pbIsWinter && File.exist?(name))? true : false 
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  # Check map
  def check_map
    (0...CONDITION.size).each{|i| return true if $game_map.map_id == CONDITION[i][0] }
    return false
  end
  
  # Set map
  def set_i_img
    map = $game_map.map_id
    (0...CONDITION.size).each{|i| return i if map == CONDITION[i][0] }
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#===============================================================================
# * Condition how to decrease or increase the reward points
#===============================================================================
  def define_reward
    if !CONDITION[set_i_img][3]
      # Increase
      if @left == 0 && @right == 0 && @up == 0 && @down == 0 && @zoom == 0 || 
        @left == 1 && @down == 2 # you can change this line
        $game_variables[Reward_Points] += 1
      # Decrease
      elsif @left >= 15 && @up == 5 # you can change this line
        $game_variables[Reward_Points] -= 1
        $game_variables[Reward_Points] = 0 if $game_variables[Reward_Points] < 0
      end
    end
  end
#===============================================================================
# * Condition how to decrease or increase the reward points on a beautiful scene
#     (or a special scene) 
#===============================================================================
  def define_special
    if CONDITION[set_i_img][3]
      # * Increase
      if @left == 0 && @right == 0 && @up == 0 && @down == 0 && @zoom == 0 || 
        @left == 1 && @down == 2 # you can change this line
        $game_variables[Special_Points] += 2
      # * Decrease
      elsif @left >= 15 && @up == 5 # you can change this line
        $game_variables[Special_Points] -= 2
        $game_variables[Special_Points] = 0 if $game_variables[Special_Points] < 0
      end
    end 
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#
# Draw scene
#
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  def drawScene
    spritename = "#{CONDITION[set_i_img]}"
    filename = "#{CONDITION[set_i_img][1][@scene]}"
    fol = "Graphics/Pictures/Photo/ScenePhoto/"
    springF = "Spring_" + filename
    summerF = "Summer_" + filename
    autumnF = "Autumn_" + filename
    winterF = "Winter_" + filename
    # Create sprite
    # Spring
    if img_spring(fol+springF+".png")
      create_sprite(spritename,springF,@viewport)
    # Summer
    elsif img_summer(fol+summerF+".png")
      create_sprite(spritename,summerF,@viewport)
    # Autumn
    elsif img_autumn(fol+autumnF+".png")
      create_sprite(spritename,autumnF,@viewport)
    # Winter
    elsif img_winter(fol+winterF+".png")
      create_sprite(spritename,winterF,@viewport)
    else
      create_sprite(spritename,filename,@viewport)
    end 
    set_zoom_xy(spritename)
    bitmap = @sprites["#{spritename}"].bitmap
    x = (SCREEN_WIDTH-bitmap.width*@zoom_x)/2
    y = (SCREEN_HEIGHT-bitmap.height*@zoom_y)/2
    set_xy_sprite(spritename,x,y)
  end
#-------------------------------------------------------------------------------
  def draw_scene_extra
    (0...SCENE_EXTRA[set_i_img].size).each{|i|
    spritename = "spN#{i} #{SCENE_EXTRA[set_i_img][i][0]}"
    filename = "#{SCENE_EXTRA[set_i_img][i][0]}"
    x = SCENE_EXTRA[set_i_img][i][1]
    y = SCENE_EXTRA[set_i_img][i][2]
    create_sprite_2(spritename,filename,@viewport) 
    set_oxoy_middle(spritename)
    set_xy_sprite(spritename,x,y) }
  end
#-------------------------------------------------------------------------------
  def move_xy_extra(xnum,ynum,xchange=false,ychange=false)
    (0...SCENE_EXTRA[set_i_img].size).each{|i|
    spritename = "spN#{i} #{SCENE_EXTRA[set_i_img][i][0]}"
    @sprites["#{spritename}"].x += xnum if xchange 
    @sprites["#{spritename}"].y += ynum if ychange }
  end
#-------------------------------------------------------------------------------
  def zoom_extra(znum,zin=false,zout=false)
    (0...SCENE_EXTRA[set_i_img].size).each{|i|
    spritename = "spN#{i} #{SCENE_EXTRA[set_i_img][i][0]}"
    bitmap = @sprites["#{spritename}"].bitmap
    if zin
      @sprites["#{spritename}"].zoom_x += znum
      @sprites["#{spritename}"].zoom_y += znum
      zx = @sprites["#{spritename}"].zoom_x
      zy = @sprites["#{spritename}"].zoom_y
      ynum = (SCENE_EXTRA[set_i_img][i][2]*znum/10).to_f
      @sprites["#{spritename}"].y += ynum
      if !(SCENE_EXTRA[set_i_img][i].include?(true))
        if SCENE_EXTRA[set_i_img][i][1] < (SCREEN_HEIGHT+bitmap.width)/2
          xnum = (SCENE_EXTRA[set_i_img][i][1]*znum/2).to_f
          @sprites["#{spritename}"].x -= xnum
        else
          xnum = (SCENE_EXTRA[set_i_img][i][1]*znum/5).to_f
          @sprites["#{spritename}"].x += xnum
        end
      else
        # Origin person
        if SCENE_EXTRA[set_i_img][i][1] < (SCREEN_HEIGHT+bitmap.width)/2
          xnum = (SCENE_EXTRA[set_i_img][i][1]*znum/5).to_f
          @sprites["#{spritename}"].x -= xnum
        end
      end
    elsif zout
      @sprites["#{spritename}"].zoom_x -= znum
      @sprites["#{spritename}"].zoom_y -= znum
      zx = @sprites["#{spritename}"].zoom_x
      zy = @sprites["#{spritename}"].zoom_y
      zx = 1 if zx < 1
      zy = 1 if zy < 1
      ynum = (SCENE_EXTRA[set_i_img][i][2]*znum/10).to_f
      @sprites["#{spritename}"].y -= ynum
      if !(SCENE_EXTRA[set_i_img][i].include?(true))
        if SCENE_EXTRA[set_i_img][i][1] < (SCREEN_HEIGHT+bitmap.width)/2
          xnum = (SCENE_EXTRA[set_i_img][i][1]*znum/2).to_f
          @sprites["#{spritename}"].x += xnum
        else
          xnum = (SCENE_EXTRA[set_i_img][i][1]*znum/5).to_f
          @sprites["#{spritename}"].x -= xnum
        end
      else
        # Origin person
        if SCENE_EXTRA[set_i_img][i][1] < (SCREEN_HEIGHT+bitmap.width)/2
          xnum = (SCENE_EXTRA[set_i_img][i][1]*znum/5).to_f
          @sprites["#{spritename}"].x += xnum
        end
      end
    end }
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  def define
    hour = pbGetTimeNow.hour
    spritename = "#{CONDITION[set_i_img]}"
    # Set tone
    if CHANGE_SCENE_TONE
      if CONDITION[set_i_img][2] == 0
        if hour >= 5 && hour < 7
          tone = Tone.new(-40,-50,-35,50)
        elsif hour >= 17 && hour < 20
          tone = Tone.new(-5,-30,-20,0)
        elsif hour >= 20 || hour < 5
          tone = Tone.new(-40,-75,5,40)
        end
      else
        tone = Tone.new(0,0,0,0)
      end
      set_tone(spritename,tone)
    end
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  def drawSky
    # Create sprite
    # Morning
    create_sprite("sky","SceneSky",@viewport1)
    set_visible_sprite("sky")
    (1...5).each{|i|
    create_ani_sprite("cloud#{i}","Cloud#{i}",@viewport1) # Animation script
    set_visible_sprite("cloud#{i}")}
    # Night
    create_sprite("skynight","SceneSkyNight",@viewport1)
    set_visible_sprite("skynight")
    (0...3).each{|i| 
    create_sprite("star#{i}","Star",@viewport1)
    @sprites["star#{i}"].src_rect.width = @sprites["star#{i}"].bitmap.width/3
    @sprites["star#{i}"].src_rect.height = @sprites["star#{i}"].bitmap.height/3
    @sprites["star#{i}"].src_rect.x = 0
    @sprites["star#{i}"].src_rect.y = @sprites["star#{i}"].src_rect.height*i
    set_visible_sprite("star#{i}") }
    # Create star (clone)
    star_clone
    star_clone_vsb(false)
    create_ani_sprite("cloudnight","CloudNight",@viewport1) # Animation script
    set_visible_sprite("cloudnight")
  end
  
  def star_clone
    (0...@numberclone).each{|i|
    rc1 = rand(SCREEN_WIDTH)
    rc2 = rand(SCREEN_HEIGHT/3)
    create_sprite("sClone#{i}","Star",@viewport1)
    @sprites["sClone#{i}"].src_rect.width = @sprites["sClone#{i}"].bitmap.width/3
    @sprites["sClone#{i}"].src_rect.height = @sprites["sClone#{i}"].bitmap.height/3
    @sprites["sClone#{i}"].src_rect.x = 0
    @sprites["sClone#{i}"].src_rect.y = @sprites["sClone#{i}"].src_rect.height*i
    set_xy_sprite("sClone#{i}",rc1,rc2) }
  end
  
  def star_clone_vsb(vsb)
    (0...@numberclone).each{|i| set_visible_sprite("sClone#{i}",vsb)}
  end
#-------------------------------------------------------------------------------
  def sky_morning
    set_visible_sprite("skynight")
    (0...3).each{|i| set_visible_sprite("star#{i}") }
    star_clone_vsb(false)
    set_visible_sprite("cloudnight")
    set_visible_sprite("sky",true)
    (1...5).each{|i| set_visible_sprite("cloud#{i}",true)}
  end
  
  def sky_night
    set_visible_sprite("sky")
    (1...5).each{|i| set_visible_sprite("cloud#{i}")}
    set_visible_sprite("skynight",true)
    (0...3).each{|i| set_visible_sprite("star#{i}",true) }
    star_clone_vsb(true)
    set_visible_sprite("cloudnight",true)
  end
#-------------------------------------------------------------------------------
  def define_sky
    hour = pbGetTimeNow.hour
    if hour >= 5 && hour < 20
      # Set sky
      sky_morning
      # Set speed cloud
      @sprites["cloud1"].ox += 0.75
      @sprites["cloud2"].ox += 0.75
      @sprites["cloud3"].ox += 1
      @sprites["cloud4"].ox += 0.5
      # Set tone
      if hour >= 5 && hour < 7
        tone = Tone.new(-40,-50,-35,50)
      elsif hour >= 17 && hour < 20
        tone = Tone.new(-5,-30,-20,0)
      elsif hour >= 7 && hour < 17
        tone = Tone.new(0,0,0,0)
      end
      (1...5).each{|i| set_tone("cloud#{i}",tone) }
    else
      # Set sky
      sky_night
      @sprites["cloudnight"].ox += 0.4
      if @ratioappear == 0
        (0...3).each{|i| 
        r1 = rand(SCREEN_WIDTH)
        r2 = rand(SCREEN_HEIGHT/3)
        set_xy_sprite("star#{i}",r1,r2) }
      end
      if @ratioappear >= 0 && @ratioappear < 70
        @ratioappear += 1
      elsif @ratioappear >= 70 && @ratioappear < 72
        @ratioappear += 1
        (0...3).each{|i| 
        @sprites["star#{i}"].src_rect.x = @sprites["star#{i}"].src_rect.width }
      elsif @ratioappear >= 72 && @ratioappear < 75
        @ratioappear += 1
        (0...3).each{|i| 
        @sprites["star#{i}"].src_rect.x = @sprites["star#{i}"].src_rect.width*2 }
      elsif @ratioappear >= 75 && @ratioappear < 90
        (0...3).each{|i| @sprites["star#{i}"].src_rect.x = 0 }
        @ratioappear += 1
      elsif @ratioappear >= 90
        @ratioappear = 0
      end
    end
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  # Set input
  def setInput
    # Set sprite
    spritename = "#{CONDITION[set_i_img]}"
    bitmap = @sprites["#{spritename}"].bitmap
    # Set max
    max = 10
    if Input.trigger?(Input::DOWN)
      # Limit
      max_h = (bitmap.height*@zoom_y - SCREEN_HEIGHT)/2
      # Set value
      if @up == 0
        if @down < max
          @down += 1
        else
          @down = max
        end
      elsif @up > 0
        @up -= 1
      else
        @up = 0
      end
      @sprites["#{spritename}"].y -= max_h/max
      if @sprites["#{spritename}"].y < (-max_h*2)
        @sprites["#{spritename}"].y = (-max_h*2)
      else
        move_xy_extra(0,-max_h/max,false,true) if @sceneEx
      end
    end
    if Input.trigger?(Input::UP)
      # Limit
      max_h = (bitmap.height*@zoom_y - SCREEN_HEIGHT)/2
      # Set value
      if @down == 0
        if @up < max
          @up += 1
        else
          @up = max
        end
      elsif @down > 0
        @down -= 1
      else
        @down = 0
      end
      @sprites["#{spritename}"].y += max_h/max
      if @sprites["#{spritename}"].y > 0
        @sprites["#{spritename}"].y = 0
      else
        move_xy_extra(0,max_h/max,false,true) if @sceneEx
      end
    end
    if Input.trigger?(Input::RIGHT)
      # Limit
      max_w = (bitmap.width*@zoom_x - SCREEN_WIDTH)/2
      # Set value
      if @left == 0
        if @right < max
          @right += 1
        else
          @right = max
        end
      elsif @left > 0
        @left -= 1
      else
        @left = 0
      end
      @sprites["#{spritename}"].x -= max_w/(max*2)
      if @sprites["#{spritename}"].x < (-max_w*2)
        @sprites["#{spritename}"].x = (-max_w*2)
      else
        move_xy_extra(-max_w/(max*2),0,true,false) if @sceneEx
      end
    end
    if Input.trigger?(Input::LEFT)
      # Limit
      max_w = (bitmap.width*@zoom_x - SCREEN_WIDTH)/2
      # Set value
      if @right == 0
        if @left < max
          @left += 1
        else
          @left = max
        end
      elsif @right > 0
        @right -= 1
      else
        @right = 0
      end
      @sprites["#{spritename}"].x += max_w/(max*2)
      if @sprites["#{spritename}"].x > 0
        @sprites["#{spritename}"].x = 0
      else
        move_xy_extra(max_w/(max*2),0,true,false) if @sceneEx
      end
    end
    # Zoom in
    if Input.trigger?(Input::L) # Press A
      if @zoom < max
        zoom_extra(0.1,true) if @sceneEx
        @sprites["#{spritename}"].zoom_x += 0.1
        @sprites["#{spritename}"].zoom_y += 0.1
        zx = @sprites["#{spritename}"].zoom_x
        zy = @sprites["#{spritename}"].zoom_y
        @sprites["#{spritename}"].src_rect.width = bitmap.width/zx*@zoom_x*(1.1)
        @sprites["#{spritename}"].src_rect.height = bitmap.height/zy*@zoom_y*(1.1)
        @sprites["#{spritename}"].src_rect.x = bitmap.width*(1-(1/zx*@zoom_x))/2
        @sprites["#{spritename}"].src_rect.y = bitmap.height*(1-(1/zy*@zoom_y))/2
        @zoom += 1
      end
    end
    # Zoom out
    if Input.trigger?(Input::R) # Press S
      if @zoom <= max && @zoom > 0
        zoom_extra(0.1,false,true) if @sceneEx
        @sprites["#{spritename}"].zoom_x -= 0.1
        @sprites["#{spritename}"].zoom_y -= 0.1
        zx = @sprites["#{spritename}"].zoom_x
        zy = @sprites["#{spritename}"].zoom_y
        zx = 1 if zx < 1
        zy = 1 if zy < 1
        @sprites["#{spritename}"].src_rect.width = bitmap.width/zx*@zoom_x*(1.1)
        @sprites["#{spritename}"].src_rect.height = bitmap.height/zy*@zoom_y*(1.1)
        @sprites["#{spritename}"].src_rect.x = bitmap.width*(1-(1/zx*@zoom_x))/2
        @sprites["#{spritename}"].src_rect.y = bitmap.height*(1-(1/zy*@zoom_y))/2
        @zoom -= 1
      end
    end
  end
#-------------------------------------------------------------------------------
  def update_ingame
    Graphics.update
    Input.update
    pbUpdateSpriteHash(@sprites)
  end
#-------------------------------------------------------------------------------
  def pbCaptureScreenUpgrade
    capturefile = nil
    1000.times{|i|
    i+=1
    filename = RTP.getAlbum(sprintf("screen%03d.png",i))
    if !safeExists?(filename)
      capturefile = filename
      break
    end }
    if capturefile && safeExists?("rubyscreen.dll")
      Graphics.snap_to_bitmap(false).saveToPng(capturefile)
      pbSEPlay("Pkmn exp full") if FileTest.audio_exist?("Audio/SE/Pkmn exp full")
    end
  end
#-------------------------------------------------------------------------------
  def pbEndScene
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
    @viewport1.dispose
  end
end
#-------------------------------------------------------------------------------
def pbTakePhoto(scene)
  s = Photo.new
  s.pbStart(scene)
end
#-------------------------------------------------------------------------------
module RTP
  def self.getAlbum(fileName)
    return "Graphics/Album/Album_" + fileName
  end
end