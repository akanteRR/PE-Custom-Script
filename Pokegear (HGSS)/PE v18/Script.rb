#-------------------------------------------------------------------------------
# HGSS Pokegear menu
# Credit: bo4p5687, graphics by Richard PT
#-------------------------------------------------------------------------------
PluginManager.register({
  :name    => "HGSS Pokegear Menu",
  :credits => ["bo4p5687", "graphics by Richard PT"]
})
#-------------------------------------------------------------------------------
class PokemonGlobalMetadata
  attr_accessor :backgroundPokegear
  
  alias backgroundNew initialize
  def initialize
    @backgroundPokegear = 0
    backgroundNew
  end
end
#-------------------------------------------------------------------------------
# Call player in pokegear (signal)
def canCall
  # Map (player can't call, here)
  map = []
  return false if map && map.include?($game_map.map_id)
  return true
end
#-------------------------------------------------------------------------------
class PokemonPokegear_Scene
  
  # Music
  ListMusicRadio = [
  # Display name, Name of music (file)
  ["March","Radio - March"],
  ["Lullaby","Radio - Lullaby"],
  ["Oak","Radio - Oak"],
  # Add new music here
  # Example: ["Music","Radio - Music"],
  # [],
  # Custom (use the file in "Audio/BGM/")
  ["Custom"]
  ]
  
  def initialize
    @sprites={}
    @viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z = 99999
    @viewport1 = Viewport.new(36,16,412,292)
    @viewport1.z = 99999
    @viewport2 = Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport2.z = 99999
    @exit = false
    $PokemonGlobal.backgroundPokegear = 0 if !$PokemonGlobal.backgroundPokegear
    # Background number: 0, 1, 2, 3, 4, 5
    @background = $PokemonGlobal.backgroundPokegear
    @process = 0
    @features = 0
    @beforeshowmap = 0
    @choose = 0; @change = true; @otherfeatures = true
    @listmusic = ["Default"]; @select = 0; @custom = false
    @trainers = []; @store = []; @choice = 0; @sort = false; @sortselect = 0
    @frame = 0; @current = 0
    @se = 0
  end
  
  def start
    
    # Start
    loop do
      # Update
      update_ingame
      # Exit
      break if @exit
      case @process
      # Main page
      when 0
        @beforeshowmap = 0
        # Dispose
        dispose
        clearTxt("text 2") if @sprites["text 2"]
        clearTxt("text 3") if @sprites["text 3"]
        # Scene
        chooseScene
        @process = 5
      # Customize
      when 1
        @beforeshowmap = 1
        @otherfeatures = true
        # Dispose
        dispose
        clearTxt("text 2") if @sprites["text 2"]
        clearTxt("text 3") if @sprites["text 3"]
        # Draw
        drawBar
        sceneCustomize
        @process = 6
      # Radio
      when 2
        @beforeshowmap = 2
        @otherfeatures = true
        # Dispose
        dispose
        clearTxt("text 2") if @sprites["text 2"]
        clearTxt("text 3") if @sprites["text 3"]
        # Draw
        drawBar
        sceneRadio
        @process = 8
      # Map
      when 3
        # Dispose
        dispose
        clearTxt("text 2") if @sprites["text 2"]
        clearTxt("text 3") if @sprites["text 3"]
        # Show map
        pbShowMapPokegear
        # Change
        case @beforeshowmap
        when 0; @process = 0
        when 1; @process = 1
        when 2; @process = 2
        when 3; @process = 4
        end
      # Phone
      when 4
        @beforeshowmap = 3
        @otherfeatures = true
        # Dispose
        dispose
        clearTxt("text 2") if @sprites["text 2"]
        clearTxt("text 3") if @sprites["text 3"]
        # Draw
        drawBar
        scenePhone
      # Main page (control)
      when 5
        # Redraw time
        x = setPositionTime[0]; y = setPositionTime[1]
        drawTime(x,y)
        # Input
        chooseFeature
        # Mouse
        chooseFeatureMouse
      # Customize page (control)
      when 6
        setPositionFrame
        # Input
        chooseCustomize
        # Mouse
        chooseCustomizeMouse
        chooseFeatureMouse
      # Customize page (change background)
      when 7
        # Input, mouse
        chooseChangeCustom
        sePlayAll
      # Radio page (control)
      when 8
        # Input
        chooseRadio
        # Mouse
        chooseRadioMouse
        chooseFeatureMouse
      # Phone page (control - no phone numbers)
      when 9
        # Input
        chooseFeature
        # Mouse
        chooseFeatureMouse
      # Phone page (control)
      when 10
        # Input
        choosePhone
        # Mouse
        choosePhoneMouse
        chooseFeatureMouse
      # Phone page (Show information)
      when 11
        animationIcon
        # Input, mouse
        choosePhoneInformation
        sePlayAll
      # Phone page (Call)
      when 12
        # Input, mouse
        choosePhoneSelect
        sePlayAll
      end
    end
    # End
    endScene
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  def pbShowMapPokegear
    scene = PokemonRegionMap_Scene.new(-1,false)
    screen = PokemonRegionMapScreen.new(scene)
    createBlackScreen
    screen.pbStartScreen
  end
  
  def createBlackScreen
    create_sprite("map","mapbg",@viewport,"Pictures")
    @sprites["map"].color.alpha = 255
  end
