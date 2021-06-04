#===============================================================================
# Fame Checker by bo4p5687
#      Graphics by Richard PT
#===============================================================================
#
# How to use:
#  Add a new item and read below lines.
#  
#===============================================================================
#
# To this script works, put it above main.
#
#===============================================================================
#  
#   Below this line, there are some lines which you must add. 
#
#===============================================================================
#===============================================================================
#=========================         Start         ===============================
#===============================================================================
#===============================================================================

LISTNAME = []
  LISTNAME.push(
  ["OAK"], # First person's name
  ["BROCK"] # Second person's name
  )
  
#===============================================================================
#===============================================================================

PRESENTATIONCHARACTERS = []
  PRESENTATIONCHARACTERS.push(
  # Start first person
  [
  # Here: Information of famous person
  # You can continue this information
  "From: PROF. OAK",
  "Why do Pokemon compete and battle so hard for you?",
  "They do so because they can see the love and trust you have towards Pokemon.",
  "Never forget that.",
  "From: PROF. OAK"
  ],
  # End first person

  # Start second person
  [
  # Here: Information of famous person
  # You can continue this information
  "From: BROCK",
  "In this big world of ours, there must be many tough Trainers.",
  "Let's both keep training and making ourselves stronger!",
  "From: BROCK"
  ]
  # End second person
  )
  
#===============================================================================
#===============================================================================

IMAGECHARACTER = []
  IMAGECHARACTER.push(
  # Start first person
  # Here: Image of famous person
  ["trainer024"],
  # End first person
  
  # Start second person
  ["trainer059"]
  # End second person
  )
  
#===============================================================================
#===============================================================================
# Order mini character
#  1     2     3
#  4     5     6
#===============================================================================

SWITCHICON = []
  SWITCHICON.push(
  # Start first person
  # Here: Switch for open mini information
  # Switch should be reserved
  # Order: 1, 2, 3, 4, 5, 6
  [201,202,203,204,205,206], 
  # End first person
  
  # Start second person
  # Here: Switch for open mini information
  # Switch should be reserved
  # Order: 1, 2, 3, 4, 5, 6
  [207,208,209,210,211,212]
  # End second person
  )
  
#===============================================================================
#===============================================================================

INFORMATIONCHARACTERS = []
  INFORMATIONCHARACTERS.push(
  # Start first person
  [
  # Here: Content of mini informations
  # You can continue the content
  # Order: 
  #    1,
  #    2,
  #    3,
  #    4,
  #    5,
  #    6
  ["What does this person do?","Prof","Test 1"],
  ["What is this person like?","To make a complete guide on all the Pokemon in the world...","Test 2"],
  ["What is this person like?","Uhm...","Test 3"],
  ["Family and friends?","I think...","Test 4"],
  ["Family and friends?","...","Hmm...","Test 5"],
  ["What does this person do?","...","Test 6"]
  ],
  # End first person
  
  # Start second person
  [
  # Here: Content of mini informations
  # You can continue the content
  # Order: 
  #    1,
  #    2,
  #    3,
  #    4,
  #    5,
  #    6
  ["What does this person do?","...","Test 1"],
  ["What is this person like?","Ah! I think...","Test 2"],
  ["What is this person like?","Uhm...I think...","Test 3"],
  ["Family and friends?","I think...","Test 4"],
  ["Family and friends?","...","Hmm...","Test 5"],
  ["What does this person do?","...","Test 6"]
  ]
  # End second person
  )
  
#===============================================================================
#===============================================================================
  
NAMEICON = []
  NAMEICON.push(
  # Start first person
  # Here: Icon of mini information
  # Location of graphics: Graphics\Characters
  # Order: 1, 2, 3, 4, 5, 6
  ["trchar069","trchar065","trchar064","trchar063","trchar062","trchar061"],
  # End first person
  
  # Start second person
  # Here: Icon of mini information
  # Location of graphics: Graphics\Characters
  # Order: 1, 2, 3, 4, 5, 6
  ["trchar039","trchar035","trchar034","trchar033","trchar032","trchar031"]
  # End second person
  )
  
#===============================================================================
#===============================================================================

