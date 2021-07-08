#===============================================================================
# * Gender Selection Screen like Sun/Moon (8 characters) by bo4p5687
#===============================================================================
#
# How to use:
#  To use, remove event "Show choices: Boy, Girl" and add script:
#        pbCallGenderSelect
#
# Graphic:
#  You should use images 512x384 for background and background for selecting, 90x106 for Avatar
#  Put the images in folder: Graphics\Pictures\GenderSelection  
#
#===============================================================================
#
# To this script works, put it above main.
#
#===============================================================================
class GenderPickScene
  
  AVATAR = [
  ["AvatarA"], # Name of first Avatar: Player A
  ["AvatarB"], # Name of second Avatar: Player B
  ["AvatarC"], # Name of third Avatar: Player C
  ["AvatarD"], # Name of fourth Avatar: Player D
  ["AvatarE"], # Name of fifth Avatar: Player E
  ["AvatarF"], # Name of sixth Avatar: Player F
  ["AvatarG"], # Name of seventh Avatar: Player G
  ["AvatarH"] # Name of eighth Avatar: Player H
  ]
  X_Y_AVATAR = [
  [68,65], # Player A
  [182,65], # Player B
  [296,65], # Player C
  [410,65], # Player D
  [68,230], # Player E
  [182,230], # Player F
  [296,230], # Player G
  [410,230]  # Player H
  ]
  X_Y_AVATAR_AFTER = [211,100]
  OPACITY_AVATAR = [155,255,0] # Before choose, choose and after choose
  BACKGROUND = "Background" # Name of background
  BACKGROUND_SELECTION = "BackgroundSelect" # Name of background for selecting 
  
  def update
    pbUpdateSpriteHash(@sprites)
  end

  def initialize
    @viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z=99999
    @sprites={}
    @select=0; @exit = false
    # Draw sprite
    # Background
    pbSprite("bg",BACKGROUND,0,0)
    pbSprite("bgslt",BACKGROUND_SELECTION,0,0)
    # Avatar
    (0...AVATAR.size).each{|i| 
    pbSprite(AVATAR[i],AVATAR[i],X_Y_AVATAR[i][0],X_Y_AVATAR[i][1],OPACITY_AVATAR[0])
    }	
  end
  
  def pbEndScene
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end
  
  def pbSprite(name,bitmap,x,y,opacity=255)
    @sprites["#{name}"]=Sprite.new(@viewport)
    @sprites["#{name}"].bitmap=BitmapCache.load_bitmap("Graphics/Pictures/GenderSelection/#{bitmap}")
    @sprites["#{name}"].x=x
    @sprites["#{name}"].y=y
    @sprites["#{name}"].opacity = opacity
  end

  def return_old(name,x,y)
    @sprites["#{name}"].x=x
    @sprites["#{name}"].y=y
  end
  
  def update_ingame
    Graphics.update
    Input.update
    self.update 
  end
  
  def pbGenderSelect
    @progress = 0
    loop do
      update_ingame
      case @progress
        when 0;select_choice
        when 1;after_selecting
      end
      break if @exit
    end
  end
  
  def select_choice
    (0...AVATAR.size).each{|i| 
    if @select == i
      @sprites["#{AVATAR[i]}"].opacity = OPACITY_AVATAR[1] 
    else
      @sprites["#{AVATAR[i]}"].opacity = OPACITY_AVATAR[0] 
    end}
    if Input.trigger?(Input::RIGHT)
      pbSEPlay("Choose")
      pbSEPlay("Anim/Choose")
      @select += 1
      @select = 0 if @select == (AVATAR.size)
    end
    if Input.trigger?(Input::LEFT)
      pbSEPlay("Choose")
      pbSEPlay("Anim/Choose")
      @select -= 1
      @select = (AVATAR.size)-1 if @select < 0
    end
    if Input.trigger?(Input::UP)
      pbSEPlay("Choose")
      pbSEPlay("Anim/Choose")
      if (AVATAR.size)%2 == 0
        @select -= (AVATAR.size)/2 
        if @select %2 == 0
          @select = (AVATAR.size)-2 if @select < 0
        else
          @select = (AVATAR.size)-1 if @select < 1
        end
      else
        @select -= (AVATAR.size+1)/2
        @select = (AVATAR.size-1)/2 if @select == (AVATAR.size-1)/2
        if @select %2 == 0
          @select = (AVATAR.size)-1 if @select < 0
        else
          @select = (AVATAR.size)-2 if @select < 1
        end
      end
    end
    if Input.trigger?(Input::DOWN)
      pbSEPlay("Choose")
      pbSEPlay("Anim/Choose")
      if (AVATAR.size) %2 == 0
        @select += (AVATAR.size)/2 
        if @select %2 == 0
          @select -= (AVATAR.size) if @select >= (AVATAR.size)
        else
          @select -= (AVATAR.size) if @select > (AVATAR.size)
        end
      else
        @select -= (AVATAR.size+1)/2
        @select = (AVATAR.size-1)/2 if @select == (AVATAR.size-1)/2
        if @select %2 == 0
          @select -= (AVATAR.size)+1 if @select > (AVATAR.size)
        else
          @select -= (AVATAR.size)-1 if @select >= (AVATAR.size)
        end
      end
    end
    if Input.trigger?(Input::C)
      pbSEPlay("Choose")
      pbSEPlay("Anim/Choose")
      @sprites["bgslt"].opacity = 0
      @progress = 1
    end
  end
  
  def after_selecting
    (0...AVATAR.size).each{|i| 
    if @select == i
      @sprites["#{AVATAR[i]}"].x = X_Y_AVATAR_AFTER[0]
      @sprites["#{AVATAR[i]}"].y = X_Y_AVATAR_AFTER[1]
    else
      @sprites["#{AVATAR[i]}"].opacity = OPACITY_AVATAR[2]
    end}
    if pbConfirmMessage("You OK with the one you chose,yeah?")
      pbChangePlayer(@select)
      @exit = true
    else
      @sprites["bgslt"].opacity = 255
      return_old(AVATAR[@select],X_Y_AVATAR[@select][0],X_Y_AVATAR[@select][1])
      @progress = 0
    end
  end
  
end

def pbCallGenderSelect
  scene=GenderPickScene.new
  scene.pbGenderSelect
  scene.pbEndScene
end