#-------------------------------------------------------------------------------
# # Scene
#-------------------------------------------------------------------------------
  # Main Page
  DayOfWeek = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
  def chooseScene
    # Scene
    create_sprite("scene","Background",@viewport)
    set_src_wh_sprite("scene",SCREEN_WIDTH,SCREEN_HEIGHT)
    set_src_xy_sprite("scene",SCREEN_WIDTH*@background,0)
    # Draw text
    create_sprite_2("text",@viewport)
    x = setPositionTime[0]; y = setPositionTime[1]
    drawTime(x,y)
    # Phone signal
    filename = (canCall)? "signalon" : "signaloff"
    create_sprite("signal",filename,@viewport)
    x += 230
    y = (@background==2)? y-15 : y+5
    set_xy_sprite("signal",x,y)
    #(@background==2)? set_angle_sprite("signal",5) : set_angle_sprite("signal",0)
    # Bar (features)
    drawBar
  end
  
  def drawBar
    # Bar
    create_sprite("bar","Bar",@viewport)
    set_src_wh_sprite("bar",SCREEN_WIDTH,55)
    set_src_xy_sprite("bar",SCREEN_WIDTH*@background,0)
    set_xy_sprite("bar",0,SCREEN_HEIGHT-55)
    # Icon
    create_sprite("customize","Icon",@viewport)
    create_sprite("radio","Icon",@viewport)
    create_sprite("map","Icon",@viewport)
    create_sprite("phone","Icon",@viewport)
    create_sprite("exit","Icon",@viewport)
    srcw = 80; srch = 52
    set_src_wh_sprite("customize",srcw,srch)
    set_src_wh_sprite("radio",srcw,srch)
    set_src_wh_sprite("map",srcw,srch)
    set_src_wh_sprite("phone",srcw,srch)
    set_src_wh_sprite("exit",srcw,srch)
    srcx = 0; srcy = 52*@background
    set_src_xy_sprite("customize",srcx,srcy)
    set_src_xy_sprite("radio",srcx+srcw,srcy)
    set_src_xy_sprite("map",srcx+srcw*2,srcy)
    set_src_xy_sprite("phone",srcx+srcw*3,srcy)
    set_src_xy_sprite("exit",srcx+srcw*4,srcy)
    x = 25; y = SCREEN_HEIGHT - 54
    set_xy_sprite("customize",x,y)
    set_xy_sprite("radio",x+srcw+15,y)
    set_xy_sprite("map",x+srcw*2+30,y)
    set_xy_sprite("phone",x+srcw*3+45,y)
    set_xy_sprite("exit",x+srcw*4+60,y)
    # Icon when choose
    create_sprite("customize2","Icon after",@viewport)
    create_sprite("radio2","Icon after",@viewport)
    create_sprite("map2","Icon after",@viewport)
    create_sprite("phone2","Icon after",@viewport)
    create_sprite("exit2","Icon after",@viewport)
    set_src_wh_sprite("customize2",srcw,srch)
    set_src_wh_sprite("radio2",srcw,srch)
    set_src_wh_sprite("map2",srcw,srch)
    set_src_wh_sprite("phone2",srcw,srch)
    set_src_wh_sprite("exit2",srcw,srch)
    set_src_xy_sprite("customize2",srcx,srcy)
    set_src_xy_sprite("radio2",srcx+srcw,srcy)
    set_src_xy_sprite("map2",srcx+srcw*2,srcy)
    set_src_xy_sprite("phone2",srcx+srcw*3,srcy)
    set_src_xy_sprite("exit2",srcx+srcw*4,srcy)
    set_xy_sprite("customize2",x,y)
    set_xy_sprite("radio2",x+srcw+15,y)
    set_xy_sprite("map2",x+srcw*2+30,y)
    set_xy_sprite("phone2",x+srcw*3+45,y)
    set_xy_sprite("exit2",x+srcw*4+60,y)
    set_visible_sprite("customize2")
    set_visible_sprite("radio2")
    set_visible_sprite("map2")
    set_visible_sprite("phone2")
    set_visible_sprite("exit2")
    # Select icon (rectangle)
    create_sprite("selectI","Select Icon",@viewport)
    set_xy_sprite("selectI",x+(srcw+15)*@features,y)
  end
  
  def setPositionTime
    width = 270; height = 45
    case @background
    when 0,1; x = (SCREEN_WIDTH-width)/2; y = 78
    when 2; x = 120; y = 100
    when 3; x = 125; y = 75
    when 4; x = (SCREEN_WIDTH-width)/2; y = 35
    else; x = 125; y = 80
    end
    return ret = [x,y]
  end
  
  def drawTime(x,y)
    (@background == 2)? set_angle_sprite("text",3) : set_angle_sprite("text",0)
    time = Time.now; hour = time.hour; min = time.min
    hour = "0#{hour}" if hour < 10
    min = "0#{min}" if min < 10
    string = "#{hour} : #{min}    #{DayOfWeek[time.wday]}"
    text = []
    text<<[string,x,y,0,BaseColor,ShadowColor]
    drawTxt("text",text)
  end
#-------------------------------------------------------------------------------
  # Customize Page
  def sceneCustomize
    # Scene
    create_sprite("customize scene","Page customize",@viewport)
    set_src_wh_sprite("customize scene",SCREEN_WIDTH,SCREEN_HEIGHT)
    set_src_xy_sprite("customize scene",SCREEN_WIDTH*@background,0)
    # Select
    create_sprite("customize frame","Frame",@viewport)
    create_sprite("customize select frame","Select Frame",@viewport)
    # Change menu
    create_sprite("customize change menu","Change Menu",@viewport)
    create_sprite("customize select change","Select Change",@viewport)
    width = @sprites["customize select change"].bitmap.width
    height = @sprites["customize select change"].bitmap.height
    set_src_wh_sprite("customize select change",width,height/2)
    set_src_xy_sprite("customize select change",0,0)
    set_visible_sprite("customize change menu")
    set_visible_sprite("customize select change")
    @choose = @background
    setPositionFrame
  end
  
  def setPositionFrame
    xa = [46,207,367]
    x = (@choose%3==0)? xa[0] : (@choose%3==1)? xa[1] : xa[2]
    y = (@choose<3)? 52 : 210
    set_xy_sprite("customize frame",x,y)
    set_xy_sprite("customize select frame",x-10,y-10)
  end
  
  def sceneChooseCustom
    set_visible_sprite("customize change menu",true)
    xa = [46,207,367]
    x = (@choose%3==0)? xa[0]+108 : (@choose%3==1)? xa[1]+108 : xa[2]-138
    y = (@choose<3)? 52 : 210
    set_xy_sprite("customize change menu",x,y)
    return ret = [x,y]
  end
