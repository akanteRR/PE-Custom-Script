# Mega evolution
# Credit: bo4p5687

PluginManager.register({
  :name => "Mega evolution (scene)",
  :credits => "bo4p5687"
})

class SceneMegaEvolution
  def initialize
    @sprites={}
    @viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z = 99999
    @red = {}; @green = {}; @blue = {}
  end
 
  def start(time,backdrop,pkmn)
    @previousBGM = $game_system.getPlayingBGM
    pbBGMPlay("cinnabar")
    @pkmn = pkmn
    # Scene
    case time
    when 1; time = "eve"
    when 2; time = "night"
    end
    backdropFilename = backdrop
    if time
      trialName = sprintf("%s_%s",backdropFilename,time)
      backdropFilename = trialName if pbResolveBitmap(sprintf("Graphics/Battlebacks/"+trialName+"_bg"))
    end
    # Center
    @middlex = SCREEN_WIDTH/2; @middley = SCREEN_HEIGHT/2
    # Background
    create_sprite("bg","#{backdropFilename}_bg",@viewport,"Battlebacks")   
    set_zoom("bg",1,1.35)
    # Base
    create_sprite("base","Base",@viewport)
    @sprites["base"].opacity = 0
    # Save color
    red = @sprites["bg"].color.red; green = @sprites["bg"].color.green
    blue = @sprites["bg"].color.blue
    saveColor("bg",red,green,blue)
    # Set white screen (bitmap)
    @sprites["bg"].color.red = 255; @sprites["bg"].color.green = 255
    @sprites["bg"].color.blue = 255
    17.times { @sprites["bg"].color.alpha += 15; pbWait(1) }
    pbWait(5)
    # Restore color (background)
    restoreColor("bg",red,green,blue)
    17.times { @sprites["bg"].color.alpha -= 15; pbWait(1) }
    pbWait(2)
    # Pokemon
    @sprites["pkmn"] = Sprite.new(@viewport)
    @sprites["pkmn"].bitmap = bitmapPkmn.bitmap
    ox = @sprites["pkmn"].bitmap.width/2
    oy = @sprites["pkmn"].bitmap.height/2
    set_oxoy_sprite("pkmn",ox,oy)
    set_xy_sprite("pkmn",@middlex,@middley)
    pbPlayCry(@pkmn)
    pbWait(30)
    # Buble (effect)
    setPositionEffectBuble
    # Set red screen (bitmap)
    @sprites["bg"].color.red = 235; @sprites["bg"].color.green = 0
    @sprites["bg"].color.blue = 0
    17.times { @sprites["bg"].color.alpha += 12; @sprites["base"].opacity += 15
    @sprites["pkmn"].color.alpha += 15; pbWait(1) }
    pbWait(2)
    # Set circle
    create_sprite("circle","Circle",@viewport)
    ox = @sprites["circle"].bitmap.width/2
    oy = @sprites["circle"].bitmap.height/2
    set_oxoy_sprite("circle",ox,oy)
    set_xy_sprite("circle",@middlex,@middley)
    set_zoom("circle",0,0)
    # Set buble
    setEffectBuble(0,0); setEffectBuble(4,1); setEffectBuble(8,2); setEffectBuble(12,3)
    setEffectBuble(1,0); setEffectBuble(5,1); setEffectBuble(9,2); setEffectBuble(13,3)
    setEffectBuble(2,0); setEffectBuble(6,1); setEffectBuble(10,2); setEffectBuble(14,3)
    setEffectBuble(3,0); setEffectBuble(7,1); setEffectBuble(11,2); setEffectBuble(15,3)
    # Animation
    zoom = 0; 15.times { zoom += 0.2; set_zoom("circle",zoom,zoom); pbWait(2) }
    # Save color (pokemon)
    redpkmn = @sprites["pkmn"].color.red
    greenpkmn = @sprites["pkmn"].color.green
    bluepkmn = @sprites["pkmn"].color.blue
    saveColor("pkmn",redpkmn,greenpkmn,bluepkmn)
    # Set white (pokemon)
    @sprites["pkmn"].color.red = 255; @sprites["pkmn"].color.green = 255
    @sprites["pkmn"].color.blue = 255; @sprites["pkmn"].color.alpha = 255
    set_visible_sprite("circle"); pbWait(1)
    # Light
    create_sprite("light","Light",@viewport)
    srcw = @sprites["light"].bitmap.width/3
    srch = @sprites["light"].bitmap.height
    set_src_wh_sprite("light",srcw,srch)
    set_src_xy_sprite("light",0,0)
    set_visible_sprite("light")
    # Circle 2
    create_sprite("circle 2","Circle 2",@viewport)
    srcw = @sprites["circle 2"].bitmap.width/3
    srch = @sprites["circle 2"].bitmap.height
    set_src_wh_sprite("circle 2",srcw,srch)
    set_src_xy_sprite("circle 2",0,0)
    set_oxoy_sprite("circle 2",srcw/2,srch/2)
    set_xy_sprite("circle 2",@middlex,@middley)
    # Save color (circle)
    redc = @sprites["circle 2"].color.red
    greenc = @sprites["circle 2"].color.green
    bluec = @sprites["circle 2"].color.blue
    saveColor("circle 2",redc,greenc,bluec)
    # Set white (circle)
    @sprites["circle 2"].color.red = 255; @sprites["circle 2"].color.green = 255
    @sprites["circle 2"].color.blue = 255; @sprites["circle 2"].color.alpha = 255
    pbWait(1)
    # Animation
    zoom = 1; mul = 0; inc = 0
    9.times { mul+=1; zoom += 0.1; set_zoom("circle 2",zoom,zoom)
    if mul>=7
      # Restore color (circle)
      restoreColor("circle 2",redc,greenc,bluec)
      @sprites["circle 2"].color.alpha = 0
      srcx = @sprites["circle 2"].bitmap.width/3*inc
      set_src_xy_sprite("circle 2",srcx,0)
      set_visible_sprite("light",true)
      srcx = @sprites["light"].bitmap.width/3*inc
      set_src_xy_sprite("light",srcx,0)
      inc += 1
    end
    pbWait(5) }
    create_sprite("scene","#{backdropFilename}_bg",@viewport,"Battlebacks")
    set_zoom("scene",1,1.35)
    @sprites["scene"].color.red = 255; @sprites["scene"].color.green = 255
    @sprites["scene"].color.blue = 255; @sprites["scene"].color.alpha = 255
    # Restore color
    # Pokemon
    restoreColor("pkmn",redpkmn,greenpkmn,bluepkmn)
    @sprites["pkmn"].color.alpha = 0
    set_zoom("pkmn",2,2)
    # Background
    restoreColor("bg",red,green,blue)
    @sprites["bg"].color.alpha = 0
    pbWait(10)
    set_visible_sprite("circle 2"); set_visible_sprite("light")
    set_visible_sprite("base")
  end
 
  def megaEvolve
    # Reset Form
    @sprites["pkmn"].bitmap = bitmapPkmn.bitmap
    17.times { @sprites["scene"].opacity -= 15; pbWait(2) }
    zoom = 2
    10.times { zoom-=0.1; set_zoom("pkmn",zoom,zoom); pbWait(2) }
    create_sprite("light 2","Light 2",@viewport)
    ox = @sprites["light 2"].bitmap.width/2
    oy = @sprites["light 2"].bitmap.height/2
    set_oxoy_sprite("light 2",ox,oy)
    set_xy_sprite("light 2",@middlex,@middley-130)
    create_sprite("icon","icon_mega",@viewport,"Pictures/Battle")
    ox = @sprites["icon"].bitmap.width/2
    oy = @sprites["icon"].bitmap.height/2
    set_oxoy_sprite("icon",ox,oy)
    set_xy_sprite("icon",@middlex,@middley-130)
    set_zoom("icon",1.5,1.5)
    o = 0
    10.times { @sprites["light 2"].angle += 36
    pbPlayCry(@pkmn) if o==5; o += 1; pbWait(5) }
    pbBGMPlay(@previousBGM)
  end
 
  def setXYB(xname,yname,xcoor,ycoor)
    @xyb = {} if !@xyb; @xyb[xname] = xcoor; @xyb[yname] = ycoor
  end
