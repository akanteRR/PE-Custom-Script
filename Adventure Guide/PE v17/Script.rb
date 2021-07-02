#===============================================================================
#
#   Help book (adventure rules) by bo4p5687; graphics by Richard PT
#
#===============================================================================
# Here:
#  + when I write beautiful. It means it's the limit of letters. If you write more letters, it will
#    not show or it's uglier.
#  + when I write ugly. It means when you write with this quantity, a word is ugly.
#  + when I wirte only max. It means if you write more, it will not show the rest.
#===============================================================================
#=========================         Start         ===============================
#===============================================================================
# The first page
CHOICEHELP = []
  CHOICEHELP.push(
  # beautiful: 37; ugly: 38 -> max: 65
  #START
  ["How do I do this?"], # 17 letters, including space and "?"
  ["What does this term mean?"], # 25 letters, including space and "?"
  ["CANCEL"]
  #END
  )
  
# Description of the choice (the first page)  
DESCRIPTIONHELP = []
  DESCRIPTIONHELP.push(
  # max: 124
  #START
  ["Detailled intrustions are given for various operations."], # 55 letters, including space and "."
  ["Detailled descriptions are given for terms that appear in the game."], # 67 letters, including space and "."
  ["Select to exit the Help."]
  #END
  )
  
# The second page  
MINIHELP = []
  MINIHELP.push(
  # beautiful: 37; ugly: 38 -> max: 65
  #START
  [
  ["Opening the MENU"],["Using BAG"],["Using TOSH"],["Using SAVE"],["Using OPTION"],["CANCEL"]
  ], # How do I do this?
  
  [
  ["Pokemon"],["CANCEL"]
  ] # What does this term mean?
  #END
  )

# The third page
CONTENTHELP = []
  CONTENTHELP.push(
  #START
  [ # How do I do this? (start)
  
  [ ## Opening the MENU (start)
  ["1. Press Start."],
  ["2. The Menu will open on the right."],
  ["3. Depending on the situation, the Menu may feature different heading."],
  ["The Menu will not open in certain situations such as when talking, doing something, battling, etc."]
  ], ## Opening the MENU (end)
  
  [ ## Using BAG (start)
  ["1. Select Bag on the Menu."],
  ["2. Press left or right on the + Control Pad to check the data headings:"],
  ["Items"],
  ["Key Items"],
  ["Poke Balls"],
  ["Press up or down to select an item."]
  ], ## Using BAG (end)
  
  [ ## Using TOSH (start)
  ["Test"]
  ], ## Using TOSH (end)
  
  [ ## Using SAVE (start)
  ["Test"]
  ], ## Using SAVE (end)
  
  [ ## Using OPTION (start)
  ["Test"]
  ], ## Using OPTION (end)
  
  ], # How do I do this? (end)
  
  [ # What does this term mean? (start)
  
  [ ## Pokemon (start)
  ["Pokemon is a name given to describe wondrous creatures that inhabit all corners of this world."],
  ["People raise Pokemon to be their pets, use them for battling, and so on."]
  ] ## Pokemon (end)
  
  ] # What does this term mean? (end)
  #END
  )
  
#===============================================================================
#================                 End                           ================
#===============================================================================
ItemHandlers::UseFromBag.add(:ADVENTURERULES,proc{|item|
   next (pbHelpBook) ? 1 : 0
})
#===============================================================================