#-------------------------------------------------------------------------------
  # Set text (radio, phone)
  def setTextRP
    # Text
    create_sprite_2("text 2",@viewport1) if !@sprites["text 2"]
    clearTxt("text 2")
    create_sprite_2("text 3",@viewport1) if !@sprites["text 3"]
    clearTxt("text 3")
  end
  
  # Set position of arrow
  def posArrow(range)
    y = 16 + 48*range
    set_xy_sprite("arrow",26,y)
  end
  
  # Radio page
  def sceneRadio
    @select = 0
    # Scene
    create_sprite("radio scene","Page Radio",@viewport)
    set_src_wh_sprite("radio scene",SCREEN_WIDTH,SCREEN_HEIGHT)
    set_src_xy_sprite("radio scene",SCREEN_WIDTH*@background,0)
    # List music
    putMusicCustom
    # Text
    (@custom)? nameMusic(1) : nameMusic(0)
    # Arrow
    create_sprite("arrow","Arrow",@viewport)
    posArrow(@select)
  end
  
  # Put the files in "Audio/BGM/"
  def putMusicCustom
    @listmusic = ["Default"]
    Dir.chdir("Audio/BGM/") {
      Dir.glob("*.mp3") { |f| @listmusic.push(f) }
      Dir.glob("*.MP3") { |f| @listmusic.push(f) }
      Dir.glob("*.ogg") { |f| @listmusic.push(f) }
      Dir.glob("*.OGG") { |f| @listmusic.push(f) }
      Dir.glob("*.wav") { |f| @listmusic.push(f) }
      Dir.glob("*.WAV") { |f| @listmusic.push(f) }
      Dir.glob("*.mid") { |f| @listmusic.push(f) }
      Dir.glob("*.MID") { |f| @listmusic.push(f) }
      Dir.glob("*.midi") { |f| @listmusic.push(f) }
      Dir.glob("*.MIDI") { |f| @listmusic.push(f) } }
  end
  
  # Radio (draw name)
  def nameMusic(list)
    # Text (bitmap)
    setTextRP
    # List: 0: begin; 1: custom 
    max = (list==0)? ListMusicRadio.length : @listmusic.length
    textpos = []
    endnum = (max>0 && max<6)? max : 6
    pos = (max>0 && max<6)? 0 : (@select>=max-6)? max-6 : @select
    (0...endnum).each { |i|
      string = (list==0)? ListMusicRadio[pos+i][0] : @listmusic[pos+i]
      x = 10; y = 5+50*i
      textpos<<[string,x,y,0,ShadowColor,BaseColor]
    }
    drawTxt("text 2",textpos)
  end
  
  # Set song
  def songPlayBGM(song=nil,white=false,black=false)
    $game_system.setDefaultBGM(song)
    $PokemonMap.whiteFluteUsed = white if $PokemonMap
    $PokemonMap.blackFluteUsed = black if $PokemonMap
  end
  
  def fluteMusic(white=false,black=false)
    $PokemonMap.whiteFluteUsed = white if $PokemonMap
    $PokemonMap.blackFluteUsed = black if $PokemonMap
  end
