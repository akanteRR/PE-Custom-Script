#-------------------------------------------------------------------------------
# Multiple Save Files (v.18.1)
# Credit: mej71 (original), bo4p5687 (update)
#-------------------------------------------------------------------------------
PluginManager.register({
  :name => "Multiple Save Files (v.18.1)",
  :credits => ["mej71 (original)","bo4p5687 (update)"]
})
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
# Create custom message
#-------------------------------------------------------------------------------
def pbCustomMessageForSave(message,commands,index,&block)
  return pbMessage(message,commands,index,&block)
end
#-------------------------------------------------------------------------------
# Count file save
#-------------------------------------------------------------------------------
def countFileSave
  dir = DIR_SAVE_GAME; filename = FILENAME_SAVE_GAME
  Dir.mkdir(dir) if !safeExists?(dir)
  d = Dir.glob("#{dir}/#{filename}*.rxdata")
  count = d.size
  return count
end
#-------------------------------------------------------------------------------
# Method
#-------------------------------------------------------------------------------
def checkAndRenameForFile(limit,file="Game",dir="Save Game")
  return if limit<=0
  arr = Dir.glob("#{dir}/#{file}*.rxdata")
  File.rename("#{dir}/#{file}.rxdata", "#{dir}/#{file}1.rxdata") if File.file?("#{dir}/#{file}.rxdata")
  name = []
  arr.each { |f| name << ( File.basename(f, ".rxdata").gsub(/[^0-9]/, "") ) }
  needtorewrite = false
  (0...arr.size).each { |i|
    needtorewrite = true if arr[i]!="#{dir}/#{file}#{name[i]}.rxdata"
  }
  if needtorewrite
    numbername = []
    name.each { |n| numbername << n.to_i}
    (0...numbername.size).each { |i|
      loop do
        break if i==0
        diff = numbername.index(numbername[i])
        break if diff==i
        numbername[i] += 1
      end
      Dir.mkdir("#{dir}/#{numbername[i]}")
      File.rename("#{arr[i]}", "#{dir}/#{numbername[i]}/#{file}#{numbername[i]}.rxdata")
    }
    (0...name.size).each { |i|
      name2 = "#{dir}/#{numbername[i]}/#{file}#{numbername[i]}.rxdata"
      File.rename(name2, "#{dir}/#{file}#{numbername[i]}.rxdata")
      Dir.delete("#{dir}/#{numbername[i]}")
    }
  end
  arr.size.times { |i|
    num = 0
    namef = sprintf("%d", i + 1)
    loop do
      break if File.file?("#{dir}/#{file}#{namef}.rxdata")
      num    += 1
      namef2  = sprintf("%d", i + 1 + num)
      File.rename("#{dir}/#{file}#{namef2}.rxdata", "#{dir}/#{file}#{namef}.rxdata") if File.file?("#{dir}/#{file}#{namef2}.rxdata")
    end
  }
end
#-------------------------------------------------------------------------------
# This will create a new file save
#-------------------------------------------------------------------------------
def savenameForpbSave(new=false)
  dir = DIR_SAVE_GAME; filename = FILENAME_SAVE_GAME
  count = countFileSave
  if count<=0
    savename = "#{filename}1.rxdata"
  else
    checkAndRenameForFile(count,filename,dir)
    count += 1 if new
    savename = "#{filename}#{count}.rxdata"
  end
  return savename
end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
# Save
#-------------------------------------------------------------------------------
# Rewrite pbSave
#-------------------------------------------------------------------------------
def pbSave(safesave=false,new=false)
  $Trainer.metaID=$PokemonGlobal.playerID
  # Write save name
  number = savenameForpbSave(new)
  savename = "Save Game/#{number}"
  begin
    File.open(savename,"wb") { |f|
       Marshal.dump($Trainer,f)
       Marshal.dump(Graphics.frame_count,f)
       if $data_system.respond_to?("magic_number")
         $game_system.magic_number = $data_system.magic_number
       else
         $game_system.magic_number = $data_system.version_id
       end
       $game_system.save_count+=1
       Marshal.dump($game_system,f)
       Marshal.dump($PokemonSystem,f)
       Marshal.dump($game_map.map_id,f)
       Marshal.dump($game_switches,f)
       Marshal.dump($game_variables,f)
       Marshal.dump($game_self_switches,f)
       Marshal.dump($game_screen,f)
       Marshal.dump($MapFactory,f)
       Marshal.dump($game_player,f)
       $PokemonGlobal.safesave=safesave
       Marshal.dump($PokemonGlobal,f)
       Marshal.dump($PokemonMap,f)
       Marshal.dump($PokemonBag,f)
       Marshal.dump($PokemonStorage,f)
       Marshal.dump(ESSENTIALS_VERSION,f)
    }
    Graphics.frame_reset
  rescue
    return false
  end
  return true