class HelpBook
    
  def initialize
    @viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z=99999
    
    @viewport1=Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport1.z=99999
    
    @viewport2=Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport2.z=99999
    
    @viewport3=Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport3.z=99999
    
    @viewport4=Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport4.z=99999
    
    @viewport5=Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport5.z=99999
    
    @sprites={}
    
    @exit = false
    @process = 0
    
    @position = 0
    @choice = 0
    @positiontwo = 0
    @choicetwo = 0
    @positionthree = 0
    
    @line = 0
    @linetwo = 0
  end
  
  def pbStart
    Graphics.update
    Input.update
    self.update
    draw_scene
    loop do
      Graphics.update
      Input.update
      self.update
      break if @exit == true
      draw_first_text # draw page 1
      if @process == 0
        Graphics.update
        Input.update
        self.update
        @sprites["scene1"].visible = true # scene
        @sprites["scene2"].visible = false
        @sprites["scene3"].visible = false
        @sprites["select1"].visible = true # choice/select
        @sprites["select2"].visible = false 
        @sprites["behind1"].visible = true # behind
        @sprites["behind2"].visible = false
        @sprites["behind3"].visible = false
        @sprites["up2"].visible = false # up/down
        @sprites["down2"].visible = false
        @sprites["behind1_description"].visible = true # blanc
        @sprites["behind2_title"].visible = false # blanc title 2
        first_text
        if Input.trigger?(Input::B)
          pbEndScene
          @exit = true
        end
      elsif @process == 1
        Graphics.update
        Input.update
        self.update
        @sprites["scene1"].visible = false #scene
        @sprites["scene2"].visible = true
        @sprites["scene3"].visible = false
        @sprites["select1"].visible = false # choice/select
        @sprites["select2"].visible = true
        @sprites["behind1"].visible = false # behind
        @sprites["behind2"].visible = true 
        @sprites["behind3"].visible = false
        @sprites["up1"].visible = false # up/down
        @sprites["down1"].visible = false
        @sprites["up3"].visible = false # up/down
        @sprites["down3"].visible = false
        @sprites["behind1_description"].visible = false # blanc
        @sprites["behind2_title"].visible = true # blanc title 2
        @sprites["behind3_title"].visible = false # blanc title 3
        @sprites["overlay_list_choice_help"].bitmap.clear # clear page 1
        @sprites["overlay_description"].bitmap.clear # clear page 1
        second_text
        if Input.trigger?(Input::B)
          @positiontwo = 0
          @choicetwo = 0
          draw_first_text # redraw page 1
          @sprites["overlay_title_second"].bitmap.clear # clear title page 2
          @sprites["overlay_list_second"].bitmap.clear
          @process = 0
        end
      elsif @process == 2
        Graphics.update
        Input.update
        self.update
        @sprites["scene1"].visible = false #scene
        @sprites["scene2"].visible = false
        @sprites["scene3"].visible = true
        @sprites["select2"].visible = false # choice/select
        @sprites["behind1"].visible = false # behind
        @sprites["behind2"].visible = false
        @sprites["behind3"].visible = true
        @sprites["up2"].visible = false # up/down
        @sprites["down2"].visible = false
        @sprites["behind2_title"].visible = false  # blanc title 2
        @sprites["behind3_title"].visible = true # blanc title 3
        third_text
        if Input.trigger?(Input::B) || Input.trigger?(Input::C)
          @sprites["overlay_title_third"].bitmap.clear # clear title page 3
          @sprites["overlay_third"].bitmap.clear
          @positionthree = 0
          @line = 0
          @linetwo = 0
          draw_title_second_text # draw page 2
          draw_second_text # draw page 2
          @process = 1
        end
      end
    end
    pbEndScene
  end
  
  def draw_scene
    for i in 1...4
      @sprites["scene#{i}"] = Sprite.new(@viewport4)
      @sprites["scene#{i}"].bitmap = Bitmap.new("Graphics/Pictures/Help/Scene_#{i}")
      @sprites["scene#{i}"].visible = false
    end
    
    for i in 1...3
      @sprites["select#{i}"] = Sprite.new(@viewport4)
      @sprites["select#{i}"].bitmap = Bitmap.new("Graphics/Pictures/Help/Choice")
      @sprites["select#{i}"].x = 16
      @sprites["select#{i}"].y = 70
      @sprites["select#{i}"].visible = false
    end
    
    @sprites["behind1"] = Sprite.new(@viewport)
    @sprites["behind1"].bitmap = Bitmap.new("Graphics/Pictures/Help/Behind")
    @sprites["behind1"].visible = false
    
    @sprites["behind2"] = Sprite.new(@viewport1)
    @sprites["behind2"].bitmap = Bitmap.new("Graphics/Pictures/Help/Behind")
    @sprites["behind2"].visible = false
    
    @sprites["behind3"] = Sprite.new(@viewport2)
    @sprites["behind3"].bitmap = Bitmap.new("Graphics/Pictures/Help/Behind")
    @sprites["behind3"].visible = false
    
    for i in 1...4
      @sprites["up#{i}"] = Sprite.new(@viewport4)
      @sprites["up#{i}"].bitmap = Bitmap.new("Graphics/Pictures/Help/Arrow")
      @sprites["up#{i}"].src_rect.width = @sprites["up#{i}"].bitmap.width
      @sprites["up#{i}"].src_rect.height = @sprites["up#{i}"].bitmap.height/2
      @sprites["up#{i}"].src_rect.x = 0
      @sprites["up#{i}"].src_rect.y = 0
      @sprites["up#{i}"].x = 496
      @sprites["up#{i}"].visible = false
      
      @sprites["down#{i}"] = Sprite.new(@viewport4)
      @sprites["down#{i}"].bitmap = Bitmap.new("Graphics/Pictures/Help/Arrow")
      @sprites["down#{i}"].src_rect.width = @sprites["down#{i}"].bitmap.width
      @sprites["down#{i}"].src_rect.height = @sprites["down#{i}"].bitmap.height/2
      @sprites["down#{i}"].src_rect.x = 0
      @sprites["down#{i}"].src_rect.y = @sprites["down#{i}"].src_rect.height
      @sprites["down#{i}"].x = 496
      @sprites["down#{i}"].visible = false
    end
    
    @sprites["up1"].y = 40
    @sprites["down1"].y = 254
    
    for i in 2..3
      @sprites["up#{i}"].y = 89

      @sprites["down#{i}"].y = 349
    end
    
    @sprites["behind1_description"] = Sprite.new(@viewport1)
    @sprites["behind1_description"].bitmap = Bitmap.new("Graphics/Pictures/Help/Description")
    @sprites["behind1_description"].x = 17
    @sprites["behind1_description"].y = 288
    @sprites["behind1_description"].visible = false
    
    @sprites["behind2_title"] = Sprite.new(@viewport2)
    @sprites["behind2_title"].bitmap = Bitmap.new("Graphics/Pictures/Help/Behind_Title")
    @sprites["behind2_title"].visible = false
    
    @sprites["behind3_title"] = Sprite.new(@viewport3)
    @sprites["behind3_title"].bitmap = Bitmap.new("Graphics/Pictures/Help/Behind_Title")
    @sprites["behind3_title"].visible = false
    
    @sprites["overlay_list_choice_help"] = Sprite.new(@viewport)
    @sprites["overlay_list_choice_help"].bitmap = Bitmap.new(Graphics.width, Graphics.height)
    @sprites["overlay_list_choice_help"].bitmap.clear
    
    @sprites["overlay_description"] = Sprite.new(@viewport1)
    @sprites["overlay_description"].bitmap = Bitmap.new(Graphics.width, Graphics.height)
    @sprites["overlay_description"].bitmap.clear
    
    @sprites["overlay_title_second"] = Sprite.new(@viewport2)
    @sprites["overlay_title_second"].bitmap = Bitmap.new(Graphics.width, Graphics.height)
    @sprites["overlay_title_second"].bitmap.clear
    
    @sprites["overlay_list_second"] = Sprite.new(@viewport1)
    @sprites["overlay_list_second"].bitmap = Bitmap.new(Graphics.width, Graphics.height)
    @sprites["overlay_list_second"].bitmap.clear
    
    @sprites["overlay_title_third"] = Sprite.new(@viewport3)
    @sprites["overlay_title_third"].bitmap = Bitmap.new(Graphics.width, Graphics.height)
    @sprites["overlay_title_third"].bitmap.clear
    
    @sprites["overlay_third"] = Sprite.new(@viewport2)
    @sprites["overlay_third"].bitmap = Bitmap.new(Graphics.width, Graphics.height)
    @sprites["overlay_third"].bitmap.clear
  end
  
