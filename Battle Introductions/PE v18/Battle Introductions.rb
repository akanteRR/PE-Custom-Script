#-------------------------------------------------------------------------------
#  Battle Introductions
#  Credit: bo4p5687, graphics by Richard PT
#
#  Put graphics in Graphics/Pictures/Battle Introductions
#  
#  You can add new environment with name: environment Animation
#  Example: Planet Animation 
#  Note: This is the name of the image in folder
#
#  Find 'case environment' for adding new environment
#
#-------------------------------------------------------------------------------
PluginManager.register({
  :name => "Battle Introductions",
  :credits => ["bo4p5687", "graphics by Richard PT"]
})
#-------------------------------------------------------------------------------
class BattleIntroAnimation < PokeBattle_Animation
  
  # Set name for introduction
  class BattleIntroduction
    def initialize(sprites,viewport,environment)
      @sprites = sprites
      @viewport = viewport
      @name = nil
      # Set name of the picture. It depend environment (in module PBEnvironment)
      case environment
      when 1; @name = "Grass"
      when 2; @name = "Tall Grass"
      when 3,4,5; @name = "Water"
      when 6; @name = "Underwater"
      when 7; @name = "Cave"
      when 9; @name = "Sand"
      end
    end
    
    def check?
      return false if @name.nil?
      return true
    end
    
    def create
      @sprites = AnimatedPlane.new(@viewport)
      filename = "Graphics/Pictures/Battle Introductions/#{@name} Animation"
      @sprites.bitmap = Bitmap.new(filename)
      return @sprites
    end
  end
  
  def createProcesses
    appearTime = 20   # This is in 1/20 seconds
    # Set for animation of introduction
    @vp = Viewport.new(0,0,Graphics.width,288)
    @vp.z = 99999
    animIntro = BattleIntroduction.new(@sprites["Intro animation"],@vp,@battle.environment)
    @animI = (animIntro.check?)? animIntro.create : nil
    if !@animI.nil?
      @frs = 0
      appearTime = 60
    end
    # Background
    if @sprites["battle_bg2"]
      makeSlideSprite("battle_bg",0.5,appearTime)
      makeSlideSprite("battle_bg2",0.5,appearTime)
    end
    # Bases
    makeSlideSprite("base_0",1,appearTime,PictureOrigin::Bottom)
    makeSlideSprite("base_1",-1,appearTime,PictureOrigin::Center)
    # Player sprite, partner trainer sprite
    @battle.player.each_with_index do |_p,i|
      makeSlideSprite("player_#{i+1}",1,appearTime,PictureOrigin::Bottom)
    end
    # Opposing trainer sprite(s) or wild Pokémon sprite(s)
    if @battle.trainerBattle?
      @battle.opponent.each_with_index do |_p,i|
        makeSlideSprite("trainer_#{i+1}",-1,appearTime,PictureOrigin::Bottom)
      end
    else   # Wild battle
      @battle.pbParty(1).each_with_index do |_pkmn,i|
        idxBattler = 2*i+1
        makeSlideSprite("pokemon_#{idxBattler}",-1,appearTime,PictureOrigin::Bottom)
      end
    end
    # Shadows
    for i in 0...@battle.battlers.length
      makeSlideSprite("shadow_#{i}",((i%2)==0) ? 1 : -1,appearTime,PictureOrigin::Center)
    end
    # Fading blackness over whole screen
    blackScreen = addNewSprite(0,0,"Graphics/Battle animations/black_screen")
    blackScreen.setZ(0,999)
    blackScreen.moveOpacity(0,8,0)
    # Fading blackness over command bar
    blackBar = addNewSprite(@sprites["cmdBar_bg"].x,@sprites["cmdBar_bg"].y,
       "Graphics/Battle animations/black_bar")
    blackBar.setZ(0,998)
    blackBar.moveOpacity(appearTime*3/4,appearTime/4,0)
  end
 
  alias dispose_animation_introduction dispose
  def dispose
    dispose_animation_introduction
    @animI.dispose if !@animI.nil?
    @vp.dispose
  end
  
  def update
    return if @animDone
    @tempSprites.each { |s| s.update if s }
    finished = true
    @pictureEx.each_with_index do |p,i|
      next if !p.running?
      finished = false
      # Set animation
      if !@animI.nil?
        @animI.ox += 5
        if @frs>5 && @frs%5==0 
          @vp.rect.height -= 0.25
          @vp.rect.y += 1
        end
        @frs+=1
      end
      p.update
      setPictureIconSprite(@pictureSprites[i],p)
    end
    @animDone = true if finished
  end
end