#-------------------------------------------------------------------------------
# Credit: bo4p5687
#-------------------------------------------------------------------------------
PluginManager.register({
  :name => "Evolution (Customize)",
  :credits => "bo4p5687"
})
#-------------------------------------------------------------------------------
# You can change style with NewEvolutionGen
# Style:
#  -1: Default (PE)
#  0: Pokemon R/G/B
#  1: Pokemon FRLG
#  2: Pokemon DP
#-------------------------------------------------------------------------------
NewEvolutionGen = -1
#-------------------------------------------------------------------------------
class NewEvolutionScene
    
  def initialize(oldspecies,newspecies)
    @sprites = {}
    # Viewport
    @vpnarrow = Viewport.new(0,0,SCREEN_WIDTH,SCREEN_HEIGHT)
    @vpnarrow.z = 99999
    @viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z = 99999
    @msgviewport = Viewport.new(0,0,Graphics.width,Graphics.height)
    @msgviewport.z = 99999
    # Scene
    case NewEvolutionGen
    # R/G/B
    when 0; createScene
    # FR/LG
    when 1; createScene("Scene","FRLG"); setBackgroundFRLG(5)
    # Diamond/Pearl
    when 2; createScene(nil,nil,@vpnarrow)
      
    end
    # Set pokemon for evolution
    @old = oldspecies; @new = newspecies
    # Old
    old = PokemonSprite.new(@viewport)
    old.setOffset(PictureOrigin::Center)
    old.setPokemonBitmap(@old)
    old.x = Graphics.width/2
    old.y = (Graphics.height-64)/2
    # New
    new = PokemonSprite.new(@viewport)
    new.setOffset(PictureOrigin::Center)
    new.setPokemonBitmapSpecies(@old,@new)
    new.x = old.x
    new.y = old.y
    @sprites["old"] = old
    @sprites["new"] = new
    # Msg
    @sprites["msgwindow"] = pbCreateMessageWindow(@msgviewport)
    # Value
    @canceled = false; @store=[]
  end
#-------------------------------------------------------------------------------
# Scene
#-------------------------------------------------------------------------------
  def createScene(new=nil,newdir=nil,vp=nil)
    vp = @viewport if vp.nil?
    if new.nil?
      create_sprite("scene","evolutionbg",vp,nil,"Pictures")
    else
      (newdir.nil?)? create_sprite("scene",new,vp,nil) : create_sprite("scene",new,vp,newdir)
    end
  end