#-------------------------------------------------------------------------------
  # Phone page
  def scenePhone
    @select = 0
    # Scene
    create_sprite("phone scene","Page Phone",@viewport)
    set_src_wh_sprite("phone scene",SCREEN_WIDTH,SCREEN_HEIGHT)
    set_src_xy_sprite("phone scene",SCREEN_WIDTH*@background,0)
    # List Trainer (phonebook)
    putTrainerList
    (@trainers.length==0)? (@process=9) : (continueScenePhone;@process = 10)
  end
    
  def continueScenePhone
    # Text
    namePhone
    # Arrow
    create_sprite("arrow","Arrow",@viewport)
    posArrow(@select)
    create_sprite("arrow2","Arrow Sort",@viewport)
    posArrowSort(@sortselect)
    visibleSortArrow
    # Choose 
    create_sprite("phone menu","Phone Menu",@viewport2)
    pos = posPhoneMenu
    set_visible_sprite("phone menu")
    @choice==0
    create_sprite("phone select","Phone Select",@viewport2)
    x = pos[0] + 8; y = 10
    set_xy_sprite("phone select",x,y)
    width = @sprites["phone select"].bitmap.width
    height = @sprites["phone select"].bitmap.height
    set_src_wh_sprite("phone select",width,height/3)
    set_src_xy_sprite("phone select",0,height/3*@choice)
    set_visible_sprite("phone select")
    # Information
    create_sprite("phone information","Information",@viewport2)
    set_src_wh_sprite("phone information",340,202)
    set_src_xy_sprite("phone information",340*@background,0)
    set_xy_sprite("phone information",-340,12)
    # Rematch
    rematchIcon
  end
  
  # Set position of arrow (sort)
  def posArrowSort(range)
    y = 16 + 48*range
    set_xy_sprite("arrow2",26,y)
  end
  
  def visibleSortArrow
    if @sort
      set_visible_sprite("arrow")
      set_visible_sprite("arrow2",true)
    else
      set_visible_sprite("arrow",true)
      set_visible_sprite("arrow2")
    end
  end
  
  def posPhoneMenu
    x = 224; y = 169
    set_xy_sprite("phone menu",x,y)
    return ret = [x,y]
  end
  
  # Trainer list
  def putTrainerList
    @trainers = []; @store = []
    if $PokemonGlobal.phoneNumbers
      for num in $PokemonGlobal.phoneNumbers
        if num[0]   # if visible
          if num.length==8   # if trainer
            @trainers.push([num[1],num[2],num[6],(num[4]>=2)])
            @store.push([num[1],num[2],num[6],num[7]]) # Store
          else               # if NPC
            @trainers.push([num[1],num[2],num[3]])
            @store.push([num[1],num[2],num[3]]) # Store
          end
        end
      end
    end
  end
  
  def setForSorting(order)
    if $PokemonGlobal.phoneNumbers
      (0...$PokemonGlobal.phoneNumbers.size).each { |i|
      num = $PokemonGlobal.phoneNumbers[i]
      if num[0] # if visible
        if num.length==8 # Trainer
          if @store[order][0]==num[1] && @store[order][1]==num[2] &&
            @store[order][2]==num[6] && @store[order][3]==num[7]
            return ret = [i,num]
            break
          end
        else # NPC
          if @store[order][0]==num[1] && @store[order][1]==num[2] &&
            @store[order][2]==num[3]
            return ret = [i,num]
            break
          end
        end
      end }
    end
  end
  
  def sortTrainer(old,new)
    if $PokemonGlobal.phoneNumbers
      oldnum = setForSorting(old)
      newnum = setForSorting(new)
      $PokemonGlobal.phoneNumbers[oldnum[0]] = newnum[1]
      $PokemonGlobal.phoneNumbers[newnum[0]] = oldnum[1]
    end
  end
  
  # Name trainer
  def namePhone(order=nil)
    # Set text
    setTextRP
    # Write list
    num = (order.nil?)? @select : @sortselect
    max = @trainers.length
    text = []
    endnum = (max>0 && max<6)? max : 6
    pos = (max>0 && max<6)? 0 : (num>=max-6)? max-6 : num
    (0...endnum).each { |i|
      x = 10; y = 50*i + 5
      if @trainers[pos+i].length==4 
        string = pbGetMessageFromHash(MessageTypes::TrainerNames,@trainers[pos+i][1])
      else
        string = @trainers[pos+i][1]
      end
      text<<[string,x,y,0,ShadowColor,BaseColor]
      if @trainers[pos+i].length==4
        x += 165
        string = PBTrainers.getName(@trainers[pos+i][0])
        text<<[string,x,y,0,BaseColor,ShadowColor]
      end
    }
    drawTxt("text 3",text)
  end
  
  def showInformationTrainer(show)
    pos = (@sort)? @sortselect : @select
    text = []
    if show
      5.times { @sprites["phone information"].x += 68 } if @sprites["phone information"].x<340
      if @trainers[pos].length==4
        filename = pbTrainerCharFile(@trainers[pos][0])
      else
        filename = sprintf("Graphics/Characters/phone%03d",@trainers[pos][0])
      end
      @sprites["phone icon"] = Sprite.new(@viewport2)
      @sprites["phone icon"].bitmap = Bitmap.new(filename)
      charwidth  = @sprites["phone icon"].bitmap.width
      charheight = @sprites["phone icon"].bitmap.height
      set_src_wh_sprite("phone icon",charwidth/4,charheight/4)
      set_src_xy_sprite("phone icon",0,0)
      x = 24; y = @sprites["phone information"].y + 28
      set_xy_sprite("phone icon",24,28)
      create_sprite_2("text 4",@viewport2) if !@sprites["text 4"]
      clearTxt("text 4")
      # Up
      x = 100; y = @sprites["phone information"].y+20
      width = 220; height = 30
      string = "Location :"
      text<<[string,x,y,0,BaseColor,ShadowColor]
      string = (@trainers[pos][2]) ? pbGetMessage(MessageTypes::MapNames,@trainers[pos][2]) : ""
      text<<[string,x+10,y+35,0,BaseColor,ShadowColor]
      # Down
      x = 10; y = @sprites["phone information"].y+114
      width = 330; height = 50
      string = "Registered : #{@trainers.length}"
      text<<[string,x,y+5,0,BaseColor,ShadowColor]
      string = "Waiting for a rematch : #{rematchCount}"
      text<<[string,x,y+44,0,BaseColor,ShadowColor]
      drawTxt("text 4",text)
    else
      set_visible_sprite("phone icon")
      clearTxt("text 4") if @sprites["text 4"]
      5.times { @sprites["phone information"].x -= 68} if @sprites["phone information"].x<340
    end
  end
  
  def rematchCount
    rematch = 0
    (0...@trainers.length).each { |i| 
    rematch+=1 if @trainers[i].length==4 && @trainers[i][3] }
    return rematch
  end
  
  def animationIcon
    charwidth = @sprites["phone icon"].bitmap.width/4
    @frame+=1
    if @frame==5
      @frame = 0
      @current+=1
      @current%=4
      set_src_xy_sprite("phone icon",@current*charwidth,0)
    end
  end
  
  # Set rematch icon
  def rematchIcon
    (0...@trainers.length).each { |i| x = 0; y = 5
    create_sprite_3("rematch #{i}",x,y,"phoneRematch",@viewport1) if !@sprites["rematch #{i}"]
    set_visible_sprite("rematch #{i}",(@trainers[i].length==4 && @trainers[i][3])) }
  end
  
