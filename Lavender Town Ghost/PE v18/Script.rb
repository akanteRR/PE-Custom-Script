#-------------------------------------------------------------------------------
# Lavender Town Ghosts V18.1
#
# Credit: zerokid (original), bo4p5687 (update), Richard PT (key item section)
#-------------------------------------------------------------------------------
PluginManager.register({
  :name    => "Lavender Town Ghosts",
  :version => "1.1",
  :credits => ["zerokid (original)", "bo4p5687 (update)", "Richard PT (key item section)"]
})
#-------------------------------------------------------------------------------
# Map id
GHOSTMAPS=[50,51,52,53,54,66]
#-------------------------------------------------------------------------------
# Set image
class PokemonBattlerSprite
  def setGhostBitmap
    @_iconBitmap.dispose if @_iconBitmap
    @_iconBitmap = AnimatedBitmap.new("Graphics/Battlers/Ghost.png")
    self.bitmap = (@_iconBitmap) ? @_iconBitmap.bitmap : nil
    pbSetPositionGhost
  end
end
# Check this event
def isGhostEncountersActive?
  onGhostMap=false
  (0...GHOSTMAPS.length).each {|i|
    if $game_map.map_id == GHOSTMAPS[i]
      onGhostMap = true; break
    end }
  if !$PokemonBag.pbHasItem?(:SILPHSCOPE)
    return true if onGhostMap
    return false
  else
    return false
  end
end
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
# Set position
class PokemonBattlerSprite
  def pbSetPositionGhost
    return if !@_iconBitmap
    pbSetOrigin
    if (@index%2)==0
      self.z = 50+5*@index/2
    else
      self.z = 50-5*(@index+1)/2
    end
    # Set original position
    p = PokeBattle_SceneConstants.pbBattlerPosition(@index,@sideSize)
    @spriteX = p[0]
    @spriteY = p[1]
  end
end
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
class PokeBattle_Scene

  # Set Bitmap
  def pbChangeGhostPokemon(idxBattler,pkmn)
    idxBattler = idxBattler.index if idxBattler.respond_to?("index")
    pkmnSprite   = @sprites["pokemon_#{idxBattler}"]
    pkmnSprite.setGhostBitmap
  end

  def pbInitSprites
    @sprites = {}
    # The background image and each side's base graphic
    pbCreateBackdropSprites
    # Create message box graphic
    messageBox = pbAddSprite("messageBox",0,Graphics.height-96,
       "Graphics/Pictures/Battle/overlay_message",@viewport)
    messageBox.z = 195
    # Create message window (displays the message)
    msgWindow = Window_AdvancedTextPokemon.newWithSize("",
       16,Graphics.height-96+2,Graphics.width-32,96,@viewport)
    msgWindow.z              = 200
    msgWindow.opacity        = 0
    msgWindow.baseColor      = PokeBattle_SceneConstants::MESSAGE_BASE_COLOR
    msgWindow.shadowColor    = PokeBattle_SceneConstants::MESSAGE_SHADOW_COLOR
    msgWindow.letterbyletter = true
    @sprites["messageWindow"] = msgWindow
    # Create command window
    @sprites["commandWindow"] = CommandMenuDisplay.new(@viewport,200)
    # Create fight window
    @sprites["fightWindow"] = FightMenuDisplay.new(@viewport,200)
    # Create targeting window
    @sprites["targetWindow"] = TargetMenuDisplay.new(@viewport,200,@battle.sideSizes)
    pbShowWindow(MESSAGE_BOX)
    # The party lineup graphics (bar and balls) for both sides
    for side in 0...2
      partyBar = pbAddSprite("partyBar_#{side}",0,0,
         "Graphics/Pictures/Battle/overlay_lineup",@viewport)
      partyBar.z       = 120
      partyBar.mirror  = true if side==0   # Player's lineup bar only
      partyBar.visible = false
      for i in 0...PokeBattle_SceneConstants::NUM_BALLS
        ball = pbAddSprite("partyBall_#{side}_#{i}",0,0,nil,@viewport)
        ball.z       = 121
        ball.visible = false
      end
      # Ability splash bars
      if PokeBattle_SceneConstants::USE_ABILITY_SPLASH
        @sprites["abilityBar_#{side}"] = AbilitySplashBar.new(side,@viewport)
      end
    end
    # Player's and partner trainer's back sprite
    @battle.player.each_with_index do |p,i|
      pbCreateTrainerBackSprite(i,p.trainertype,@battle.player.length)
    end
    # Opposing trainer(s) sprites
    if @battle.trainerBattle?
      @battle.opponent.each_with_index do |p,i|
        pbCreateTrainerFrontSprite(i,p.trainertype,@battle.opponent.length)
      end
    end
    # Data boxes and Pokémon sprites
    @battle.battlers.each_with_index do |b,i|
      next if !b
      @sprites["dataBox_#{i}"] = PokemonDataBox.new(b,@battle.pbSideSize(i),@viewport)
      pbCreatePokemonSprite(i)
    end
    # Wild battle, so set up the Pokémon sprite(s) accordingly
    if @battle.wildBattle?
      @battle.pbParty(1).each_with_index do |pkmn,i|
        index = i*2+1
        # Change this
        if isGhostEncountersActive? # Ghost event
          pbChangeGhostPokemon(index,pkmn)
        else
          pbChangePokemon(index,pkmn)
        end
        pkmnSprite = @sprites["pokemon_#{index}"]
        pkmnSprite.tone    = Tone.new(-80,-80,-80)
        pkmnSprite.visible = true
      end
    end
  end