INFORMATIONTEXT = []
  INFORMATIONTEXT.push(
  # Start first person
  [
  # Here: Mini information
  # There are two mini informations
  # Order: 
  #    1,
  #    2,
  #    3,
  #    4,
  #    5,
  #    6
  ["PALLET TOWN","TEST 1"],
  ["RESEARCH LAB","TEST 2"],
  ["RESEARCH LAB","TEST 3"],
  ["VIRIDIAN CITY","TEST 4"],
  ["POKEMON LEAGUE","TEST 5"],
  ["RESEARCH LAB","TEST 6"]
  ],
  # End first person
  
  # Start second person
  [
  # Here: Mini information
  # There are two mini informations
  # Order: 
  #    1,
  #    2,
  #    3,
  #    4,
  #    5,
  #    6
  ["PEWTER CITY","TEST 1"],
  ["PEWTER GYM","TEST 2"],
  ["PEWTER CITY","TEST 3"],
  ["ROUTE 4","TEST 4"],
  ["MT.MOON","TEST 5"],
  ["PEWTER MUSEUM","TEST 6"]
  ]
  # End second person
  )
  
#===============================================================================
#===============================================================================
 
# Recommend: 
#   First line: x = 234; y = 160
#   Second line: x = 234; y = 184

INFORMATIONTEXT_POSITION_X = []
  INFORMATIONTEXT_POSITION_X.push(
  # Start first person
  [
  # Here: Position of mini information
  # Order: 1, 2, 3, 4, 5, 6
  [234,234],[234,234],[234,234],[234,234],[234,234],[234,234]  
  ],
  # End first person
  
  # Start second person
  [
  # Here: Position of mini information
  # Order: 1, 2, 3, 4, 5, 6
  [234,234],[234,234],[234,234],[234,234],[234,234],[234,234]
  ]
  # End second person
  )
  
INFORMATIONTEXT_POSITION_Y = []
  INFORMATIONTEXT_POSITION_Y.push(
  # Start first person
  [
  # Here: Position of mini information
  # Order: 1, 2, 3, 4, 5, 6
  [160,184],[160,184],[160,184],[160,184],[160,184],[160,184]
  ],
  # End first person
  
  # Start second person
  [
  # Here: Position of mini information
  # Order: 1, 2, 3, 4, 5, 6
  [160,184],[160,184],[160,184],[160,184],[160,184],[160,184]
  ]
  # End second person
  )

#===============================================================================
#===============================================================================
#================                 End                           ================
#===============================================================================
#===============================================================================

Register_name = 126  # Variable should be reserved

#===============================================================================
#===============================================================================
# 
# Add item
#
#===============================================================================

ItemHandlers::UseFromBag.add(:FAMECHECKER,proc{|item|
   next (pbFameChecker) ? 1 : 0
})

#===============================================================================
#===============================================================================