#===============================================================================
# First page
#===============================================================================

  def draw_first_text
    bcolor = Color.new(255,255,255)
    scolor = Color.new(0,0,0)
    bitmap1 = @sprites["overlay_list_choice_help"].bitmap
    textposition = []
    for i in 0...CHOICEHELP.length
      textposition.push([_INTL("{1}",CHOICEHELP[i]),38,64+32*i,0,bcolor,scolor])
      if CHOICEHELP[i][0].length > 37 && CHOICEHELP[i][0].length <= 52
        bitmap1.font.size = 20
        bitmap1.font.name = "Arial"
        pbDrawTextPositions(bitmap1,[textposition[i]]) 
      elsif CHOICEHELP[i][0].length > 52 && CHOICEHELP[i][0].length <= 65
        bitmap1.font.size = 15
        bitmap1.font.name = "Arial"
        pbDrawTextPositions(bitmap1,[textposition[i]])
      else
        pbSetSystemFont(bitmap1)
        pbDrawTextPositions(bitmap1,[textposition[i]])
      end
    end
  end
  
  def redraw_first_text
    bitmap1 = @sprites["overlay_list_choice_help"].bitmap
    bitmap1.clear
    bacolor = Color.new(255,255,255)
    shcolor = Color.new(0,0,0)
    textposition = []
    for i in 0...CHOICEHELP.length
      textposition.push([_INTL("{1}",CHOICEHELP[i]),38,64+32*i-32*@choice,0,bacolor,shcolor])
      if CHOICEHELP[i][0].length > 37 && CHOICEHELP[i][0].length <= 52
        bitmap1.font.size = 20
        bitmap1.font.name = "Arial"
        pbDrawTextPositions(bitmap1,[textposition[i]]) 
      elsif CHOICEHELP[i][0].length > 52 && CHOICEHELP[i][0].length <= 65
        bitmap1.font.size = 15
        bitmap1.font.name = "Arial"
        pbDrawTextPositions(bitmap1,[textposition[i]])
      else
        pbSetSystemFont(bitmap1)
        pbDrawTextPositions(bitmap1,[textposition[i]])
      end
    end
  end
  
  def draw_descripttion_first_text
    basecolor = Color.new(0,0,0)
    shadowcolor = Color.new(255,255,255)
    bitmap2 = @sprites["overlay_description"].bitmap
    bitmap2.clear
    a = CHOICEHELP.length
    if a <= 6
      for i in 0...a
        if i == @position
          if DESCRIPTIONHELP[i][0].length > 103 && DDESCRIPTIONHELP[i][0].length <= 124
            bitmap2.font.size = 21
            bitmap2.font.name = "Arial"
            drawTextEx(bitmap2,18,288,470,3,DESCRIPTIONHELP[i][0],basecolor,shadowcolor)
          elsif DESCRIPTIONHELP[i][0].length <= 103
            pbSetSystemFont(bitmap2)
            drawTextEx(bitmap2,18,288,470,2,DESCRIPTIONHELP[i][0],basecolor,shadowcolor)
          end
        end
      end
    elsif a >= 7
      for i in 0...a
        if i == @choice
          if DESCRIPTIONHELP[i][0].length > 103 && DESCRIPTIONHELP[i][0].length <= 124
            bitmap2.font.size = 21
            bitmap2.font.name = "Arial"
            drawTextEx(bitmap2,18,288,470,3,DESCRIPTIONHELP[i][0],basecolor,shadowcolor)
          elsif DESCRIPTIONHELP[i][0].length <= 103
            pbSetSystemFont(bitmap2)
            drawTextEx(bitmap2,18,288,470,2,DESCRIPTIONHELP[i][0],basecolor,shadowcolor)
          end
        end
      end
    end
  end
  
  def first_text
    a = CHOICEHELP.length
    if a <= 6
      draw_descripttion_first_text
      if Input.trigger?(Input::UP)
        pbSEPlay("Choose")
        pbSEPlay("Anim/Choose")
        @position -= 1
        @position = 0 if @position < 0
      end
      if Input.trigger?(Input::DOWN)
        pbSEPlay("Choose")
        pbSEPlay("Anim/Choose")
        @position += 1
        @position = a - 1 if @position >= a
      end
      for i in 0...a
        @sprites["select1"].y = 70 + 32*i if @position == i
      end
      if Input.trigger?(Input::C)
        unless @position == a-1
          draw_title_second_text # draw page 2
          draw_second_text # draw page 2
          @process = 1
        else
          pbEndScene
          @exit = true
        end
      end
    elsif a == 7
      draw_descripttion_first_text
      if Input.trigger?(Input::UP)
        pbSEPlay("Choose")
        pbSEPlay("Anim/Choose")
        @choice -= 1
        @position -= 1
        @choice = 0 if @choice < 0
        @position = 0 if @position < 0
      end
      if Input.trigger?(Input::DOWN)
        pbSEPlay("Choose")
        pbSEPlay("Anim/Choose")
        @choice += 1
        @position += 1 if @choice > 1
        @choice = 6 if @choice >= 6
        @position = 5 if @position >= 6
      end
      for i in 0...6
        @sprites["select1"].y = 70 + 32*i if @position == i
      end
      if @choice == 1
        redraw_first_text
        @sprites["up1"].visible = true
        @sprites["down1"].visible = false
      elsif @choice == 0
        redraw_first_text
        @sprites["down1"].visible = true
        @sprites["up1"].visible = false
      end
      if Input.trigger?(Input::C)
        unless @choice == 6
          draw_title_second_text # draw page 2
          draw_second_text # draw page 2
          @process = 1
        else
          pbEndScene
          @exit = true
        end
      end
    elsif a >= 8
      draw_descripttion_first_text
      if Input.trigger?(Input::UP)
        pbSEPlay("Choose")
        pbSEPlay("Anim/Choose")
        @choice -= 1
        @position -= 1        
        @choice = 0 if @choice < 0
        @position = 0 if @position < 0
        redraw_first_text if @choice >= 0 && @choice <= a-6
      end
      if Input.trigger?(Input::DOWN)
        pbSEPlay("Choose")
        pbSEPlay("Anim/Choose")
        @choice += 1
        @position += 1 if @choice > a-6        
        @choice = a - 1 if @choice >= a
        @position = 5 if @position >= 6
        redraw_first_text if @choice >= 1 && @choice <= a-6
      end
      for i in 0...6
        @sprites["select1"].y = 70 + 32*i if @position == i
      end
      if @choice >= 1 && @choice <= a-7
        @sprites["down1"].visible = true
        @sprites["up1"].visible = true
      elsif @choice == 0
        @sprites["down1"].visible = true
        @sprites["up1"].visible = false
      else
        @sprites["down1"].visible = false
        @sprites["up1"].visible = true
      end
      if Input.trigger?(Input::C)
        unless @choice == a-1
          draw_title_second_text # draw page 2
          draw_second_text # draw page 2
          @process = 1
        else
          pbEndScene
          @exit = true
        end
      end
    end
  end
  