#-------------------------------------------------------------------------------
# Scene
#-------------------------------------------------------------------------------
  def evolution(cancancel=true)
    case NewEvolutionGen
    when 0; evolutionRGB(cancancel)
    when 1; evolutionFRLG(cancancel)
    when 2; evolutionDP(cancancel)
    end
  end
  
  MaxFrameFlash = 7*Graphics.frame_rate
  
  # R/G/B
  def evolutionRGB(cancancel=true)
    set_visible_sprite("new")
    pbFadeInAndShow(@sprites) { update }
    # Start
    startEvolution
    # Frames
    play = false
    total = 0; max = MaxFrameFlash; current = 0
    # Narrow scene
    narrowOrExpandScene(true)
    loop do
      # Update
      update_ingame
      if Input.trigger?(Input::B) && cancancel
        pbBGMStop; pbPlayCancelSE
        @canceled = true
        break
      end
      total+=1
      if !play
        (total=0; play=true) if total==Graphics.frame_rate
      else
        if total<max
          current+=1
          if total<(max/3*2).floor
            current = 0 if current>11
            r = current%11
            case r
            when 3,4,5,6; set_visible_sprite("new",true)
            else; set_visible_sprite("new")
            end
          elsif total>(max/3*2).floor && total<(max/6*5).floor
            current = 0 if current>5
            r = current%7
            case r
            when 3,4,5; set_visible_sprite("new",true)
            else; set_visible_sprite("new")
            end
          else
            current = 0 if current>2
            (current%2==1)? set_visible_sprite("new",true) : set_visible_sprite("new")
          end
        else
          break
        end
      end
    end
    # Set visible
    setVisibleAfterEvol
    # Expand scene
    narrowOrExpandScene
    # End evolution
    successOrNotEvolution
  end
  
  # FR/LG
  def evolutionFRLG(cancancel=true)
    # Set zoom pokemon
    set_zoom("new",0,0)
    # Record
    recordZoomPkmn("old"); recordZoomPkmn("new")
    pbFadeInAndShow(@sprites) { update }
    # Start
    startEvolution
    # Black scene
    17.times { @sprites["scene"].color.alpha += 15; pbWait(1) }
    # Store color
    storeColor("old"); storeColor("new")
    # Set white image
    # Old
    @sprites["old"].color.red = 255
    @sprites["old"].color.green = 255
    @sprites["old"].color.blue = 255
    # New
    @sprites["new"].color.red = 255
    @sprites["new"].color.green = 255
    @sprites["new"].color.blue = 255
    @sprites["new"].color.alpha = 255
    # Light
    middlex = SCREEN_WIDTH/2; middley = SCREEN_HEIGHT/2
    max = 10
    # Curve
    createLightCircle(1,middlex-50,middley+50,max)
    createLightCircle(2,middlex-10,middley+50,max)
    createLightCircle(3,middlex+10,middley+50,max)
    createLightCircle(4,middlex+50,middley+50,max)
    # Ellipse
    y = 40
    createLightCircle(5,middlex-15,y,max)
    createLightCircle(6,middlex-70,y,max)
    createLightCircle(7,middlex+15,y,max)
    createLightCircle(8,middlex+70,y,max)
    (5..8).each { |i| setVisibleLight(i,max) }
    # Circle
    numbc = 8; xc = 10; yc = middley; distx = 60; disty = middley-20; maxc = 2
    createCircleAlmostFRLG(numbc,xc,yc,distx,disty,maxc)
    (9..24).each { |i| setVisibleLight(i,2) }
    # Create firework (10)
    maxfw = 10
    (25..34).each { |i| 
    createLightCircle(i,middlex,middley-32,maxfw); setVisibleLight(i,maxfw) }
    # Set animation
    animation = 0 
    # Animation (background)
    animationbg = 0; zoombg = []; ry = 0; canmovebg = 0; 5.times { zoombg<<0 }
    # Animation (pokemon)
    maxframe = MaxFrameFlash; animationpo = 0; canzoompkmn = false
    # Animation (circle)
    circlemove = 0; countcircle = 0
    # Flash (zoom)
    flash = false
    # Position (set move)
    pos = 0; canmove = 0
    move2 = false; invisbl = 0
    loop do
      # Update
      update_ingame
      if Input.trigger?(Input::B) && cancancel
        pbBGMStop; pbPlayCancelSE
        # Set invisible
        (0...5).each { |i| set_visible_sprite("bg #{i}") }
        (1..8).each { |i| setVisibleLight(i,max) }
        (9..24).each { |i| setVisibleLight(i,2) }
        (25..34).each { |i| setVisibleLight(i,maxfw) }
        # Break
        @canceled = true
        break
      end
      animation += 1
      # Zoom background
      if animation%2==0 
        animationbg += 1; ry += 1
        if animationbg==3
          animationbg = 0
          (0..canmovebg).each { |i| 
          if circlemove!=0
            if zoombg[i]>=1.5; set_visible_sprite("bg #{i}") 
            else; zoombg[i] += 0.2; set_zoom("bg #{i}",zoombg[i],zoombg[i])
            end
          else
            zoombg[i] += 0.2; zoombg[i] = 0 if zoombg[i]>=1.5
            set_zoom("bg #{i}",zoombg[i],zoombg[i]) 
          end }
          canmovebg += 1 if ry%3==0; canmovebg = 4 if canmovebg > 4
        end
      end
      if !flash && circlemove==0
        canmove += 1
        if animation==2
          # Reset animation
          animation = 0 
          # Move light (down to up)
          if !move2
            # Set "true" for moving
            (1..4).each { |i| @startmove["#{i} #{max}"][pos] = true }
            # Move
            curveLightFRLG(1,pos,max,10,18,-1) if @startmove["1 #{max}"][pos]
            curveLightFRLG(2,pos,max,10,18,-1) if @startmove["2 #{max}"][pos]
            curveLightFRLG(3,pos,max,10,18,1) if @startmove["3 #{max}"][pos]
            curveLightFRLG(4,pos,max,10,18,1) if @startmove["4 #{max}"][pos]
            # Set x, y for light
            (1..4).each { |i| setXYLight(i,max) }
            # Move (Light)
            (pos += 1; @sprites["old"].color.alpha += 12) if canmove%8==0
            pos = max-1 if pos>=max
            # Check for next light (reset)
            (1..4).each { |i| invisbl += 1 if checkVisibleLight(i,max) }
            if invisbl==4
              (5..8).each { |i| setVisibleLight(i,max,nil,true) }
              pos = 0; canmove = 0; invisbl = 0; move2 = true
            else; invisbl = 0
            end
          # Move light (up to down)
          else
            # Set "true" for moving
            (5..8).each { |i| @startmove["#{i} #{max}"][pos] = true }
            # Move
            sinLightFRLG(5,pos,max,5,-1) if @startmove["5 #{max}"][pos]
            sinLightFRLG(6,pos,max,5,-1) if @startmove["6 #{max}"][pos]
            sinLightFRLG(7,pos,max,5,1) if @startmove["7 #{max}"][pos]
            sinLightFRLG(8,pos,max,5,1) if @startmove["8 #{max}"][pos]
            # Set x, y for light
            (5..8).each { |i| setXYLight(i,max) }
            # Move (Light)
            pos += 1 if canmove%8==0
            pos = max-1 if pos>=max
            # Reset
            (5..8).each { |i| invisbl += 1 if checkVisibleLight(i,max) }
            if invisbl==4
              animation = 0; canmove = 0; pos = 0; invisbl = 0; flash = true
            else; invisbl = 0
            end
          end
        end
      # Flash
      elsif flash && circlemove==0
        animationpo += 1; numberzoom = 0.5
        if animation<(maxframe/2).floor
          canzoompkmn = true if animationpo%10==0
        elsif animation<(maxframe*7/8).floor && animation>(maxframe/2).floor
          canzoompkmn = true if animationpo%7==0
        elsif animation<maxframe && animation>(maxframe*7/8).floor
          canzoompkmn = true if animationpo%11==0
        elsif animation>maxframe
          (9..24).each { |i| setVisibleLight(i,2,0,true) }
          animation = 0; circlemove = 1
        end
        if canzoompkmn
          canzoompkmn = false
          recordZoomChanged("old",numberzoom)
          recordZoomChanged("new",numberzoom)
        end
      end
      # After flash
      case circlemove
      when 1
        # Move circle
        if animation%3==0
          countcircle += 1
          xc2 = xc + (middlex-xc)/10*countcircle
          yc2 = yc - 3.2*countcircle
          distx2 = distx - distx/10*countcircle
          disty2 = disty - disty/10*countcircle
          createCircleAlmostFRLG(numbc,xc2,yc2,distx2,disty2,maxc,0,true) 
          if countcircle>10
            (9..24).each { |i| 
            setVisibleLight(i,2,0); setVisibleLight(i,2,1,true) }
            countcircle = 0; animation = 0; circlemove = 2
          end
        end
      when 2
        if animation%3==0
          countcircle += 1
          if countcircle<=10
            # Move circle
            xc2 = xc + (middlex-xc)/10*countcircle
            yc2 = yc - 3.2*countcircle
            distx2 = distx - distx/10*countcircle
            disty2 = disty - disty/10*countcircle
            createCircleAlmostFRLG(numbc,xc2,yc2,distx2,disty2,maxc,1,true)
            (9..24).each { |i| setVisibleLight(i,2,1) } if countcircle==10
          else
            # Set visible firework (10)
            (25..34).each { |i| setVisibleLight(i,maxfw,nil,true) }
            countcircle = 0; animation = 0; circlemove = 3
          end
        end
      when 3
        canmove += 1
        if animation%2==0
          # Set "true" for moving
          (25..34).each { |i| @startmove["#{i} #{maxfw}"][pos] = true 
          firstMoveFireworkFRLG(i,pos,maxfw,29) if @startmove["#{i} #{maxfw}"][pos]
          # Set x, y for light
          setXYLight(i,maxfw) }
          # Move (Light)
          pos += 1 if canmove%8==0
          pos = maxfw-1 if pos>=maxfw
          # Break
          break if @storey["34 #{maxfw}"][maxfw-1]<0
        end
      end
    end
    # Set visible
    setVisibleAfterEvol
    # Flash
    flashOutOrIn(true)
    # Restore color (pokemon)
    restoreColor("old"); restoreColor("new")
    @sprites["old"].color.alpha = 0; @sprites["new"].color.alpha = 0
    # Flash
    flashOutOrIn(false)
    # Firework
    if !@canceled
      pos = 0; canmove = 0; animation = 0
      loop do
        # Update
        update_ingame
        break if @storey["34 #{maxfw}"][maxfw-1]>middley-50
        animation += 1
        if animation%2==0
          canmove += 1
          (25..34).each { |i| @startmove["#{i} #{maxfw}"][pos] = false
          if !@startmove["#{i} #{maxfw}"][pos]
            secondMoveFireworkFRLG(i,pos,maxfw,29,middley)
          end
          setXYLight(i,maxfw) }
          pos+=1 if canmove%10==0; pos = maxfw-1 if pos>=maxfw
        end
      end
      (25..34).each { |i| setVisibleLight(i,maxfw) }
    end
    # Restore color (scene)
    15.times { @sprites["scene"].color.alpha -= 17; pbWait(1) }
    # End evolution
    successOrNotEvolution
  end
  
  # Diamond/Pearl
  def evolutionDP(cancancel=true)
    # Set zoom pokemon
    set_zoom("new",0,0)
    # Record
    recordZoomPkmn("old"); recordZoomPkmn("new")
    pbFadeInAndShow(@sprites) { update }
    # Start
    startEvolution
    # Store color
    storeColor("old"); storeColor("new")
    # Set white image
    # Old
    @sprites["old"].color.red = 255
    @sprites["old"].color.green = 255
    @sprites["old"].color.blue = 255
    # New
    @sprites["new"].color.red = 255
    @sprites["new"].color.green = 255
    @sprites["new"].color.blue = 255
    @sprites["new"].color.alpha = 255
    # Narrow scene
    narrowOrExpandScene(true,0,true)
    # Light
    middlex = SCREEN_WIDTH/2; middley = SCREEN_HEIGHT/2
    max = 10
    xchoice = [middlex-80,middlex+80]
    (0...10).each { |i|
    x = (i%2==0)? xchoice[0] : xchoice[1]
    y = 10+20*i
    createLightCircle(i,x,y,max,@vpnarrow) 
    (0...max).each { |j|
    @sprites["circle #{i} #{j}"].color.red = 252
    @sprites["circle #{i} #{j}"].color.green = 252
    @sprites["circle #{i} #{j}"].color.blue = 210
    @sprites["circle #{i} #{j}"].color.alpha = 150
    set_opacity_sprite("circle #{i} #{j}",150) } }
    # Create sunlight
    @opacitychangeDP = {}
    (0...40).each { |i|
    create_sprite("slight #{i}","Sunlight",@vpnarrow,"DP")
    @opacitychangeDP["slight #{i}"] = false
    ox = @sprites["slight #{i}"].bitmap.width
    oy = @sprites["slight #{i}"].bitmap.height/2
    set_oxoy_sprite("slight #{i}",ox,oy)
    x = middlex
    y = middley - 32 - @vpnarrow.rect.y
    set_xy_sprite("slight #{i}",x,y)
    angle = (i%4==0)? rand(90) : (i%4==1)? 90+rand(90) : (i%4==2)? 180+rand(90) : 270+rand(90)
    set_angle_sprite("slight #{i}",angle)
    zoom = rand(3)*0.1 + 1.1
    set_zoom("slight #{i}",zoom,zoom)
    @sprites["slight #{i}"].color.red = 255
    @sprites["slight #{i}"].color.green = 255
    @sprites["slight #{i}"].color.blue = 255
    set_opacity_sprite("slight #{i}",100)
    set_visible_sprite("slight #{i}") }
    # Create circle (sun)
    @zoomchangeDP = {}
    (0...2).each { |i|
    create_sprite("sun #{i}","Circle Yellow",@vpnarrow,"DP")
    @zoomchangeDP["sun #{i}"] = false
    ox = @sprites["sun #{i}"].bitmap.width/2
    oy = @sprites["sun #{i}"].bitmap.height/2
    set_oxoy_sprite("sun #{i}",ox,oy)
    x = middlex
    y = middley - 32 - @vpnarrow.rect.y
    set_xy_sprite("sun #{i}",x,y)
    zoom = (i==0)? 1 : 1.2
    set_zoom("sun #{i}",zoom,zoom)
    @sprites["sun #{i}"].color.red = 255
    @sprites["sun #{i}"].color.green = 255
    @sprites["sun #{i}"].color.blue = 255
    opacity = (i==0)? 220 : 180
    set_opacity_sprite("sun #{i}",opacity) 
    set_visible_sprite("sun #{i}") }
    # Create light (out when zooming Pokemon)
    @storexychangeDP = {}
    (0...40).each { |i|
    create_sprite("circle emanate #{i}","Circle",@vpnarrow)
    ox = @sprites["circle emanate #{i}"].bitmap.width/2
    oy = @sprites["circle emanate #{i}"].bitmap.height/2
    set_oxoy_sprite("circle emanate #{i}",ox,oy)
    x = middlex
    y = middley - 32 - @vpnarrow.rect.y
    set_xy_sprite("circle emanate #{i}",x,y)
    @storexychangeDP["circle emanate #{i}"] = [x,y]
    @storexychangeDP["can change #{i}"] = 0
    @storexychangeDP["store random #{i}"] = false
    @storexychangeDP["random xy #{i}"] = [0,0]
    zoom = 0.8
    set_zoom("circle emanate #{i}",zoom,zoom)
    set_visible_sprite("circle emanate #{i}") }
    # Animation
    animation = 0; canmove = 0; pos = 0; invisbl = 0
    # Animation (zoom)
    animationpo = 0; maxframe = MaxFrameFlash; canzoompkmn = false
    # Flash (pokemon)
    flash = false
    loop do
      # Update
      update_ingame
      if Input.trigger?(Input::B) && cancancel
        pbBGMStop; pbPlayCancelSE
        # Set invisible
        # Light (begin)
        (0...10).each { |i| setVisibleLight(i,max,nil,false) }
        # Sunlight
        (0...40).each { |i| set_visible_sprite("slight #{i}") }
        # Sun
        (0...2).each { |i| set_visible_sprite("sun #{i}") }
        # Light (when zooming)
        (0...40).each { |i| set_visible_sprite("circle emanate #{i}") }
        @canceled = true
        break
      end
      animation+=1
      if !flash
        if animation==2
          canmove += 1
          # Reset animation
          animation = 0
          # Set "true" for moving
          (0...10).each { |i| @startmove["#{i} #{max}"][pos] = true 
          # Move
          if @startmove["#{i} #{max}"][pos]
            if i%2==0 
              sinLightDP(i,pos,max,20,1,1.5,true)
            else
              sinLightDP(i,pos,max,20,-1,1.5)
            end
          end }
          # Set x, y for light
          (0...10).each { |i| setXYLight(i,max) }
          # Move (Light)
          (pos += 1; @sprites["old"].color.alpha += 25) if canmove%8==0
          pos = max-1 if pos>=max
          # Check for next light (reset)
          (0...10).each { |i| invisbl += 1 if checkVisibleLight(i,max) }
          if invisbl==10
            animation = 0; pos = 0; canmove = 0; invisbl = 0 
            # Set visible
            # Sunlight
            (0...40).each { |i| set_visible_sprite("slight #{i}",true) }
            # Sun
            (0...2).each { |i| set_visible_sprite("sun #{i}",true) }
            # Light (when zooming)
            (0...40).each { |i| set_visible_sprite("circle emanate #{i}",true) }
            # Set (true) flash 
            flash = true
          else; invisbl = 0
          end
        end
      else
        animationpo += 1; numberzoom = 0.5
        if animation<(maxframe/2).floor
          if animation%4==0
            # Sunlight
            changeOpacitySunlightYellowDP
            # Sun (zoom)
            changeZoomSunYellowDP(0.08)
          end
          # Flash
          changeXYEmanateDP if animation%6==0
          # Zoom (pokemon)
          canzoompkmn = true if animationpo%10==0
        elsif animation<(maxframe*7/8).floor && animation>(maxframe/2).floor
          if animation%4==0
            # Sunlight
            changeOpacitySunlightYellowDP
            # Sun (zoom)
            changeZoomSunYellowDP(0.08)
          end
          # Flash
          changeXYEmanateDP if animation%6==0
          # Change Color
          changeColorDP if animation%2==0
          # Zoom (pokemon)
          canzoompkmn = true if animationpo%7==0
        elsif animation<maxframe && animation>(maxframe*7/8).floor
          # Set invisible
          # Sunlight
          (0...40).each { |i| set_visible_sprite("slight #{i}") }
          # Light (when zooming)
          (0...40).each { |i| set_visible_sprite("circle emanate #{i}") }
          # Sun
          (0...2).each { |i| @sprites["sun #{i}"].zoom_x -= 0.2 
          @sprites["sun #{i}"].zoom_y -= 0.2 } if animation%2==0
          # Zoom (pokemon)
          canzoompkmn = true if animationpo%11==0
        elsif animation>maxframe; break
        end
        if canzoompkmn
          canzoompkmn = false
          recordZoomChanged("old",numberzoom)
          recordZoomChanged("new",numberzoom)
        end
      end
    end
    if !@canceled
      # Circle (Yellow when evolution)
      create_sprite("circle success","Circle Success",@viewport,"DP")
      ox = @sprites["circle success"].bitmap.width/2
      oy = @sprites["circle success"].bitmap.height/2
      set_oxoy_sprite("circle success",ox,oy)
      set_xy_sprite("circle success",middlex,middley-32)
      set_zoom("circle success",0,0)
      # Light
      create_sprite("light success","Light",@vpnarrow,"DP")
      ox = @sprites["light success"].bitmap.width/2
      oy = @sprites["light success"].bitmap.height/2
      set_oxoy_sprite("light success",ox,oy)
      setPosLightEnd
      # Set white (light)
      @sprites["light success"].color.red = 255
      @sprites["light success"].color.green = 255
      @sprites["light success"].color.blue = 255
      @sprites["light success"].color.alpha = 255
      # Set circle (after light)
      (0...12).each { |i| x = rand(SCREEN_WIDTH); y = rand(SCREEN_HEIGHT-105)
      createLightCircle(i,x,y,2,@viewport)
      set_opacity_sprite("circle #{i} 1",50)
      setVisibleLight(i,2) }
    end
    # Expand scene
    narrowOrExpandScene(false,0,true)
    # End evolution
    successOrNotEvolution
  end
