# Animated battler
# Credit: bo4p5687

if defined?(PluginManager)
  PluginManager.register({
    :name => "Animated battler",
    :credits => "bo4p5687"
  })
end

# Repeat animation (times)
module RepeatAnimate
	Trainer = 3
	Pokemon = 3
	# Wait each frame
	WaitT = 1 # Trainer
	WaitP = 1 # Pokemon
end

#===============================================================================
# Pokémon sprite (used out of battle)
#===============================================================================
class PokemonSprite

	# Return first frame
	def firstFrame
		return if !self.bitmap
		self.src_rect.width = self.src_rect.height = self.bitmap.height
	end

  def setOffset(offset=PictureOrigin::Center)
    @offset = offset
		firstFrame # Set again
    changeOrigin
  end

	alias animate_change_origin changeOrigin
  def changeOrigin
    return if !self.bitmap
		animate_change_origin
		firstFrame # Set again
		# Set coordinate
		div = self.bitmap.width / self.bitmap.height
    case @offset
    when PictureOrigin::Top, PictureOrigin::Center, PictureOrigin::Bottom
      self.ox = self.bitmap.width / (2 * div)
    when PictureOrigin::TopRight, PictureOrigin::Right, PictureOrigin::BottomRight
      self.ox = self.bitmap.width / div
    end
  end

	alias animate_set_pkmn_bitmap setPokemonBitmap
	def setPokemonBitmap(pokemon,back=false)
		animate_set_pkmn_bitmap(pokemon,back)
		firstFrame # Set again
		changeOrigin
  end

	alias animate_set_pkmn_bitmap_species setPokemonBitmapSpecies
  def setPokemonBitmapSpecies(pokemon,species,back=false)
		animate_set_pkmn_bitmap_species(pokemon,species,back)
		firstFrame # Set again
    changeOrigin
  end

	alias animate_set_species_bitmap setSpeciesBitmap
  def setSpeciesBitmap(species,female=false,form=0,shiny=false,shadow=false,back=false,egg=false)
		animate_set_species_bitmap(species,female,form,shiny,shadow,back,egg)
		firstFrame # Set again
    changeOrigin
  end

	def update
    super
    if @_iconbitmap
      @_iconbitmap.update
      self.bitmap = @_iconbitmap.bitmap
			firstFrame # Set again, update
    end
  end

end

class MosaicPokemonSprite
	alias animate_mosaic_refresh mosaicRefresh
  def mosaicRefresh(bitmap)
		firstFrame # Set again, begin
		animate_mosaic_refresh(bitmap)
  end
end

class PokemonBattlerSprite

	# Return first frame
	def firstFrame
		return if !self.bitmap
		self.src_rect.width = self.src_rect.height = self.bitmap.height
	end

  def setPokemonBitmap(pkmn,back=false)
    @pkmn = pkmn
    @_iconBitmap.dispose if @_iconBitmap
    @_iconBitmap = pbLoadPokemonBitmap(@pkmn,back)
    self.bitmap = (@_iconBitmap) ? @_iconBitmap.bitmap : nil
		firstFrame # Set again
    pbSetPosition
  end

  # Set sprite's origin to bottom middle
  def pbSetOrigin
    return if !@_iconBitmap
		self.src_rect.width = self.bitmap.height
		div = self.bitmap.width / self.bitmap.height
    self.ox = @_iconBitmap.width / (2 * div)
    self.oy = @_iconBitmap.height
  end

	def update(frameCounter=0)
    return if !@_iconBitmap
    @updating = true
    # Update bitmap
    @_iconBitmap.update
    self.bitmap = @_iconBitmap.bitmap
		firstFrame # Set again
    # Pokémon sprite bobbing while Pokémon is selected
    @spriteYExtra = 0
    if @selected==1    # When choosing commands for this Pokémon
      case (frameCounter/QUARTER_ANIM_PERIOD).floor
      when 1 then @spriteYExtra = 2
      when 3 then @spriteYExtra = -2
      end
    end
    self.x       = self.x
    self.y       = self.y
    self.visible = @spriteVisible
    # Pokémon sprite blinking when targeted
    if @selected==2 && @spriteVisible
      case (frameCounter/SIXTH_ANIM_PERIOD).floor
      when 2, 5 then self.visible = false
      else           self.visible = true
      end
    end
    @updating = false
  end

end