#===============================================================================
# Second page
#===============================================================================

  def draw_title_second_text
    basecolor = Color.new(255,255,255)
    shadowcolor = Color.new(0,0,0)
    bitmap3 = @sprites["overlay_title_second"].bitmap
    bitmap3.clear
    secondtitleposition = []
    a = CHOICEHELP.length
    if a <= 6
      for i in 0...a
        if i == @position
          secondtitleposition.push([_INTL("{1}",CHOICEHELP[i]),5,48,0,basecolor,shadowcolor])
          if CHOICEHELP[i][0].length > 37 && CHOICEHELP[i][0].length <= 52
            bitmap3.font.size = 20
            bitmap3.font.name = "Arial"
            pbDrawTextPositions(bitmap3,secondtitleposition) 
          elsif CHOICEHELP[i][0].length > 52 && CHOICEHELP[i][0].length <= 65
            bitmap3.font.size = 15
            bitmap3.font.name = "Arial"
            pbDrawTextPositions(bitmap3,secondtitleposition)
          else
            pbSetSystemFont(bitmap3)
            pbDrawTextPositions(bitmap3,secondtitleposition)
          end
        end
      end
    elsif a >= 7
      for i in 0...a
        if i == @choice
          secondtitleposition.push([_INTL("{1}",CHOICEHELP[i]),5,48,0,basecolor,shadowcolor])
          if CHOICEHELP[i][0].length > 37 && CHOICEHELP[i][0].length <= 52
            bitmap3.font.size = 20
            bitmap3.font.name = "Arial"
            pbDrawTextPositions(bitmap3,secondtitleposition) 
          elsif CHOICEHELP[i][0].length > 52 && CHOICEHELP[i][0].length <= 65
            bitmap3.font.size = 15
            bitmap3.font.name = "Arial"
            pbDrawTextPositions(bitmap3,secondtitleposition)
          else
            pbSetSystemFont(bitmap3)
            pbDrawTextPositions(bitmap3,secondtitleposition)
          end
        end
      end
    end
  end
  
  def draw_second_text
    coloronne = Color.new(255,255,255)
    colortwo = Color.new(0,0,0)
    bitmap4 = @sprites["overlay_list_second"].bitmap
    bitmap4.clear
    a = CHOICEHELP.length
    if a <= 6
      for i in 0...a
        if i == @position
          secondtext = []
          for j in 0...MINIHELP[i].length
            secondtext.push([_INTL("{1}",MINIHELP[i][j]),38,97+32*j,0,coloronne,colortwo])
            if MINIHELP[i][j][0].length > 37 && MINIHELP[i][j][0].length <= 52
              bitmap4.font.size = 20
              bitmap4.font.name = "Arial"
              pbDrawTextPositions(bitmap4,[secondtext[j]]) 
            elsif MINIHELP[i][j][0].length > 52 && MINIHELP[i][j][0].length <= 65
              bitmap4.font.size = 15
              bitmap4.font.name = "Arial"
              pbDrawTextPositions(bitmap4,[secondtext[j]])
            else
              pbSetSystemFont(bitmap4)
              pbDrawTextPositions(bitmap4,[secondtext[j]])
            end
          end
        end
      end
    elsif a >= 7
      for i in 0...a
        if i == @choice
          secondtext = []
          for j in 0...MINIHELP[i].length
            secondtext.push([_INTL("{1}",MINIHELP[i][j]),38,97+32*j,0,coloronne,colortwo])
            if MINIHELP[i][j][0].length > 37 && MINIHELP[i][j][0].length <= 52
              bitmap4.font.size = 20
              bitmap4.font.name = "Arial"
              pbDrawTextPositions(bitmap4,[secondtext[j]]) 
            elsif MINIHELP[i][j][0].length > 52 && MINIHELP[i][j][0].length <= 65
              bitmap4.font.size = 15
              bitmap4.font.name = "Arial"
              pbDrawTextPositions(bitmap4,[secondtext[j]])
            else
              pbSetSystemFont(bitmap4)
              pbDrawTextPositions(bitmap4,[secondtext[j]])
            end
          end
        end
      end
    end
  end
  
  def redraw_second_text
    coloronne = Color.new(255,255,255)
    colortwo = Color.new(0,0,0)
    bitmap4 = @sprites["overlay_list_second"].bitmap
    a = CHOICEHELP.length
    if a <= 6
      for i in 0...a
        if i == @position
          bitmap4.clear
          secondtext = []
          for j in 0...MINIHELP[i].length
            secondtext.push([_INTL("{1}",MINIHELP[i][j]),38,97+32*j-32*@choicetwo,0,coloronne,colortwo])
            if MINIHELP[i][j][0].length > 37 && MINIHELP[i][j][0].length <= 52
              bitmap4.font.size = 20
              bitmap4.font.name = "Arial"
              pbDrawTextPositions(bitmap4,[secondtext[j]]) 
            elsif MINIHELP[i][j][0].length > 52 && MINIHELP[i][j][0].length <= 65
              bitmap4.font.size = 15
              bitmap4.font.name = "Arial"
              pbDrawTextPositions(bitmap4,[secondtext[j]])
            else
              pbSetSystemFont(bitmap4)
              pbDrawTextPositions(bitmap4,[secondtext[j]])
            end
          end
        end
      end
    elsif a >= 7
      for i in 0...a
        if i == @choice
          bitmap4.clear
          secondtext = []
          for j in 0...MINIHELP[i].length
            secondtext.push([_INTL("{1}",MINIHELP[i][j]),38,97+32*j-32*@choicetwo,0,coloronne,colortwo])
            if MINIHELP[i][j][0].length > 37 && MINIHELP[i][j][0].length <= 52
              bitmap4.font.size = 20
              bitmap4.font.name = "Arial"
              pbDrawTextPositions(bitmap4,[secondtext[j]]) 
            elsif MINIHELP[i][j][0].length > 52 && MINIHELP[i][j][0].length <= 65
              bitmap4.font.size = 15
              bitmap4.font.name = "Arial"
              pbDrawTextPositions(bitmap4,[secondtext[j]])
            else
              pbSetSystemFont(bitmap4)
              pbDrawTextPositions(bitmap4,[secondtext[j]])
            end
          end
        end
      end
    end
  end
  
  def second_text
    a = CHOICEHELP.length
    if a <= 6
      for i in 0...a
        if i == @position
          b = MINIHELP[i].length
          if b <= 8
            @sprites["select2"].y = 102 if @positiontwo == 0
            if Input.trigger?(Input::UP)
              pbSEPlay("Choose")
              pbSEPlay("Anim/Choose")
              @positiontwo -= 1
              @positiontwo = 0 if @positiontwo < 0
            end
            if Input.trigger?(Input::DOWN)
              pbSEPlay("Choose")
              pbSEPlay("Anim/Choose")
              @positiontwo += 1
              @positiontwo = b - 1 if @positiontwo >= b
            end
            for j in 0...b
              @sprites["select2"].y = 102 + 32*j if @positiontwo == j
            end
            if Input.trigger?(Input::C)
              unless @positiontwo == b-1
                draw_title_third_page # page 3
                draw_third_text
                @process = 2
              else
                @positiontwo = 0
                draw_first_text # redraw page 1
                @sprites["overlay_title_second"].bitmap.clear # clear title page 2
                @sprites["overlay_list_second"].bitmap.clear
                @process = 0
              end
            end
          elsif b == 9
            @sprites["select2"].y = 102 if @choicetwo == 0
            if Input.trigger?(Input::UP)
              pbSEPlay("Choose")
              pbSEPlay("Anim/Choose")
              @choicetwo -= 1
              @positiontwo -= 1
              @choicetwo = 0 if @choicetwo < 0
              @positiontwo = 0 if @positiontwo < 0
            end
            if Input.trigger?(Input::DOWN)
              pbSEPlay("Choose")
              pbSEPlay("Anim/Choose")
              @choicetwo += 1
              @positiontwo += 1 if @choicetwo > 1
              @choicetwo = 8 if @choicetwo >= 8
              @positiontwo = 7 if @positiontwo >= 8
            end
            for j in 0...8
              @sprites["select2"].y = 102 + 32*j if @positiontwo == j
            end
            if @choicetwo == 1
              redraw_second_text
              @sprites["up2"].visible = true
              @sprites["down2"].visible = false
            elsif @choicetwo == 0
              redraw_second_text
              @sprites["down2"].visible = true
              @sprites["up2"].visible = false
            end
            if Input.trigger?(Input::C)
              unless @choicetwo == 8
                draw_title_third_page # page 3
                draw_third_text
                @process = 2
              else
                @positiontwo = 0
                @choicetwo = 0
                draw_first_text # redraw page 1
                @sprites["overlay_title_second"].bitmap.clear # clear title page 2
                @sprites["overlay_list_second"].bitmap.clear
                @process = 0
              end
            end
          elsif b >= 10
            @sprites["select2"].y = 102 if @choicetwo == 0
            if Input.trigger?(Input::UP)
              pbSEPlay("Choose")
              pbSEPlay("Anim/Choose")
              @choicetwo -= 1
              @positiontwo -= 1        
              @choicetwo = 0 if @choicetwo < 0
              @positiontwo = 0 if @positiontwo < 0
              redraw_second_text if @choicetwo >= 0 && @choicetwo <= b-8
            end
            if Input.trigger?(Input::DOWN)
              pbSEPlay("Choose")
              pbSEPlay("Anim/Choose")
              @choicetwo += 1
              @positiontwo += 1 if @choicetwo > b-8        
              @choicetwo = b - 1 if @choicetwo >= b
              @positiontwo = 7 if @positiontwo >= 8
              redraw_second_text if @choicetwo >= 1 && @choicetwo <= b-8
            end
            for j in 0...8
              @sprites["select2"].y = 102 + 32*j if @positiontwo == j
            end
            if @choicetwo >= 1 && @choicetwo <= b-9
              @sprites["down2"].visible = true
              @sprites["up2"].visible = true
            elsif @choicetwo == 0
              @sprites["down2"].visible = true
              @sprites["up2"].visible = false
            else
              @sprites["down2"].visible = false
              @sprites["up2"].visible = true
            end
            if Input.trigger?(Input::C)
              unless @choicetwo == b-1
                draw_title_third_page # page 3
                draw_third_text
                @process = 2
              else
                @positiontwo = 0
                @choicetwo = 0
                draw_first_text # redraw page 1
                @sprites["overlay_title_second"].bitmap.clear # clear title page 2
                @sprites["overlay_list_second"].bitmap.clear
                @process = 0
              end
            end
          end
        end
      end
    elsif a >= 7
      for i in 0...a
        if i == @choice
          b = MINIHELP[i].length
          if b <= 8
            @sprites["select2"].y = 102 if @positiontwo == 0
            if Input.trigger?(Input::UP)
              pbSEPlay("Choose")
              pbSEPlay("Anim/Choose")
              @positiontwo -= 1
              @positiontwo = 0 if @positiontwo < 0
            end
            if Input.trigger?(Input::DOWN)
              pbSEPlay("Choose")
              pbSEPlay("Anim/Choose")
              @positiontwo += 1
              @positiontwo = b - 1 if @positiontwo >= b
            end
            for j in 0...b
              @sprites["select2"].y = 102 + 32*j if @positiontwo == j
            end
            if Input.trigger?(Input::C)
              unless @positiontwo == b-1
                draw_title_third_page # page 3
                draw_third_text
                @process = 2
              else
                @positiontwo = 0
                draw_first_text # redraw page 1
                @sprites["overlay_title_second"].bitmap.clear # clear title page 2
                @sprites["overlay_list_second"].bitmap.clear
                @process = 0
              end
            end
          elsif b == 9
            @sprites["select2"].y = 102 if @choicetwo == 0
            if Input.trigger?(Input::UP)
              pbSEPlay("Choose")
              pbSEPlay("Anim/Choose")
              @choicetwo -= 1
              @positiontwo -= 1
              @choicetwo = 0 if @choicetwo < 0
              @positiontwo = 0 if @positiontwo < 0
            end
            if Input.trigger?(Input::DOWN)
              pbSEPlay("Choose")
              pbSEPlay("Anim/Choose")
              @choicetwo += 1
              @positiontwo += 1 if @choicetwo > 1
              @choicetwo = 8 if @choicetwo >= 8
              @positiontwo = 7 if @positiontwo >= 8
            end
            for j in 0...8
              @sprites["select2"].y = 102 + 32*j if @positiontwo == j
            end
            if @choicetwo == 1
              redraw_second_text
              @sprites["up2"].visible = true
              @sprites["down2"].visible = false
            elsif @choicetwo == 0
              redraw_second_text
              @sprites["down2"].visible = true
              @sprites["up2"].visible = false
            end
            if Input.trigger?(Input::C)
              unless @choicetwo == 8
                draw_title_third_page # page 3
                draw_third_text
                @process = 2
              else
                @positiontwo = 0
                @choicetwo = 0
                draw_first_text # redraw page 1
                @sprites["overlay_title_second"].bitmap.clear # clear title page 2
                @sprites["overlay_list_second"].bitmap.clear
                @process = 0
              end
            end
          elsif b >= 10
            @sprites["select2"].y = 102 if @choicetwo == 0
            if Input.trigger?(Input::UP)
              pbSEPlay("Choose")
              pbSEPlay("Anim/Choose")
              @choicetwo -= 1
              @positiontwo -= 1        
              @choicetwo = 0 if @choicetwo < 0
              @positiontwo = 0 if @positiontwo < 0
              redraw_second_text if @choicetwo >= 0 && @choicetwo <= b-8
            end
            if Input.trigger?(Input::DOWN)
              pbSEPlay("Choose")
              pbSEPlay("Anim/Choose")
              @choicetwo += 1
              @positiontwo += 1 if @choicetwo > b-8        
              @choicetwo = b - 1 if @choicetwo >= b
              @positiontwo = 7 if @positiontwo >= 8
              redraw_second_text if @choicetwo >= 1 && @choicetwo <= b-8
            end
            for j in 0...8
              @sprites["select2"].y = 102 + 32*j if @positiontwo == j
            end
            if @choicetwo >= 1 && @choicetwo <= b-9
              @sprites["down2"].visible = true
              @sprites["up2"].visible = true
            elsif @choicetwo == 0
              @sprites["down2"].visible = true
              @sprites["up2"].visible = false
            else
              @sprites["down2"].visible = false
              @sprites["up2"].visible = true
            end
            if Input.trigger?(Input::C)
              unless @choicetwo == b-1
                draw_title_third_page # page 3
                draw_third_text
                @process = 2
              else
                @positiontwo = 0
                @choicetwo = 0
                draw_first_text # redraw page 1
                @sprites["overlay_title_second"].bitmap.clear # clear title page 2
                @sprites["overlay_list_second"].bitmap.clear
                @process = 0
              end
            end
          end
          
        end
      end
    end
  end
  