#-------------------------------------------------------------------------------
# Set background (FRLG style)
#-------------------------------------------------------------------------------
  def setBackgroundFRLG(number)
    middlex = SCREEN_WIDTH/2; middley = SCREEN_HEIGHT/2
    (0...number).each { |i| 
    create_sprite("bg #{i}","Background Animation",@viewport,"FRLG")
    set_oxoy_sprite("bg #{i}",middlex,middley)
    set_xy_sprite("bg #{i}",middlex,middley-32) 
    set_zoom("bg #{i}",0,0) }
  end
#-------------------------------------------------------------------------------
# Light (FRLG style)
#-------------------------------------------------------------------------------
  def createLightCircle(order,x,y,max=10,vp=nil)
    vp = @viewport if vp.nil?
    @storex = {} if !@storex; @storey = {} if !@storey
    @startmove = {} if !@startmove; @storef = {} if !@storef
    @storex["#{order} #{max}"] = [] if !@storex["#{order} #{max}"]
    @storey["#{order} #{max}"] = [] if !@storey["#{order} #{max}"]
    @startmove["#{order} #{max}"] = [] if !@startmove["#{order} #{max}"]
    @storef["factor #{order} #{max}"] = [] if !@storef["factor #{order} #{max}"]
    @storef["reverse #{order} #{max}"] = [] if !@storef["reverse #{order} #{max}"]
    @storef["nega #{order} #{max}"] = [] if !@storef["nega #{order} #{max}"]
    @storef["ivsble #{order} #{max}"] = [] if !@storef["ivsble #{order} #{max}"]
    # Set value
    (0...max).each { |i|
    # Set x, y
    create_sprite("circle #{order} #{i}","Circle",vp)
    ox = @sprites["circle #{order} #{i}"].bitmap.width/2
    oy = @sprites["circle #{order} #{i}"].bitmap.height/2
    set_oxoy_sprite("circle #{order} #{i}",ox,oy)
    set_xy_sprite("circle #{order} #{i}",x,y)
    # Set some features
    # Set x, y
    @storex["#{order} #{max}"] << x; @storey["#{order} #{max}"] << y 
    # Set can move
    @startmove["#{order} #{max}"] << false 
    # Set factor (sin)
    @storef["factor #{order} #{max}"] << 0 
    # Set reverse move
    @storef["reverse #{order} #{max}"] << false 
    # Set direction
    @storef["nega #{order} #{max}"] << -1 
    # Set invisible
    @storef["ivsble #{order} #{max}"] << 0 }
  end
  
  def setXYLight(order,max=10)
    (0...max).each { |i| 
    x = @storex["#{order} #{max}"][i]
    y = @storey["#{order} #{max}"][i]
    set_xy_sprite("circle #{order} #{i}",x,y) }
  end
  
  def setVisibleLight(order,max=10,pos=nil,canvisible=false)
    if pos.nil?
      if !canvisible
        (0...max).each { |i| set_visible_sprite("circle #{order} #{i}") }
      else
        (0...max).each { |i| set_visible_sprite("circle #{order} #{i}",true) }
      end
    else
      if !canvisible
        set_visible_sprite("circle #{order} #{pos}")
      else
        set_visible_sprite("circle #{order} #{pos}",true)
      end
    end
  end
  
  def checkVisibleLight(order,max=10)
    all = []
    (0...max).each { |i| all<<false if !@sprites["circle #{order} #{i}"].visible}
    return true if all.length==max
    return false
  end