#-------------------------------------------------------------------------------
# Choose feature (Input)
#-------------------------------------------------------------------------------
  def chooseFeature
    set_xy_sprite("selectI",25+95*@features,SCREEN_HEIGHT-54)
    if Input.trigger?(Input::LEFT)
      pbPlayDecisionSE
      @features -= 1
      @features = 4 if @features < 0
    end
    if Input.trigger?(Input::RIGHT)
      pbPlayDecisionSE
      @features += 1
      @features = 0  if @features > 4
    end
    if Input.trigger?(Input::C)
      (@features==4)? pbPlayCloseMenuSE : pbPlayDecisionSE
      case @features
      # Customize
      when 0
        set_visible_sprite("customize2",true)
        pbWait(5)
        set_visible_sprite("customize2")
        @process = 1
      # Radio
      when 1
        set_visible_sprite("radio2",true)
        pbWait(5)
        set_visible_sprite("radio2")
        @process = 2
      # Map
      when 2
        set_visible_sprite("map2",true)
        pbWait(5)
        set_visible_sprite("map2")
        @process = 3
      # Phone
      when 3
        set_visible_sprite("phone2",true)
        pbWait(5)
        set_visible_sprite("phone2")
        @process = 4
      # Exit
      else
        set_visible_sprite("exit2",true)
        pbWait(5)
        set_visible_sprite("exit2")
        (@process!=5)? (@process=0) : (@exit=true)
      end
    end
    if Input.trigger?(Input::B)
      pbPlayCloseMenuSE
      (@process!=5)? (@process=0) : (@exit=true)
    end
  end
  
  def chooseFeatureMouse
    set_xy_sprite("selectI",25+95*@features,SCREEN_HEIGHT-54)
    w = 80; h = 52
    x = []; t = 0
    5.times { x.push(25+(w+15)*t); t+=1 }
    y = SCREEN_HEIGHT - 54
    # Customize
    if rectMouse(x[0],y,w,h)
      @features = 0
      if clickedMouse
        pbPlayDecisionSE
        set_visible_sprite("customize2",true)
        pbWait(5)
        set_visible_sprite("customize2")
        @process = 1 
      end
    # Radio
    elsif rectMouse(x[1],y,w,h)
      @features = 1
      if clickedMouse
        pbPlayDecisionSE
        set_visible_sprite("radio2",true)
        pbWait(5)
        set_visible_sprite("radio2")
        @process = 2 
      end
    # Map
    elsif rectMouse(x[2],y,w,h)
      @features = 2
      if clickedMouse
        pbPlayDecisionSE
        set_visible_sprite("map2",true)
        pbWait(5)
        set_visible_sprite("map2")
        @process = 3 
      end
    # Phone
    elsif rectMouse(x[3],y,w,h)
      @features = 3
      if clickedMouse
        pbPlayDecisionSE
        set_visible_sprite("phone2",true)
        pbWait(5)
        set_visible_sprite("phone2")
        @process = 4 
      end
    # Exit
    elsif rectMouse(x[4],y,w,h)
      @features = 4
      if clickedMouse
        pbPlayCloseMenuSE
        set_visible_sprite("exit2",true)
        pbWait(5)
        set_visible_sprite("exit2")
        if @process==5
          @exit=true
        elsif @process==8
          if @custom
            @custom=false
            @select = 0
            # Redraw music list
            nameMusic(0)
          else
            @process=0
          end
        elsif @process==10
          (@sort)? (@sort=false) : (@process=0)
        else
          @process=0 
        end
      end
    end
    # Play SE
    sePlayAll
  end
#-------------------------------------------------------------------------------
# Choose customize (Input)
#-------------------------------------------------------------------------------
  def setReturnPageCustom
    # Set can't visible
    set_visible_sprite("customize change menu")
    set_visible_sprite("customize select change")
    @change = true; @process = 6
  end
  
  def chooseCustomize
    if @otherfeatures
      if Input.trigger?(Input::LEFT)
        pbPlayDecisionSE
        @choose -= 1
        @choose = 5 if @choose < 0
      end
      if Input.trigger?(Input::RIGHT)
        pbPlayDecisionSE
        @choose += 1
        @choose = 0  if @choose > 5
      end
      if Input.trigger?(Input::UP)
        pbPlayDecisionSE
        @choose -= 3
        @choose += 6 if @choose < 0
      end
      if Input.trigger?(Input::DOWN)
        pbPlayDecisionSE
        @choose += 3
        @choose -= 6 if @choose > 5
      end
      if Input.trigger?(Input::C)
        pbPlayDecisionSE
        @process=7
      end
    else
      chooseFeature
    end
    if Input.trigger?(Input::B)
      if @otherfeatures
        pbPlayCloseMenuSE
        @otherfeatures = false 
      end
    end
  end
  
  def chooseCustomizeMouse
    w = 98; h = 89
    x = [46,207,367]; y = [52,210]
    if rectMouse(x[0],y[0],w,h) || rectMouse(x[1],y[0],w,h) ||
      rectMouse(x[2],y[0],w,h) || rectMouse(x[0],y[1],w,h) ||
      rectMouse(x[1],y[1],w,h) || rectMouse(x[2],y[1],w,h)
      if clickedMouse
        pbPlayDecisionSE
        @process=7
      end
    end
    if rectMouse(x[0],y[0],w,h)
      @choose = 0
    elsif rectMouse(x[1],y[0],w,h)
      @choose = 1
    elsif rectMouse(x[2],y[0],w,h)
      @choose = 2
    elsif rectMouse(x[0],y[1],w,h)
      @choose = 3
    elsif rectMouse(x[1],y[1],w,h)
      @choose = 4
    elsif rectMouse(x[2],y[1],w,h)
      @choose = 5
    end
  end
  
  # Change background
  def chooseChangeCustom
    xy = sceneChooseCustom
    x = xy[0] + 8
    y = (@change)? xy[1]+10 : xy[1]+58
    height = @sprites["customize select change"].bitmap.height/2
    set_src_xy_sprite("customize select change",0,((@change)? 0 : height))
    set_xy_sprite("customize select change",x,y)
    set_visible_sprite("customize select change",true)
    if Input.trigger?(Input::UP) || Input.trigger?(Input::DOWN)
      pbPlayDecisionSE
      @change = (@change)? false : true
    end
    if Input.trigger?(Input::C)
      if @change
        pbPlayDecisionSE
        $PokemonGlobal.backgroundPokegear = @choose
        if @background!=$PokemonGlobal.backgroundPokegear
          @background = $PokemonGlobal.backgroundPokegear
          @change = true
          @process = 1
        end
      else
        pbPlayCloseMenuSE
        setReturnPageCustom
      end
    end
    if Input.trigger?(Input::B)
      pbPlayCloseMenuSE
      setReturnPageCustom
    end
    w = 112; h = 44
    if rectMouse(x,xy[1]+10,w,h)
      @change = true
      if clickedMouse
        pbPlayDecisionSE
        $PokemonGlobal.backgroundPokegear = @choose
        if @background!=$PokemonGlobal.backgroundPokegear
          @background = $PokemonGlobal.backgroundPokegear
          @change = true
          @process = 1
        end
      end
    elsif rectMouse(x,xy[1]+58,w,h)
      @change = false
      if clickedMouse
        pbPlayCloseMenuSE
        setReturnPageCustom
      end
    end
  end