def pbSpriteSetAnimFrame(sprite,frame,user=nil,target=nil,inEditor=false)
  return if !sprite
	# New
	div = sprite.bitmap.width / sprite.bitmap.height if sprite.bitmap
	# Old
  if !frame
    sprite.visible  = false
    sprite.src_rect = Rect.new(0,0,1,1)
    return
  end
  sprite.blend_type = frame[AnimFrame::BLENDTYPE]
  sprite.angle      = frame[AnimFrame::ANGLE]
  sprite.mirror     = (frame[AnimFrame::MIRROR]>0)
  sprite.opacity    = frame[AnimFrame::OPACITY]
  sprite.visible    = true
  if !frame[AnimFrame::VISIBLE]==1 && inEditor
    sprite.opacity  /= 2
  else
    sprite.visible  = (frame[AnimFrame::VISIBLE]==1)
  end
  pattern = frame[AnimFrame::PATTERN]
  if pattern>=0
    animwidth = 192
    sprite.src_rect.set((pattern%5)*animwidth,(pattern/5)*animwidth,
       animwidth,animwidth)
  else
    sprite.src_rect.set(0,0,
       (sprite.bitmap) ? sprite.bitmap.width / (div>1 ? div : 1) : 128, # Change
       (sprite.bitmap) ? sprite.bitmap.height : 128)
  end
  sprite.zoom_x = frame[AnimFrame::ZOOMX]/100.0
  sprite.zoom_y = frame[AnimFrame::ZOOMY]/100.0
  sprite.color.set(
     frame[AnimFrame::COLORRED],
     frame[AnimFrame::COLORGREEN],
     frame[AnimFrame::COLORBLUE],
     frame[AnimFrame::COLORALPHA]
  )
  sprite.tone.set(
     frame[AnimFrame::TONERED],
     frame[AnimFrame::TONEGREEN],
     frame[AnimFrame::TONEBLUE],
     frame[AnimFrame::TONEGRAY]
  )
  sprite.ox = sprite.src_rect.width / 2
  sprite.oy = sprite.src_rect.height / 2
  sprite.x  = frame[AnimFrame::X]
  sprite.y  = frame[AnimFrame::Y]
  if sprite!=user && sprite!=target
    case frame[AnimFrame::PRIORITY]
    when 0   # Behind everything
      sprite.z = 10
    when 1   # In front of everything
      sprite.z = 80
    when 2   # Just behind focus
      case frame[AnimFrame::FOCUS]
      when 1   # Focused on target
        sprite.z = (target) ? target.z-1 : 20
      when 2   # Focused on user
        sprite.z = (user) ? user.z-1 : 20
      else     # Focused on user and target, or screen
        sprite.z = 20
      end
    when 3   # Just in front of focus
      case frame[AnimFrame::FOCUS]
      when 1   # Focused on target
        sprite.z = (target) ? target.z+1 : 80
      when 2   # Focused on user
        sprite.z = (user) ? user.z+1 : 80
      else     # Focused on user and target, or screen
        sprite.z = 80
      end
    else
      sprite.z = 80
    end
  end
end

class PokeBattle_Scene
	def pbCreateTrainerFrontSprite(idxTrainer,trainerType,numTrainers=1)
    trainerFile = pbTrainerSpriteFile(trainerType)
    spriteX, spriteY = PokeBattle_SceneConstants.pbTrainerPosition(1,idxTrainer,numTrainers)
    trainer = pbAddSprite("trainer_#{idxTrainer+1}",spriteX,spriteY,trainerFile,@viewport)
    return if !trainer.bitmap
    # Alter position of sprite
    trainer.z  = 7+idxTrainer
		div = trainer.bitmap.width / trainer.bitmap.height
		trainer.src_rect.width = trainer.bitmap.height if div > 1
    trainer.ox = trainer.src_rect.width/2
    trainer.oy = trainer.bitmap.height
  end
end

class TrainerIntroAnimation < PokeBattle_Animation
  def initialize(sprites,viewport,battle)
    @battle=battle
    super(sprites,viewport)
  end

  def createProcesses
    @battle.opponent.each_with_index do |p,i|
			trainer = addSprite(@sprites["trainer_#{i+1}"],PictureOrigin::Bottom)
			sprite = @sprites["trainer_#{i+1}"]
			div = sprite.bitmap.width / sprite.bitmap.height
			return unless div > 1
			delay = 0
			trainer.setSrcSize(delay, sprite.bitmap.width / div, sprite.bitmap.height)
			trainer.setSrc(delay, 0, 0)
			# Animate
			curframe = RepeatAnimate::WaitT
			sum = div * RepeatAnimate::Trainer
			while sum > 0
				trainer.setSrc(delay + curframe - RepeatAnimate::WaitT, ((curframe / RepeatAnimate::WaitT) % div) * sprite.bitmap.height, 0)
				curframe += RepeatAnimate::WaitT
				sum -= 1
			end
			trainer.setSrc(delay + div * RepeatAnimate::Trainer, 0, 0)
    end
  end