#-------------------------------------------------------------------------------
# Light Curve (FRLG style)
#-------------------------------------------------------------------------------
  def curveLightFRLG(order,pos,max,numb,numa,revnega)
    (0..pos).each { |i| 
    if @storef["ivsble #{order} #{max}"][i]!=3
      # Set y
      @storey["#{order} #{max}"][i] -= 4
      # Value
      @storef["factor #{order} #{max}"][i] += 0.08
      if @storef["reverse #{order} #{max}"][i]
        @storef["nega #{order} #{max}"][i] = (-1)*revnega; number = numa
      else
        @storef["nega #{order} #{max}"][i] = revnega; number = numb
      end
      factor = @storef["factor #{order} #{max}"][i]
      nega = @storef["nega #{order} #{max}"][i]
      x = @storex["#{order} #{max}"][i]
      add = (Math.sin(factor*Math::PI)*number*nega + x).floor
      # Set x
      @storex["#{order} #{max}"][i] = add 
      if @storef["factor #{order} #{max}"][i]>=2 
        if !@storef["reverse #{order} #{max}"][i]
          # Set
          @storef["factor #{order} #{max}"][i] = 0
          @storef["reverse #{order} #{max}"][i] = true
          # Zoom out
          set_zoom("circle #{order} #{i}",0.5,0.5)
        elsif @storef["ivsble #{order} #{max}"][i]!=3
          # Set
          @storef["ivsble #{order} #{max}"][i] += 1
        end
      end
    end
    # Invisible
    setVisibleLight(order,max,i) if @storef["ivsble #{order} #{max}"][i]==3 }
  end
  
  def sinLightFRLG(order,pos,max,number,revnega)
    (0..pos).each { |i| 
    if @storef["ivsble #{order} #{max}"][i]!=2
      # Set y
      @storey["#{order} #{max}"][i] += 8
      # Value
      @storef["factor #{order} #{max}"][i] += 0.08
      @storef["nega #{order} #{max}"][i] = revnega
      factor = @storef["factor #{order} #{max}"][i]
      nega = @storef["nega #{order} #{max}"][i]
      x = @storex["#{order} #{max}"][i]
      add = (Math.sin(factor*Math::PI)*number*nega + x).floor
      # Set x
      @storex["#{order} #{max}"][i] = add 
      # Set
      if @storef["factor #{order} #{max}"][i]>=2
        @storef["ivsble #{order} #{max}"][i] += 1
      elsif @storef["factor #{order} #{max}"][i]>=1
        # Zoom out
        set_zoom("circle #{order} #{i}",0.5,0.5)
      end
    end
    # Invisible
    setVisibleLight(order,max,i) if @storef["ivsble #{order} #{max}"][i]==2 }
  end