#-------------------------------------------------------------------------------
# Choose radio (Input)
#-------------------------------------------------------------------------------
  def chooseRadio
    max = (@custom)? @listmusic.length : ListMusicRadio.length
    # Move arrow
    (max<6)? posArrow(@select) : (@select>=max-6)? posArrow(@select-max+6) : posArrow(0)
    if @otherfeatures
      if Input.trigger?(Input::UP)
        pbPlayDecisionSE
        @select -= 1
        @select = max-1 if @select < 0
        (@custom)? nameMusic(1) : nameMusic(0)
      end
      if Input.trigger?(Input::DOWN)
        pbPlayDecisionSE
        @select += 1
        @select = 0 if @select>=max
        (@custom)? nameMusic(1) : nameMusic(0)
      end
      if Input.trigger?(Input::C)
        pbPlayDecisionSE
        # Custom
        if @custom
          (@select==0)? songPlayBGM : songPlayBGM(@listmusic[@select])
        # Music
        else
          if @select==max-1
            @custom = true
            @select = 0
            nameMusic(1)
          else
            pbBGMPlay(ListMusicRadio[@select][1],100,100)
            case @select
            when 0; fluteMusic(true)
            when 1; fluteMusic(true)
            end
          end 
        end
      end
    else
      chooseFeature
    end
    if Input.trigger?(Input::B)
      if @otherfeatures
        pbPlayCloseMenuSE
        if @custom
          @custom=false
          @select = 0
          nameMusic(0)
        else
          @otherfeatures=false
        end
      end
    end
  end
  
  def chooseRadioMouse
    # Change position
    x = 462; y = [33,183]
    w = 48; h = 117
    max = (@custom)? @listmusic.length : ListMusicRadio.length
    if clickedMouse
      pbPlayDecisionSE
      if rectMouse(x,y[0],w,h)
        @select -= 1
        @select = max-1 if @select < 0
        (@custom)? nameMusic(1) : nameMusic(0)
      elsif rectMouse(x,y[1],w,h)
        @select += 1
        @select = 0 if @select>=max
        (@custom)? nameMusic(1) : nameMusic(0)
      # Music
      elsif rectMouse(26,10,432,313)
        if @custom
          (@select==0)? songPlayBGM : songPlayBGM(@listmusic[@select])
        else
          if @select==max-1
            @custom = true
            @select = 0
            nameMusic(1)
          else
            pbBGMPlay(ListMusicRadio[@select][1],100,100)
            case @select
            when 0; fluteMusic(true)
            when 1; fluteMusic(true)
            end
          end
        end
      end
    end
  end