#===============================================================================
# Third page
#===============================================================================
  
  def draw_title_third_page
    colorbase = Color.new(255,255,255)
    clorshadow = Color.new(0,0,0)
    bitmap5 = @sprites["overlay_title_third"].bitmap
    bitmap5.clear
    a = CHOICEHELP.length
    if a <= 6
      for i in 0...a
        if i == @position
          b = MINIHELP[i].length
          for j in 0...b
            if b <= 8
              if j == @positiontwo
                thirdtitleposition = []
                thirdtitleposition.push([_INTL("{1}",MINIHELP[i][j]),5,48,0,colorbase,clorshadow])
                if MINIHELP[i][j][0].length > 37 && MINIHELP[i][j][0].length <= 52
                  bitmap5.font.size = 20
                  bitmap5.font.name = "Arial"
                  pbDrawTextPositions(bitmap5,thirdtitleposition) 
                elsif MINIHELP[i][j][0].length > 52 && MINIHELP[i][j][0].length <= 65
                  bitmap5.font.size = 15
                  bitmap5.font.name = "Arial"
                  pbDrawTextPositions(bitmap5,thirdtitleposition)
                else
                  pbSetSystemFont(bitmap5)
                  pbDrawTextPositions(bitmap5,thirdtitleposition)
                end
              end
            elsif b >= 9
              if j == @choicetwo
                thirdtitleposition = []
                thirdtitleposition.push([_INTL("{1}",MINIHELP[i][j]),5,48,0,colorbase,clorshadow])
                if MINIHELP[i][j][0].length > 37 && MINIHELP[i][j][0].length <= 52
                  bitmap5.font.size = 20
                  bitmap5.font.name = "Arial"
                  pbDrawTextPositions(bitmap5,thirdtitleposition) 
                elsif MINIHELP[i][j][0].length > 52 && MINIHELP[i][j][0].length <= 65
                  bitmap5.font.size = 15
                  bitmap5.font.name = "Arial"
                  pbDrawTextPositions(bitmap5,thirdtitleposition)
                else
                  pbSetSystemFont(bitmap5)
                  pbDrawTextPositions(bitmap5,thirdtitleposition)
                end
              end
            end
          end
        end
      end
    elsif a >= 7
      for i in 0...a
        if i == @choice
          b = MINIHELP[i].length
          for j in 0...b
            if b <= 8
              if j == @positiontwo
                thirdtitleposition = []
                thirdtitleposition.push([_INTL("{1}",MINIHELP[i][j]),5,48,0,colorbase,clorshadow])
                if MINIHELP[i][j][0].length > 37 && MINIHELP[i][j][0].length <= 52
                  bitmap5.font.size = 20
                  bitmap5.font.name = "Arial"
                  pbDrawTextPositions(bitmap5,thirdtitleposition) 
                elsif MINIHELP[i][j][0].length > 52 && MINIHELP[i][j][0].length <= 65
                  bitmap5.font.size = 15
                  bitmap5.font.name = "Arial"
                  pbDrawTextPositions(bitmap5,thirdtitleposition)
                else
                  pbSetSystemFont(bitmap5)
                  pbDrawTextPositions(bitmap5,thirdtitleposition)
                end
                
              end
            elsif b >= 9
              if j == @choicetwo
                thirdtitleposition = []
                thirdtitleposition.push([_INTL("{1}",MINIHELP[i][j]),5,48,0,colorbase,clorshadow])
                if MINIHELP[i][j][0].length > 37 && MINIHELP[i][j][0].length <= 52
                  bitmap5.font.size = 20
                  bitmap5.font.name = "Arial"
                  pbDrawTextPositions(bitmap5,thirdtitleposition) 
                elsif MINIHELP[i][j][0].length > 52 && MINIHELP[i][j][0].length <= 65
                  bitmap5.font.size = 15
                  bitmap5.font.name = "Arial"
                  pbDrawTextPositions(bitmap5,thirdtitleposition)
                else
                  pbSetSystemFont(bitmap5)
                  pbDrawTextPositions(bitmap5,thirdtitleposition)
                end
              end
            end
          end
        end
      end
    end
  end
  
  def draw_third_text
    premiercouleur = Color.new(255,255,255)
    deuxiemecouleur = Color.new(0,0,0)
    bitmap6 = @sprites["overlay_third"].bitmap
    bitmap6.clear
    a = CHOICEHELP.length
    if a <= 6
      for i in 0...a
        if i == @position
          b = MINIHELP[i].length
          for j in 0...b
            if b <= 8
              if j == @positiontwo
                for k in 0...CONTENTHELP[i][j].length
                  length = CONTENTHELP[i][j][k][0].length
                  if length > 44
                    if length%44 == 0
                      @linetwo = length/44
                      pbSetSystemFont(bitmap6)
                      drawTextEx(bitmap6,5,97+32*@line,481,@linetwo,_INTL("{1}",CONTENTHELP[i][j][k][0]),premiercouleur,deuxiemecouleur)
                      line += length/44
                    elsif length%44 != 0
                      balance = length%44
                      @linetwo = (length - balance)/44 + 1
                      pbSetSystemFont(bitmap6)
                      drawTextEx(bitmap6,5,97+32*@line,481,@linetwo,_INTL("{1}",CONTENTHELP[i][j][k][0]),premiercouleur,deuxiemecouleur)
                      @line += (length - balance)/44 + 1
                    end
                  else
                    pbSetSystemFont(bitmap6)
                    drawTextEx(bitmap6,5,97+32*@line,481,1,_INTL("{1}",CONTENTHELP[i][j][k][0]),premiercouleur,deuxiemecouleur)
                    @line += 1
                  end
                end
              end
            elsif b >= 9
              if j == @choicetwo
                for k in 0...CONTENTHELP[i][j].length
                  length = CONTENTHELP[i][j][k][0].length
                  if length > 44
                    if length%44 == 0
                      @linetwo = length/44
                      pbSetSystemFont(bitmap6)
                      drawTextEx(bitmap6,5,97+32*@line,481,@linetwo,_INTL("{1}",CONTENTHELP[i][j][k][0]),premiercouleur,deuxiemecouleur)
                      line += length/44
                    elsif length%44 != 0
                      balance = length%44
                      @linetwo = (length - balance)/44 + 1
                      pbSetSystemFont(bitmap6)
                      drawTextEx(bitmap6,5,97+32*@line,481,@linetwo,_INTL("{1}",CONTENTHELP[i][j][k][0]),premiercouleur,deuxiemecouleur)
                      @line += (length - balance)/44 + 1
                    end
                  else
                    pbSetSystemFont(bitmap6)
                    drawTextEx(bitmap6,5,97+32*@line,481,1,_INTL("{1}",CONTENTHELP[i][j][k][0]),premiercouleur,deuxiemecouleur)
                    @line += 1
                  end
                end
              end
            end
          end
        end
      end
    elsif a >= 7
      for i in 0...a
        if i == @choice
          b = MINIHELP[i].length
          for j in 0...b
            if b <= 8
              if j == @positiontwo
                for k in 0...CONTENTHELP[i][j].length
                  length = CONTENTHELP[i][j][k][0].length
                  if length > 44
                    if length%44 == 0
                      @linetwo = length/44
                      pbSetSystemFont(bitmap6)
                      drawTextEx(bitmap6,5,97+32*@line,481,@linetwo,_INTL("{1}",CONTENTHELP[i][j][k][0]),premiercouleur,deuxiemecouleur)
                      line += length/44
                    elsif length%44 != 0
                      balance = length%44
                      @linetwo = (length - balance)/44 + 1
                      pbSetSystemFont(bitmap6)
                      drawTextEx(bitmap6,5,97+32*@line,481,@linetwo,_INTL("{1}",CONTENTHELP[i][j][k][0]),premiercouleur,deuxiemecouleur)
                      @line += (length - balance)/44 + 1
                    end
                  else
                    pbSetSystemFont(bitmap6)
                    drawTextEx(bitmap6,5,97+32*@line,481,1,_INTL("{1}",CONTENTHELP[i][j][k][0]),premiercouleur,deuxiemecouleur)
                    @line += 1
                  end
                end
              end
            elsif b >= 9
              if j == @choicetwo
                for k in 0...CONTENTHELP[i][j].length
                  length = CONTENTHELP[i][j][k][0].length
                  if length > 44
                    if length%44 == 0
                      @linetwo = length/44
                      pbSetSystemFont(bitmap6)
                      drawTextEx(bitmap6,5,97+32*@line,481,@linetwo,_INTL("{1}",CONTENTHELP[i][j][k][0]),premiercouleur,deuxiemecouleur)
                      line += length/44
                    elsif length%44 != 0
                      balance = length%44
                      @linetwo = (length - balance)/44 + 1
                      pbSetSystemFont(bitmap6)
                      drawTextEx(bitmap6,5,97+32*@line,481,@linetwo,_INTL("{1}",CONTENTHELP[i][j][k][0]),premiercouleur,deuxiemecouleur)
                      @line += (length - balance)/44 + 1
                    end
                  else
                    pbSetSystemFont(bitmap6)
                    drawTextEx(bitmap6,5,97+32*@line,481,1,_INTL("{1}",CONTENTHELP[i][j][k][0]),premiercouleur,deuxiemecouleur)
                    @line += 1
                  end
                end
              end
            end
          end
        end
      end
    end
  end
  
  def redraw_third_text
    premiercouleur = Color.new(255,255,255)
    deuxiemecouleur = Color.new(0,0,0)
    bitmap6 = @sprites["overlay_third"].bitmap
    bitmap6.clear
    a = CHOICEHELP.length
    if a <= 6
      for i in 0...a
        if i == @position
          b = MINIHELP[i].length
          for j in 0...b
            if b <= 8
              if j == @positiontwo
                @line = 0
                @linetwo = 0
                for k in 0...CONTENTHELP[i][j].length
                  length = CONTENTHELP[i][j][k][0].length
                  if length > 44
                    if length%44 == 0
                      @linetwo = length/44
                      pbSetSystemFont(bitmap6)
                      drawTextEx(bitmap6,5,97+32*@line-32*@positionthree,481,@linetwo,_INTL("{1}",CONTENTHELP[i][j][k][0]),premiercouleur,deuxiemecouleur)
                      line += length/44
                    elsif length%44 != 0
                      balance = length%44
                      @linetwo = (length - balance)/44 + 1
                      pbSetSystemFont(bitmap6)
                      drawTextEx(bitmap6,5,97+32*@line-32*@positionthree,481,@linetwo,_INTL("{1}",CONTENTHELP[i][j][k][0]),premiercouleur,deuxiemecouleur)
                      @line += (length - balance)/44 + 1
                    end
                  else
                    pbSetSystemFont(bitmap6)
                    drawTextEx(bitmap6,5,97+32*@line-32*@positionthree,481,1,_INTL("{1}",CONTENTHELP[i][j][k][0]),premiercouleur,deuxiemecouleur)
                    @line += 1
                  end
                end
              end
            elsif b >= 9
              if j == @choicetwo
                @line = 0
                @linetwo = 0
                for k in 0...CONTENTHELP[i][j].length
                  length = CONTENTHELP[i][j][k][0].length
                  if length > 44
                    if length%44 == 0
                      @linetwo = length/44
                      pbSetSystemFont(bitmap6)
                      drawTextEx(bitmap6,5,97+32*@line-32*@positionthree,481,@linetwo,_INTL("{1}",CONTENTHELP[i][j][k][0]),premiercouleur,deuxiemecouleur)
                      line += length/44
                    elsif length%44 != 0
                      balance = length%44
                      @linetwo = (length - balance)/44 + 1
                      pbSetSystemFont(bitmap6)
                      drawTextEx(bitmap6,5,97+32*@line-32*@positionthree,481,@linetwo,_INTL("{1}",CONTENTHELP[i][j][k][0]),premiercouleur,deuxiemecouleur)
                      @line += (length - balance)/44 + 1
                    end
                  else
                    pbSetSystemFont(bitmap6)
                    drawTextEx(bitmap6,5,97+32*@line-32*@positionthree,481,1,_INTL("{1}",CONTENTHELP[i][j][k][0]),premiercouleur,deuxiemecouleur)
                    @line += 1
                  end
                end
              end
            end
          end
        end
      end
    elsif a >= 7
      for i in 0...a
        if i == @choice
          b = MINIHELP[i].length
          for j in 0...b
            if b <= 8
              if j == @positiontwo
                @line = 0
                @linetwo = 0
                for k in 0...CONTENTHELP[i][j].length
                  length = CONTENTHELP[i][j][k][0].length
                  if length > 44
                    if length%44 == 0
                      @linetwo = length/44
                      pbSetSystemFont(bitmap6)
                      drawTextEx(bitmap6,5,97+32*@line-32*@positionthree,481,@linetwo,_INTL("{1}",CONTENTHELP[i][j][k][0]),premiercouleur,deuxiemecouleur)
                      line += length/44
                    elsif length%44 != 0
                      balance = length%44
                      @linetwo = (length - balance)/44 + 1
                      pbSetSystemFont(bitmap6)
                      drawTextEx(bitmap6,5,97+32*@line-32*@positionthree,481,@linetwo,_INTL("{1}",CONTENTHELP[i][j][k][0]),premiercouleur,deuxiemecouleur)
                      @line += (length - balance)/44 + 1
                    end
                  else
                    pbSetSystemFont(bitmap6)
                    drawTextEx(bitmap6,5,97+32*@line-32*@positionthree,481,1,_INTL("{1}",CONTENTHELP[i][j][k][0]),premiercouleur,deuxiemecouleur)
                    @line += 1
                  end
                end
              end
            elsif b >= 9
              if j == @choicetwo
                @line = 0
                @linetwo = 0
                for k in 0...CONTENTHELP[i][j].length
                  length = CONTENTHELP[i][j][k][0].length
                  if length > 44
                    if length%44 == 0
                      @linetwo = length/44
                      pbSetSystemFont(bitmap6)
                      drawTextEx(bitmap6,5,97+32*@line-32*@positionthree,481,@linetwo,_INTL("{1}",CONTENTHELP[i][j][k][0]),premiercouleur,deuxiemecouleur)
                      line += length/44
                    elsif length%44 != 0
                      balance = length%44
                      @linetwo = (length - balance)/44 + 1
                      pbSetSystemFont(bitmap6)
                      drawTextEx(bitmap6,5,97+32*@line-32*@positionthree,481,@linetwo,_INTL("{1}",CONTENTHELP[i][j][k][0]),premiercouleur,deuxiemecouleur)
                      @line += (length - balance)/44 + 1
                    end
                  else
                    pbSetSystemFont(bitmap6)
                    drawTextEx(bitmap6,5,97+32*@line-32*@positionthree,481,1,_INTL("{1}",CONTENTHELP[i][j][k][0]),premiercouleur,deuxiemecouleur)
                    @line += 1
                  end
                end
              end
            end
          end
        end
      end
    end
  end
  
  def third_text
    a = CHOICEHELP.length
    if a <= 6
      for i in 0...a
        if i == @position
          b = MINIHELP[i].length
          for j in 0...b
            if b <= 8
              if j == @positiontwo
                c = @line
                if c == 9
                  if Input.trigger?(Input::UP)
                    pbSEPlay("Choose")
                    pbSEPlay("Anim/Choose")
                    @positionthree -= 1
                    @positionthree = 0 if @positionthree <= 0
                  end
                  if Input.trigger?(Input::DOWN)
                    pbSEPlay("Choose")
                    pbSEPlay("Anim/Choose")
                    @positionthree += 1
                    @positionthree = 1 if @positionthree >= 1
                  end
                  if @positionthree == 1
                    redraw_third_text
                    @sprites["up3"].visible = true
                    @sprites["down3"].visible = false
                  elsif @positionthree == 0
                    redraw_third_text
                    @sprites["up3"].visible = false
                    @sprites["down3"].visible = true
                  end
                elsif c >= 10
                  if Input.trigger?(Input::UP)
                    pbSEPlay("Choose")
                    pbSEPlay("Anim/Choose")
                    @positionthree -= 1
                    @positionthree = 0 if @positionthree <= 0
                    redraw_third_text
                  end
                  if Input.trigger?(Input::DOWN)
                    pbSEPlay("Choose")
                    pbSEPlay("Anim/Choose")
                    @positionthree += 1
                    @positionthree = c-8 if @positionthree >= c-8
                    redraw_third_text
                  end
                  if @positionthree == 0
                    @sprites["up3"].visible = false
                    @sprites["down3"].visible = true
                  elsif @positionthree <= c-9 && @positionthree >= 1
                    @sprites["up3"].visible = true
                    @sprites["down3"].visible = true
                  else
                    @sprites["up3"].visible = true
                    @sprites["down3"].visible = false
                  end
                end
              end
            elsif b >= 9
              if j == @choicetwo
                c = @line
                if c == 9
                  if Input.trigger?(Input::UP)
                    pbSEPlay("Choose")
                    pbSEPlay("Anim/Choose")
                    @positionthree -= 1
                    @positionthree = 0 if @positionthree <= 0
                  end
                  if Input.trigger?(Input::DOWN)
                    pbSEPlay("Choose")
                    pbSEPlay("Anim/Choose")
                    @positionthree += 1
                    @positionthree = 1 if @positionthree >= 1
                  end
                  if @positionthree == 1
                    redraw_third_text
                    @sprites["up3"].visible = true
                    @sprites["down3"].visible = false
                  elsif @positionthree == 0
                    redraw_third_text
                    @sprites["up3"].visible = false
                    @sprites["down3"].visible = true
                  end
                elsif c >= 10
                  if Input.trigger?(Input::UP)
                    pbSEPlay("Choose")
                    pbSEPlay("Anim/Choose")
                    @positionthree -= 1
                    @positionthree = 0 if @positionthree <= 0
                    redraw_third_text
                  end
                  if Input.trigger?(Input::DOWN)
                    pbSEPlay("Choose")
                    pbSEPlay("Anim/Choose")
                    @positionthree += 1
                    @positionthree = c-8 if @positionthree >= c-8
                    redraw_third_text
                  end
                  if @positionthree == 0
                    @sprites["up3"].visible = false
                    @sprites["down3"].visible = true
                  elsif @positionthree <= c-9 && @positionthree >= 1
                    @sprites["up3"].visible = true
                    @sprites["down3"].visible = true
                  else
                    @sprites["up3"].visible = true
                    @sprites["down3"].visible = false
                  end
                end
              end
            end
          end
        end
      end
    elsif a >= 7
      for i in 0...a
        if i == @choice
          b = MINIHELP[i].length
          for j in 0...b
            if b <= 8
              if j == @positiontwo
                c = @line
                if c == 9
                  if Input.trigger?(Input::UP)
                    pbSEPlay("Choose")
                    pbSEPlay("Anim/Choose")
                    @positionthree -= 1
                    @positionthree = 0 if @positionthree <= 0
                  end
                  if Input.trigger?(Input::DOWN)
                    pbSEPlay("Choose")
                    pbSEPlay("Anim/Choose")
                    @positionthree += 1
                    @positionthree = 1 if @positionthree >= 1
                  end
                  if @positionthree == 1
                    redraw_third_text
                    @sprites["up3"].visible = true
                    @sprites["down3"].visible = false
                  elsif @positionthree == 0
                    redraw_third_text
                    @sprites["up3"].visible = false
                    @sprites["down3"].visible = true
                  end
                elsif c >= 10
                  if Input.trigger?(Input::UP)
                    pbSEPlay("Choose")
                    pbSEPlay("Anim/Choose")
                    @positionthree -= 1
                    @positionthree = 0 if @positionthree <= 0
                    redraw_third_text
                  end
                  if Input.trigger?(Input::DOWN)
                    pbSEPlay("Choose")
                    pbSEPlay("Anim/Choose")
                    @positionthree += 1
                    @positionthree = c-8 if @positionthree >= c-8
                    redraw_third_text
                  end
                  if @positionthree == 0
                    @sprites["up3"].visible = false
                    @sprites["down3"].visible = true
                  elsif @positionthree <= c-9 && @positionthree >= 1
                    @sprites["up3"].visible = true
                    @sprites["down3"].visible = true
                  else
                    @sprites["up3"].visible = true
                    @sprites["down3"].visible = false
                  end
                end
              end
            elsif b >= 9
              if j == @choicetwo
                c = @line
                if c == 9
                  if Input.trigger?(Input::UP)
                    pbSEPlay("Choose")
                    pbSEPlay("Anim/Choose")
                    @positionthree -= 1
                    @positionthree = 0 if @positionthree <= 0
                  end
                  if Input.trigger?(Input::DOWN)
                    pbSEPlay("Choose")
                    pbSEPlay("Anim/Choose")
                    @positionthree += 1
                    @positionthree = 1 if @positionthree >= 1
                  end
                  if @positionthree == 1
                    redraw_third_text
                    @sprites["up3"].visible = true
                    @sprites["down3"].visible = false
                  elsif @positionthree == 0
                    redraw_third_text
                    @sprites["up3"].visible = false
                    @sprites["down3"].visible = true
                  end
                elsif c >= 10
                  if Input.trigger?(Input::UP)
                    pbSEPlay("Choose")
                    pbSEPlay("Anim/Choose")
                    @positionthree -= 1
                    @positionthree = 0 if @positionthree <= 0
                    redraw_third_text
                  end
                  if Input.trigger?(Input::DOWN)
                    pbSEPlay("Choose")
                    pbSEPlay("Anim/Choose")
                    @positionthree += 1
                    @positionthree = c-8 if @positionthree >= c-8
                    redraw_third_text
                  end
                  if @positionthree == 0
                    @sprites["up3"].visible = false
                    @sprites["down3"].visible = true
                  elsif @positionthree <= c-9 && @positionthree >= 1
                    @sprites["up3"].visible = true
                    @sprites["down3"].visible = true
                  else
                    @sprites["up3"].visible = true
                    @sprites["down3"].visible = false
                  end
                end
              end
            end
          end
        end
      end
    end
  end
  
  def update
    pbUpdateSpriteHash(@sprites)
  end
  
  def pbEndScene
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
    @viewport1.dispose
    @viewport2.dispose
    @viewport3.dispose
    @viewport4.dispose
  end
  
end

def pbHelpBook
  scene=HelpBook.new
  scene.pbStart
end