#-------------------------------------------------------------------------------
# Create/Set Circle (FRLG style)
#-------------------------------------------------------------------------------
  def createCircleAlmostFRLG(order,x,y,distancex,distancey,max,rep=nil,move=false)
    pos = 0; factor = 0
    # 16 circles
    (order+1..order+16).each { |i|
    sin = (Math.sin(factor*Math::PI)*distancey).floor
    realy = (y + sin).floor
    realx = (pos>8)? x + distancex*(pos-8) : x + distancex*pos
    if !move
      createLightCircle(i,realx,realy,max) 
    else
      set_xy_sprite("circle #{i} #{rep}",realx,realy)
    end
    factor += 0.125
    pos += 1 }
  end
#-------------------------------------------------------------------------------
# Create/Set Firework Animation (FRLG style)
#-------------------------------------------------------------------------------
  def firstMoveFireworkFRLG(order,pos,max,numx)
    (0..pos).each { |i| 
    if !@storef["reverse #{order} #{max}"][i]
      @storef["reverse #{order} #{max}"][i] = true
      @storef["factor #{order} #{max}"][i] = rand(5)
    end
    if @storef["reverse #{order} #{max}"][i]
      randnum = @storef["factor #{order} #{max}"][i]
    else
      randnum = 0
    end
    # Set y
    @storey["#{order} #{max}"][i] -= 5
    # Set x
    if order>=numx
      @storex["#{order} #{max}"][i] += 0.25*randnum + 0.1
    else
      @storex["#{order} #{max}"][i] -= 0.25*randnum + 0.1
    end }
  end
  
  def secondMoveFireworkFRLG(order,pos,max,numx,limitheight)
    (0..pos).each { |i| 
    # Zoom out
    set_zoom("circle #{order} #{i}",0.5,0.5)
    # Set y
    @storey["#{order} #{max}"][i] += 5 if @storef["ivsble #{order} #{max}"][i]!=2
    # Set x
    if @storef["ivsble #{order} #{max}"][i]==0
      if order>=numx
        @storex["#{order} #{max}"][i] = rand(SCREEN_WIDTH/2) + SCREEN_WIDTH/2
      else
        @storex["#{order} #{max}"][i] = rand(SCREEN_WIDTH/2)
      end
      @storef["ivsble #{order} #{max}"][i] = 1
    elsif @storef["ivsble #{order} #{max}"][i]==1
      random = rand(5)
      case random
      when 0; @storex["#{order} #{max}"][i] -= 2
      when 1; @storex["#{order} #{max}"][i] += 2
      end
      if @storey["#{order} #{max}"][i]>=limitheight
        @storef["ivsble #{order} #{max}"][i] = 2
      end
    else
      # Invisible
      setVisibleLight(order,max,i)
    end }
  end