#-------------------------------------------------------------------------------
# Choose phone (Input)
#-------------------------------------------------------------------------------
  def setReturnPagePhone(num=nil)
    (num.nil?)? pbPlayDecisionSE : pbPlayCloseMenuSE
    # Visible
    set_visible_sprite("phone menu"); set_visible_sprite("phone select")
    @choice = 0; @process = 10
  end
  
  def choosePhone
    max = @trainers.length
    # Visible
    visibleSortArrow
    if !@sort
      num = @select
      (max<6)? posArrow(num) : (num>=max-6)? posArrow(num-max+6) : posArrow(0)
      if @otherfeatures
        if Input.trigger?(Input::UP)
          pbPlayDecisionSE
          @select -= 1
          @select = max-1 if @select<0
          namePhone 
        end
        if Input.trigger?(Input::DOWN)
          pbPlayDecisionSE
          @select += 1
          @select = 0 if @select>=max
          namePhone 
        end
        if Input.trigger?(Input::C)
          pbPlayDecisionSE
          @sortselect = @select
          # Visible
          set_visible_sprite("phone menu",true)
          set_visible_sprite("phone select",true)
          @process = 12
        end
      else
        chooseFeature
      end
      if Input.trigger?(Input::B)
        pbPlayCloseMenuSE
        @otherfeatures=false if @otherfeatures
      end
    # Mode: sort
    else
      num = @sortselect
      (max<6)? posArrowSort(num) : (num>=max-6)? posArrowSort(num-max+6) : posArrowSort(0)
      if Input.trigger?(Input::UP)
        pbPlayDecisionSE
        @sortselect -= 1
        @sortselect = max-1 if @sortselect<0
        namePhone(0) 
      end
      if Input.trigger?(Input::DOWN)
        pbPlayDecisionSE
        @sortselect += 1
        @sortselect = 0 if @sortselect>=max
        namePhone(0) 
      end
      if Input.trigger?(Input::C)
        pbPlayDecisionSE
        # Sort (change position)
        sortTrainer(@select,@sortselect)
        @sort = false
        @process = 4
      end
       if Input.trigger?(Input::B)
        pbPlayCloseMenuSE
        namePhone
        @sort = false
      end      
    end
    # Show information
    if Input.trigger?(Input::A) && @otherfeatures
      pbPlayDecisionSE
      showInformationTrainer(true)
      @process = 11
    end
  end
  
  def choosePhoneMouse
    # Change position
    x = 462; y = [33,183]
    w = 48; h = 117
    max = @trainers.length
    if clickedMouse
      if !@sort
        pbPlayDecisionSE
        if rectMouse(x,y[0],w,h)
          @select -= 1
          @select = max-1 if @select<0
          namePhone 
        elsif rectMouse(x,y[1],w,h)
          @select += 1
          @select = 0 if @select>=max
          namePhone 
        elsif rectMouse(26,10,432,313)
          pbPlayDecisionSE
          @sortselect = @select
          # Visible
          set_visible_sprite("phone menu",true)
          set_visible_sprite("phone select",true)
          @process = 12
        end
      # Mode: sort
      else
        pbPlayDecisionSE
        if rectMouse(x,y[0],w,h)
          @sortselect -= 1
          @sortselect = max-1 if @sortselect<0
          namePhone(0) 
        elsif rectMouse(x,y[1],w,h)
          @sortselect += 1
          @sortselect = 0 if @sortselect>=max
          namePhone(0) 
        elsif rectMouse(26,10,432,313)
          # Sort (change position)
          sortTrainer(@select,@sortselect)
          @sort = false
          @process = 4
        end
      end
      # Show information
      if rectMouse(460,0,52,17)
        showInformationTrainer(true)
        @process = 11
      end
    end
  end
  
  def choosePhoneInformation
    x = 327
    y = @sprites["phone information"].y
    if Input.trigger?(Input::B) || (rectMouse(x,y,13,26) && clickedMouse)
      pbPlayCloseMenuSE
      showInformationTrainer(false)
      @process = 10 
    end
  end
  
  def choosePhoneSelect
    pos = posPhoneMenu
    x = pos[0] + 8; ya = [10,58,106]
    y = (@choice==0)? pos[1] + ya[0] : (@choice==1)? pos[1] + ya[1] : pos[1] + ya[2]
    height = @sprites["phone select"].bitmap.height/3
    set_src_xy_sprite("phone select",0,height*@choice)
    set_xy_sprite("phone select",x,y)
    if Input.trigger?(Input::UP)
      @choice -= 1
      @choice = 2 if @choice<0
    end
    if Input.trigger?(Input::DOWN)
      @choice += 1
      @choice = 0 if @choice>2
    end
    if Input.trigger?(Input::C)
      pbPlayDecisionSE
      case @choice
      # Call
      when 0
        setReturnPagePhone
        if canCall
          pbCallTrainer(@trainers[@select][0],@trainers[@select][1]) # Call
          putTrainerList
          rematchIcon
        else
          pbMessage(_INTL("Got no signal."))
        end
      # Sort
      when 1
        @sort = true
        setReturnPagePhone
      else
        setReturnPagePhone
      end
    end
    setReturnPagePhone(0) if Input.trigger?(Input::B)
    # Mouse
    # Call
    if rectMouse(x,pos[1]+ya[0],272,44)
      @choice=0
      if clickedMouse
        setReturnPagePhone
        if canCall
          pbCallTrainer(@trainers[@select][0],@trainers[@select][1]) # Call
          putTrainerList
          rematchIcon
        else
          pbMessage(_INTL("Got no signal."))
        end 
      end
    # Sort
    elsif rectMouse(x,pos[1]+ya[1],272,44)
      @choice=1
      if clickedMouse
        @sort = true
        setReturnPagePhone 
      end
    # Quit
    elsif rectMouse(x,pos[1]+ya[2],272,44)
      @choice=2
      setReturnPagePhone(0) if clickedMouse
    end
  end
  
#-------------------------------------------------------------------------------
# SE play
#-------------------------------------------------------------------------------
  def playSEMainPage
    w = 80; h = 52
    x = []; t = 0
    5.times { x.push(25+(w+15)*t); t+=1 }
    y = SCREEN_HEIGHT - 54
    if rectMouse(x[0],y,w,h) || rectMouse(x[1],y,w,h) || rectMouse(x[2],y,w,h) ||
     rectMouse(x[3],y,w,h) || rectMouse(x[4],y,w,h)
     return true
    end
  end
 
  def xyForSE(number)
    case number
    # Customize
    when 0
      x = [46,207,367]; y = [52,210]
      w = 98; h = 89
      if rectMouse(x[0],y[0],w,h) || rectMouse(x[1],y[0],w,h) ||
        rectMouse(x[2],y[0],w,h) || rectMouse(x[0],y[1],w,h) ||
        rectMouse(x[1],y[1],w,h) || rectMouse(x[2],y[1],w,h)
        return true
      end
    # Customize (change)
    when 1
      xy = sceneChooseCustom
      x = xy[0] + 8; y = (@change)? xy[1]+10 : xy[1]+58
      w = 112; h = 44
      return true if rectMouse(x,xy[1]+10,w,h) || rectMouse(x,xy[1]+58,w,h)
    # Radio
    when 2
      x = 462; y = [33,183]
      w = 48; h = 117
      return true if rectMouse(x,y[0],w,h) || rectMouse(x,y[1],w,h) || rectMouse(26,10,432,313)
    # Phone (show information)
    when 3
      x = 327
      y = @sprites["phone information"].y
      return true if rectMouse(x,y,13,26)
    # Phone (use features)
    when 4
      pos = posPhoneMenu
      x = pos[0] + 8; y = [10,58,106]
      (0...y.length).each {|i| y[i]+=pos[1]}
      return true if rectMouse(x,y[0],272,44) || rectMouse(x,y[1],272,44) || rectMouse(x,y[2],272,44)
    end
  end
  
  def sePlayAll
    if ((@process==5 || @process==9) && playSEMainPage) || # Main page and Phone page (0 phone number)
      # Customize (control)
      (@process==6 && (playSEMainPage || xyForSE(0))) ||
      # Customize (change)
      (@process==7 && xyForSE(1)) || 
      # Radio (control)
      (@process==8 && (playSEMainPage || xyForSE(2))) ||
      # Phone (control)
      (@process==10 && (playSEMainPage || xyForSE(2) || rectMouse(460,0,52,17))) ||
      # Phone (show information)
      (@process==11 && xyForSE(3)) ||
      # Phone (use features)
      (@process==12 && xyForSE(4))
      # Play SE
      playSEMouse
    else
      @se = 0
    end
  end
  
  def playSEMouse
    @se = 1 if @se==0
    if @se==1
      @se = 2
      pbPlayDecisionSE
    end
  end