end
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
class PokeBattle_Battle

  # RUN
  def pbRun(idxBattler,duringBattle=false)
    battler = @battlers[idxBattler]
    if battler.opposes?
      return 0 if trainerBattle?
      @choices[idxBattler][0] = :Run
      @choices[idxBattler][1] = 0
      @choices[idxBattler][2] = nil
      return -1
    end
    # Fleeing from trainer battles
    if trainerBattle?
      if $DEBUG && Input.press?(Input::CTRL)
        if pbDisplayConfirm(_INTL("Treat this battle as a win?"))
          @decision = 1
          return 1
        elsif pbDisplayConfirm(_INTL("Treat this battle as a loss?"))
          @decision = 2
          return 1
        end
      elsif @internalBattle
        pbDisplayPaused(_INTL("No! There's no running from a Trainer battle!"))
      elsif pbDisplayConfirm(_INTL("Would you like to forfeit the match and quit now?"))
        pbDisplay(_INTL("{1} forfeited the match!",self.pbPlayer.name)) { pbSEPlay("Battle flee") }
        @decision = 3
        return 1
      end
      return 0
    end
    # Fleeing from wild battles
    if $DEBUG && Input.press?(Input::CTRL)
      pbDisplayPaused(_INTL("You got away safely!")) { pbSEPlay("Battle flee") }
      @decision = 3
      return 1
    end
    if !@canRun
      pbDisplayPaused(_INTL("You can't escape!"))
      return 0
    end
    if !duringBattle
      # *** Ghost (run) ***
      if isGhostEncountersActive?
        pbDisplayPaused(_INTL("Got away safely!"))
        @decision=3
        return 1
      end
      if battler.pbHasType?(:GHOST) && NEWEST_BATTLE_MECHANICS
        pbDisplayPaused(_INTL("You got away safely!")) { pbSEPlay("Battle flee") }
        @decision = 3
        return 1
      end
      # Abilities that guarantee escape
      if battler.abilityActive?
        if BattleHandlers.triggerRunFromBattleAbility(battler.ability,battler)
          pbShowAbilitySplash(battler,true)
          pbHideAbilitySplash(battler)
          pbDisplayPaused(_INTL("You got away safely!")) { pbSEPlay("Battle flee") }
          @decision = 3
          return 1
        end
      end
      # Held items that guarantee escape
      if battler.itemActive?
        if BattleHandlers.triggerRunFromBattleItem(battler.item,battler)
          pbDisplayPaused(_INTL("{1} fled using its {2}!",
             battler.pbThis,battler.itemName)) { pbSEPlay("Battle flee") }
          @decision = 3
          return 1
        end
      end
      # Other certain trapping effects
      if battler.effects[PBEffects::Trapping]>0 ||
         battler.effects[PBEffects::MeanLook]>=0 ||
         battler.effects[PBEffects::Ingrain] ||
         @field.effects[PBEffects::FairyLock]>0
        pbDisplayPaused(_INTL("You can't escape!"))
        return 0
      end
      # Trapping abilities/items
      eachOtherSideBattler(idxBattler) do |b|
        next if !b.abilityActive?
        if BattleHandlers.triggerTrappingTargetAbility(b.ability,battler,b,self)
          pbDisplayPaused(_INTL("{1} prevents escape with {2}!",b.pbThis,b.abilityName))
          return 0
        end
      end
      eachOtherSideBattler(idxBattler) do |b|
        next if !b.itemActive?
        if BattleHandlers.triggerTrappingTargetItem(b.item,battler,b,self)
          pbDisplayPaused(_INTL("{1} prevents escape with {2}!",b.pbThis,b.itemName))
          return 0
        end
      end
    end
    # Fleeing calculation
    # Get the speeds of the Pokémon fleeing and the fastest opponent
    # NOTE: Not pbSpeed, because using unmodified Speed.
    @runCommand += 1 if !duringBattle   # Make it easier to flee next time
    speedPlayer = @battlers[idxBattler].speed
    speedEnemy = 1
    eachOtherSideBattler(idxBattler) do |b|
      speed = b.speed
      speedEnemy = speed if speedEnemy<speed
    end
    # Compare speeds and perform fleeing calculation
    if speedPlayer>speedEnemy
      rate = 256
    else
      rate = (speedPlayer*128)/speedEnemy
      rate += @runCommand*30
    end
    if rate>=256 || @battleAI.pbAIRandom(256)<rate
      pbDisplayPaused(_INTL("You got away safely!")) { pbSEPlay("Battle flee") }
      @decision = 3
      return 1
    end
    pbDisplayPaused(_INTL("You couldn't get away!"))
    return -1
  end

  # Battle
  def pbStartBattleSendOut(sendOuts)
    # "Want to battle" messages
    if wildBattle?
      foeParty = pbParty(1)
      if isGhostEncountersActive?
        pbDisplayPaused(_INTL("Ghostttt!"))
      else
        case foeParty.length
        when 1
          pbDisplayPaused(_INTL("Oh! A wild {1} appeared!",foeParty[0].name))
        when 2
          pbDisplayPaused(_INTL("Oh! A wild {1} and {2} appeared!",foeParty[0].name,
             foeParty[1].name))
        when 3
          pbDisplayPaused(_INTL("Oh! A wild {1}, {2} and {3} appeared!",foeParty[0].name,
             foeParty[1].name,foeParty[2].name))
       end
     end
    else   # Trainer battle
      case @opponent.length
      when 1
        pbDisplayPaused(_INTL("You are challenged by {1}!",@opponent[0].fullname))
      when 2
        pbDisplayPaused(_INTL("You are challenged by {1} and {2}!",@opponent[0].fullname,
           @opponent[1].fullname))
      when 3
        pbDisplayPaused(_INTL("You are challenged by {1}, {2} and {3}!",
           @opponent[0].fullname,@opponent[1].fullname,@opponent[2].fullname))
      end
    end
    # Send out Pokémon (opposing trainers first)
    for side in [1,0]
      next if side==1 && wildBattle?
      msg = ""
      toSendOut = []
      trainers = (side==0) ? @player : @opponent
      # Opposing trainers and partner trainers's messages about sending out Pokémon
      trainers.each_with_index do |t,i|
        next if side==0 && i==0   # The player's message is shown last
        msg += "\r\n" if msg.length>0
        sent = sendOuts[side][i]
        case sent.length
        when 1
          msg += _INTL("{1} sent out {2}!",t.fullname,@battlers[sent[0]].name)
        when 2
          msg += _INTL("{1} sent out {2} and {3}!",t.fullname,
             @battlers[sent[0]].name,@battlers[sent[1]].name)
        when 3
          msg += _INTL("{1} sent out {2}, {3} and {4}!",t.fullname,
             @battlers[sent[0]].name,@battlers[sent[1]].name,@battlers[sent[2]].name)
        end
        toSendOut.concat(sent)
      end
      # The player's message about sending out Pokémon
      if side==0
        msg += "\r\n" if msg.length>0
        sent = sendOuts[side][0]
        case sent.length
        when 1
          msg += _INTL("Go! {1}!",@battlers[sent[0]].name)
        when 2
          msg += _INTL("Go! {1} and {2}!",@battlers[sent[0]].name,@battlers[sent[1]].name)
        when 3
          msg += _INTL("Go! {1}, {2} and {3}!",@battlers[sent[0]].name,
             @battlers[sent[1]].name,@battlers[sent[2]].name)
        end
        toSendOut.concat(sent)
      end
      pbDisplayBrief(msg) if msg.length>0
      # The actual sending out of Pokémon
      animSendOuts = []
      toSendOut.each do |idxBattler|
        animSendOuts.push([idxBattler,@battlers[idxBattler].pokemon])
      end
      pbSendOut(animSendOuts,true)
    end
  end

  # Pokemon can't fight
  def pbFightMenu(idxBattler)
    # Auto-use Encored move or no moves choosable, so auto-use Struggle
    return pbAutoChooseMove(idxBattler) if !pbCanShowFightMenu?(idxBattler)
    # Battle Palace only
    return true if pbAutoFightMenu(idxBattler)
    # Regular move selection
    ret = false
    @scene.pbFightMenu(idxBattler,pbCanMegaEvolve?(idxBattler)) { |cmd|
      case cmd
      when -1   # Cancel
      when -2   # Toggle Mega Evolution
        pbToggleRegisteredMegaEvolution(idxBattler)
        next false
      when -3   # Shift
        pbUnregisterMegaEvolution(idxBattler)
        pbRegisterShift(idxBattler)
        ret = true
      else      # Chose a move to use
        if isGhostEncountersActive? && wildBattle?
          pbDisplayPaused(_INTL("{1} is too scared to moveeee!",@battlers[idxBattler].name))
        else
          next false if cmd<0 || !@battlers[idxBattler].moves[cmd] ||
                                  @battlers[idxBattler].moves[cmd].id<=0
          next false if !pbRegisterMove(idxBattler,cmd)
          next false if !singleBattle? &&
             !pbChooseTarget(@battlers[idxBattler],@battlers[idxBattler].moves[cmd])
          ret = true
        end
      end
      next true
    }
    return ret
  end