end
#-------------------------------------------------------------------------------
# Rewrite emergency save
#-------------------------------------------------------------------------------
def pbEmergencySave
  oldscene=$scene
  $scene=nil
  pbMessage(_INTL("The script is taking too long. The game will restart."))
  return if !$Trainer
  # Count save file
  dir = DIR_SAVE_GAME; filename = FILENAME_SAVE_GAME
  count = countFileSave
  # It will check the last save for saving
  if safeExists?("#{dir}/#{filename}#{count}.rxdata")
    File.open("#{dir}/#{filename}#{count}.rxdata",  'rb') { |r|
      File.open("#{dir}/#{filename}#{count}.rxdata.bak", 'wb') { |w|
        while s = r.read(4096)
          w.write s
        end
      }
    }
  end
  if pbSave
    pbMessage(_INTL("\\se[]The game was saved.\\me[GUI save game] The previous save file has been backed up.\\wtnp[30]"))
  else
    pbMessage(_INTL("\\se[]Save failed.\\wtnp[30]"))
  end
  $scene=oldscene
end
#-------------------------------------------------------------------------------
# Rewrite save screen
#-------------------------------------------------------------------------------
class PokemonSaveScreen
  def pbSaveScreen
    ret = false
    # Count file
    dir = DIR_SAVE_GAME; filename = FILENAME_SAVE_GAME
    count = countFileSave
    # Start
    msg = _INTL("What do you want to do?")
    cmds = [_INTL("Delete"),_INTL("Save"),_INTL("Cancel")]
    cmd = pbCustomMessageForSave(msg,cmds,3)
    # Delete file save
    if cmd==0
      if count<=0
        pbMessage(_INTL("No save file was found."))
      else
        # Rename file (again)
        checkAndRenameForFile(count,filename,dir)
        # Delete file save
        cmds = [_INTL("Delete All File Save"),_INTL("Delete Only One File Save"),_INTL("Cancel")]
        cmd2 = pbCustomMessageForSave(msg,cmds,3)
        # All file save
        if cmd2==0
          if pbConfirmMessageSerious(_INTL("Delete all saves?"))
            pbMessage(_INTL("Once data has been deleted, there is no way to recover it.\1"))
            if pbConfirmMessageSerious(_INTL("Delete the saved data anyway?"))
              pbMessage(_INTL("Deleting all data. Don't turn off the power.\\wtnp[0]"))
              (0...count).each { |i| savefile = "#{dir}/#{filename}#{i+1}.rxdata"
                begin; File.delete(savefile); rescue; end
                begin; File.delete(savefile+".bak"); rescue; end
              }
              pbWait(2)
              Graphics.frame_reset
              pbMessage(_INTL("The save file was deleted."))
            end
          end
        # Only one
        elsif cmd2==1
          pbFadeOutIn {
            file = ScreenChooseFileSave.new(count)
            file.movePanel(2)
            file.endScene
            if file.deletefile
              pbWait(2)
              Graphics.frame_reset
              pbMessage(_INTL("The save file was deleted."))
            end
          }
        end
      end
      # Return menu
      return false
    else
      @scene.pbStartScreen
      # Save
      if cmd==1
        cmds = [_INTL("New File Save"),_INTL("Old File Save"),_INTL("Cancel")]
        cmd2 = pbCustomMessageForSave(msg,cmds,3)
        # New file save
        if cmd2==0
          if pbSave(false,true)
            pbMessage(_INTL("\\se[]{1} saved the game.\\me[GUI save game]\\wtnp[30]",$Trainer.name))
            ret=true
          else
            pbMessage(_INTL("\\se[]Save failed.\\wtnp[30]"))
            ret=false
          end
        # Overwrite file save
        elsif cmd2==1
          if count<=0
            pbMessage(_INTL("No save file was found."))
          else
            pbFadeOutIn {
              file = ScreenChooseFileSave.new(count)
              file.movePanel
              file.endScene
              ret = file.staymenu
            }
          end
        end
      # Cancel
      else
        pbSEPlay("GUI save choice")
      end
      @scene.pbEndScreen
    end
    return ret
  end