#-------------------------------------------------------------------------------
# Effect
#-------------------------------------------------------------------------------
  # Buble
  def setPositionEffectBuble
    (0...16).each { |i|
    create_sprite("buble #{i}","Buble Pink",@viewport) if !@sprites["buble #{i}"]
    case i
    when 0..3; xbb = @middlex/2-rand(10); ybb = @middley/2-rand(10)
    when 4..7; xbb = @middlex/2-rand(10); ybb = @middley*1.5+rand(10)
    when 8..11; xbb = @middlex*1.5+rand(10); ybb = @middley/2-rand(10)
    else; xbb = @middlex*1.5+rand(10); ybb = @middley*1.5+rand(10)
    end
    setXYB("x #{i}","y #{i}",xbb,ybb)
    set_xy_sprite("buble #{i}",xbb,ybb)
    set_visible_sprite("buble #{i}") }
  end
 
  def setEffectBuble(number,calc)
    set_visible_sprite("buble #{number}",true)
    5.times { xch = @xyb["x #{number}"]; ych = @xyb["y #{number}"]
    xxx = ((@middlex-xch)/5).floor; yyy = ((@middley-ych)/5).floor
    xxx2 = ((xch-@middlex)/5).floor; yyy2 = ((ych-@middley)/5).floor
    case calc
    when 0
      @sprites["buble #{number}"].x += xxx; @sprites["buble #{number}"].y += yyy
    when 1
      @sprites["buble #{number}"].x += xxx; @sprites["buble #{number}"].y -= yyy2
    when 2
      @sprites["buble #{number}"].x -= xxx2; @sprites["buble #{number}"].y += yyy
    else
      @sprites["buble #{number}"].x -= xxx2; @sprites["buble #{number}"].y -= yyy2
    end
    pbWait(2)}
    set_visible_sprite("buble #{number}")
    pbWait(1)
  end