end
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
# Throw Pokeball
module PokeBattle_BattleCommon
  alias pbGhostThrow pbThrowPokeBall
  def pbThrowPokeBall(idxBattler,ball,rareness=nil,showPlayer=false)
    if isGhostEncountersActive?
			@scene.pbThrowAndDeflect(ball,idxBattler)
      pbDisplayPaused(_INTL("It dodged the thrown Ball! This POKéMON can't be caught!"))
      return
    end
    pbGhostThrow(idxBattler,ball,rareness,showPlayer)
  end
end
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
class PokeBattle_AI
  alias pbGhostAI pbDefaultChooseEnemyCommand
  def pbDefaultChooseEnemyCommand(idxBattler)
    if isGhostEncountersActive? && @battle.wildBattle? && @battle.opposes?(idxBattler)
      @battle.pbDisplayPaused(_INTL("Ghost: Get out... Get out..."))
      return
    end
    pbGhostAI(idxBattler)
  end
end
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
class PokeBattle_Battler
  def pbInitPokemon(pkmn,idxParty)
    raise _INTL("An egg can't be an active Pokémon.") if pkmn.egg?
    if opposes? && !@battle.trainerBattle? && isGhostEncountersActive?
      @name         = "Ghost"
    else
      @name         = pkmn.name
    end
    @species      = pkmn.species
    @form         = pkmn.form
    @level        = pkmn.level
    @hp           = pkmn.hp
    @totalhp      = pkmn.totalhp
    @type1        = pkmn.type1
    @type2        = pkmn.type2
    @ability      = pkmn.ability
    @item         = pkmn.item
    if opposes? && !@battle.trainerBattle? && isGhostEncountersActive?
      @gender       = 2
    else
      @gender       = pkmn.gender
    end
    @attack       = pkmn.attack
    @defense      = pkmn.defense
    @spatk        = pkmn.spatk
    @spdef        = pkmn.spdef
    @speed        = pkmn.speed
    @status       = pkmn.status
    @statusCount  = pkmn.statusCount
    @pokemon      = pkmn
    @pokemonIndex = idxParty
    @participants = []   # Participants earn Exp. if this battler is defeated
    @moves        = []
    pkmn.moves.each_with_index do |m,i|
      @moves[i] = PokeBattle_Move.pbFromPBMove(@battle,m)
    end
    @iv           = pkmn.iv.clone
  end
