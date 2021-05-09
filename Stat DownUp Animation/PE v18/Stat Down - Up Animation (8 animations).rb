#===============================================================================
# ■ Klein Bitmap Functions V1 by KleinStudio
# http://pokemonfangames.com
#
# * About the functions
#    ● Functions for bitmaps
#      - scroll_up(velocity=1)
#        -- Scroll up the bitmap
#
#      - scroll_down(velocity=1)
#        -- Scroll down the bitmap
#
#      - scroll_right(velocity=1)
#        -- Scroll right the bitmap
#
#      - scroll_left(velocity=1)
#        -- Scroll left the bitmap
#
#      - save_pallete(palletename) *experimental*
#        -- Create a .kpal file from the bitmap
#           *warning* Can have issues with indexes graphics
#
#      - modify_pallete(palletename) *experimental*
#        -- Load a .kpal file and apply it to the actual bitmap
#           *warning* Can have issues with indexes graphics
#
#      - modify_color(c1, c2)
#        -- Set color to second color in a bitmap
#
#      - to_retro(c1, c2, c3, c4)
#        -- Repaint the bitmap using only a 4 color pallete,
#           c1 is the darker color, c2 the mid-darker,
#           c3 the mid-brighter and c4 the brighter
#
#      - to_negative
#         -- Repaint the bitmap with negative colors
#           
#      - add_outline(c1, pixelsize=1)
#         -- Add a colored outline
#
#    ● Functions for sprites
#      - set_pattern(pattern, alpha, everyframe=false):
#        -- This functions will blend a bitmap over the actual one.
#
#      - delete_pattern 
#        -- Delete the klein pattern (if any)
#
#    ● Extra functions
#      - klein_bitmap_version
#        -- Return the actual version from DLL file
#
#      - compare_klein_bitmaps(bitmap1, bitmap2)
#        -- Return true if the bitmap is exactly the same (dimensions, etc)
#
#      - klein_dll(func, send, get)
#        -- Call a function from the DLL
#      
#===============================================================================
KLEIN_BFUNCS_WORKING = true
KLEIN_BFUNCS_DLL = "KleinBitmap.dll"
#-------------------------------------------------------------------------------
# Bitmap functions
#-------------------------------------------------------------------------------
class Bitmap
    
  def save_pallete(palletename)
    klein_dll("save_pallete", "lp", "").call(self.__id__,palletename)
  end
  
  def modify_pallete(palletename)
    return if !safeExists?(palletename+".kpal")
    klein_dll("modify_pallete", "lp", "").call(self.__id__,palletename)
  end
  
  def scroll_up(speed=1);klein_dll("scroll_up", "ll", "").call(self.__id__,speed);end
  def scroll_down(speed=1);klein_dll("scroll_down", "ll", "").call(self.__id__,speed);end
  def scroll_right(speed=1);klein_dll("scroll_right", "ll", "").call(self.__id__,speed);end
  def scroll_left(speed=1);klein_dll("scroll_left", "ll", "").call(self.__id__,speed);end
  
  def to_retro(c1,c2,c3,c4)
    klein_dll("to_retro", "lllllllllllll", "").call(self.__id__,
      c1.red, c1.green, c1.blue, c2.red, c2.green, c2.blue,
      c3.red, c3.green, c3.blue, c4.red, c4.green, c4.blue); end
      
  def modify_color(c1,c2)
    klein_dll("modify_color", "lllllll", "").call(self.__id__,
      c1.red, c1.green, c1.blue, c2.red, c2.green, c2.blue); end
      
  def add_outline(c1, pixelsize=1)
    klein_dll("add_outline", "lllll", "").call(self.__id__,
      c1.red, c1.green, c1.blue, pixelsize); end

  def to_negative;klein_dll("to_negative", "l", "").call(self.__id__);end
end

#-------------------------------------------------------------------------------
# Sprite functions
#-------------------------------------------------------------------------------
class Sprite
  attr_accessor :kleinPatternBitmap
  
  def set_pattern(pattern, alpha, everyframe = false)
    # Get the id from the pattern bitmap
    pattern_id = pattern.__id__
    # Clone the bitmap
    if @kleinBitmapCopy.nil? 
      @kleinBitmapCopy = self.bitmap.clone 
    else
      if everyframe
        @kleinBitmapCopy.dispose
        @kleinBitmapCopy = self.bitmap.clone 
      end
      self.bitmap = @kleinBitmapCopy.clone
    end
    # Call the function
    klein_dll("set_pattern", "lll", "").call(self.bitmap.__id__,pattern_id,alpha)
  end
  
  def delete_pattern
    return if @kleinBitmapCopy.nil?
    # Return the bitmap to the original 
    self.bitmap = @kleinBitmapCopy.clone
    # Dispose the copy
    @kleinBitmapCopy.dispose
    @kleinBitmapCopy=nil
  end
end
#-------------------------------------------------------------------------------
# Extra functions
#-------------------------------------------------------------------------------
def klein_bitmap_version
  klein_dll("version", "", "l").call()
end

def compare_klein_bitmaps(bitmap1, bitmap2)
  func=klein_dll("compare_bitmap", "ll", "l").call(bitmap1.__id__,bitmap2.__id__)
  return func == 0 ? false : true
end

def klein_dll(func, send, get)
  return Win32API.new(KLEIN_BFUNCS_DLL, func, send, get)
end
#-------------------------------------------------------------------------------
#   Stat Down/Up Animation V1 by KleinStudio 
#   You need the Klein Bitmap Functions to make this script works
#   Put below Klein Bitmap Functions to make this script works
#   http://pokemonfangames.com
#
#   bo4p5687 (updated)
#-------------------------------------------------------------------------------
# Each stat has one animation
#-------------------------------------------------------------------------------
PluginManager.register({
  :name    => " Stat Down/Up Animation",
  :version => "1.0",
  :credits => ["KleinStudio for the original","bo4p5687 for update","LDEJRuff for graphics"]
})
#-------------------------------------------------------------------------------
if defined?(KLEIN_BFUNCS_WORKING) && defined?(klein_bitmap_version) && klein_bitmap_version>=1
  class PokeBattle_Scene    
    def pbCommonAnimationStat(animName,sin=nil,user=nil,target=nil)
      # Add animation
      if user!=nil && (animName=="StatDown" || animName=="StatUp")
        stat = BitmapCache.load_bitmap("Graphics/Pictures/Stats Animation/" + sin) if stat.nil?
        opacity = 255
        (127/4).times do
          if animName=="StatDown"
            stat.scroll_down(7)
          else
            stat.scroll_up(7)
          end
          opacity-=4 
          @sprites["pokemon_#{user.index}"].set_pattern(stat, opacity)
          pbGraphicsUpdate
          animateBattleSprites if defined?(animateBattleSprites)
          pbInputUpdate
        end
        (127/4).times do
          if animName=="StatDown"
            stat.scroll_down(7)
          else
            stat.scroll_up(7)
          end
          opacity+=4 
          @sprites["pokemon_#{user.index}"].set_pattern(stat, opacity)
          pbGraphicsUpdate
          animateBattleSprites if defined?(animateBattleSprites)
          pbInputUpdate
        end
        stat=nil
        @sprites["pokemon_#{user.index}"].delete_pattern
        return
      end
      pbCommonAnimation(animName,user,target)
    end
  end
  
  class PokeBattle_Battle
    def pbCommonAnimationStat(name,sin=nil,user=nil,targets=nil)
      @scene.pbCommonAnimationStat(name,sin,user,targets) if @showAnims
    end
  end
end