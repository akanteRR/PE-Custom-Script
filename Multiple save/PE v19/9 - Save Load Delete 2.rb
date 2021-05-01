#------------------------------------------------------------------------------#
# Scene for save menu, load menu and delete menu                               #
#------------------------------------------------------------------------------#
class ScreenChooseFileSave
#-------------------------------------------------------------------------------
# Set Panel
#-------------------------------------------------------------------------------
  # Draw panel
  def startPanel
    # Check and rename
    FileSave.rename
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
			set_xy_sprite("panel #{i}",x,y) 
		}
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
						if checkInput(Input::USE)
							dispose
							draw = true
							if self.fileLoad.empty?
								@choose = 0; @position = 0
								if FileSave.count==0
									pbMessage(_INTL('You dont have any save file. Restart game now.'))
									@staymenu = false
									$scene = pbCallTitle if @type == 1
									break
								end
							else
								infor = true
							end
						end
            if checkInput(Input::BACK)
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
            if checkInput(Input::USE)
              # Save file
							case @type
              when 0
								SaveData.changeFILEPATH(FileSave.name(@position+1))
								if Game.save
									pbMessage(_INTL("\\se[]{1} saved the game.\\me[GUI save game]\\wtnp[30]", $Trainer.name))
									ret = true
								else
									pbMessage(_INTL("\\se[]Save failed.\\wtnp[30]"))
									ret = false
								end
								SaveData.changeFILEPATH($storenamefilesave.nil? ? FileSave.name : $storenamefilesave)
                break
              # Delete file
              when 2
                if pbConfirmMessageSerious(_INTL("Delete all saved data?"))
                  pbMessage(_INTL("Once data has been deleted, there is no way to recover it.\1"))
                  if pbConfirmMessageSerious(_INTL("Delete the saved data anyway?"))
                    pbMessage(_INTL("Deleting all data. Don't turn off the power.\\wtnp[0]"))
                    # Delete
                    self.deleteFile
                    @deletefile = true
                  end
                end
                break
              end
            end
            (dispose; draw = true; infor = false) if checkInput(Input::BACK)
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
        if checkInput(Input::USE)
          # Set up system again
					$storenamefilesave = FileSave.name(@position+1)
          Game.set_up_system
          if @posinfor==0
            Game.load(self.fileLoad)
            @staymenu = false
            break
          # Mystery Gift
          elsif @posinfor==1 && @mysgif
						pbFadeOutIn { 
							pbDownloadMysteryGift(self.fileLoad[:player]) 
							@posinfor = 0; @qinfor = 0; @mysgif = false
              dispose; draw = true; loadmenu=false; infor = false
						}
          # Language
          elsif Settings::LANGUAGES.length>=2 && ( @posinfor==2 || (@posinfor==1 && !@mysgif))
						$PokemonSystem.language = pbChooseLanguage
						pbLoadMessages('Data/' + Settings::LANGUAGES[$PokemonSystem.language][1])
						self.fileLoad[:pokemon_system] = $PokemonSystem
						File.open(FileSave.name(@position+1), 'wb') { |file| Marshal.dump(self.fileLoad, file) }
            @posinfor = 0; @qinfor = 0; @mysgif = false
            dispose; draw = true; loadmenu=false; infor = false
          end
        end
        if checkInput(Input::BACK)
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
		# Set trainer
		trainer = self.fileLoad[:player]
    # Set mystery gift and language
    if type==1
			mystery = self.fileLoad[:player].mystery_gift_unlocked
      @mysgif = mystery
      @qinfor+=1 if mystery
      @qinfor+=1 if Settings::LANGUAGES.length>=2
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
		framecount = self.fileLoad[:frame_count]
    totalsec = (framecount || 0) / Graphics.frame_rate
    bitmap = @sprites["text"].bitmap
    textpos = []
    # Text of trainer
    x = 24*2; y = 16*2
    title = (type==0)? "Save" : (type==1)?  "Load" : "Delete"
    textpos<<[_INTL("#{title}"),16*2+x,5*2+y,0,TEXTCOLOR,TEXTSHADOWCOLOR]
    textpos<<[_INTL("Badges:"),16*2+x,56*2+y,0,TEXTCOLOR,TEXTSHADOWCOLOR]
    textpos<<[trainer.badge_count.to_s,103*2+x,56*2+y,1,TEXTCOLOR,TEXTSHADOWCOLOR]
    textpos<<[_INTL("Pokédex:"),16*2+x,72*2+y,0,TEXTCOLOR,TEXTSHADOWCOLOR]
    textpos<<[trainer.pokedex.seen_count.to_s,103*2+x,72*2+y,1,TEXTCOLOR,TEXTSHADOWCOLOR]
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
		mapid = self.fileLoad[:map_factory].map.map_id
    mapname = pbGetMapNameFromId(mapid)
    mapname.gsub!(/\\PN/,trainer.name)
    textpos<<[mapname,193*2+x,5*2+y,1,TEXTCOLOR,TEXTSHADOWCOLOR]
    # Load menu
    if type==1
      # Mystery gift / Language
      string = []
      string<<_INTL("Mystery Gift") if mystery
      string<<_INTL("Language") if Settings::LANGUAGES.length>=2
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

    # Set trainer (draw)
    if !trainer || !trainer.party
      # Fade
      pbFadeInAndShow(@sprites) { update }
      return
    else
      meta = GameData::Metadata.get_player(trainer.character_ID)
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
# Delete
#-------------------------------------------------------------------------------
  def deleteFile
		savefile = FileSave.name(@position+1, false)
		begin
      SaveData.delete_file(savefile)
      pbMessage(_INTL('The saved data was deleted.'))
    rescue SystemCallError
      pbMessage(_INTL('All saved data could not be deleted.'))
    end
  end
#-------------------------------------------------------------------------------
#  Load File
#-------------------------------------------------------------------------------
	def load_save_file(file_path)
		save_data = SaveData.read_from_file(file_path)
		unless SaveData.valid?(save_data)
			if File.file?(file_path + '.bak')
				pbMessage(_INTL('The save file is corrupt. A backup will be loaded.'))
				save_data = load_save_file(file_path + '.bak')
			else
				self.prompt_save_deletion
				return {}
			end
		end
		return save_data
	end

	# Called if all save data is invalid.
	# Prompts the player to delete the save files.
	def prompt_save_deletion
		pbMessage(_INTL('Cant load this save file'))
		pbMessage(_INTL('The save file is corrupt, or is incompatible with this game.'))
		exit unless pbConfirmMessageSerious(_INTL('Do you want to delete this save file?'))
		self.deleteFile
		$game_system   = Game_System.new
		$PokemonSystem = PokemonSystem.new
	end

	def fileLoad
		return load_save_file(FileSave.name(@position+1))
	end
end