end

# Wild battle
class WildIntroAnimation < PokeBattle_Animation
  def initialize(sprites,viewport,sideSize)
    @sideSize = sideSize
    super(sprites,viewport)
  end

  def createProcesses
    for i in 0...@sideSize
      idxBattler = 2*i+1
      next if !@sprites["pokemon_#{idxBattler}"]
      battler = addSprite(@sprites["pokemon_#{idxBattler}"],PictureOrigin::Bottom)
			sprite  = @sprites["pokemon_#{idxBattler}"]
			div = sprite.bitmap.width / sprite.bitmap.height
			return unless div > 1
			delay = 0
			battler.setSrcSize(delay, sprite.bitmap.width / div, sprite.bitmap.height)
			battler.setSrc(delay, 0, 0)
			# Animate
			curframe = RepeatAnimate::WaitP
			sum = div * RepeatAnimate::Pokemon
			while sum > 0
				battler.setSrc(delay + curframe - RepeatAnimate::WaitP, ((curframe / RepeatAnimate::WaitP) % div) * sprite.bitmap.height, 0)
				curframe += RepeatAnimate::WaitP
				sum -= 1
			end
			battler.setSrc(delay + div * RepeatAnimate::Pokemon, 0, 0)
    end
  end

end


module PokeBattle_BallAnimationMixin
	alias animate_battler_appear battlerAppear
	def battlerAppear(battler,delay,battlerX,battlerY,batSprite,color)
		animate_battler_appear(battler,delay,battlerX,battlerY,batSprite,color)
		# New
		div = batSprite.bitmap.width / batSprite.bitmap.height
		return if div <= 1
		curframe = RepeatAnimate::WaitP
		sum = div * RepeatAnimate::Pokemon
		while sum > 0
			battler.setSrc(delay + 5 + 1 + curframe - RepeatAnimate::WaitP, ((curframe/RepeatAnimate::WaitP) % div) * batSprite.bitmap.height, 0)
			curframe += RepeatAnimate::WaitP
			sum -= 1
		end
		battler.setSrc(delay + 5 + 1 + div * RepeatAnimate::Pokemon, 0, 0)
  end
end

class PokeBattle_Scene
  def pbBattleIntroAnimation
    # Make everything appear
    introAnim = BattleIntroAnimation.new(@sprites,@viewport,@battle)
    loop do
      introAnim.update
      pbUpdate
      break if introAnim.animDone?
    end
    introAnim.dispose
    # Post-appearance activities
    # Trainer battle: get ready to show the party lineups (they are brought
    # on-screen by a separate animation)
    if @battle.trainerBattle?
			# Add trainer
			@animations.push(TrainerIntroAnimation.new(@sprites,@viewport,@battle))
      # NOTE: Here is where you'd make trainer sprites animate if they had an
      #       entrance animation. Be sure to set it up like a Pokémon entrance
      #       animation, i.e. add them to @animations so that they can play out
      #       while party lineups appear and messages show.
      pbShowPartyLineup(0,true)
      pbShowPartyLineup(1,true)
      return
    end
		# Add
		@animations.push(WildIntroAnimation.new(@sprites,@viewport,@battle.sideSizes[1]))
    # Wild battle: play wild Pokémon's intro animations (including cry), show
    # data box(es), return the wild Pokémon's sprite(s) to normal colour, show
    # shiny animation(s)
    # Set up data box animation
    for i in 0...@battle.sideSizes[1]
      idxBattler = 2*i+1
      next if !@battle.battlers[idxBattler]
      dataBoxAnim = DataBoxAppearAnimation.new(@sprites,@viewport,idxBattler)
      @animations.push(dataBoxAnim)
    end
    # Set up wild Pokémon returning to normal colour and playing intro
    # animations (including cry)
    @animations.push(BattleIntroAnimation2.new(@sprites,@viewport,@battle.sideSizes[1]))
    # Play all the animations
    while inPartyAnimation?; pbUpdate; end
    # Show shiny animation for wild Pokémon
    if @battle.showAnims
      for i in 0...@battle.sideSizes[1]
        idxBattler = 2*i+1
        next if !@battle.battlers[idxBattler] || !@battle.battlers[idxBattler].shiny?
        pbCommonAnimation("Shiny",@battle.battlers[idxBattler])
      end
    end
  end
end