#-------------------------------------------------------------------------------
# Set x, y for light (begin)
#-------------------------------------------------------------------------------
  def sinLightDP(order,pos,max,number,revnega,numbery,reversey=false)
    (0..pos).each { |i| 
    if @storef["ivsble #{order} #{max}"][i]!=1
      # Set y
      if reversey
        @storey["#{order} #{max}"][i] += numbery
      else
        @storey["#{order} #{max}"][i] -= numbery
      end
      # Value
      @storef["factor #{order} #{max}"][i] += 0.08
      @storef["nega #{order} #{max}"][i] = revnega
      factor = @storef["factor #{order} #{max}"][i]
      nega = @storef["nega #{order} #{max}"][i]
      x = @storex["#{order} #{max}"][i]
      add = (Math.sin(factor*Math::PI)*number*nega + x).floor
      # Set x
      @storex["#{order} #{max}"][i] = add 
      # Set
      if @storef["factor #{order} #{max}"][i]>=2
        @storef["ivsble #{order} #{max}"][i] += 1
      elsif @storef["factor #{order} #{max}"][i]>=1
        # Zoom out
        set_zoom("circle #{order} #{i}",1.1,1.1)
        # Set opacity
        @sprites["circle #{order} #{i}"].opacity -= 15
      end
    end
    # Invisible
    setVisibleLight(order,max,i) if @storef["ivsble #{order} #{max}"][i]==1 }
  end
#-------------------------------------------------------------------------------
# Set x, y (Animation)
#-------------------------------------------------------------------------------
  def changeOpacitySunlightYellowDP
    (0...40).each { |i| 
    opacity = @sprites["slight #{i}"].opacity
    if opacity>=200; @opacitychangeDP["slight #{i}"] = true
    elsif opacity<=30; @opacitychangeDP["slight #{i}"] = false
    end
    if @opacitychangeDP["slight #{i}"]
      @sprites["slight #{i}"].opacity -= 30 - rand(30)
    else
      @sprites["slight #{i}"].opacity += 30 + rand(30)
    end }
  end
  
  def changeZoomSunYellowDP(value)
    (0...2).each { |i|
    spritex = @sprites["sun #{i}"].zoom_x
    spritey = @sprites["sun #{i}"].zoom_y
    limit = (i==0)? [1.7,1] : [1.9,1.2]
    if spritex>=limit[0] && spritey>=limit[0]; @zoomchangeDP["sun #{i}"] = false
    elsif spritex<=limit[1] && spritey<=limit[1]; @zoomchangeDP["sun #{i}"] = true
    end
    if @zoomchangeDP["sun #{i}"]
      @sprites["sun #{i}"].zoom_x += value
      @sprites["sun #{i}"].zoom_y += value
    else
      @sprites["sun #{i}"].zoom_x -= value
      @sprites["sun #{i}"].zoom_y -= value
    end }
  end
  
  def changeXYEmanateDP
    (0...40).each { |i|
    x = @storexychangeDP["circle emanate #{i}"][0]
    y = @storexychangeDP["circle emanate #{i}"][1]
    if !@storexychangeDP["store random #{i}"]
      # Coordinate
      # x
      @storexychangeDP["random xy #{i}"][0] = 10 + rand(25)
      # y
      @storexychangeDP["random xy #{i}"][1] = 10 + rand(30)
    end
    # Set
    if @storexychangeDP["can change #{i}"]<5
      # x
      case i%4
      when 0,1; x -= @storexychangeDP["random xy #{i}"][0]
      when 2,3; x += @storexychangeDP["random xy #{i}"][0]
      end
      # y
      case i%4
      when 0,3; y -= @storexychangeDP["random xy #{i}"][1]
      when 1,2; y += @storexychangeDP["random xy #{i}"][1]
      end
    else
      x = SCREEN_WIDTH/2
      y = SCREEN_HEIGHT/2 - 32 - @vpnarrow.rect.y
    end
    set_xy_sprite("circle emanate #{i}",x,y)
    @storexychangeDP["circle emanate #{i}"] = [x,y]
    if @storexychangeDP["can change #{i}"]<5
      @storexychangeDP["can change #{i}"] += 1
      @storexychangeDP["store random #{i}"] = true
    else
      @storexychangeDP["can change #{i}"] = 0
      @storexychangeDP["store random #{i}"] = false
    end }
  end
  
  def changeColorDP
    (0...40).each { |i| @sprites["slight #{i}"].color.alpha += 5 }
    (0...2).each { |i| @sprites["sun #{i}"].color.alpha += 4 }
  end