end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
# Load
#-------------------------------------------------------------------------------
class PokemonLoadScreen
  # Delete screen
  def pbStartDeleteScreen
    @scene.pbStartDeleteScene
    @scene.pbStartScene2
    # Count save file
    dir = DIR_SAVE_GAME; filename = FILENAME_SAVE_GAME
    count = countFileSave
    if count<=0
      pbMessage(_INTL("No save file was found."))
    else
      msg = _INTL("What do you want to do?")
      cmds = [_INTL("Delete All File Save"),_INTL("Delete Only One File Save"),_INTL("Cancel")]
      cmd = pbCustomMessageForSave(msg,cmds,3)
      # Delete all
      if cmd==0
        if pbConfirmMessageSerious(_INTL("Delete all saves?"))
          pbMessage(_INTL("Once data has been deleted, there is no way to recover it.\1"))
          if pbConfirmMessageSerious(_INTL("Delete the saved data anyway?"))
            pbMessage(_INTL("Deleting all data. Don't turn off the power.\\wtnp[0]"))
            (0...count).each { |i| savefile = "#{dir}/#{filename}#{i+1}.rxdata"
              begin; File.delete(savefile); rescue; end
              begin; File.delete(savefile+".bak"); rescue; end
            }
            pbWait(2)
            Graphics.frame_reset
            pbMessage(_INTL("The save file was deleted."))
          end
        end
      # Delete only one
      elsif cmd==1
        pbFadeOutIn {
          file = ScreenChooseFileSave.new(count)
          file.movePanel(2)
          file.endScene
          if file.deletefile
            pbWait(2)
            Graphics.frame_reset
            pbMessage(_INTL("The save file was deleted."))
          end
        }
      end
    end
    @scene.pbEndScene
    $scene = pbCallTitle
  end

  # Rewrite start load screen
  def pbStartLoadScreen
    $PokemonTemp   = PokemonTemp.new
    $game_temp     = Game_Temp.new
    $game_system   = Game_System.new
    $PokemonSystem = PokemonSystem.new if !$PokemonSystem
    # Count file save
    dir = DIR_SAVE_GAME; filename = FILENAME_SAVE_GAME
    count = countFileSave
    FontInstaller.install
    data_system = pbLoadRxData("Data/System")
    mapfile = ($RPGVX) ? sprintf("Data/Map%03d.rvdata",data_system.start_map_id) :
                         sprintf("Data/Map%03d.rxdata",data_system.start_map_id)
    if data_system.start_map_id==0 || !pbRgssExists?(mapfile)
      pbMessage(_INTL("No starting position was set in the map editor.\1"))
      pbMessage(_INTL("The game cannot continue."))
      @scene.pbEndScene
      $scene = nil
      return
    end
    commands = []
    cmdContinue    = -1
    cmdNewGame     = -1
    cmdOption      = -1
    cmdDebug       = -1
    cmdQuit        = -1
    commands[cmdContinue = commands.length]    = _INTL("Load Game") if count>0
    commands[cmdNewGame = commands.length]     = _INTL("New Game")
    commands[cmdOption = commands.length]        = _INTL("Options")
    commands[cmdDebug = commands.length]         = _INTL("Debug") if $DEBUG
    commands[cmdQuit = commands.length]          = _INTL("Quit Game")
    trainer = nil; framecount = 0; mapid = 0; showContinue = false
    @scene.pbStartScene(commands,showContinue,trainer,framecount,mapid)
    @scene.pbSetParty(trainer) if showContinue
    @scene.pbStartScene2
    pbLoadBattleAnimations
    loop do
      command = @scene.pbChoose(commands)
      if cmdContinue>=0 && command==cmdContinue
        pbPlayDecisionSE
        begin
          file = ScreenChooseFileSave.new(count)
          file.movePanel(1)
          @scene.pbEndScene if !file.staymenu
          file.endScene
          return if !file.staymenu
        rescue
          @scene.pbEndScene
          file.endScene
          pbMessage(_INTL("You have error!!!"))
          $scene = nil
          return
        end
      elsif cmdNewGame>=0 && command==cmdNewGame
        pbPlayDecisionSE
        @scene.pbEndScene
        if $game_map && $game_map.events
          for event in $game_map.events.values
            event.clear_starting
          end
        end
        $game_temp.common_event_id = 0 if $game_temp
        $scene               = Scene_Map.new
        Graphics.frame_count = 0
        $game_system         = Game_System.new
        $game_switches       = Game_Switches.new
        $game_variables      = Game_Variables.new
        $game_self_switches  = Game_SelfSwitches.new
        $game_screen         = Game_Screen.new
        $game_player         = Game_Player.new
        $PokemonMap          = PokemonMapMetadata.new
        $PokemonGlobal       = PokemonGlobalMetadata.new
        $PokemonStorage      = PokemonStorage.new
        $PokemonEncounters   = PokemonEncounters.new
        $PokemonTemp.begunNewGame = true
        pbRefreshResizeFactor   # To fix Game_Screen pictures
        $data_system         = pbLoadRxData("Data/System")
        $MapFactory          = PokemonMapFactory.new($data_system.start_map_id)   # calls setMapChanged
        $game_player.moveto($data_system.start_x, $data_system.start_y)
        $game_player.refresh
        $game_map.autoplay
        $game_map.update
        return
      elsif cmdOption>=0 && command==cmdOption
        pbPlayDecisionSE
        pbFadeOutIn {
          scene = PokemonOption_Scene.new
          screen = PokemonOptionScreen.new(scene)
          screen.pbStartScreen(true)
        }
      elsif cmdDebug>=0 && command==cmdDebug
        pbPlayDecisionSE
        pbFadeOutIn { pbDebugMenu(false) }
      elsif cmdQuit>=0 && command==cmdQuit
        pbPlayCloseMenuSE
        @scene.pbEndScene
        $scene = nil
        return
      end
    end
  end