#-------------------------------------------------------------------------------
# Set bitmap
#-------------------------------------------------------------------------------
  # Image
  def create_sprite(spritename,filename,vp,dir="Pictures/Pokegear HGSS")
    @sprites["#{spritename}"] = Sprite.new(vp)
    @sprites["#{spritename}"].bitmap = Bitmap.new("Graphics/#{dir}/#{filename}")
  end
  
  # Set ox, oy
  def set_oxoy_sprite(spritename,ox,oy)
    @sprites["#{spritename}"].ox = ox
    @sprites["#{spritename}"].oy = oy
  end
  
  # Set x, y
  def set_xy_sprite(spritename,x,y)
    @sprites["#{spritename}"].x = x
    @sprites["#{spritename}"].y = y
  end
  
  # Set zoom
  def set_zoom(spritename,zoom_x,zoom_y)
    @sprites["#{spritename}"].zoom_x = zoom_x
    @sprites["#{spritename}"].zoom_y = zoom_y
  end
  
  # Set visible
  def set_visible_sprite(spritename,vsb=false)
    @sprites["#{spritename}"].visible = vsb
  end
  
  # Set angle
  def set_angle_sprite(spritename,angle)
    @sprites["#{spritename}"].angle = angle
  end
  
  # Set src
  def set_src_wh_sprite(spritename,w,h)
    @sprites["#{spritename}"].src_rect.width = w
    @sprites["#{spritename}"].src_rect.height = h
  end
  
  def set_src_xy_sprite(spritename,x,y)
    @sprites["#{spritename}"].src_rect.x = x
    @sprites["#{spritename}"].src_rect.y = y
  end
#-------------------------------------------------------------------------------
# Text
#-------------------------------------------------------------------------------
  # Draw
  def create_sprite_2(spritename,vp)
    @sprites["#{spritename}"] = Sprite.new(vp)
    @sprites["#{spritename}"].bitmap = Bitmap.new(Graphics.width,Graphics.height)
  end
  
  # Write
  BaseColor = Color.new(255,255,255)
  ShadowColor = Color.new(0,0,0)
  def drawTxt(bitmap,textpos,font=nil,fontsize=nil)
    # Sprite
    bitmap = @sprites["#{bitmap}"].bitmap
    bitmap.clear #if !nclear
    # Set font, size
    (font!=nil)? (bitmap.font.name=font) : pbSetSystemFont(bitmap)
    bitmap.font.size = fontsize if !fontsize.nil?
=begin
    pbDrawOutlineText(bitmap, # Bitmap
    x,y,width,height, # Position
    _INTL("#{string}"), # Title
    bcolor,scolor, # Color
    align) # Align
=end
    pbDrawTextPositions(bitmap,textpos)
  end
  
  # Clear
  def clearTxt(bitmap)
    @sprites["#{bitmap}"].bitmap.clear
  end
#-------------------------------------------------------------------------------
# Icon
#-------------------------------------------------------------------------------
  def create_sprite_3(spritename,x,y,filename,vp,dir="Pictures")
    @sprites["#{spritename}"] = IconSprite.new(x,y,vp)
    @sprites["#{spritename}"].setBitmap("Graphics/#{dir}/#{filename}")
  end
  
#-------------------------------------------------------------------------------
# Mouse
#-------------------------------------------------------------------------------
  def rectMouse(x,y,w,h)
    rect = [x,w+x,y,h+y]
    mouse = Mouse::getMousePos
    mouse = [0,0] if !mouse
    if mouse[0]>=rect[0] && mouse[0]<= rect[1] && 
      mouse[1]>=rect[2] && mouse[1]<= rect[3]
      return true 
    end
    return false
  end
  
  def clickedMouse
    return true if Input.triggerex?(Input::RightMouseKey) || Input.triggerex?(Input::LeftMouseKey)
    return false
  end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
  def dispose(id=nil)
    (!id)? pbDisposeSprite(@sprites,id) : pbDisposeSpriteHash(@sprites)
  end
  
  def update_ingame
    Graphics.update
    Input.update
    pbUpdateSpriteHash(@sprites)
  end
  
  def endScene
    # End
    dispose
    @viewport.dispose
    @viewport1.dispose
    @viewport2.dispose
  end
end
#-------------------------------------------------------------------------------
class PokemonPokegearScreen
  def initialize(scene)
    @scene = scene
  end
  
  def pbStartScreen
    @scene.start
  end
end