#-------------------------------------------------------------------------------
# After evolution (success)
#-------------------------------------------------------------------------------
  def setPosLightEnd
    x = SCREEN_WIDTH/2; y = SCREEN_HEIGHT/2-@vpnarrow.rect.y
    set_xy_sprite("light success",x,y)
  end
  
  def featureSuccessFinDP(zoom,alpha)
    ( setPosLightEnd
    set_zoom("circle success",zoom,zoom)
    set_zoom("light success",1+zoom,1+zoom)
    alpha = 0 if alpha.nil? || alpha<=0
    @sprites["light success"].color.alpha = alpha
    ) if !@canceled
  end
  
  def featureSuccessFoutDP(opacity,zoom)
    ( set_opacity_sprite("circle success",opacity)
    set_opacity_sprite("light success",opacity) 
    (0...12).each { |i| setVisibleLight(i,2,nil,true)
    set_zoom("circle #{i} 0",zoom-1,zoom-1) 
    set_zoom("circle #{i} 1",zoom,zoom) }
    ) if !@canceled
  end
#-------------------------------------------------------------------------------
# Zoom pokemon (record)
#-------------------------------------------------------------------------------
  def recordZoomPkmn(sprite)
    @changedzoom = {} if !@changedzoom; @changedzoom[sprite] = false
  end
  
  def recordZoomChanged(sprite,value)
    zoomx = @sprites[sprite].zoom_x; zoomy = @sprites[sprite].zoom_y
    if zoomx<=0 && zoomy<=0; @changedzoom[sprite] = true
    elsif zoomx>=1 && zoomy>=1; @changedzoom[sprite] = false
    end
    nega = (@changedzoom[sprite])? 1 : -1
    zoomx += nega*value; zoomy += nega*value
    set_zoom(sprite,zoomx,zoomy)
  end
#-------------------------------------------------------------------------------
# Visible sprites (after)
#-------------------------------------------------------------------------------
  def setVisibleAfterEvol
    set_zoom("old",1,1); set_zoom("new",1,1)
    if @canceled; set_visible_sprite("old",true); set_visible_sprite("new")
    else; set_visible_sprite("old"); set_visible_sprite("new",true)
    end
  end
#-------------------------------------------------------------------------------
# Start/End/Success Evolution
#-------------------------------------------------------------------------------
  def startEvolution
    pbBGMStop
    pbPlayCry(@old)
    pbMessageDisplay(@sprites["msgwindow"],
      _INTL("\\se[]What? {1} is evolving!\\^",@old.name)) { update }
    pbMessageWaitForInput(@sprites["msgwindow"],50,true) { update }
    pbPlayDecisionSE
    pbMEPlay("Evolution start")
    pbBGMPlay("Evolution")
  end
  
  def successOrNotEvolution
    (@canceled)? pbMessageDisplay(@sprites["msgwindow"],
    _INTL("Huh? {1} stopped evolving!",@old.name)) { update } : successEvolution
  end
  
  def successEvolution
    # Play cry of evolved species
    frames = pbCryFrameLength(@new,@old.form)
    pbBGMStop
    pbPlayCrySpecies(@new,@old.form)
    frames.times { Graphics.update; update }
    # Success jingle/message
    pbMEPlay("Evolution success")
    newspeciesname = PBSpecies.getName(@new)
    oldspeciesname = PBSpecies.getName(@old.species)
    pbMessageDisplay(@sprites["msgwindow"],
      _INTL("\\se[]Congratulations! Your {1} evolved into {2}!\\wt[80]",
      @old.name,newspeciesname)) { update }
    @sprites["msgwindow"].text = ""
    # Check for consumed item and check if Pokémon should be duplicated
    pbEvolutionMethodAfterEvolution
    # Modify Pokémon to make it evolved
    @old.species = @new
    @old.name    = newspeciesname if @old.name==oldspeciesname
    @old.form    = 0 if @old.isSpecies?(:MOTHIM)
    @old.calcStats
    # See and own evolved species
    $Trainer.seen[@new]  = true
    $Trainer.owned[@new] = true
    pbSeenForm(@old)
    # Learn moves upon evolution for evolved species
    movelist = @old.getMoveList
    for i in movelist
      next if i[0]!=0 && i[0]!=@old.level   # 0 is "learn upon evolution"
      pbLearnMove(@old,i[1],true) { update }
    end
  end
#-------------------------------------------------------------------------------
# Check method evolution
#-------------------------------------------------------------------------------
  def pbEvolutionMethodAfterEvolution
    pbCheckEvolutionEx(@old) { |pkmn, method, parameter, new_species|
    success = PBEvolution.call("afterEvolution",method,pkmn,new_species,parameter,@new)
    next (success)? 1 : -1 }
  end