end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
# Scene for save menu, load menu and delete menu
#-------------------------------------------------------------------------------
class ScreenChooseFileSave
  attr_reader :staymenu
  attr_reader :deletefile

  def initialize(count)
    @sprites = {}
    @viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z = 99999
    # Set value
    # Check quantity
    @count = count
    if @count<=0
      pbMessage("No save file was found.")
      return
    end
    # Check still menu
    @staymenu = false
    @deletefile = false
    # Check position
    @position = 0
    # Check position if count > 7
    @choose = 0
    # Set position of panel 'information'
    @posinfor = 0
    # Quantity of panel in information page
    @qinfor = 0
    # Check mystery gift
    @mysgif = false
    #@trainer = nil
  end

  # Set background (used "loadbg")
  def drawBg
    color = Color.new(248,248,248)
    addBackgroundOrColoredPlane(@sprites,"background","loadbg",color,@viewport)
  end
#-------------------------------------------------------------------------------
# Set Panel
#-------------------------------------------------------------------------------
  # Draw panel
  def startPanel
    # Check and rename
    dir = DIR_SAVE_GAME; filename = FILENAME_SAVE_GAME
    checkAndRenameForFile(@count,filename,dir)
    # Start
    drawBg
    # Set bar
    num = (@count>7)? 7 : @count
    (0...num).each { |i|
    create_sprite("panel #{i}","loadPanels",@viewport)
    w = 384; h = 46
    set_src_wh_sprite("panel #{i}",w,h)
    x = 16; y = 444
    set_src_xy_sprite("panel #{i}",x,y)
    x = 24*2; y = 16*2 + 48*i
    set_xy_sprite("panel #{i}",x,y) }
    # Set choose bar
    create_sprite("choose panel","loadPanels",@viewport)
    w = 384; h = 46
    set_src_wh_sprite("choose panel",w,h)
    x = 16; y = 444 + 46
    set_src_xy_sprite("choose panel",x,y)
    choosePanel(@choose)
    # Set text
    create_sprite_2("text",@viewport)
    textPanel
    pbFadeInAndShow(@sprites) { update }
  end

  def choosePanel(pos=0)
    x = 24*2; y = 16*2 + 48*pos
    set_xy_sprite("choose panel",x,y)
  end

  # Draw text panel
  BaseColor   = Color.new(252,252,252)
  ShadowColor = Color.new(0,0,0)
  def textPanel(font=nil)
    return if @count<=0
    bitmap = @sprites["text"].bitmap
    bitmap.clear
    if @count>0 && @count<7
      namesave = 0; endnum = @count
    else
      namesave = (@position>@count-7)? @count-7 : @position
      endnum = 7
    end
    textpos = []
    (0...endnum).each { |i|
      string = _INTL("Save File #{namesave+1+i}")
      x = 24*2 + 36; y = 16*2 + 5 + 48*i
      textpos<<[string,x,y,0,BaseColor,ShadowColor]
    }
    (font.nil?)? pbSetSystemFont(bitmap) : bitmap.font.name = font
    pbDrawTextPositions(bitmap,textpos)
  end

  # Move panel
  # Type: 0: Save; 1: Load; 2: Delete
  def movePanel(type=0)
    infor = false; draw = true; loadmenu = false
    @type = type
    loop do
      # Panel Page
      if !loadmenu
        if !infor
          if draw; startPanel; draw = false
          else
            # Update
            update_ingame
            if checkInput(Input::UP)
              @position -= 1
              @choose -= 1
              if @choose<0
                if @position<0
                  @choose = (@count<7)? @count-1 : 6
                else
                  @choose = 0
                end
              end
              @position = @count-1 if @position<0
              # Move choose panel
              choosePanel(@choose)
              # Draw text
              textPanel
            end
            if checkInput(Input::DOWN)
              @position += 1
              @choose += 1 if @position>@count-7
              (@choose = 0; @position = 0) if @position>=@count
              # Move choose panel
              choosePanel(@choose)
              # Draw text
              textPanel
            end
            (dispose; draw = true; infor = true) if checkInput(Input::C)
            if checkInput(Input::B)
              @staymenu = true if @type==1
              break
            end
          end
        # Information page
        elsif infor
          if draw; startPanelInfor(@type); draw = false
          else
            # Update
            update_ingame
            # Load file
            loadmenu = true if @type==1
            if checkInput(Input::C)
              # Save file
              if @type==0
                if saveOldfile
                  pbMessage(_INTL("\\se[]{1} saved the game.\\me[GUI save game]\\wtnp[30]",$Trainer.name))
                  @staymenu = false
                else
                  pbMessage(_INTL("\\se[]Save failed.\\wtnp[30]"))
                  @staymenu = true
                end
                break
              # Delete file
              elsif @type==2
                if pbConfirmMessageSerious(_INTL("Delete all saved data?"))
                  pbMessage(_INTL(
                    "Once data has been deleted, there is no way to recover it.\1"))
                  if pbConfirmMessageSerious(
                      _INTL("Delete the saved data anyway?"))
                    pbMessage(_INTL(
                        "Deleting all data. Don't turn off the power.\\wtnp[0]"))
                    # Delete
                    deleteFile
                    @deletefile = true
                  end
                end
                break
              end
            end
            (dispose; draw = true; infor = false) if checkInput(Input::B)
          end
        end
      else
        # Update
        update_ingame
        # Start
        if @qinfor>0
          if checkInput(Input::UP)
            @posinfor -= 1
            @posinfor = @qinfor if @posinfor<0
            choosePanelInfor
          end
          if checkInput(Input::DOWN)
            @posinfor += 1
            @posinfor = 0 if @posinfor>@qinfor
            choosePanelInfor
          end
        end
        if checkInput(Input::C)
          # Set up system again
          pbSetUpSystem(@position)
          if @posinfor==0
            loadOldFile
            @staymenu = false
            break
          # Mystery Gift
          elsif @posinfor==1 && @mysgif
            pbFadeOutIn {
              @trainer = pbDownloadMysteryGift(@trainer)
              @posinfor = 0; @qinfor = 0; @mysgif = false
              dispose; draw = true; loadmenu=false; infor = false
            }
          # Language
          elsif LANGUAGES.length>=2 && ( @posinfor==2 || (@posinfor==1 && !@mysgif))
            dir = DIR_SAVE_GAME; filename = FILENAME_SAVE_GAME
            savefile = "#{dir}/#{filename}#{@position+1}.rxdata"
            $PokemonSystem.language = pbChooseLanguage
            pbLoadMessages("Data/"+LANGUAGES[$PokemonSystem.language][1])
            savedata = []
            if safeExists?(savefile)
              File.open(savefile,"rb") { |f|
                16.times { savedata.push(Marshal.load(f)) }
              }
              savedata[3]=$PokemonSystem
              begin
                File.open(savefile,"wb") { |f|
                  16.times { |i| Marshal.dump(savedata[i],f) }
                }
              rescue
              end
            end
            @posinfor = 0; @qinfor = 0; @mysgif = false
            dispose; draw = true; loadmenu=false; infor = false
          end
        end
        if checkInput(Input::B)
          @posinfor = 0; @qinfor = 0; @mysgif = false
          dispose; draw = true; loadmenu = false; infor = false
        end
      end
    end
  end