class FameChecker
    
  def initialize
    @viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z=99999
    @viewport1=Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport1.z=99999
    @viewport2=Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport2.z=99999
    @sprites = {}
    @character = {}
    @exit = false
    @position = 0
    @choice = 0
    @process = 0
    @animation = 0
    @check = 0
    @selection = 0
  end
  
  def pbStart
    Graphics.update
    Input.update
    self.update
    $game_variables[Register_name] = 0 if $game_variables[Register_name] < 0
    if $game_variables[Register_name] == 0
      Kernel.pbMessage(_INTL("You don't have any informations. Add them."))
    else
      Graphics.update
      Input.update
      self.update
      draw_scene
      draw_choice
      draw_icon
      draw_select
      loop do
        Graphics.update
        Input.update
        self.update
        break if @exit == true
        if @process == 0
          Graphics.update
          Input.update
          self.update
          @sprites["scene1"].visible = true
          @sprites["scene2"].visible = false
          @sprites["scene3"].visible = false
          @sprites["scene4"].visible = false
          @sprites["arrow"].src_rect.x = 0
          choice
          @selection = 0
          if Input.trigger?(Input::C)
            pbSEPlay("Choose")
            pbSEPlay("Anim/Choose")
            @process = 1
          end
          if Input.trigger?(Input::A)
            pbSEPlay("Choose")
            pbSEPlay("Anim/Choose")
            @process = 2
          end
          if Input.trigger?(Input::B)
            pbSEPlay("Choose")
            pbSEPlay("Anim/Choose")
            pbEndScene
            @exit = true
          end
        elsif @process == 1
          Graphics.update
          Input.update
          self.update
          @sprites["scene1"].visible = false
          @sprites["scene2"].visible = false
          @sprites["scene3"].visible = true
          @sprites["scene4"].visible = false
          @sprites["arrow"].src_rect.x = @sprites["arrow"].src_rect.width
          select_information
          if Input.trigger?(Input::B)
            pbSEPlay("Choose")
            pbSEPlay("Anim/Choose")
            @sprites["select"].visible = false
            @process = 0
          end
        elsif @process == 2
          Graphics.update
          Input.update
          self.update
          @sprites["scene1"].visible = false
          @sprites["scene2"].visible = true
          @sprites["scene3"].visible = false
          @sprites["scene4"].visible = false
          @sprites["arrow"].src_rect.x = @sprites["arrow"].src_rect.width
          if Input.trigger?(Input::C)
            pbSEPlay("Choose")
            pbSEPlay("Anim/Choose")
            @process = 3
          end
          if Input.trigger?(Input::B)
            pbSEPlay("Choose")
            pbSEPlay("Anim/Choose")
            @process = 6
          end
        elsif @process == 3
          Graphics.update
          Input.update
          self.update
          draw_character
          @process = 4
        elsif @process == 4
          Graphics.update
          Input.update
          self.update
          @sprites["scene1"].visible = false
          @sprites["scene2"].visible = true
          @sprites["scene3"].visible = false
          @sprites["scene4"].visible = false
          appear
        elsif @process == 5
          Graphics.update
          Input.update
          self.update
          @sprites["scene1"].visible = false
          @sprites["scene2"].visible = false
          @sprites["scene3"].visible = false
          @sprites["scene4"].visible = true
          presentation
          @process = 4
        elsif @process == 6
          Graphics.update
          Input.update
          self.update
          after_presentation
        elsif @process == 7
          Graphics.update
          Input.update
          self.update
          @character.bitmap.clear
          @process = 8
        elsif @process == 8
          Graphics.update
          Input.update
          self.update
          draw_icon
          @process = 0
        end
      end
    end
    pbEndScene
  end
  
  def draw_scene
    for i in 1..4
      @sprites["scene#{i}"] = Sprite.new(@viewport1)
      @sprites["scene#{i}"].bitmap = Bitmap.new("Graphics/Pictures/FameChecker/Scene_#{i}")
      @sprites["scene#{i}"].visible = false
    end
    
    @sprites["announcement_order_up"] = Sprite.new(@viewport1)
    @sprites["announcement_order_up"].bitmap = Bitmap.new("Graphics/Pictures/FameChecker/Order_Arrow")
    @sprites["announcement_order_up"].src_rect.width = @sprites["announcement_order_up"].bitmap.width/2
    @sprites["announcement_order_up"].src_rect.x = 0
    @sprites["announcement_order_up"].src_rect.y = 0
    @sprites["announcement_order_up"].x = 66
    @sprites["announcement_order_up"].y = 30
    @sprites["announcement_order_up"].visible = false
    
    @sprites["announcement_order_down"] = Sprite.new(@viewport1)
    @sprites["announcement_order_down"].bitmap = Bitmap.new("Graphics/Pictures/FameChecker/Order_Arrow")
    @sprites["announcement_order_down"].src_rect.width = @sprites["announcement_order_down"].bitmap.width/2
    @sprites["announcement_order_down"].src_rect.x = @sprites["announcement_order_up"].src_rect.width
    @sprites["announcement_order_down"].src_rect.y = 0
    @sprites["announcement_order_down"].x = 66
    @sprites["announcement_order_down"].y = 209
    @sprites["announcement_order_down"].visible = false
    
    @sprites["ball"] = Sprite.new(@viewport2)
    @sprites["ball"].bitmap = Bitmap.new("Graphics/Pictures/FameChecker/Ball")
    @sprites["ball"].src_rect.width = @sprites["ball"].bitmap.width/12
    @sprites["ball"].src_rect.height = @sprites["ball"].bitmap.height
    @sprites["ball"].src_rect.x = 0
    @sprites["ball"].src_rect.y = 0
    @sprites["ball"].x = 789
    @sprites["ball"].y = 110

    @sprites["screen"] = Sprite.new(@viewport2)
    @sprites["screen"].bitmap = Bitmap.new("Graphics/Pictures/FameChecker/Screen")
    @sprites["screen"].x = 512
    @sprites["screen"].y = 40
    
    @sprites["list"] = Sprite.new(@viewport)
    @sprites["list"].bitmap = Bitmap.new("Graphics/Pictures/FameChecker/List")
    @sprites["list"].x = 14
    @sprites["list"].y = 46
    
    @sprites["behind_door"] = Sprite.new(@viewport)
    @sprites["behind_door"].bitmap = Bitmap.new("Graphics/Pictures/FameChecker/Information_Hide_behind")
    @sprites["behind_door"].x = 229
    @sprites["behind_door"].y = 155
    
    @sprites["behind_door2"] = Sprite.new(@viewport)
    @sprites["behind_door2"].bitmap = Bitmap.new(Graphics.width, Graphics.height)
    @sprites["behind_door2"].bitmap.clear
    
    @sprites["door_up"] = Sprite.new(@viewport)
    @sprites["door_up"].bitmap = Bitmap.new("Graphics/Pictures/FameChecker/Information_Hide")
    @sprites["door_up"].src_rect.width = @sprites["door_up"].bitmap.width
    @sprites["door_up"].src_rect.height = @sprites["door_up"].bitmap.height/2
    @sprites["door_up"].src_rect.x = 0
    @sprites["door_up"].src_rect.y = 0
    @sprites["door_up"].x = 230
    @sprites["door_up"].y = 156
    
    @sprites["door_down"] = Sprite.new(@viewport)
    @sprites["door_down"].bitmap = Bitmap.new("Graphics/Pictures/FameChecker/Information_Hide")
    @sprites["door_down"].src_rect.width = @sprites["door_down"].bitmap.width
    @sprites["door_down"].src_rect.height = @sprites["door_down"].bitmap.height/2
    @sprites["door_down"].src_rect.x = 0
    @sprites["door_down"].src_rect.y = @sprites["door_down"].src_rect.height
    @sprites["door_down"].x = 230 
    @sprites["door_down"].y = 155 + @sprites["door_down"].src_rect.height

    @sprites["arrow"] = Sprite.new(@viewport)
    @sprites["arrow"].bitmap = Bitmap.new("Graphics/Pictures/FameChecker/Choice_Arrow")
    @sprites["arrow"].src_rect.width = @sprites["arrow"].bitmap.width/2
    @sprites["arrow"].src_rect.height = @sprites["arrow"].bitmap.height
    @sprites["arrow"].src_rect.x = 0
    @sprites["arrow"].src_rect.y = 0
    @sprites["arrow"].x = 20
    @sprites["arrow"].y = 56
    @sprites["arrow"].visible = false
    
    @sprites["hide0"] = Sprite.new(@viewport1)
    @sprites["hide0"].bitmap = Bitmap.new("Graphics/Pictures/FameChecker/Hide")
    @sprites["hide0"].x = 224
    @sprites["hide0"].y = 51
    
    @sprites["hide1"] = Sprite.new(@viewport1)
    @sprites["hide1"].bitmap = Bitmap.new("Graphics/Pictures/FameChecker/Hide")
    @sprites["hide1"].x = 327
    @sprites["hide1"].y = 51
    
    @sprites["hide2"] = Sprite.new(@viewport1)
    @sprites["hide2"].bitmap = Bitmap.new("Graphics/Pictures/FameChecker/Hide")
    @sprites["hide2"].x = 430
    @sprites["hide2"].y = 51

    @sprites["hide3"] = Sprite.new(@viewport1)
    @sprites["hide3"].bitmap = Bitmap.new("Graphics/Pictures/FameChecker/Hide")
    @sprites["hide3"].x = 224
    @sprites["hide3"].y = 99
    
    @sprites["hide4"] = Sprite.new(@viewport1)
    @sprites["hide4"].bitmap = Bitmap.new("Graphics/Pictures/FameChecker/Hide")
    @sprites["hide4"].x = 327
    @sprites["hide4"].y = 99
        
    @sprites["hide5"] = Sprite.new(@viewport1)
    @sprites["hide5"].bitmap = Bitmap.new("Graphics/Pictures/FameChecker/Hide")
    @sprites["hide5"].x = 430
    @sprites["hide5"].y = 99
   
    @sprites["list2"] = Sprite.new(@viewport)
    @sprites["list2"].bitmap = Bitmap.new(Graphics.width, Graphics.height)
    @sprites["list2"].bitmap.clear
  end
  
  def draw_choice
    $game_variables[Register_name] = LISTNAME.length if $game_variables[Register_name] > LISTNAME.length
    a = $game_variables[Register_name]
    if a != 0
      @sprites["arrow"].visible = true
      pbSetSystemFont(@sprites["list2"].bitmap)
      @sprites["list2"].bitmap.font.bold=true
      textposition = []
      for i in 0...a
        textposition.push([_INTL("{1}",LISTNAME[i]),
        33,50+26*i,0,
        Color.new(255,255,255),Color.new(0,0,0)])
      end
      pbDrawTextPositions(@sprites["list2"].bitmap,textposition)
    end
  end
  
  def choice
    a = $game_variables[Register_name]
    if a <= 6
      if Input.trigger?(Input::UP)
        pbSEPlay("Choose")
        pbSEPlay("Anim/Choose")
        @position -= 1
        @position = 0 if @position < 0
        @process = 7
      end
      if Input.trigger?(Input::DOWN)
        pbSEPlay("Choose")
        pbSEPlay("Anim/Choose")
        @position += 1
        @position = a - 1 if @position >= a
        @process = 7
      end
      for i in 0...a
        @sprites["arrow"].y = 56 + 26*i if @position == i
      end
    elsif a == 7
      if Input.trigger?(Input::UP)
        pbSEPlay("Choose")
        pbSEPlay("Anim/Choose")
        @choice -= 1
        @position -= 1
        @choice = 0 if @choice < 0
        @position = 0 if @position < 0
        @process = 7
      end
      if Input.trigger?(Input::DOWN)
        pbSEPlay("Choose")
        pbSEPlay("Anim/Choose")
        @choice += 1
        @position += 1 if @choice > 1
        @choice = 6 if @choice >= 6
        @position = 5 if @position >= 6
        @process = 7
      end
      for i in 0...6
        @sprites["arrow"].y = 56 + 26*i if @position == i
      end
      if @choice == 1 
        @sprites["list2"].bitmap.clear
        for i in 0...a
          pbDrawTextPositions(@sprites["list2"].bitmap,[
          [_INTL("{1}",LISTNAME[i]),
            33,50+26*i-26,0,
            Color.new(255,255,255),Color.new(0,0,0)]
            ])
        end
        @sprites["announcement_order_up"].visible = true
        @sprites["announcement_order_down"].visible = false
      elsif @choice == 0
        @sprites["list2"].bitmap.clear
        for i in 0...a
          pbDrawTextPositions(@sprites["list2"].bitmap,[
          [_INTL("{1}",LISTNAME[i]),
            33,50+26*i,0,
            Color.new(255,255,255),Color.new(0,0,0)]
            ])
        end
        @sprites["announcement_order_down"].visible = true
        @sprites["announcement_order_up"].visible = false
      end
    elsif a >= 8
      if Input.trigger?(Input::UP)
        pbSEPlay("Choose")
        pbSEPlay("Anim/Choose")
        @choice -= 1
        @position -= 1        
        @choice = 0 if @choice < 0
        @position = 0 if @position < 0
        if @choice >= 0 && @choice <= a-6
          @sprites["list2"].bitmap.clear
          for i in 0...a
            pbDrawTextPositions(@sprites["list2"].bitmap,[
            [_INTL("{1}",LISTNAME[i]),
              33,50+26*i-26*@choice,0,
              Color.new(255,255,255),Color.new(0,0,0)]
              ])
          end
        end
        @process = 7
      end
      if Input.trigger?(Input::DOWN)
        pbSEPlay("Choose")
        pbSEPlay("Anim/Choose")
        @choice += 1
        @position += 1 if @choice > a-6        
        @choice = a - 1 if @choice >= a
        @position = 5 if @position >= 6
        if @choice >= 1 && @choice <= a-6
          @sprites["list2"].bitmap.clear
          for i in 0...a
            pbDrawTextPositions(@sprites["list2"].bitmap,[
            [_INTL("{1}",LISTNAME[i]),
              33,50+26*i-26*@choice,0,
              Color.new(255,255,255),Color.new(0,0,0)]
              ])
          end
        end
        @process = 7
      end
      for i in 0...6
        @sprites["arrow"].y = 56 + 26*i if @position == i
      end
      if @choice >= 1 && @choice <= a-7
        @sprites["announcement_order_down"].visible = true
        @sprites["announcement_order_up"].visible = true
      elsif @choice == 0
        @sprites["announcement_order_down"].visible = true
        @sprites["announcement_order_up"].visible = false
      else
        @sprites["announcement_order_down"].visible = false
        @sprites["announcement_order_up"].visible = true
      end
    end 
  end 
  
  def appear
    unless @sprites["screen"].x == 167
      345.times do
        @sprites["screen"].x -= 1
        @sprites["ball"].x -= 1
        @sprites["character"].x -= 1
        pbWait(1)
      end
    else
      @animation = 0
      @sprites["screen"].x = 167
      @sprites["ball"].x = 444
      @sprites["character"].x = 248
      if Input.trigger?(Input::C)
        pbSEPlay("Choose")
        pbSEPlay("Anim/Choose")
        @process = 5
      end
      if Input.trigger?(Input::B)
        pbSEPlay("Choose")
        pbSEPlay("Anim/Choose")
        @process = 6 
      end
    end
  end
  
  def presentation
    a = $game_variables[Register_name]
    check_update_ball
    if a <= 6
      b = @position
      for i in 0...PRESENTATIONCHARACTERS[b].length
        showtalk(PRESENTATIONCHARACTERS[b][i])
      end
    elsif a >= 7
      b = @choice
      for i in 0...PRESENTATIONCHARACTERS[b].length
        showtalk(PRESENTATIONCHARACTERS[b][i])
      end
    end
  end
  
  def draw_character
    a = $game_variables[Register_name]
    if a <= 6
      b = @position
      @sprites["character"] = Sprite.new(@viewport2)
      @sprites["character"].bitmap = Bitmap.new("Graphics/Characters/" + IMAGECHARACTER[b][0])
      @sprites["character"].x = 593
      @sprites["character"].y = 64
    elsif a >= 7
      b = @choice
      @sprites["character"] = Sprite.new(@viewport2)
      @sprites["character"].bitmap = Bitmap.new("Graphics/Characters/" + IMAGECHARACTER[b][0])
      @sprites["character"].x = 593
      @sprites["character"].y = 64
    end
  end
  
  def after_presentation
    unless @sprites["screen"].x == 512
      345.times do
        @sprites["screen"].x += 1
        @sprites["ball"].x += 1
        @sprites["character"].x += 1 
        pbWait(1)
      end
    else
      @animation = 0
      @sprites["screen"].x = 512
      @sprites["ball"].x = 789
      @sprites["ball"].src_rect.x = 0
      @sprites["character"].x = 593
      if @sprites["character"].x == 593
        @sprites["character"].bitmap.clear
        @process = 0
      end
    end
  end
  
  def update_ball
    if @process == 5
      @animation += 1
      if @animation%3 == 0
        @sprites["ball"].src_rect.x += @sprites["ball"].src_rect.width
        @sprites["ball"].src_rect.x = 0 if @sprites["ball"].src_rect.x >= @sprites["ball"].bitmap.width
      end
      @animation = 0 if @animation == 3
    end
  end
  
  def check_update_ball
    Graphics.update
    Input.update
    update_ball
    pbUpdateSpriteHash(@sprites)
  end

  def showtalk(text)
    Kernel.pbMessage(_INTL(text)) { update_ball }
  end
  
  def draw_icon
    a = $game_variables[Register_name]
    if a <= 6
      b = @position
      @character = Sprite.new(@viewport1)
      @character.bitmap = Bitmap.new(Graphics.width, Graphics.height)
      @character.bitmap.clear
      for j in 0...6
        if $game_switches[SWITCHICON[b][j]]
          @sprites["hide#{j}"].visible = false
          imageposition = []
          imageposition.push(["Graphics/Characters/" + NAMEICON[b][0],224,51,0,0,32,48]) if j == 0 
          imageposition.push(["Graphics/Characters/" + NAMEICON[b][1],327,51,0,0,32,48]) if j == 1 
          imageposition.push(["Graphics/Characters/" + NAMEICON[b][2],430,51,0,0,32,48]) if j == 2 
          imageposition.push(["Graphics/Characters/" + NAMEICON[b][3],224,99,0,0,32,48]) if j == 3 
          imageposition.push(["Graphics/Characters/" + NAMEICON[b][4],327,99,0,0,32,48]) if j == 4
          imageposition.push(["Graphics/Characters/" + NAMEICON[b][5],430,99,0,0,32,48]) if j == 5
          pbDrawImagePositions(@character.bitmap,imageposition)
        else
          @sprites["hide#{j}"].visible = true          
        end        
      end
    elsif a >= 7
      b = @choice
      @character = Sprite.new(@viewport1)
      @character.bitmap = Bitmap.new(Graphics.width, Graphics.height)
      @character.bitmap.clear
      for j in 0...6
        if $game_switches[SWITCHICON[b][j]]
          @sprites["hide#{j}"].visible = false
          imageposition = []
          imageposition.push(["Graphics/Characters/" + NAMEICON[b][0],224,51,0,0,32,48]) if j == 0 
          imageposition.push(["Graphics/Characters/" + NAMEICON[b][1],327,51,0,0,32,48]) if j == 1 
          imageposition.push(["Graphics/Characters/" + NAMEICON[b][2],430,51,0,0,32,48]) if j == 2 
          imageposition.push(["Graphics/Characters/" + NAMEICON[b][3],224,99,0,0,32,48]) if j == 3 
          imageposition.push(["Graphics/Characters/" + NAMEICON[b][4],327,99,0,0,32,48]) if j == 4
          imageposition.push(["Graphics/Characters/" + NAMEICON[b][5],430,99,0,0,32,48]) if j == 5
          pbDrawImagePositions(@character.bitmap,imageposition)
        else
          @sprites["hide#{j}"].visible = true          
        end        
      end
    end
  end
  
  def draw_select
    @sprites["select"] = Sprite.new(@viewport2)
    @sprites["select"].bitmap = Bitmap.new("Graphics/Pictures/FameChecker/Select_square")
    @sprites["select"].x = 220
    @sprites["select"].y = 51
    @sprites["select"].visible = false
  end
  
  def select_information
    @sprites["select"].visible = true
    if @selection == 0
      @sprites["select"].x = 220
      @sprites["select"].y = 51
    end
    if Input.trigger?(Input::UP) || Input.trigger?(Input::DOWN)
      pbSEPlay("Choose")
      pbSEPlay("Anim/Choose")
      if @selection == 0
        @selection = 3
        @sprites["select"].x = 220
        @sprites["select"].y = 99
      elsif @selection == 3
        @selection = 0
        @sprites["select"].x = 220
        @sprites["select"].y = 51
      elsif @selection == 1
        @selection = 4
        @sprites["select"].x = 323
        @sprites["select"].y = 99
      elsif @selection == 4
        @selection = 1
        @sprites["select"].x = 323
        @sprites["select"].y = 51
      elsif @selection == 2
        @selection = 5
        @sprites["select"].x = 426
        @sprites["select"].y = 99
      elsif @selection == 5
        @selection = 2
        @sprites["select"].x = 426
        @sprites["select"].y = 51
      end
      information_mini
      draw_mini_information
    end
    if Input.trigger?(Input::RIGHT)
      pbSEPlay("Choose")
      pbSEPlay("Anim/Choose")
      if @selection == 0
        @selection = 1
        @sprites["select"].x = 323
        @sprites["select"].y = 51
      elsif @selection == 1
        @selection = 2
        @sprites["select"].x = 426
        @sprites["select"].y = 51
      elsif @selection == 2
        @selection = 3
        @sprites["select"].x = 220
        @sprites["select"].y = 99
      elsif @selection == 3
        @selection = 4
        @sprites["select"].x = 323
        @sprites["select"].y = 99
      elsif @selection == 4
        @selection = 5
        @sprites["select"].x = 426
        @sprites["select"].y = 99
      elsif @selection == 5
        @selection = 0
        @sprites["select"].x = 220
        @sprites["select"].y = 51
      end
      information_mini
      draw_mini_information
    end
    if Input.trigger?(Input::LEFT)
      pbSEPlay("Choose")
      pbSEPlay("Anim/Choose")
      if @selection == 0
        @selection = 5
        @sprites["select"].x = 426
        @sprites["select"].y = 99
      elsif @selection == 1
        @selection = 0
        @sprites["select"].x = 220
        @sprites["select"].y = 51
      elsif @selection == 2
        @selection = 1
        @sprites["select"].x = 323
        @sprites["select"].y = 51
      elsif @selection == 3
        @selection = 2
        @sprites["select"].x = 426
        @sprites["select"].y = 51
      elsif @selection == 4
        @selection = 3
        @sprites["select"].x = 220
        @sprites["select"].y = 99
      elsif @selection == 5
        @selection = 4
        @sprites["select"].x = 323
        @sprites["select"].y = 99
      end
      information_mini
      draw_mini_information
    end
    if Input.trigger?(Input::C)
      pbSEPlay("Choose")
      pbSEPlay("Anim/Choose")
      a = $game_variables[Register_name]
      if a <= 6
        b = @position
        for j in 0...6
          if @selection == j
            return if !$game_switches[SWITCHICON[b][j]]
            for k in 0...INFORMATIONCHARACTERS[b][j].length
              Kernel.pbMessage(_INTL(INFORMATIONCHARACTERS[b][j][k]))
            end
          end
        end
      elsif a >= 7
        b = @choice
        for j in 0...6
          if @selection == j
            return if !$game_switches[SWITCHICON[b][j]]
            for k in 0...INFORMATIONCHARACTERS[b][j].length
              Kernel.pbMessage(_INTL(INFORMATIONCHARACTERS[b][j][k]))
            end
          end
        end
      end
    end
    a = $game_variables[Register_name]
    if a <= 6
      b = @position
      if @selection == 0
        if $game_switches[SWITCHICON[b][0]]
          return if @sprites["door_up"].y != 156
          56.times do
            @sprites["door_up"].y -= 0.5
            @sprites["door_down"].y += 0.5
          end
          @sprites["behind_door2"].bitmap.clear
          @sprites["behind_door2"].bitmap.font.size = 25
          @sprites["behind_door2"].bitmap.font.bold = true
          for i in 0...2
            pbDrawTextPositions(@sprites["behind_door2"].bitmap,[
            [_INTL("{1}",INFORMATIONTEXT[b][0][i]),
              INFORMATIONTEXT_POSITION_X[b][0][i],INFORMATIONTEXT_POSITION_Y[b][0][i],0,
              Color.new(220,212,144),Color.new(0,0,0)]])
          end
        elsif !$game_switches[SWITCHICON[b][0]] && @sprites["door_up"].y == 128
          56.times do 
            @sprites["door_up"].y += 0.5
            @sprites["door_down"].y -= 0.5
          end
        end
      end
    elsif a >= 7
      b = @choice
      if @selection == 0
        if $game_switches[SWITCHICON[b][0]]
          return if @sprites["door_up"].y != 156
          56.times do
            @sprites["door_up"].y -= 0.5
            @sprites["door_down"].y += 0.5
          end
          @sprites["behind_door2"].bitmap.clear
          @sprites["behind_door2"].bitmap.font.size = 25
          @sprites["behind_door2"].bitmap.font.bold = true
          for i in 0...2
            pbDrawTextPositions(@sprites["behind_door2"].bitmap,[
            [_INTL("{1}",INFORMATIONTEXT[b][0][i]),
              INFORMATIONTEXT_POSITION_X[b][0][i],INFORMATIONTEXT_POSITION_Y[b][0][i],0,
              Color.new(220,212,144),Color.new(0,0,0)]])
          end
        elsif !$game_switches[SWITCHICON[b][0]] && @sprites["door_up"].y == 128
          56.times do 
            @sprites["door_up"].y += 0.5
            @sprites["door_down"].y -= 0.5
          end
        end
      end
    end
  end
  
  def information_mini
    a = $game_variables[Register_name]
    if a <= 6
      b = @position
      for j in 0...6
        if @selection == j
          if $game_switches[SWITCHICON[b][j]]
            return if @sprites["door_up"].y != 156
            56.times do
              @sprites["door_up"].y -= 0.5
              @sprites["door_down"].y += 0.5
            end
          elsif !$game_switches[SWITCHICON[b][j]] && @sprites["door_up"].y == 128
            56.times do 
              @sprites["door_up"].y += 0.5
              @sprites["door_down"].y -= 0.5
            end
          end
        end
      end
    elsif a >= 7
      b = @choice
      for j in 0...6
        if @selection == j
          if $game_switches[SWITCHICON[b][j]]
            return if @sprites["door_up"].y != 156
            56.times do
              @sprites["door_up"].y -= 0.5
              @sprites["door_down"].y += 0.5
            end
          elsif !$game_switches[SWITCHICON[b][j]] && @sprites["door_up"].y == 128
            56.times do 
              @sprites["door_up"].y += 0.5
              @sprites["door_down"].y -= 0.5
            end
          end
        end
      end
    end
  end
  
  def draw_mini_information
    a = $game_variables[Register_name]
    if a <= 6
      b = @position
      for j in 0...6
        if @selection == j
          return if !$game_switches[SWITCHICON[b][j]]
          @sprites["behind_door2"].bitmap.clear
          @sprites["behind_door2"].bitmap.font.size = 25
          @sprites["behind_door2"].bitmap.font.bold = true
          for i in 0...2
            pbDrawTextPositions(@sprites["behind_door2"].bitmap,[
            [_INTL("{1}",INFORMATIONTEXT[b][j][i]),
              INFORMATIONTEXT_POSITION_X[b][j][i],INFORMATIONTEXT_POSITION_Y[b][j][i],0,
              Color.new(220,212,144),Color.new(0,0,0)]])
          end
        end
      end
    elsif a >= 7
      b = @choice
      for j in 0...6
        if @selection == j
          return if !$game_switches[SWITCHICON[b][j]]
          @sprites["behind_door2"].bitmap.clear
          @sprites["behind_door2"].bitmap.font.size = 25
          @sprites["behind_door2"].bitmap.font.bold = true
          for i in 0...2
            pbDrawTextPositions(@sprites["behind_door2"].bitmap,[
            [_INTL("{1}",INFORMATIONTEXT[b][j][i]),
              INFORMATIONTEXT_POSITION_X[b][j][i],INFORMATIONTEXT_POSITION_Y[b][j][i],0,
              Color.new(220,212,144),Color.new(0,0,0)]])
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
  end
  
end

def pbFameChecker
  scene=FameChecker.new
  scene.pbStart
end