#-------------------------------------------------------------------------------
# Bitmap, Color
#-------------------------------------------------------------------------------
  def bitmapPkmn
    bmpkmn = pbLoadPokemonBitmapSpecies(@pkmn,@pkmn.species)
    return bmpkmn
  end
 
  def saveColor(sprite,red,green,blue)
    @red[sprite] = red; @green[sprite] = green; @blue[sprite] = blue
  end
 
  def restoreColor(sprite,red,green,blue)
    red = @red[sprite]; green = @green[sprite]; blue = @blue[sprite]
  end
#-------------------------------------------------------------------------------
# Set
#-------------------------------------------------------------------------------
  # Image
  def create_sprite(spritename,filename,vp,dir="Pictures/Mega Evolution")
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
  def endScene
    # Reset bitmap
    megaEvolve
    # End
    pbDisposeSpriteHash(@sprites)
  end
end

# Mega
class PokeBattle_Battle
  def pbMegaEvolve(idxBattler)
    battler = @battlers[idxBattler]
    return if !battler || !battler.pokemon
    return if !battler.hasMega? || battler.mega?
    trainerName = pbGetOwnerName(idxBattler)
    # Break Illusion
    if battler.hasActiveAbility?(:ILLUSION)
      BattleHandlers.triggerTargetAbilityOnHit(battler.ability,nil,battler,nil,self)
    end
    # Mega Evolve
    case battler.pokemon.megaMessage
    when 1   # Rayquaza
      pbDisplay(_INTL("{1}'s fervent wish has reached {2}!",trainerName,battler.pbThis))
    else
      pbDisplay(_INTL("{1}'s {2} is reacting to {3}'s {4}!",
         battler.pbThis,battler.itemName,trainerName,pbGetMegaRingName(idxBattler)))
    end
    megascene = SceneMegaEvolution.new
    megascene.start(time,backdrop,battler.pokemon)
    battler.pokemon.makeMega
    battler.form = battler.pokemon.form
    battler.pbUpdate(true)
    @scene.pbChangePokemon(battler,battler.pokemon)
    @scene.pbRefreshOne(idxBattler)
    megascene.endScene
    megaName = battler.pokemon.megaName
    if !megaName || megaName==""
      megaName = _INTL("Mega {1}",PBSpecies.getName(battler.pokemon.species))
    end
    pbDisplay(_INTL("{1} has Mega Evolved into {2}!",battler.pbThis,megaName))
    side  = battler.idxOwnSide
    owner = pbGetOwnerIndexFromBattlerIndex(idxBattler)
    @megaEvolution[side][owner] = -2
    if battler.isSpecies?(:GENGAR) && battler.mega?
      battler.effects[PBEffects::Telekinesis] = 0
    end
    pbCalculatePriority(false,[idxBattler]) if NEWEST_BATTLE_MECHANICS
    # Trigger ability
    battler.pbEffectsOnSwitchIn
  end
end