#-------------------------------------------------------------------------------
# Set information
#-------------------------------------------------------------------------------
  def startPanelInfor(type)
    # Draw background
    drawBg
    create_sprite("infor panel 0","loadPanels",@viewport)
    w = 408; h = 222
    set_src_wh_sprite("infor panel 0",w,h)
    x = 0; y = 0
    set_src_xy_sprite("infor panel 0",x,y)
    x = 24*2; y = 16*2
    set_xy_sprite("infor panel 0",x,y)
    drawInfor(type)
  end

  # Color
  TEXTCOLOR             = Color.new(232,232,232)
  TEXTSHADOWCOLOR       = Color.new(136,136,136)
  MALETEXTCOLOR         = Color.new(56,160,248)
  MALETEXTSHADOWCOLOR   = Color.new(56,104,168)
  FEMALETEXTCOLOR       = Color.new(240,72,88)
  FEMALETEXTSHADOWCOLOR = Color.new(160,64,64)

  # Draw information (text)
  def drawInfor(type,font=nil)
    dir = DIR_SAVE_GAME; filename = FILENAME_SAVE_GAME
    savefile = "#{dir}/#{filename}#{@position+1}.rxdata"
    # Set trainer, framecount, mapid
    if safeExists?(savefile)
      backup   = false
      continue = false
      trainer      = nil
      framecount   = 0
      mapid        = 0
      begin
        load = pbTryLoadFile(savefile)
        trainer, framecount, mapid  = [load[0],load[1],load[4]]
        # Load menu
        ($game_system, $PokemonSystem = [load[2],load[3]]) if type==1
        continue = true
      rescue
        if safeExists?(savefile+".bak")
          begin
            load = pbTryLoadFile(savefile+".bak")
            trainer, framecount, mapid  = [load[0],load[1],load[4]]
            # Load menu
            ($game_system, $PokemonSystem = [load[2],load[3]]) if type==1
            backup = true
            continue = true
          rescue
          end
        end
        if backup
          pbMessage(_INTL("The save file is corrupt. The previous save file will be loaded."))
        else
          pbMessage(_INTL("The save file is corrupt, or is incompatible with this game."))
          if !pbConfirmMessageSerious(_INTL("Do you want to delete the save file and start anew?"))
            $scene = nil
            return
          end
          begin; File.delete(savefile); rescue; end
          begin; File.delete(savefile+".bak"); rescue; end
          # Load menu
          ($game_system   = Game_System.new
          $PokemonSystem = PokemonSystem.new if !$PokemonSystem) if type==1
          pbMessage(_INTL("The save file was deleted."))
        end
      end
      if continue
        if !backup
          begin; File.delete(savefile+".bak"); rescue; end
        end
      end
    end
    # Set trainer
    @trainer = trainer if !trainer.nil?
    # Set mystery gift and language
    if type==1
      mystery = (trainer.mysterygiftaccess rescue false)
      @mysgif = mystery
      @qinfor+=1 if mystery
      @qinfor+=1 if LANGUAGES.length>=2
      (0...@qinfor).each { |i|
        create_sprite("panel load #{i}","loadPanels",@viewport)
        w = 384; h = 46
        set_src_wh_sprite("panel load #{i}",w,h)
        x = 16; y = 444
        set_src_xy_sprite("panel load #{i}",x,y)
        x = 24*2 + 8; y = 16*2 + 48*i + 112*2
        set_xy_sprite("panel load #{i}",x,y)
      } if @qinfor>0
    end
    # Move panel (information)
    create_sprite("infor panel 1","loadPanels",@viewport)
    w = 408; h = 222
    set_src_wh_sprite("infor panel 1",w,h)
    x = 0; y = 222
    set_src_xy_sprite("infor panel 1",x,y)
    x = 24*2; y = 16*2
    set_xy_sprite("infor panel 1",x,y)
    # Set
    create_sprite_2("text",@viewport)
    totalsec = (framecount || 0) / Graphics.frame_rate
    bitmap = @sprites["text"].bitmap
    textpos = []
    # Text of trainer
    x = 24*2; y = 16*2
    title = (type==0)? "Save" : (type==1)?  "Load" : "Delete"
    textpos<<[_INTL("#{title}"),16*2+x,5*2+y,0,TEXTCOLOR,TEXTSHADOWCOLOR]
    textpos<<[_INTL("Badges:"),16*2+x,56*2+y,0,TEXTCOLOR,TEXTSHADOWCOLOR]
    textpos<<[trainer.numbadges.to_s,103*2+x,56*2+y,1,TEXTCOLOR,TEXTSHADOWCOLOR]
    textpos<<[_INTL("Pokédex:"),16*2+x,72*2+y,0,TEXTCOLOR,TEXTSHADOWCOLOR]
    textpos<<[trainer.pokedexSeen.to_s,103*2+x,72*2+y,1,TEXTCOLOR,TEXTSHADOWCOLOR]
    textpos<<[_INTL("Time:"),16*2+x,88*2+y,0,TEXTCOLOR,TEXTSHADOWCOLOR]
    hour = totalsec / 60 / 60
    min  = totalsec / 60 % 60
    if hour>0
      textpos<<[_INTL("{1}h {2}m",hour,min),103*2+x,88*2+y,1,TEXTCOLOR,TEXTSHADOWCOLOR]
    else
      textpos<<[_INTL("{1}m",min),103*2+x,88*2+y,1,TEXTCOLOR,TEXTSHADOWCOLOR]
    end
    if trainer.male?
      textpos<<[trainer.name,56*2+x,32*2+y,0,MALETEXTCOLOR,MALETEXTSHADOWCOLOR]
    elsif
      textpos<<[trainer.name,56*2+x,32*2+y,0,FEMALETEXTCOLOR,FEMALETEXTSHADOWCOLOR]
    else
      textpos<<[trainer.name,56*2+x,32*2+y,0,TEXTCOLOR,TEXTSHADOWCOLOR]
    end
    mapname = pbGetMapNameFromId(mapid)
    mapname.gsub!(/\\PN/,trainer.name)
    textpos<<[mapname,193*2+x,5*2+y,1,TEXTCOLOR,TEXTSHADOWCOLOR]
    # Load menu
    if type==1
      # Mystery gift / Language
      string = []
      string<<_INTL("Mystery Gift") if mystery
      string<<_INTL("Language") if LANGUAGES.length>=2
      if @qinfor>0
        (0...@qinfor).each { |i|
          str = string[i]
          x1 = x + 36 + 8
          y1 = y + 5 + 112*2 + 48*i
          textpos<<[str,x1,y1,0,TEXTCOLOR,TEXTSHADOWCOLOR]
        }
      end
    end
    # Set text
    (font.nil?)? pbSetSystemFont(bitmap) : bitmap.font.name = font
    pbDrawTextPositions(bitmap,textpos)
    # Set trainer
    if !trainer || !trainer.party
      # Fade
      pbFadeInAndShow(@sprites) { update }
      return
    else
      meta = pbGetMetadata(0,MetadataPlayerA+trainer.metaID)
      if meta
        filename = pbGetPlayerCharset(meta,1,trainer,true)
        @sprites["player"] = TrainerWalkingCharSprite.new(filename,@viewport)
        charwidth  = @sprites["player"].bitmap.width
        charheight = @sprites["player"].bitmap.height
        @sprites["player"].x        = 56*2-charwidth/8
        @sprites["player"].y        = 56*2-charheight/8
        @sprites["player"].src_rect = Rect.new(0,0,charwidth/4,charheight/4)
      end
      for i in 0...trainer.party.length
        @sprites["party#{i}"] = PokemonIconSprite.new(trainer.party[i],@viewport)
        @sprites["party#{i}"].setOffset(PictureOrigin::Center)
        @sprites["party#{i}"].x = (167+33*(i%2))*2
        @sprites["party#{i}"].y = (56+25*(i/2))*2
        @sprites["party#{i}"].z = 99999
      end
      # Fade
      pbFadeInAndShow(@sprites) { update }
    end
  end

  def choosePanelInfor
    if @posinfor==0
      w = 408; h = 222
      set_src_wh_sprite("infor panel 1",w,h)
      x = 0; y = 222
      set_src_xy_sprite("infor panel 1",x,y)
      x = 24*2; y = 16*2
      set_xy_sprite("infor panel 1",x,y)
    else
      w = 384; h = 46
      set_src_wh_sprite("infor panel 1",w,h)
      x = 16; y = 490
      set_src_xy_sprite("infor panel 1",x,y)
      x = 24*2 + 8
      y = 16*2 + 48*(@posinfor-1) + 112*2
      set_xy_sprite("infor panel 1",x,y)
    end
  end
