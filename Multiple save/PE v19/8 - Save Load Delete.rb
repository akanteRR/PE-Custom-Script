#------------------------------------------------------------------------------#
# Scene for save menu, load menu and delete menu                               #
#------------------------------------------------------------------------------#
class ScreenChooseFileSave
  attr_reader :staymenu
  attr_reader :deletefile
  
  def initialize(count)
    @sprites = {}
    @viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z = 99999
    # Set value
    # Check quantity
    @count = count
    if @count<=0
      pbMessage("No save file was found.")
      return
    end
    # Check still menu
    @staymenu = false
    @deletefile = false
    # Check position
    @position = 0
    # Check position if count > 7
    @choose = 0
    # Set position of panel 'information'
    @posinfor = 0
    # Quantity of panel in information page
    @qinfor = 0
    # Check mystery gift
    @mysgif = false
  end
  
  # Set background (used "loadbg")
  def drawBg
    color = Color.new(248,248,248)
    addBackgroundOrColoredPlane(@sprites,"background","loadbg",color,@viewport)
  end
	#-------------------------------------------------------------------------------
	# Set SE for input
	#-------------------------------------------------------------------------------
	def checkInput(name)
		if Input.trigger?(name)
			(name==Input::BACK)? pbPlayCloseMenuSE : pbPlayDecisionSE
			return true
		end
		return false
	end
	#-------------------------------------------------------------------------------
	# Set bitmap
	#-------------------------------------------------------------------------------
	# Image
	def create_sprite(spritename,filename,vp,dir="Pictures")
		@sprites["#{spritename}"] = Sprite.new(vp)
		@sprites["#{spritename}"].bitmap = Bitmap.new("Graphics/#{dir}/#{filename}")
	end
	# Set x, y
	def set_xy_sprite(spritename,x,y)
		@sprites["#{spritename}"].x = x
		@sprites["#{spritename}"].y = y
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
	# Text
	#-------------------------------------------------------------------------------
	# Draw
	def create_sprite_2(spritename,vp)
		@sprites["#{spritename}"] = Sprite.new(vp)
		@sprites["#{spritename}"].bitmap = Bitmap.new(Graphics.width,Graphics.height)
		@sprites["#{spritename}"].bitmap.clear
	end
	#-------------------------------------------------------------------------------
	def dispose
		pbDisposeSpriteHash(@sprites)
	end

	def update
		pbUpdateSpriteHash(@sprites)
	end

	def update_ingame
		Graphics.update
		Input.update
		pbUpdateSpriteHash(@sprites)
	end

	def endScene
		dispose
		@viewport.dispose
	end
end