end
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
class PokemonDataBox
  def refresh
    self.bitmap.clear
    return if !@battler.pokemon
    textPos = []
    imagePos = []
    # Draw background panel
    self.bitmap.blt(0,0,@databoxBitmap.bitmap,Rect.new(0,0,@databoxBitmap.width,@databoxBitmap.height))
    # Draw Pokémon's name
    nameWidth = self.bitmap.text_size(@battler.name).width
    nameOffset = 0
    nameOffset = nameWidth-116 if nameWidth>116
    textPos.push([@battler.name,@spriteBaseX+8-nameOffset,6,false,NAME_BASE_COLOR,NAME_SHADOW_COLOR])
    # Draw Pokémon's gender symbol
    case @battler.displayGender
    when 0   # Male
      textPos.push([_INTL("♂"),@spriteBaseX+126,6,false,MALE_BASE_COLOR,MALE_SHADOW_COLOR])
    when 1   # Female
      textPos.push([_INTL("♀"),@spriteBaseX+126,6,false,FEMALE_BASE_COLOR,FEMALE_SHADOW_COLOR])
    end
    pbDrawTextPositions(self.bitmap,textPos)
    # Draw Pokémon's level
    imagePos.push(["Graphics/Pictures/Battle/overlay_lv",@spriteBaseX+140,16])
    pbDrawNumber(@battler.level,self.bitmap,@spriteBaseX+162,16)
    # Draw shiny icon
    if @battler.shiny?
      shinyX = (@battler.opposes?(0)) ? 206 : -6   # Foe's/player's
      imagePos.push(["Graphics/Pictures/shiny",@spriteBaseX+shinyX,36])
    end
    # Draw Mega Evolution/Primal Reversion icon
    if @battler.mega?
      imagePos.push(["Graphics/Pictures/Battle/icon_mega",@spriteBaseX+8,34])
    elsif @battler.primal?
      primalX = (@battler.opposes?) ? 208 : -28   # Foe's/player's
      if @battler.isSpecies?(:KYOGRE)
        imagePos.push(["Graphics/Pictures/Battle/icon_primal_Kyogre",@spriteBaseX+primalX,4])
      elsif @battler.isSpecies?(:GROUDON)
        imagePos.push(["Graphics/Pictures/Battle/icon_primal_Groudon",@spriteBaseX+primalX,4])
      end
    end
    # Draw owned icon (foe Pokémon only)
    if @battler.owned? && @battler.opposes?(0)
      imagePos.push(["Graphics/Pictures/Battle/icon_own",@spriteBaseX+8,36]) if !isGhostEncountersActive?
    end
    # Draw status icon
    if @battler.status>0
      s = @battler.status
      s = 6 if s==PBStatuses::POISON && @battler.statusCount>0   # Badly poisoned
      imagePos.push(["Graphics/Pictures/Battle/icon_statuses",@spriteBaseX+24,36,
         0,(s-1)*STATUS_ICON_HEIGHT,-1,STATUS_ICON_HEIGHT])
    end
    pbDrawImagePositions(self.bitmap,imagePos)
    refreshHP
    refreshExp
  end
end