#-------------------------------------------------------------------------------
# Save
#-------------------------------------------------------------------------------
  def saveOldfile
    $Trainer.metaID=$PokemonGlobal.playerID
    # Write save name
    dir = DIR_SAVE_GAME; filename = FILENAME_SAVE_GAME
    savename = "#{dir}/#{filename}#{@position+1}.rxdata"
    begin
      File.open(savename,"wb") { |f|
         Marshal.dump($Trainer,f)
         Marshal.dump(Graphics.frame_count,f)
         if $data_system.respond_to?("magic_number")
           $game_system.magic_number = $data_system.magic_number
         else
           $game_system.magic_number = $data_system.version_id
         end
         $game_system.save_count+=1
         Marshal.dump($game_system,f)
         Marshal.dump($PokemonSystem,f)
         Marshal.dump($game_map.map_id,f)
         Marshal.dump($game_switches,f)
         Marshal.dump($game_variables,f)
         Marshal.dump($game_self_switches,f)
         Marshal.dump($game_screen,f)
         Marshal.dump($MapFactory,f)
         Marshal.dump($game_player,f)
         $PokemonGlobal.safesave = false
         Marshal.dump($PokemonGlobal,f)
         Marshal.dump($PokemonMap,f)
         Marshal.dump($PokemonBag,f)
         Marshal.dump($PokemonStorage,f)
         Marshal.dump(ESSENTIALS_VERSION,f)
      }
      Graphics.frame_reset
    rescue
      return false
    end
    return true
  end