#-------------------------------------------------------------------------------
# Narrow/Expand background (flash after evolution)
#-------------------------------------------------------------------------------
  def narrowOrExpandScene(nar=false,flash=nil,vp=false)
    tone = 0; animation = 0
    # Narrow
    if nar
      w = SCREEN_WIDTH; h = SCREEN_HEIGHT
      x = 0; y = 0
      loop do
        # Update
        update_ingame
        break if h<=200
        animation += 1
        (y += 6; y = 80 if y>=80; h -= 15; h = 200 if h<=200
        narrowExpandSceneVp(x,y,w,h,vp)) if animation%2==0
      end
      # Store value
      @store=[x,y,w,h]
    # Expand
    else
      x=@store[0]; y=@store[1]; w=@store[2]; h=@store[3]
      zoom = 0; alpha = 255
      loop do
        # Update
        update_ingame
        # Flash in
        break if h>=SCREEN_HEIGHT
        animation += 1
        (y -= 6; y = 0 if y<=0; h += 15; h = SCREEN_HEIGHT if h>=SCREEN_HEIGHT
        narrowExpandSceneVp(x,y,w,h,vp)) if animation%4==0
        if animation%2==0
          # Flash in
          if !(flash.nil?)
            tone += 20; tone = 255 if tone>=255
            @viewport.tone.set(tone,tone,tone,0)
            # Some features
            case NewEvolutionGen
            # Diamond/Pearl
            when 2
              zoom+=0.2; alpha-=40 if zoom>=0.5; featureSuccessFinDP(zoom,alpha)
            end
          end
        end
      end
      # Flash out
      if !(flash.nil?)
        animation = 0; opacity = 255
        zoom = 15 if NewEvolutionGen==2
        pbWait(3)
        # Restore color
        restoreColor("old"); restoreColor("new")
        @sprites["old"].color.alpha = 0; @sprites["new"].color.alpha = 0
        # Set visible
        setVisibleAfterEvol
        loop do
          # Update
          update_ingame
          if @canceled
            break if tone<=0
          else
            break if zoom<=0
          end
          animation+=1
          if animation%2==0
            # Some features
            case NewEvolutionGen
            # Diamond/Pearl
            when 2
              opacity-=50; zoom-=0.4 if tone<=0
              featureSuccessFoutDP(opacity,zoom)
            end
            tone-=50; tone=0 if tone<0; @viewport.tone.set(tone,tone,tone,0)
          end
        end
      end
    end
  end
  
  def flashOutOrIn(out)
    if out
      tone = 0
      20.times { tone += 12.75; tone = 255 if tone>255
      @viewport.tone.set(tone,tone,tone,0); pbWait(1) }
    else
      tone = 255
      20.times { tone -= 12.75; tone = 0 if tone<0
      @viewport.tone.set(tone,tone,tone,0); pbWait(1) }
    end
  end
  
  def narrowExpandSceneVp(x,y,w,h,vp=false)
    if vp
      @vpnarrow.rect.height = h; @vpnarrow.rect.y = y; @sprites["scene"].oy = y
    else
      set_src_wh_sprite("scene",w,h)
      set_src_xy_sprite("scene",x,y) 
      set_xy_sprite("scene",x,y)
    end
  end
#-------------------------------------------------------------------------------
# Color
#-------------------------------------------------------------------------------
  def storeColor(sprite)
    @colorstore = {} if !@colorstore
    @colorstore[sprite]=[] if !@colorstore[sprite]
    red = @sprites[sprite].color.red
    green = @sprites[sprite].color.green
    blue = @sprites[sprite].color.blue
    @colorstore[sprite]=[red,green,blue]
  end
  
  def restoreColor(sprite)
    @sprites[sprite].color.red = @colorstore[sprite][0]
    @sprites[sprite].color.green = @colorstore[sprite][1]
    @sprites[sprite].color.blue = @colorstore[sprite][2]
  end
#-------------------------------------------------------------------------------
# Set bitmap
#-------------------------------------------------------------------------------
  # Image
  def create_sprite(spritename,filename,vp,dir2=nil,dir="Pictures/New Evolution Scene")
    @sprites["#{spritename}"] = Sprite.new(vp)
    if dir2.nil?
      @sprites["#{spritename}"].bitmap = Bitmap.new("Graphics/#{dir}/#{filename}")
    else
      @sprites["#{spritename}"].bitmap = Bitmap.new("Graphics/#{dir}/#{dir2}/#{filename}")
    end
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
  
  # Set opacity
  def set_opacity_sprite(spritename,value)
    @sprites["#{spritename}"].opacity = value
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
#-------------------------------------------------------------------------------
  def dispose(id=nil)
    (!id)? pbDisposeSprite(@sprites,id) : pbDisposeSpriteHash(@sprites)
  end
  
  def update_ingame
    Graphics.update
    Input.update
    pbUpdateSpriteHash(@sprites)
  end
  
  def update
    pbUpdateSpriteHash(@sprites)
  end
  
  # End
  def endScene
    pbDisposeMessageWindow(@sprites["msgwindow"])
    pbFadeOutAndHide(@sprites) { update }
    dispose
    @vpnarrow.dispose
    @viewport.dispose
    @msgviewport.dispose
  end
end
 
class PokemonEvolutionScene
  alias startNewEvol pbStartScreen
  def pbStartScreen(pokemon,newspecies)
    case NewEvolutionGen
    # Default
    when -1; startNewEvol(pokemon,newspecies)
    else; @newevolution = NewEvolutionScene.new(pokemon,newspecies)
    end
  end
  
  alias evolutionNewEvol pbEvolution
  def pbEvolution(cancancel=true)
    case NewEvolutionGen
    # Default
    when -1; evolutionNewEvol(cancancel)
    else; @newevolution.evolution
    end
  end
  
  alias endNewEvol pbEndScreen
  def pbEndScreen
    case NewEvolutionGen
    # Default
    when -1; endNewEvol
    else; @newevolution.endScene
    end
  end
end