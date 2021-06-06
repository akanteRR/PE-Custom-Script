#===============================================================================
# * Type Quiz - by FL (Credits will be apreciated)
#===============================================================================
#
# This script is for Pokémon Essentials. It's a type quiz minigame where
# the player must know the multiplier of a certain type effectiveness in a
# certain type combination. You can use it by a normal message question or by
# a scene screen.
#
# The proportion of correct answers are made in way to every answer will have
# the same amount of being correct
#
#===============================================================================
#
# To this script works, put it above main. 
#
# Put graphics in 'Graphics/Pictures/TypeQuiz'
#
# To use the quiz in standard text message, calls the script
# 'TypeQuiz::TypeQuestion.new.messageQuestion' in a conditional branch and
# handle when the player answers correctly and incorrectly, respectively.
#
# To use the scene screen, use the script command 'TypeQuiz.scene(X)' 
# where X is the number of total questions. This method will return the number
# of question answered correctly.
#
#===============================================================================
# bo4p5687 (update)
#-------------------------------------------------------------------------------
PluginManager.register({
  :name => "Type Quiz",
  :credits => ["FL (original)","bo4p5687 (update)"]
})
#-------------------------------------------------------------------------------
module TypeQuiz
  # If false the last two answers merge into one, resulting in five answers
  SIXANSWERS = true
  # In scene points the right answer if the player miss
  SHOWRIGHTANSWER = true
  
  DIRTYPE = "Graphics/Pictures/TypeQuiz"
  
  class TypeQuestion
    attr_reader :attackType
    attr_reader :defense1Type
    attr_reader :defense2Type
    attr_reader :result
    
    TYPEAVALIABLE = [:NORMAL,:FIGHTING,:FLYING,:POISON,:GROUND,
        :ROCK,:BUG,:GHOST,:STEEL,:FIRE,:WATER,:GRASS,:ELECTRIC,:PSYCHIC,
        :ICE,:DRAGON,:DARK]
        
    ANSWERS=[ _INTL("4x"),_INTL("2x"),_INTL("Normal"),_INTL("1/2") ]
    
    ANSWERS+= SIXANSWERS ? [_INTL("1/4"),_INTL("Immune")] : [_INTL("1/4 or immune")]
      
    def initialize
      @result=-1
      # Set type
      @attackType   = getID(PBTypes,TYPEAVALIABLE[rand(TYPEAVALIABLE.size)])
      @defense1Type = getID(PBTypes,TYPEAVALIABLE[rand(TYPEAVALIABLE.size)])
      @defense2Type = getID(PBTypes,TYPEAVALIABLE[rand(TYPEAVALIABLE.size)])
      # Set value
      mod1 = PBTypes.getEffectiveness(@attackType,@defense1Type)
      mod2 = PBTypeEffectiveness::NORMAL_EFFECTIVE_ONE
      if @defense1Type!=@defense2Type
        mod2 = PBTypes.getEffectiveness(@attackType,@defense2Type)
      end
      e = mod1*mod2
      # Use module PBTypeEffectiveness
      # INEFFECTIVE          = 0
      # NOT_EFFECTIVE_ONE    = 1
      # NORMAL_EFFECTIVE_ONE = 2
      # SUPER_EFFECTIVE_ONE  = 4
      # NORMAL_EFFECTIVE     = NORMAL_EFFECTIVE_ONE ** 3
      if e==0
        @result = ANSWERS.size-1
      elsif e==1
        @result = 4
      elsif e==2
        @result = 3
      elsif e<=4 && e>2
        @result = 2
      elsif e<=8 && e>4
        @result = 1
      elsif e>8
        @result = 0
      end
    end
    
    def messageQuestion
      attack = PBTypes.getName(@attackType)
      defense = PBTypes.getName(@defense1Type)
      defense += "/"+PBTypes.getName(@defense2Type) if @defense1Type!=@defense2Type
      question=_INTL("What is the damage of an {1} move versus a {2} pokémon?",
        attack,defense)
      return pbMessage(question,ANSWERS,0)==@result
    end  
  end
    
  class TypeQuizScene
    BGPATH = "#{DIRTYPE}/typequizbg"
    VSPATH = "#{DIRTYPE}/typequizvs"
    SCENEMUSIC = "evolv" # Put "" or nil to don't change the music.
    
    WAITFRAMESQUANTITY = 40*1
    MARGIN = 32
    
    def update
      pbUpdateSpriteHash(@sprites)
    end
    
    def pbStartScene(questions)
      @questionsTotal=questions
      @questionsCount=0
      @questionsRight=0
      @index=0
      pbBGMPlay(SCENEMUSIC) if SCENEMUSIC && SCENEMUSIC!=nil
      @sprites={} 
      @viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
      @viewport.z=99999
      @typebitmap = Sprite.new(@viewport)
      @typebitmap.bitmap = Bitmap.new("#{DIRTYPE}/types")
      @sprites["background"]=IconSprite.new(0,0,@viewport)
      @sprites["background"].setBitmap(BGPATH)
      @sprites["background"].x=(Graphics.width-@sprites["background"].bitmap.width)/2
      @sprites["background"].y=(Graphics.height-@sprites["background"].bitmap.height)/2    
      @sprites["vs"]=IconSprite.new(0,0,@viewport)
      @sprites["vs"].setBitmap(VSPATH)
      @sprites["vs"].x=Graphics.width*3/4-@sprites["vs"].bitmap.width/2-12
      @sprites["vs"].y=Graphics.height*3/4-@sprites["vs"].bitmap.height/2-32
      @sprites["arrow"] = IconSprite.new(MARGIN+8,0,@viewport)
      @sprites["overlay"]=BitmapSprite.new(Graphics.width,Graphics.height,@viewport)
      pbSetSystemFont(@sprites["overlay"].bitmap)
      nextQuestion
      pbFadeInAndShow(@sprites) { update }
    end
    
    def nextQuestion
      @questionsCount+=1
      return if finished?
      @typeQuestion=TypeQuestion.new
      @sprites["arrow"].bitmap = Bitmap.new("#{DIRTYPE}/selarrow")
      @answerLabel=""
      refresh
      # Normal effective index
      @index=2 
      updateCursor
    end  
  
    def refresh
      leftText = ""
      centerText = ""
      rightText = ""
      overlay=@sprites["overlay"].bitmap
      overlay.clear 
      baseColor=Color.new(72,72,72)
      shadowColor=Color.new(160,160,160)
      # Remove to don't show player score
      leftText = @questionsRight.to_s
      # Remove to don't show Correct/Wrong message
      centerText = @answerLabel 
      # Remove to don't show question count
      rightText += @questionsCount.to_s 
      rightText += "/" if rightText!=""
      # Remove to don't show question total
      rightText += @questionsTotal.to_s 
      textPositions=[]
      # Left
      x = MARGIN; y = Graphics.height/2-80
      textPositions<<[leftText,x,y,false,baseColor,shadowColor]
      # Center
      x = Graphics.width/2; y = Graphics.height/2-80
      textPositions<<[centerText,x,y,2,baseColor,shadowColor]
      # Right
      x = Graphics.width-MARGIN; y = Graphics.height/2-80
      textPositions<<[rightText,x,y,true,baseColor,shadowColor]
      # Answers
      (0...TypeQuestion::ANSWERS.size).each { |i|
      string = TypeQuestion::ANSWERS[i]
      x = 2*MARGIN
      y = Graphics.height/2+i*40-40
      textPositions.push([string,x,y,false,baseColor,shadowColor]) }
      pbDrawTextPositions(overlay,textPositions)
      # Draw type
      typeX = Graphics.width*3/4-40
      typeDefY = Graphics.height*3/4+40
      typeAtkRect  = Rect.new(0,@typeQuestion.attackType*28,64,28)
      typeDef1Rect = Rect.new(0,@typeQuestion.defense1Type*28,64,28)
      typeDef2Rect = Rect.new(0,@typeQuestion.defense2Type*28,64,28)
      overlay.blt(typeX,Graphics.height/2-36,@typebitmap.bitmap,typeAtkRect)
      if @typeQuestion.defense1Type==@typeQuestion.defense2Type
        overlay.blt(typeX,typeDefY,@typebitmap.bitmap,typeDef1Rect)
      else
        overlay.blt(typeX-34,typeDefY,@typebitmap.bitmap,typeDef1Rect)
        overlay.blt(typeX+34,typeDefY,@typebitmap.bitmap,typeDef2Rect)
      end
    end
    
    def updateCursor
      @sprites["arrow"].y=Graphics.height/2+@index*40-40
    end  
  
    def pbMain
      redraw = false
      loop do
        Graphics.update
        Input.update
        update
        break if finished?
        if @answerLabel!=""
          if !redraw
            refresh
            pbWait(WAITFRAMESQUANTITY)
            redraw = true
          else
            nextQuestion
            redraw = false
          end
        else  
          if Input.trigger?(Input::C)
            if @typeQuestion.result == @index 
              @answerLabel=_INTL("Correct!")
              pbSEPlay("itemlevel") 
              @questionsRight+=1
            else
              @answerLabel=_INTL("Wrong!")
              pbSEPlay("buzzer") 
              if SHOWRIGHTANSWER
                @index = @typeQuestion.result
                @sprites["arrow"].bitmap = Bitmap.new("#{DIRTYPE}/selarrowwhite")
                updateCursor
              end
            end
          end  
          if Input.trigger?(Input::B)
            pbPlayDecisionSE
            break
          end
          if Input.trigger?(Input::UP)
            pbPlayDecisionSE
            @index = (@index==0 ? TypeQuestion::ANSWERS.size : @index)-1
            updateCursor
          elsif Input.trigger?(Input::DOWN)
            pbPlayDecisionSE
            @index = (@index==TypeQuestion::ANSWERS.size-1) ? 0 : @index+1
            updateCursor
          end
        end
      end
      # Result
      result
    end
    
    def result
      if finished?
        pbMessage(_INTL("Game end! {1} correct answer(s)!",@questionsRight))
        return @questionsRight
      end
      return -1
    end
    
    def finished?
      return @questionsCount>@questionsTotal
    end  
  
    def pbEndScene
      $game_map.autoplay if SCENEMUSIC && SCENEMUSIC!=nil
      pbFadeOutAndHide(@sprites) { update }
      pbDisposeSpriteHash(@sprites)
      @typebitmap.dispose
      @viewport.dispose
    end
  end
  
  class TypeQuizScreen
    def initialize(scene)
      @scene=scene
    end
  
    def pbStartScreen(questions=10)
      @scene.pbStartScene(questions)
      @scene.pbMain
      @scene.pbEndScene
    end
  end
  
  def self.scene(questions=10)
    pbFadeOutIn {
      scene = TypeQuizScene.new
      screen = TypeQuizScreen.new(scene)
      screen.pbStartScreen(questions)
    }
  end
end