#-------------------------------------------------------------------------------
# Load
#-------------------------------------------------------------------------------
  def loadOldFile
    dir = DIR_SAVE_GAME; filename = FILENAME_SAVE_GAME
    savefile = "#{dir}/#{filename}#{@position+1}.rxdata"
    metadata = nil
    File.open(savefile) { |f|
      Marshal.load(f)   # Trainer already loaded
      $Trainer             = @trainer
      Graphics.frame_count = Marshal.load(f)
      $game_system         = Marshal.load(f)
      Marshal.load(f)   # PokemonSystem already loaded
      Marshal.load(f)   # Current map id no longer needed
      $game_switches       = Marshal.load(f)
      $game_variables      = Marshal.load(f)
      $game_self_switches  = Marshal.load(f)
      $game_screen         = Marshal.load(f)
      $MapFactory          = Marshal.load(f)
      $game_map            = $MapFactory.map
      $game_player         = Marshal.load(f)
      $PokemonGlobal       = Marshal.load(f)
      metadata             = Marshal.load(f)
      $PokemonBag          = Marshal.load(f)
      $PokemonStorage      = Marshal.load(f)
      $SaveVersion         = Marshal.load(f) unless f.eof?
      pbRefreshResizeFactor   # To fix Game_Screen pictures
      magicNumberMatches = false
      if $data_system.respond_to?("magic_number")
        magicNumberMatches = ($game_system.magic_number==$data_system.magic_number)
      else
        magicNumberMatches = ($game_system.magic_number==$data_system.version_id)
      end
      if !magicNumberMatches || $PokemonGlobal.safesave
        if pbMapInterpreterRunning?
          pbMapInterpreter.setup(nil,0)
        end
        begin
          $MapFactory.setup($game_map.map_id)   # calls setMapChanged
        rescue Errno::ENOENT
          if $DEBUG
            pbMessage(_INTL("Map {1} was not found.",$game_map.map_id))
            map = pbWarpToMap
            if map
              $MapFactory.setup(map[0])
              $game_player.moveto(map[1],map[2])
            else
              $game_map = nil
              $scene = nil
              return
            end
          else
            $game_map = nil
            $scene = nil
            pbMessage(_INTL("The map was not found. The game cannot continue."))
          end
        end
        $game_player.center($game_player.x, $game_player.y)
      else
        $MapFactory.setMapChanged($game_map.map_id)
      end
    }
    if !$game_map.events   # Map wasn't set up
      $game_map = nil
      $scene = nil
      pbMessage(_INTL("The map is corrupt. The game cannot continue."))
      return
    end
    $PokemonMap = metadata
    $PokemonEncounters = PokemonEncounters.new
    $PokemonEncounters.setup($game_map.map_id)
    pbAutoplayOnSave
    $game_map.update
    $PokemonMap.updateMap
    $scene = Scene_Map.new
    return
  end
#-------------------------------------------------------------------------------
# Delete
#-------------------------------------------------------------------------------
  def deleteFile
    dir = DIR_SAVE_GAME; filename = FILENAME_SAVE_GAME
    savefile = "#{dir}/#{filename}#{@position+1}.rxdata"
    begin; File.delete(savefile); rescue; end
    begin; File.delete(savefile+".bak"); rescue; end
  end
#-------------------------------------------------------------------------------
#  Load File
#-------------------------------------------------------------------------------
  def pbTryLoadFile(savefile)
    trainer       = nil
    framecount    = nil
    game_system   = nil
    pokemonSystem = nil
    mapid         = nil
    File.open(savefile) { |f|
      trainer       = Marshal.load(f)
      framecount    = Marshal.load(f)
      game_system   = Marshal.load(f)
      pokemonSystem = Marshal.load(f)
      mapid         = Marshal.load(f)
    }
    raise "Corrupted file" if !trainer.is_a?(PokeBattle_Trainer)
    raise "Corrupted file" if !framecount.is_a?(Numeric)
    raise "Corrupted file" if !game_system.is_a?(Game_System)
    raise "Corrupted file" if !pokemonSystem.is_a?(PokemonSystem)
    raise "Corrupted file" if !mapid.is_a?(Numeric)
    return [trainer,framecount,game_system,pokemonSystem,mapid]
  end
#-------------------------------------------------------------------------------
# Set SE for input
#-------------------------------------------------------------------------------
  def checkInput(name)
    if Input.trigger?(name)
      (name==Input::B)? pbPlayCloseMenuSE : pbPlayDecisionSE
      return true
    end
    return false
  end
#-------------------------------------------------------------------------------
# Set bitmap
#-------------------------------------------------------------------------------
  # Image
  def create_sprite(spritename,filename,vp,dir="Pictures")
    @sprites["#{spritename}"] = Sprite.new(vp)
    @sprites["#{spritename}"].bitmap = Bitmap.new("Graphics/#{dir}/#{filename}")
  end

  # Set x, y
  def set_xy_sprite(spritename,x,y)
    @sprites["#{spritename}"].x = x
    @sprites["#{spritename}"].y = y
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
    @sprites["#{spritename}"].bitmap.clear
  end
#-------------------------------------------------------------------------------
  def dispose
    pbDisposeSpriteHash(@sprites)
  end

  def update
    pbUpdateSpriteHash(@sprites)
  end

  def update_ingame
    Graphics.update
    Input.update
    pbUpdateSpriteHash(@sprites)
  end

  def endScene
    #pbFadeOutAndHide(@sprites) { update }
    dispose
    @viewport.dispose
  end
end
