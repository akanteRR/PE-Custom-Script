# Blackjack game
# Credit: bo4p5687

if defined?(PluginManager)
  PluginManager.register({
    :name => "Blackjack game",
    :credits => "bo4p5687"
  })
end

module BlackJack
	# Value of Chip, graphics has 5 chip -> 5 values. Don't change this size.
	ValueChips = [1, 25, 100, 500, 1000]
	# Class
	class Play

		# Check delay for clicking
		DelayMouse = 1
		# Quantity of player (Dont change it)
		QuantityPlayer = 4
		# Name of AI, the size of this array must be greater than or equal to 3
		# If not, maybe, player have same name but it must be greater than 0
		NameAI = ["Airi", "Whattt", "Hamson"]
		# Check delay
		def delayMouse(num=5)
			m = self.posMouse
			@delay += 1
			@delay  = 0 if @oldm!=m && @delay>num
			return true if @delay<num
			@oldm = m
			return false
		end
		# Position of rectangle 'Bet'
		# Single area
		def posBetArea(pos)
			x = 34 + pos * 122
			y = 222
			w = 66
			h = 45
			return [x, y, w, h]
		end
		# All areas
		def posAllBet
			pos = []
			QuantityPlayer.times { |i| pos << self.posBetArea(i) }
			return pos
		end
		# Bet
		def rectBet
			QuantityPlayer.times { |i| return i if areaMouse?(self.posAllBet[i]) }
			return nil
		end
		# Position of rectangle 'Card'
		# Player
		def posCardPlayer(pos,quant=0)
			x = 12 + pos * 122
			y = 132
			w = 50 + 15 * quant
			h = 80
			return [x, y, w, h]
		end
		# Dealer
		def posCardDealer(quant=0)
			x = (Graphics.width - 110) / 2
			y = 32
			w = 50 + 15 * quant
			h = 80
			return [x, y, w, h]
		end
		# Determine
		def rectCard
			return -1 if areaMouse?(self.posCardDealer(@player[:dealer][:card].size-1))
			QuantityPlayer.times { |i|
				sym = self.str2sym("player #{i}")
				if areaMouse?(self.posCardPlayer(i,@player[sym][:card].size-1))
					return nil if @player[sym][:name].nil?
					return -2  if @player[sym][:player]
					return i
				end
			}
			return nil
		end
		# Position when choosing chip
		# Single
		def posChipChoose(pos)
			x = 45 + 7 + pos*(16 + 7 + 60)
			y = 337
			r = 8
			return [x, y, r]
		end
		# All
		def posAllChipChoose
			pos = []
			6.times { |i| pos << self.posChipChoose(i) }
			return pos
		end
		# Determine
		def circleChip
			6.times { |i| return i if circleMouse?(self.posAllChipChoose[i]) }
			return nil
		end
		# Rectangle 'Ok' when betting, [x, y, w, h]
		# You don't need to set w and h, it will set with your graphic
		RectOkBet = [ 432, 290, 0, 0 ]
		# Size of bitmap "Message Box"
		# If you don't change this bitmap, don't change it
		# You need to know how to determine and write. If not, please, don't touch it
		# [w,h]
		RectMessBox = [
			# Left, Right
			[4,4], # Top
			[4,2], # Mid
			[4,4], # Bottom
			# Middle
			[2,4], # Top
			[2,2], # Mid
			[2,4]  # Bot
		]
		# Signal [w,h]
		# Icon of lost all has this form [w*2,h]
		RectSignal = [33,14]
		# Rectangle exit, [x, y]
		# Use graphic "Choice", find 'def drawExit' for changing bitmap
		RectExit = [0, 0]
		# Rectangle Arrow, [x,y]
		RectArrow = [
			[400,87], # Up
			[400,87+100+10]  # Down
		]

		def initialize
			@sprites = {}
			# Viewport
      @viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
      @viewport.z = 99999
			# Value
			# Store: A-Hearts, A-Diamonds, A-Clubs, A-Spade, etc
			# Order: 0, 1, 2, 3, etc
			@card = []
			52.times { |i| @card << i }
			# Store card player (position and dealer)
			@player = {}
			# Set for finishing game
			@finish = false
			# Check mouse and use
			@oldm = [0,0]
			@delay = 0
			# Set name AI
			@nameai = NameAI
			@nameai = ["Name"] if @nameai.size<=0 || !@nameai.is_a?(Array)
			# Store position and name of main player (it's you)
			@mainplayer = {
				:position => nil,
				:symbol => nil
			}
			# Check card if it opened
			@opened = []
			QuantityPlayer.times { @opened << false }
			# Store history when dealer opens player's card
			@history = []
			@poshistory = 0
			# Set progress
			@action = false # Bet
			# (Progress) player play
			@playertime  = false # Player can choose action in this progress
			@information = false # Player see informations of each player, include dealer
			@createdchoice = false # Progress for creating choice for player
			@choice = {} # Store information of rectangle 'Choice'
			# (Progress) turn of player
			@turn = 0
			# Check information before finish
			@checkInfor = false
			# Set mouse sounds when move
			@semouse = 0
		end

		#------------#
		# Set bitmap #
		#------------#
		# Image
		def create_sprite(spritename,filename,vp,dir="Pictures/BlackJack")
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
		# Set angle
		def set_angle_sprite(spritename,angle)
			@sprites["#{spritename}"].angle = angle
		end
		# Set src
		# width, height
		def set_src_wh_sprite(spritename,w,h)
			@sprites["#{spritename}"].src_rect.width = w
			@sprites["#{spritename}"].src_rect.height = h
		end
		# x, y
		def set_src_xy_sprite(spritename,x,y)
			@sprites["#{spritename}"].src_rect.x = x
			@sprites["#{spritename}"].src_rect.y = y
		end
		#------#
		# Text #
		#------#
		# Draw
		def create_sprite_2(spritename,vp)
			@sprites["#{spritename}"] = Sprite.new(vp)
			@sprites["#{spritename}"].bitmap = Bitmap.new(Graphics.width,Graphics.height)
		end
		# Write
		def drawTxt(bitmap,textpos,font=nil,fontsize=nil,width=0,pw=false,height=0,ph=false,clearbm=true)
			# Sprite
			bitmap = @sprites["#{bitmap}"].bitmap
			bitmap.clear if clearbm
			# Set font, size
			(font!=nil)? (bitmap.font.name=font) : pbSetSystemFont(bitmap)
			bitmap.font.size = fontsize if !fontsize.nil?
			textpos.each { |i|
				if pw
					i[1] += width==0 ? 0 : width==1 ? bitmap.text_size(i[0]).width/2 : bitmap.text_size(i[0]).width
				else
					i[1] -= width==0 ? 0 : width==1 ? bitmap.text_size(i[0]).width/2 : bitmap.text_size(i[0]).width
				end
				if ph
					i[2] += height==0 ? 0 : height==1 ? bitmap.text_size(i[0]).height/2 : bitmap.text_size(i[0]).height
				else
					i[2] -= height==0 ? 0 : height==1 ? bitmap.text_size(i[0]).height/2 : bitmap.text_size(i[0]).height
				end
			}
			pbDrawTextPositions(bitmap,textpos)
		end
		# Clear
		def clearTxt(bitmap)
			@sprites["#{bitmap}"].bitmap.clear
		end
		#-------#
		# Mouse #
		#-------#
		# Position
		def posMouse
			mouse = Mouse::getMousePos
			mouse = [0,0] if !mouse
			return mouse # Return value x, y of mouse
		end
		# Click
		def clickedMouse?
			if Input.triggerex?(Input::RightMouseKey) || Input.triggerex?(Input::LeftMouseKey)
				@semouse += 1
				pbPlayDecisionSE if @semouse==1
				return true
			end
			@semouse = 0
			return false
		end
		# Check area
		def areaMouse?(arr)
			if !arr.is_a?(Array) || arr.size!=4
				p "Check area mouse"
				Kernel.exit!
			end
			x = arr[0]; y = arr[1]; w = arr[2]; h = arr[3]
			rect = [x,w+x,y,h+y]
			m = @oldm
			return true if m[0]>=rect[0] && m[0]<=rect[1] && m[1]>=rect[2] && m[1]<=rect[3]
			return false
		end
		# Check area (circle)
		def circleMouse?(arr)
			if !arr.is_a?(Array) || arr.size!=3
				p "Check area (circle) mouse"
				Kernel.exit!
			end
			x = arr[0]; y = arr[1]; r = arr[2]
			rect = [x, 2*r+x, y, 2*r+y]
			m = @oldm
			return false unless m[0]>=rect[0] && m[0]<=rect[1] && m[1]>=rect[2] && m[1]<=rect[3]
			2.times { |i| m[i] -= arr[i] if m[i] >= arr[i] }
			equation = (m[0] - r)**2 + (m[1] - r)**2
			return equation<=(r**2)
		end
		#------------------------------------------------------------------------------#
    # Dispose
    def dispose(id=nil)
      (id.nil?)? pbDisposeSpriteHash(@sprites) : pbDisposeSprite(@sprites,id)
    end
    # Update (just script)
    def update
      pbUpdateSpriteHash(@sprites)
    end
    # Update
    def update_ingame
      Graphics.update
      Input.update
      pbUpdateSpriteHash(@sprites)
    end
    # End
    def endScene
      # Dipose sprites
      self.dispose
      # Dispose viewport
      @viewport.dispose
    end

		# Play and check condition when play again
		def play
			if @nameai.size<=0 || !@nameai.is_a?(Array)
				p "Check NameAI, it is array and its size is greater than 0"
				Kernel.exit!
			end
			loop do
				# Update
				self.update_ingame
				# Play
				self.progress
				if @finish
					self.playerGet
					break
				end
			end
		end

		# Set card, play and wait
		def progress
			# Create scene
			self.create_scene
			# Set player, dealer, bet
			self.setPlayer
			# Bet coin before play
			self.bet
			# Coin
			self.drawChips
			# Distribute
			self.distribute
			# Players distribute cards
			self.playerPlay
			# Check information
			self.finish
		end

		# Player, AI and dealer distribute cards
		def playerPlay
			loop do
				# Update
				self.update_ingame
				# Action (AI)
				self.action
				# Draw signal
				self.drawSignal
				# Player bet
				self.playerBet
				break if @checkInfor
			end
		end

		# Finish, game over
		def finish
			# Draw rectangle "exit"
			self.drawExit
			# Draw rectangle "history"
			self.drawHistory
			# Draw information
			self.drawTextFinish
			loop do
				# Update
				self.update_ingame
				# Clear chips
				self.drawChips(true)
				# Draw information again, if anyone need it
				self.checkInforFinish
				break if @finish
			end
		end

		# Create scene
		def create_scene
			# Background
			addBackgroundPlane(@sprites,"bg","BlackJack/Background",@viewport) if !@sprites["bg"]
			# Draw message box
			3.times { |i|
				@sprites["left mess #{i}"] = BitmapWrapper.new(Graphics.width,Graphics.height) if !@sprites["left mess #{i}"]
				@sprites["mid mess #{i}"] = BitmapWrapper.new(Graphics.width,Graphics.height) if !@sprites["mid mess #{i}"]
				@sprites["right mess #{i}"] = BitmapWrapper.new(Graphics.width,Graphics.height) if !@sprites["right mess #{i}"]
			}
			@sprites["mess"] = AnimatedBitmap.new("Graphics/Pictures/BlackJack/Message Box").deanimate if !@sprites["mess"]
			@sprites["signal"] = AnimatedBitmap.new("Graphics/Pictures/BlackJack/Signal").deanimate if !@sprites["signal"]
			# Draw text in the bottom
			self.create_sprite_2("text",@viewport) if !@sprites["text"]
			@sprites["text"].z = 40
			self.clearTxt("text")
		end

		# Set position of player
		def setPlayer
			# Dealer
			self.setStruct(:dealer)
			@player[:dealer][:name] = "Dealer"
			@player[:dealer][:position][0] = self.posCardDealer[0]
			@player[:dealer][:position][1] = self.posCardDealer[1]
			# Player
			QuantityPlayer.times { |i|
				sym = self.str2sym("player #{i}")
				self.setStruct(sym)
				@player[sym][:position][0] = self.posAllBet[i][0]
				@player[sym][:position][1] = self.posAllBet[i][1]
			}
			bitmap = @sprites["text"].bitmap
			text = []
			string = "Choose your position"
			x = Graphics.width / 2 
			y = 337
			text << [string, x, y, 0, Color.new(255,255,255), Color.new(0,0,0)]
			drawTxt("text",text,nil,40,1,false,1)
			# Create 'choose text'
			self.create_sprite_2("choose text",@viewport) if !@sprites["choose text"]
			@sprites["choose text"].z = 1
			self.clearTxt("choose text")
			# Check position of player
			quantpos = []
			QuantityPlayer.times { |i| quantpos << false }
			pos = nil
			# Player chooses position
			loop do
				# Update
				self.update_ingame
				# Mouse
				# Delay mouse
				self.delayMouse(DelayMouse)
				pos = self.rectBet if @delay>DelayMouse
				text = []
				QuantityPlayer.times { |i|
					string = !pos.nil? && pos==i ? "Choose" : "#{i+1}"
					arr = self.posBetArea(i)
					x = arr[0] + arr[2] / 2
					y = arr[1] + arr[3] / 2
					text << [string, x, y, 0, Color.new(255,255,255), Color.new(0,0,0)]
				}
				drawTxt("choose text",text,nil,nil,1,false,1)
				if self.clickedMouse?
					if !pos.nil?
						sym = self.str2sym("player #{pos}")
						@player[sym][:name] = $Trainer.name
						@player[sym][:player] = true
						positioncard = self.posCardPlayer(pos)
						@player[sym][:position][0] = positioncard[0]
						@player[sym][:position][1] = positioncard[1]
						quantpos[pos] = true
						create_sprite("chose Rect","Chose",@viewport) if !@sprites["chose Rect"]
						set_xy_sprite("chose Rect",self.posAllBet[pos][0],self.posAllBet[pos][1])
						# Store in @mainplayer
						@mainplayer = {
							:position => pos,
							:symbol => sym
						}
						break
					end
				end
			end
			self.clearTxt("choose text")
			# Set player 'virtual'
			quantity = rand(QuantityPlayer)
			return if quantity <= 0
			num = nil
			quantity.times { |i|
				loop do
					num = rand(QuantityPlayer)
					break if !quantpos[num]
				end
				sym = self.str2sym("player #{num}")
				randname = rand(@nameai.size)
				@player[sym][:name] = @nameai[randname]
				@nameai.delete_at(randname) if @nameai.size>1
				positioncard = self.posCardPlayer(num)
				@player[sym][:position][0] = positioncard[0]
				@player[sym][:position][1] = positioncard[1]
				quantpos[num] = true
			}
		end

		# Bet
		def bet
			# Create bitmap All - in
			@sprites["coin"] = AnimatedBitmap.new("Graphics/Pictures/BlackJack/Chip").deanimate if !@sprites["coin"]
      if !@sprites["red chip"]
        create_sprite_2("red chip",@viewport)
        bm = @sprites["red chip"].bitmap
				r = 8
				(0..2*r).each { |i| 
					(0..2*r).each { |j|
						equation = (i-r)**2 + (j-r)**2
						next if equation>(r**2)
						bm.fill_rect( i, j, 1, 1, Color.new( 239, 37, 37) ) 
					} 
				}
        @sprites["red chip"].visible = false
			end
			if !@sprites["green chip"]
				create_sprite_2("green chip",@viewport)
				bm = @sprites["green chip"].bitmap
				r = 8
				(0..2*r).each { |i| 
					(0..2*r).each { |j|
						equation = (i-r)**2 + (j-r)**2
						next if equation>(r**2)
						bm.fill_rect( i, j, 1, 1, Color.new( 48, 213, 118) ) 
					} 
				}
				@sprites["green chip"].visible = false
      end
			# Draw text 'Bet'
			self.drawTxtBet
			# Draw coin
			self.drawNumBet
			# Value for draw
			draw = false
			newtext = nil
			# Check when you have surplus, bet = 0
			redraw = nil
			# Set for checking position
			circle = nil # Circle 'bet'
			rectok = false # Rectangle 'Ok'
			# Set for break
			ext = false
			# Player bets
			loop do
				# Update
				self.update_ingame
				break if ext
				if draw
					drawTxtBet(newtext)
					draw = false
					newtext = nil
				elsif !redraw.nil?
					redraw-=1
					if redraw<=0
						drawTxtBet(newtext)
						redraw = nil
					end
				end
				# Delay
				self.delayMouse(DelayMouse)
				# Click
				if @delay>DelayMouse
					circle = self.circleChip
					rectok = areaMouse?(RectOkBet) ? true : false
					self.drawNumBet(circle,rectok)
				end
				if self.clickedMouse?
					if !circle.nil?
						@player.each { |k,v|
							next if !v[:player]
							if circle!=5
								if (v[:bet] + ValueChips[circle]) > self.totalBet(true)
									newtext = "You can't bet anymore!!!"
									redraw  = 25
								else
									@player[k][:bet] += ValueChips[circle]
								end
							else
								@player[k][:bet] = self.totalBet(true)
							end
							draw = true
							break
						}
					elsif rectok
						if @player[@mainplayer[:symbol]][:bet]==0
							draw = true
							newtext = "You need to bet!!!"
							redraw = 25
						else
							@player[@mainplayer[:symbol]][:insurance][0] = @player[@mainplayer[:symbol]][:bet] / 2
							ext = true
						end
					end
				end
			end
			# AI bet
			@player.each { |k,v|
				next if v[:name].nil? || v[:player] || k==:dealer
				num = rand(6)
				(num+1).times {
					pos = rand(ValueChips.size)
					@player[k][:bet] += ValueChips[pos]
				}
				@player[k][:insurance][0] = v[:bet] / 2
			}
			# Dispose sprite
			self.dispose("red chip") if @sprites["red chip"]
			self.dispose("green chip") if @sprites["green chip"]
			self.dispose("rect ok") if @sprites["rect ok"]
			self.dispose("coin") if @sprites["coin"]
			# Clear text
			self.clearTxt("text")
			self.clearTxt("choose text")
		end

		# Draw text when bet
		def drawTxtBet(newtext=nil,showbet=true)
			self.clearTxt("text")
			return if !newtext && !showbet
			# Draw text
			text = []
			sym = @mainplayer[:symbol]
			if showbet
				string = "Bet: #{@player[sym][:bet]}"
				x = Graphics.width / 2
				y = 320
				text << [ string, x, y, 0, Color.new(255,255,255), Color.new(0,0,0) ]
			end
			if newtext
				# Draw bitmap
				bitmap = @sprites["text"].bitmap
				self.drawMess(bitmap,newtext)
				# Draw text
				x = Graphics.width / 2
				y = Graphics.height / 2
				text << [ newtext, x, y, 0, Color.new(0,0,0), Color.new(255,255,255) ]
			end
			self.drawTxt("text",text,nil,nil,1,false,1,false,false)
		end

		# Set sprite Message
		def setSizeMess(*arg)
			name, origin, rnew, rold = arg
			return if !rnew.is_a?(Array) || !rold.is_a?(Array) 
			return if rnew.size<4 || rold.size < 4 
			return if !@sprites["#{name}"] || !@sprites["#{origin}"]
			@sprites["#{name}"].stretch_blt(
				Rect.new(rnew[0],rnew[1],rnew[2],rnew[3]),
				@sprites["#{origin}"],
				Rect.new(rold[0],rold[1],rold[2],rold[3])
			)
		end

		# Draw blt Message
		def drawBltMess(*arg)
			bitmap, x, y, sprite, rnew = arg
			return if !rnew.is_a?(Array)
			return if rnew.size < 4
			bitmap.blt(x, y, sprite, Rect.new(rnew[0],rnew[1],rnew[2],rnew[3]))
		end

		# Draw box of message
		def drawMess(bitmap,text=nil,wmax=nil,hmax=nil)
			return if bitmap.nil?
			wmax = (Graphics.width - bitmap.text_size(text).width) / 2   if !wmax
			hmax = (Graphics.height - bitmap.text_size(text).height) / 2 if !hmax
			suml = summ = sumr = sumh = 0
			rnewl = rnewm = rnewr = []
			4.times {
				rnewl << 0
				rnewm << 0
				rnewr << 0
			}
			3.times { |i|
				# Left, Right
				wl = RectMessBox[i][0]
				hl = RectMessBox[i][1]
				suml += RectMessBox[i-1][1] if i!=0
				# Middle
				wm = RectMessBox[i+3][0]
				hm = RectMessBox[i+3][1]
				summ += RectMessBox[i+3-1][1] if i!=0
				# Set
				if i==1 # Middle
					# Left
					rnewl = [0, 0, wl*2, bitmap.text_size(text).height]
					# Middle
					rnewm = [0, 0, bitmap.text_size(text).width, bitmap.text_size(text).height]
					# Right
					rnewr = [0, 0, wl*2, bitmap.text_size(text).height]
				else # Left, Right
					# Left
					rnewl = [0, 0, wl*2, hl*2]
					# Middle
					rnewm = [0, 0, bitmap.text_size(text).width, hl*2]
					# Right
					rnewr = [0, 0, wl*2, hl*2]
				end
				# Left
				roldl = [0, suml, wl, hl]
				# Middle
				roldm = [wl, summ, wm, hm]
				# Right
				roldr = [wl+wm, suml, wl, hl]
				# Set sprite
				self.setSizeMess("left mess #{i}", "mess", rnewl, roldl)
				self.setSizeMess("mid mess #{i}", "mess", rnewm, roldm)
				self.setSizeMess("right mess #{i}", "mess", rnewr, roldr)
				# Draw bitmap
				sumh += (i==1 ? hl*2 : bitmap.text_size(text).height) if i!=0
				x = wmax - wl*2
				y = hmax + sumh
				self.drawBltMess(bitmap, x, y, @sprites["left mess #{i}"], rnewl)
				x += rnewl[2]
				self.drawBltMess(bitmap, x, y, @sprites["mid mess #{i}"], rnewm)
				x += rnewm[2]
				self.drawBltMess(bitmap, x, y, @sprites["right mess #{i}"], rnewr)
			}
		end

		# Draw number for bet (first time)
		def drawNumBet(chip=nil,accept=false)
			text = []
			bitmap = @sprites["choose text"].bitmap
			6.times { |i|
				pos = self.posChipChoose(i)
				string = i!=5 ? "#{ValueChips[i]}" : "All-in"
				text << [ string, pos[0], pos[1], 0, Color.new(255,255,255), Color.new(0,0,0) ]
			}
			drawTxt("choose text",text,nil,nil,1,false,1,true)
			# Draw chip
			r = posChipChoose(0)[2]
			d = 2*r
			6.times { |i|
				pos = self.posChipChoose(i)

				if i!=5
					rect = chip==i ? Rect.new(d*i, d, d, d) : Rect.new(d*i, 0, d, d)
					bitmap.blt( pos[0], pos[1], @sprites["coin"], rect )
				# All - in
				else
					bm = chip==i ? @sprites["green chip"].bitmap : @sprites["red chip"].bitmap
					bitmap.blt( pos[0], pos[1], bm, Rect.new(0, 0, d, d) )
				end
			}
			if !@sprites["rect ok"]
				self.create_sprite("rect ok","Ok",@viewport)
				w = @sprites["rect ok"].bitmap.width
				h = @sprites["rect ok"].bitmap.height
				x = RectOkBet[0]
				y = RectOkBet[1]
				RectOkBet.replace([x, y, w, h])
				set_xy_sprite("rect ok", x, y)
			end
			# 'Ok'
			text2 = []
			string = accept ? "Click" : "Ok"
			x = RectOkBet[0] + RectOkBet[2] / 2
			y = RectOkBet[1] + RectOkBet[3] / 2
			text2 << [ string, x, y, 0, Color.new(255,255,255), Color.new(0,0,0) ]
			self.drawTxt("choose text",text2,nil,nil,1,false,1,false,false)
		end

		# Progress distribute
		def distribute
			2.times {
				@player.each { |k,v|
					next if v[:name].nil?
					self.distributeCard(k, v[:status].size==0)
					self.drawCard(k, v[:card].size-1)
				}
			}
			# Check blackjack for player
			@player.each { |k,v|
				next if v[:name].nil?
				next if !self.winBlackJack(v[:card],v[:sum])
				@player[k][:blackjack] = true
				next if k==:dealer
				self.redrawCard(k)
			}
		end

		# Distribute card
		def distributeCard(name,status=false)
			random = rand(@card.size)
			@player[name][:card] << @card[random]
			@card.delete_at(random)
			@player[name][:status] << status
			@player[name][:sum] = self.calcSPerCard(@player[name][:card])
		end

		# Draw new card
		def drawCard(*arr)
			return if !arr.is_a?(Array) || arr.size < 2
			name, position = arr
			return if !name.is_a?(Symbol) && !name.is_a?(String)
			name = self.str2sym(name) if name.is_a?(String)
			namesprite = "#{name} #{position}"
			if @sprites["#{namesprite}"]
				self.dispose("#{namesprite}")
				@sprites["#{namesprite}"] = nil
			end
			create_sprite(namesprite, "Card", @viewport)
			# Position of this card
			card = @player[name][:position]
			# Open
			if @player[name][:status][position]
				w = self.posCardPlayer(0)[2]
				h = self.posCardPlayer(0)[3]
				set_src_wh_sprite(namesprite, w, h)
				x = @player[name][:card][position] % 4 * w
				y = @player[name][:card][position] / 4 * h
				set_src_xy_sprite(namesprite, x, y)
			# Closed
			else
				@sprites["#{namesprite}"].bitmap = Bitmap.new("Graphics/Pictures/BlackJack/Behind")
			end
			@sprites["#{namesprite}"].z = card[2] + (@player[name][:status][position] ?  position : -position) 
			set_xy_sprite(namesprite, card[0] + position*15, card[1])
		end

		# Draw card (Opened)
		def redrawCard(name)
			@player[name][:card].size.times { |i|
				@player[name][:status][i] = true
				self.drawCard(name, i)
			}
		end

		# Draw chips of player
		def drawChips(invisible=false)
			QuantityPlayer.times { |i|
				sym = self.str2sym("player #{i}")
				next if @player[sym][:name].nil?
				value = self.totalBet(false,@player[sym][:bet])
				value.size.times { |j|
					namesprite = "#{sym} pos #{j} chip"
					if value[j]<=0
						set_visible_sprite(namesprite) if @sprites["#{namesprite}"]
						next
					end
					create_sprite(namesprite, "Chip", @viewport) if !@sprites["#{namesprite}"]
					set_visible_sprite(namesprite,!invisible)
					area = self.posBetArea(i)
					chip = self.posChipChoose(j)
					r = chip[2]
					set_src_wh_sprite(namesprite, 2*r, 2*r)
					x = j * 2 * r
					y = 0
					set_src_xy_sprite(namesprite, x, y)
					x = area[0] + 4 + (2*r + 5) * (j==0 ? 0 : (j==1 || j==2)? 1 : 2)
					y = area[1] + (j==0 ? area[3]/2-r : (5 + (j%2==1 ? 0 : 3+2*r )) )
					set_xy_sprite(namesprite, x, y)
				}
			}
		end

		# Draw information of player or dealer
		def drawInfor(position,finish=false)
			return if position.nil?
			if !@sprites["bg infor"]
				self.create_sprite("bg infor","Information",@viewport)
				@sprites["bg infor"].z = 50
			end
			if !@sprites["text infor"]
				self.create_sprite_2("text infor", @viewport)
				@sprites["text infor"].z = 50
			end
			self.clearTxt("text infor")
			bitmap = @sprites["text infor"].bitmap
			# Draw card
			position = @mainplayer[:position] if position==-2
			sym = position==-1 ? :dealer : self.str2sym("player #{position}")
			# Check player card (not your)
			allopen = true if !allopen
			@player[sym][:card].size.times { |i|
				namesprite = "card infor #{i}"
				self.create_sprite(namesprite,"card",@viewport) if !@sprites[namesprite]
				# Open
				if (@player[sym][:status][i] && !@player[sym][:player]) || @player[sym][:player]
					w = self.posCardPlayer(0)[2]
					h = self.posCardPlayer(0)[3]
					self.set_src_wh_sprite(namesprite, w, h)
					x = @player[sym][:card][i] % 4 * w
					y = @player[sym][:card][i] / 4 * h
					self.set_src_xy_sprite(namesprite, x, y)
				# Closed
				else
					allopen = false
					@sprites["#{namesprite}"].bitmap = Bitmap.new("Graphics/Pictures/BlackJack/Behind")
				end
				x = (Graphics.width - self.posCardPlayer(0)[2] * @player[sym][:card].size) / (@player[sym][:card].size + 1) * (i+1) + self.posCardPlayer(0)[2] * i
				y = (Graphics.height - self.posCardPlayer(0)[3]) / 2
				self.set_xy_sprite(namesprite, x, y)
				@sprites["#{namesprite}"].z = 100
			}
			# Text
			text = []
			if sym!=:dealer
				string = "Bet: #{@player[sym][:bet]}"
				if finish
					if (@player[sym][:interest] - @player[sym][:deficit]) > 0
						string += "| Wow! Your interest is #{@player[sym][:interest] - @player[sym][:deficit]} coins"
					elsif (@player[sym][:deficit] - @player[sym][:interest]) > 0
						string += "| Hmm! Your deficit is #{@player[sym][:deficit] - @player[sym][:interest]} coins"
					else
						string += "| You don't have interest"
					end
				end
				x = Graphics.width / 2
				y = 100
				text << [ string, x, y, 0, Color.new(0,0,0), Color.new(255,255,255)  ]
				if @player[sym][:giveup]
					string = "You gave up! Try it next time!"
					text << [ string, x, y+25, 0, Color.new(0,0,0), Color.new(255,255,255)  ]
				end
			end
			string = "Name: #{@player[sym][:name]}"
			x = Graphics.width  / 2
			y = Graphics.height - 100
			text << [ string, x, y, 0, Color.new(0,0,0), Color.new(255,255,255) ]
			if allopen
				string = "Score: #{@player[sym][:sum]}"
				string += "| You got blackjack! Congratulation!" if @player[sym][:blackjack]
				x = Graphics.width  / 2
				y = Graphics.height - 65
				text << [ string, x, y, 0, Color.new(0,0,0), Color.new(255,255,255) ]
			end
			# Draw text
			drawTxt("text infor",text,nil,30,1,false,1,false)
			# Draw signal (bitmap)
			bitmap = @sprites["text infor"].bitmap
			x = 20
			y = 20
			w = RectSignal[0]
			h = RectSignal[1]
			bitmap.blt(x, y, @sprites["signal"], Rect.new(0, 0, w, h)) if @player[sym][:insurance][1]
			if @player[sym][:fivecards]
				y += 14 + 10 if @player[sym][:insurance][1]
				bitmap.blt(x, y, @sprites["signal"], Rect.new(w, 0, w, h))
			end
			if @player[sym][:lost]
				y += 14 + 10 if @player[sym][:insurance][1]
				y += 14 + 10 if @player[sym][:fivecards]
				bitmap.blt(x, y, @sprites["signal"], Rect.new(0, h, w*2, h))
			end
		end

		def clearInfor
			self.dispose("text infor") if @sprites["text infor"]
			self.dispose("bg infor") if @sprites["bg infor"]
			5.times { |i|
				next if !@sprites["card infor #{i}"]
				self.dispose("card infor #{i}")
			}
			self.dispose("card not open") if @sprites["card not open"]
		end

		# Click for showing information (when player playing)
		def clickInfor
			# Delay mouse (action)
			card = self.rectCard if @delay>DelayMouse
			# Click
			if self.clickedMouse?
				# Clear information if player seeing it
				if @information
					@information = false
					self.clearInfor
				else
					# Draw information
					if !card.nil?
						@information = true
						self.drawInfor(card)
					end
				end
			end
		end

		# Create rectangle for choosing
		def createRectforChoice
			return if @createdchoice
			# Array stores choice
			name1 = ["Hit", "Stand"]
			name2 = ["Double", "Give Up", "Insure"]
			if !@sprites["choice form"]
				self.create_sprite("choice form","Choice",@viewport)
				self.set_visible_sprite("choice form")
			end
			self.create_sprite_2("bitmap choice",@viewport) if !@sprites["bitmap choice"]
			bitmap = @sprites["bitmap choice"].bitmap
			self.clearTxt("bitmap choice")
			# Set width, height
			w = @sprites["choice form"].bitmap.width
			h = @sprites["choice form"].bitmap.height / 2
			# Set quantity
			quant = @sprites["choice form"].bitmap.width < 80 ? (name1.size + name2.size) : [name1.size + 1, name2.size + 1]
			# Draw rectangle
			storesrc = []
			q = (quant.is_a?(Array) ? quant[0] : quant)
			q.times { |i|
				dist = (Graphics.width - q * w) / (q + 1)
				x = dist + (dist + w) * i
				y = Graphics.height - (15 + h)
				src = [x, y, w, h]
				storesrc << src
				rect = Rect.new(0, 0, w, h)
				bitmap.blt( x, y, @sprites["choice form"].bitmap, rect )
			}
			# Store in @choice
			if quant.is_a?(Array)
				storesrc = []
				quant.size.times { |i|
					clone = []
					quant[i].times { |j|
						dist = (Graphics.width - quant[i] * w) / (quant[i] + 1)
						x = dist + (dist + w) * j
						y = Graphics.height - (15 + h)
						clone << [x, y, w, h]
					}
					storesrc << clone
				}
			end
			@choice = {
				:name1 => name1,
				:name2 => name2,
				:quantity => quant,
				:page => 0, # Store page if quant is Array, start at 0
				:rect => storesrc # Store rectangle of each value
			}
			@createdchoice = true
		end

		# Check mouse for rectangle 'Choice'
		def rectChoice
			q = @choice[:quantity].is_a?(Array) ? @choice[:quantity][@choice[:page]] : @choice[:quantity]
			q.times { |i| return i if areaMouse?(@choice[:quantity].is_a?(Array) ? @choice[:rect][@choice[:page]][i] : @choice[:rect][i]) }
			return nil
		end

		# Recreate rectangle for choosing (if graphics has width greater than or equal to 80)
		def recreateRectforChoice(chose=nil)
			bitmap = @sprites["bitmap choice"].bitmap
			self.clearTxt("bitmap choice")
			w = @sprites["choice form"].bitmap.width
			h = @sprites["choice form"].bitmap.height / 2
			q = @choice[:quantity].is_a?(Array) ? @choice[:quantity][@choice[:page]] : @choice[:quantity]
			q.times { |i|
				dist = (Graphics.width - q * w) / (q + 1)
				x = dist + (dist + w) * i
				y = Graphics.height - (15 + h)
				rect = Rect.new(0, (chose==i ? h : 0), w, h)
				bitmap.blt( x, y, @sprites["choice form"].bitmap, rect )
			}
		end

		# Draw choose for betting (player's turn)
		def drawBetPlaying
			q = @choice[:quantity].is_a?(Array) ? @choice[:quantity][@choice[:page]] : @choice[:quantity]
			string = @choice[:quantity].is_a?(Array) ? ( @choice[:page]==0 ? @choice[:name1] << "Next page" : @choice[:name2].unshift("Prev page") ) : @choice[:name1].concat(@choice[:name2])
			rect = @choice[:quantity].is_a?(Array) ? @choice[:rect][@choice[:page]] : @choice[:rect]
			text = []
			q.times { |i| text << [string[i], rect[i][0]+rect[i][2]/2, rect[i][1]+rect[i][3]/2, 0, Color.new(0,0,0), Color.new(255,255,255) ] }
			drawTxt("choose text",text,nil,nil,1,false,1)
			return if !@choice[:quantity].is_a?(Array)
			@choice[:name1].delete("Next page") if @choice[:name1].include?("Next page")
			@choice[:name2].delete("Prev page") if @choice[:name2].include?("Prev page")
		end

		# Clear choose
		def clearBetPlaying
			self.clearTxt("bitmap choice") if @sprites["bitmap choice"]
			self.clearTxt("text")
			self.clearTxt("choose text")
			self.dispose("choice form") if @sprites["choice form"]
		end

		# Draw card when player has 5 cards
		def drawFiveCcase(name)
			5.times { |i|
				@player[name][:status][i] = true
				self.drawCard(name, i)
			}
		end

		def playerBet
			@playertime = @turn==@mainplayer[:position]
			if !@playertime
				self.clearBetPlaying
				return
			end
			# Create rectangle for choice
			self.createRectforChoice
			# Draw name of box
			self.drawBetPlaying
			# Set value
			redraw = 0
			newtext = nil
			loop do
				# Update
				self.update_ingame
				# Break
				if !@playertime
					self.clearBetPlaying
					# Next turn
					@turn += 1
					break
				end
				# Delay mouse
				self.delayMouse(DelayMouse)
				# Click information
				self.clickInfor
				# Check lost all (value of cards is greater than or equal to 28)
				if self.calcSPerCard(@player[@mainplayer[:symbol]][:card])>=28
					@player[@mainplayer[:symbol]][:lost] = true
					# Pay coins
					self.payLostAll(@mainplayer[:symbol])
					# Open his cards
					self.dealerOpen(@mainplayer[:symbol])
					@playertime = false
				# Check five cards
				elsif @player[@mainplayer[:symbol]][:card].size==5
					self.drawFiveCcase(@mainplayer[:symbol])
					@player[@mainplayer[:symbol]][:fivecards] = true if self.winFiveCards(@player[@mainplayer[:symbol]][:card])
					@playertime = false
				end
				# Draw text
				if redraw && redraw>0
					redraw -= 1
					newtext = nil if redraw<=0
				end
				self.drawTxtBet(newtext,false)
				# Delay mouse (action)
				if @delay>DelayMouse
					rect = self.rectChoice
					# Redraw when choose
					self.recreateRectforChoice(rect)
				end
				# Click
				if self.clickedMouse? && !rect.nil?
					if @choice[:quantity].is_a?(Array)
						case @choice[:page]
						# Page 1
						when 0
							case rect
							# Hit
							when 0
								redraw = 25
								newtext = "You distributed card"
								self.distributeCard(@mainplayer[:symbol])
								self.drawCard(@mainplayer[:symbol], @player[@mainplayer[:symbol]][:card].size-1)
							# Stand
							when 1
								if @player[@mainplayer[:symbol]][:sum] < 16
									redraw = 25
									newtext = "Your cards need to have value greater than 15"
								else
									@playertime = false
								end
							# Next page
							else
								@choice[:page] += 1
								# Redraw
								self.drawBetPlaying
							end
						# Page 2
						when 1
							case rect
							# Double
							when 1
								redraw = 25
								newtext = self.double(@mainplayer[:symbol]) ? "You distributed card and chose double" : "You can't do it"
							# Give up
							when 2
								@player[@mainplayer[:symbol]][:giveup] = true
								@player[@mainplayer[:symbol]][:interest] += @player[@mainplayer[:symbol]][:bet] / 2
								@player[@mainplayer[:symbol]][:deficit] += @player[@mainplayer[:symbol]][:bet] / 2
								self.dealerOpen(@mainplayer[:symbol])
								@playertime = false
							# Insure
							when 3
								redraw = 25
								self.insure(@mainplayer[:symbol])
								newtext = @player[@mainplayer[:symbol]][:insurance][1] ? "You betted insurance" : "You can't do it"
							# Previous page
							else
								@choice[:page] -= 1
								# Redraw
								self.drawBetPlaying
							end
						end
					# When rectangle of choice (bitmap) is less than 80 pixel
					else
						case rect
						# Hit
						when 0
							redraw = 25
							newtext = "You distributed card"
							self.distributeCard(@mainplayer[:symbol])
							self.drawCard(@mainplayer[:symbol], @player[@mainplayer[:symbol]][:card].size-1)
						# Stand
						when 1
							if @player[@mainplayer[:symbol]][:sum] < 16
								redraw = 25
								newtext = "Your cards need to have value greater than 15"
							else
								@playertime = false
							end
						# Double
						when 2
							redraw = 25
							newtext = self.double(@mainplayer[:symbol]) ? "You distributed card and chose double" : "You can't do it"
						# Give up
						when 3
							@player[@mainplayer[:symbol]][:giveup] = true
							@player[@mainplayer[:symbol]][:interest] += @player[@mainplayer[:symbol]][:bet] / 2
							@player[@mainplayer[:symbol]][:deficit] += @player[@mainplayer[:symbol]][:bet] / 2
							self.dealerOpen(@mainplayer[:symbol])
							@playertime = false
						# Insure
						when 4
							redraw = 25
							self.insure(@mainplayer[:symbol])
							newtext = @player[@mainplayer[:symbol]][:insurance][1] ? "You betted insurance" : "You can't do it"
						end
					end
				end
			end
		end

		# Draw signal for player (insurance, lost all, five cards)
		def drawSignal
			self.create_sprite_2("icon bitmap",@viewport) if !@sprites["icon bitmap"]
			self.clearTxt("icon bitmap")
			bitmap = @sprites["icon bitmap"].bitmap
			QuantityPlayer.times { |i|
				sym = self.str2sym("player #{i}")
				next if @player[sym][:name].nil?
				pos = self.posBetArea(i)
				x = pos[0]
				y = pos[1] + pos[3]
				w = RectSignal[0]
				h = RectSignal[1]
				bitmap.blt(x, y, @sprites["signal"], Rect.new(0, 0, w, h)) if @player[sym][:insurance][1]
				bitmap.blt(x+w, y, @sprites["signal"], Rect.new(w, 0, w, h)) if @player[sym][:fivecards]
				bitmap.blt(x, y+h, @sprites["signal"], Rect.new(0, h, w*2, h)) if @player[sym][:lost]
			}
		end

		# Draw infor when player need it
		def checkInforFinish
			# Delay mouse
			self.delayMouse(DelayMouse)
			# Delay mouse (action)
			if @delay>DelayMouse
				card = self.rectCard
				chose = self.rectExit
				history = self.rectHistory
				# Redraw rectangle exit
				self.drawExit(chose)
				# Redraw rectangle history
				self.drawHistory(history)
			end
			# Click
			if self.clickedMouse?
				# Clear information if player seeing it
				if @information
					@information = false
					self.clearInfor
				else
					# Draw information
					if !card.nil?
						@information = true
						self.drawInfor(card,true)
					elsif chose
						@finish = true
					elsif history
						self.showHistory
					end
				end
			end
		end

		# Draw text before finish
		def drawTextFinish
			self.clearTxt("text")
			bitmap = @sprites["text"].bitmap
			text = []
			string = "Click cards for more information"
			x = Graphics.width / 2
			y = (Graphics.height - 310) / 2 + 310
			text << [string, x, y, 0, Color.new(0,0,0), Color.new(255,255,255)]
			string = "Exit"
			x = RectExit[0] + @sprites["finish rect"].bitmap.width / 2
			y = RectExit[1] + @sprites["finish rect"].bitmap.height / 4
			text << [string, x, y, 0, Color.new(0,0,0), Color.new(255,255,255)]
			string = "History"
			x = (Graphics.width - @sprites["history rect"].bitmap.width) + @sprites["history rect"].bitmap.width / 2
			y = 0 + @sprites["history rect"].bitmap.height / 4
			text << [string, x, y, 0, Color.new(0,0,0), Color.new(255,255,255)]
			self.drawTxt("text",text,nil,nil,1,false,1)
		end

		# Draw exit rectangle for this game
		def drawExit(chose=false)
			if @sprites["finish rect"]
				h = @sprites["finish rect"].bitmap.height / 2
				self.set_src_xy_sprite("finish rect", 0, (chose ? h : 0))
				return
			end
			self.create_sprite("finish rect","Choice",@viewport)
			w = @sprites["finish rect"].bitmap.width
			h = @sprites["finish rect"].bitmap.height / 2
			self.set_src_wh_sprite("finish rect", w, h)
			self.set_src_xy_sprite("finish rect", 0, (chose ? h : 0))
			self.set_xy_sprite("finish rect", RectExit[0], RectExit[1])
		end

		# Rectangle exit (mouse)
		def rectExit
			w = @sprites["finish rect"].bitmap.width
			h = @sprites["finish rect"].bitmap.height / 2
			rect = [RectExit[0], RectExit[1], w, h]
			return true if self.areaMouse?(rect)
			return false
		end

		# Draw history rectangle for this game
		def drawHistory(chose=false)
			if @sprites["history rect"]
				h = @sprites["history rect"].bitmap.height / 2
				self.set_src_xy_sprite("history rect", 0, (chose ? h : 0))
				return
			end
			self.create_sprite("history rect","Choice",@viewport)
			w = @sprites["history rect"].bitmap.width
			h = @sprites["history rect"].bitmap.height / 2
			self.set_src_wh_sprite("history rect", w, h)
			self.set_src_xy_sprite("history rect", 0, (chose ? h : 0))
			x = Graphics.width - w
			y = 0
			self.set_xy_sprite("history rect", x, y)
		end

		# Rectangle history (mouse)
		def rectHistory
			w = @sprites["history rect"].bitmap.width
			h = @sprites["history rect"].bitmap.height / 2
			x = Graphics.width - w
			y = 0
			rect = [x, 0, w, h]
			return true if self.areaMouse?(rect)
			return false
		end

		# Show text in history
		def showHistory
			# Create scene
			self.create_sprite("bg history","History",@viewport)
			@sprites["bg history"].z = 50
			# Draw arrow
			self.arrowHistory
			loop do
				# Update
				self.update_ingame
				# Draw text
				self.textHistory
				# Set visible arrow
				max  = @history.size
				up   = max > self.maxTextHistory && @poshistory > 0
				down = max > self.maxTextHistory && @poshistory < max-self.maxTextHistory
				# Delay mouse
				self.delayMouse(DelayMouse)
				if @delay>DelayMouse
					arrow = self.rectArrow
					arrow = nil if (arrow==0 && !up) || (arrow==1 && !down)
					self.showArrow(up, down, arrow)
				end
				# Click
				if self.clickedMouse?
					case arrow
					when 0
						@poshistory -= 1
						@poshistory  = 0 if @poshistory<0
					when 1
						@poshistory += 1
						@poshistory  = max-1 if @poshistory>=max
					when nil
						self.clearHistory
						@poshistory = 0
						break
					end
				end
			end
		end

		# Max number of lines
		def maxTextHistory; return 6; end

		# Draw arrow
		def arrowHistory
			2.times { |i|
				if !@sprites["arrow his #{i}"]
					self.create_sprite("arrow his #{i}","History Arrow",@viewport)
					w = @sprites["arrow his #{i}"].bitmap.width / 2
					h = @sprites["arrow his #{i}"].bitmap.height / 2
					self.set_src_wh_sprite("arrow his #{i}", w, h)
					self.set_src_xy_sprite("arrow his #{i}", w*i, 0)
					x = RectArrow[i][0]
					y = RectArrow[i][1]	
					self.set_xy_sprite("arrow his #{i}", x, y)
					self.set_visible_sprite("arrow his #{i}")
					@sprites["arrow his #{i}"].z = 50
				end
			}
		end

		def showArrow(*arr)
			return if !arr.is_a?(Array) || arr.size < 2
			2.times { |i|
				self.set_visible_sprite("arrow his #{i}", arr[i])
				if @sprites["arrow his #{i}"].visible
					x = @sprites["arrow his #{i}"].bitmap.width / 2 * i
					y = arr[2] && arr[2]==i ? @sprites["arrow his #{i}"].bitmap.height / 2 : 0
					self.set_src_xy_sprite("arrow his #{i}", x, y)
				end
			}
		end

		def rectArrow
			rect = []
			2.times { |i|
				x = RectArrow[i][0]
				y = RectArrow[i][1]
				w = @sprites["arrow his #{i}"].bitmap.width / 2
				h = @sprites["arrow his #{i}"].bitmap.height / 2
				rect << [x, y, w, h]
			}
			2.times { |i| return i if self.areaMouse?(rect[i])}
			return nil
		end

		# Draw text in history
		def textHistory
			if !@sprites["bitmap history"]
				self.create_sprite_2("bitmap history",@viewport)
				@sprites["bitmap history"].z = 50
			end
			self.clearTxt("bitmap history")
			max = @history.size
			text = []
			pos = (max > 0 && max < self.maxTextHistory)? 0 : (@poshistory >= max-self.maxTextHistory)? max-self.maxTextHistory : @poshistory
			endnum = (max > 0 && max < self.maxTextHistory)? max : self.maxTextHistory
			(0...endnum).each { |i|
				string = "#{@history[pos+i]}"
				x      = 75
				y      = 106 + 30*i
				text << [string, x, y, 0, Color.new(0,0,0), Color.new(192,192,192)]
			}
			self.drawTxt("bitmap history",text)
		end

		# Clear
		def clearHistory
			self.dispose("bg history") if @sprites["bg history"]
			self.dispose("bitmap history") if @sprites["bitmap history"]
			2.times { |i| self.dispose("arrow his #{i}") if @sprites["arrow his #{i}"] }
		end

		# Double
		def double(name)
			num = @player[name][:bet]
			return false if name==@mainplayer[:symbol] && ($PokemonGlobal.coins<=0 || $PokemonGlobal.coins-num<num)
			@player[name][:bet] += num
			self.distributeCard(name)
			self.drawCard(name, @player[name][:card].size-1)
			# Draw chips
			self.drawChips
			return true
		end

		# Insure
		def insure(name)
			return if (@player[:dealer][:card][0] / 4 != 0) || (name == :dealer)
			return if @player[name][:insurance][1]
			num = @player[name][:insurance][0] + @player[name][:bet]
			return if name==@mainplayer[:symbol] && ($PokemonGlobal.coins<=0 || $PokemonGlobal.coins<num)
			@player[name][:insurance][1] = true
			# Draw chips
			self.drawChips
			# Draw signal
			self.drawSignal
		end

		# AI
		def action
			# Dealer
			if @turn >= QuantityPlayer
				player = @player[:dealer]
				player[:status].size.times { |i|
					@player[:dealer][:status][i] = true
					self.drawCard(:dealer, i)
				}
				# Lost all
				if player[:sum] >= 28
					@player.each { |k,v|
						next if k==:dealer
						self.dealerOpen(k) # Open all players
						@player[k][:interest] += v[:bet]
					}
					@checkInfor = true # Show informations before finish
					return
				# Win Black jack (insurance)
				elsif player[:card].size == 2 && self.winBlackJack(player[:card],player[:sum])
					@player[:dealer][:blackjack] = true
					# Open cards of players
					@player.each { |k,v|
						next if k==:dealer || v[:name].nil?
						self.dealerOpen(k)
					}
				# Five cards
				elsif player[:card].size == 5 && self.winFiveCards(player[:card])
					@player[:dealer][:fivecards] = true
					# Open cards of players
					@player.each { |k,v|
						next if k==:dealer || v[:name].nil?
						self.dealerOpen(k)
					}
				end
				# Normal
				if player[:sum] < 15 && !player[:fivecards]
					self.distributeCard(:dealer, true)
					self.drawCard(:dealer, player[:card].size-1)
				else
					notopen = false if !notopen
					order = -1 if !order
					needopen = 0 if !needopen
					# Check cards
					@player.each { |k,v|
						next if k==:dealer
						order += 1
						if v[:name].nil? && !@opened[order]
							@opened[order] = true
							next
						end
						# Check if give up
						if v[:giveup] && !@opened[order]
							@history << ["#{v[:name]} gave up!"]
							@opened[order] = true
							next
						# Next if player lost
						elsif v[:lost] && !@opened[order]
							@history << ["#{v[:name]} paid for his mistake!"]
							@opened[order] = true
							next
						end
						# Open card
						if !player[:fivecards] && !player[:blackjack]
							next if @opened[order]
							case player[:sum]
							when 15
								# Open card
								if v[:card].size == 4
									random = rand(1000)
									if random < 500
										self.dealerOpen(k)
										@opened[order] = true
									end
								end
							when 16
								if v[:card].size > 2 && v[:card].size < 5
									random = rand(1000)
									if random < 600
										self.dealerOpen(k)
										@opened[order] = true
									end
								end
							when 17
								random = rand(1000)
								if (random < 500 && v[:card].size == 2) || (random < 600 && v[:card].size > 2 && v[:card].size < 5)
									self.dealerOpen(k)
									@opened[order] = true
								end
							when 18
								random = rand(1000)
								if random < 900
									self.dealerOpen(k)
									@opened[order] = true
								end
							else
								self.dealerOpen(k)
								@opened[order] = true
							end
							@opened[order] = true if v[:blackjack] || v[:fivecards]
							next if !@opened[order]
						end
						next if v[:name].nil?
						# Check insurance
						case self.blackjackDealer(k)
						when "nil"
							p "Error: check blackjack"
							Kernel.exit!
						when true
							@player[k][:interest] += v[:insurance][0]
						end
						# Store in history
						if v[:blackjack] || v[:fivecards]
							@history << ["#{v[:name]} has five cards"] if v[:fivecards]
							@history << ["#{v[:name]} has blackjack"] if v[:blackjack]
						else
							@history << ["Dealer opened #{v[:name]}"]
							@history << ["Dealer: #{player[:sum]}"]
							@history << ["Player: #{v[:sum]}"]
						end
						# Compare values
						case self.compareValue(k)
						when "nil"
							p "Error: compare"
							Kernel.exit!
						# Five cards, blackjack
						when "greater five", "greater blackjack"
							@player[k][:deficit] += v[:bet] * 2
							# Store in history
							@history << ["With his five cards...Dealer won"] if self.compareValue(k)=="greater five"
							@history << ["With his blackjack...Dealer won"] if self.compareValue(k)=="greater blackjack"
						when "less five", "less blackjack"
							@player[k][:interest] += v[:bet] * 2
							# Store in history
							@history << ["With his five cards...Player won"] if self.compareValue(k)=="less five"
							@history << ["With his blackjack...Player won"] if self.compareValue(k)=="less blackjack"
						# Normal case
						when "greater"
							@player[k][:deficit] += v[:bet]
							# Store in history
							@history << ["With his numbers...Dealer won"]
						when "less"
							@player[k][:interest] += v[:bet]
							# Store in history
							@history << ["With his numbers...Player won"]
						when "draw" then @history << ["I can't believe...It's draw"] # Store in history
						end
						@opened[order] = true if player[:fivecards] || player[:blackjack]
					}
					if !@opened.include?(false)
						@checkInfor = true # Show informations before finish
						return
					end
					# Continue distribute
					random = rand(1000)
					return unless (random < 500 && player[:sum] < 18) || (random < 50 && player[:sum] == 18)
					self.distributeCard(:dealer, true)
					self.drawCard(:dealer, player[:card].size-1)
				end
				return
			end
			# Player
			name = self.str2sym("player #{@turn}")
			if @player[name][:name].nil? || @player[name][:blackjack]
				@turn += 1
				return
			end
			if @player[name][:player]
				@playertime = true
				return
			end
			player = @player[name]
			case player[:card].size
			when 5 # Player has 5 cards
				self.drawFiveCcase(name)
				@player[name][:fivecards] = true if self.winFiveCards(player[:card])
				@turn += 1
				return
			when 2 # Insurance
				if (@player[:dealer][:card][0] / 4) == 0
					random = rand(1000)
					self.insure(name) if random<300
				end
			end
			# Hit or stand or give up or lost with decision of AI
			case self.canDistribute(player[:sum],player[:card].size==4)
			when "hit"
				self.distributeCard(name)
				self.drawCard(name, player[:card].size-1)
			# Player hits and bets double coin
			when "double"
				self.double(name)
			# Next turn, player stay here
			when "stand" then @turn += 1
			# Next turn, player give up
			when "give up"
				@player[name][:giveup] = true
				@player[name][:interest] += @player[name][:bet] / 2
				@player[name][:deficit] += @player[name][:bet] / 2
				self.dealerOpen(name)
				@turn += 1
			# Lost, player pays all players (include dealer)
			when "lost all"
				@player[name][:lost] = true
				self.payLostAll(name) # Pay coins
				self.dealerOpen(name) # open his cards
				@turn += 1
			end
		end

		# Return player choice
		def canDistribute(sum,fourcard=false)
			if sum < 16
				return "hit" # 'Force' hit
			elsif sum >= 28
				return "lost all" # Player must pay coin to all players with their chips value (except dealer, you must to pay your coin)
			end
			hadcard = 0
			case sum
			when 16
				card = [0,1,2,3,4]
				card.each { |i| hadcard += 1 if self.cardOpened(i) }
				per  = 1.0 / (card.size * 4.0) * 100
				rate = hadcard * per
				random = rand(1000)
				if (random<500 && rate < 30) || (fourcard && rate<4*per)
					return "double"
				elsif (random<600 && rate < 50) || (fourcard && rate<4*2*per)
					return "hit"
				else
					return "stand"
				end
			when 17
				card = [0,1,2,3]
				card.each { |i| hadcard += 1 if self.cardOpened(i) }
				per  = 1.0 / (card.size * 4.0) * 100
				rate = hadcard * per
				random = rand(1000)
				if (random<200 && rate < 20) || (fourcard && rate<per && random<100)
					return "double"
				elsif (random<400 && rate < 30) || (fourcard && rate<4*per && random<200)
					return "hit"
				else
					return "stand"
				end
			when 18
				card = [0,1,2]
				card.each { |i| hadcard += 1 if self.cardOpened(i) }
				per  = 1.0 / (card.size * 4.0) * 100
				rate = hadcard * per
				random = rand(1000)
				if (random<100 && rate<=per) || (fourcard && rate<2*per && random<30)
					return "hit"
				else
					return "stand"
				end
			when 19
				card = [0,1]
				card.each { |i| hadcard += 1 if self.cardOpened(i) }
				per  = 1.0 / (card.size * 4.0) * 100
				rate = hadcard * per
				random = rand(1000)
				if (random<50 && rate<per) || (fourcard && rate<per && random<10)
					return "hit"
				else
					return "stand"
				end
			when 20
				hadcard += 1 if self.cardOpened(0)
				per  = 1.0 / 4.0 * 100
				rate = hadcard * per
				random = rand(1000)
				if fourcard
					return "stand"
				elsif (random<10 && rate<per)
					return "hit"
				else
					return "stand"
				end
			when 21
				return "stand"
			else
				return "give up"
			end
		end

		# Check card opened, AI decide hit or stand
		def cardOpened(num=nil)
			return false if num.nil?
			card = []
			@player.each { |k,v|
				next if v[:name].nil?
				card << (v[:card][0] / 4)
			}
			return true if card.include?(num)
			return false
		end

		# Dealer opens cards of player
		def dealerOpen(name)
			return if name.nil?
			player = @player[name]
			return if name==:dealer || player[:name].nil?
			@player[name][:status].size.times { |i| 
				@player[name][:status][i] = true
				self.drawCard(name, i)
			}
		end

		# Compare value
		def compareValue(name)
			return "nil" if name.nil?
			player = @player[name]
			return "nil" if name==:dealer || player[:name].nil?
			dealer = @player[:dealer]
			# Dealer
			# Five cards
			if dealer[:fivecards]
				if dealer[:sum] <= 21 && ( (player[:fivecards] && player[:sum] < 21 && dealer[:sum] > player[:sum]) || !player[:fivecards] )
					return "greater five"
				elsif dealer[:sum] == player[:sum] || (player[:sum] > 21 && dealer[:sum] > 21)
					return "draw"
				elsif player[:fivecards] && player[:sum] <= 21 && ((player[:sum] > dealer[:sum]) || dealer[:sum] > 21)
					return "less five"
				end
				return "less"
			# Blackjack
			elsif dealer[:blackjack]
				return "draw" if player[:blackjack]
				return "less five" if player[:fivecards] && player[:sum] <= 21
				return "greater blackjack"
			# Normal
			elsif dealer[:sum] == player[:sum]
				return "draw"
			elsif dealer[:sum] <= 21
				if player[:fivecards] && player[:sum] <= 21
					return "less five"
				elsif player[:blackjack]
					return "less blackjack"
				elsif (dealer[:sum] > player[:sum] && player[:sum] < 21) || player[:sum] > 21
					return "greater"
				end
			elsif dealer[:sum] > 21
				player[:sum] > 21 ? (return "draw") : (return "less")
			end
			return "less"
		end

		# Check 
		def blackjackDealer(name)
			return "nil" if name.nil?
			player = @player[name]
			dealer = @player[:dealer]
			return true if player[:insurance][1] && dealer[:blackjack]
			return false
		end

		# Player get coins after playing
		def playerGet
			player = @player[@mainplayer[:symbol]]
			$PokemonGlobal.coins += player[:interest] - player[:deficit]
			$PokemonGlobal.coins -= player[:bet] / 2 if player[:giveup]
		end

		# Win (Blackjack)
		def winBlackJack(cards,sum)
			return if cards.size!=2
			ace = 0 if !ace
			cards.each { |j| ace += 1 if j/4 == 0 }
			return true if (ace==1 && sum==21) || ace==2
			return false
		end

		# Win (five cards)
		def winFiveCards(cards)
			return false if !cards.is_a?(Array)
			return false if cards.size < 5
			return false if self.calcSPerCard(cards) > 21
			return true
		end

		# Lose (lost all)
		def payLostAll(name)
			money = 0
			@player.each { |k,v|
				next if k==:dealer
				if k==name
					money += v[:bet]
					next
				end
				money += v[:bet]
				@player[k][:interest] += v[:bet]
			}
			@player[name][:deficit] += money
		end

		# Set name, position of card, position of player, number of cards, cards, bet
		def setStruct(name)
			@player[name] = {
				:name => nil, # Set name of player
				:position => [nil,nil,5], # Set position of card (x, y, z) - z = 5 or higher
				:player => false, # Set position of player
				:card => [], # Cards
				:status => [], # Status of card (open or not)
				:sum => 0, # Number of card (value)
				:bet => 0, # Coin
				# For checking coin when finish (interest or deficit)
				:interest => 0,
				:deficit  => 0,
				:blackjack => false, # Check blackjack
				:fivecards => false, # Check player reaches 5 cards (5 cards <= 21 points), it's bigger than black jack
				:insurance => [0,false], # Bet (insurance)
				:giveup => false, # Player give up (don't want to play)
				:lost => false # Check if player has score greater than or equal to 28, he lose and pays all players (include dealer) for his mistake
			}
		end
		# Set symbol, string
		def sym2str(sym)
			return sym.to_s
		end
		def str2sym(str)
			return str.to_sym
		end
		# Set total chips, player can bet
		def totalBet(sum=false,coins=nil)
			total = 0
			coins = $PokemonGlobal.coins if coins.nil?
			# Value each chip
			value = []
			# ValueChips[0], ValueChips[1], etc
			ValueChips.size.times { |i| value << 0 }
			ValueChips.size.times { |i|
				j = ValueChips.size-(i+1)
				if coins / ValueChips[j] > 0
					num = coins / ValueChips[j] * ValueChips[j]
					total += num
					value[j] = coins / ValueChips[j]
					coins -= num
				end
			}
			return total if sum
			return value
		end
		# Calculate scores
		def calcSPerCard(values)
			if !values.is_a?(Array)
				p "Check value for calculating. It must be Array."
				Kernel.exit!
			end
			result   = 0 if !result
			countace = 0 if !countace
			values.each { |value|
				case value / 4
				# Ace
				when 0
					countace += 1
					result   += 11
				# J, Q, K
				when 10, 11, 12; result += 10
				# 2, 3, 4, 5, 6, 7, 8, 9, 10
				else; result += value / 4 + 1
				end
			}
			return 21 if countace==2 && values.size==2
			result -= countace * 10 if result > 21
			return result
		end

	end
	# Def
	def self.play
		value = ValueChips
		value.sort!
		if hasConst?(PBItems,:COINCASE) && !$PokemonBag.pbHasItem?(:COINCASE)
			pbMessage(_INTL("It's a BlackJack Game."))
			return
		elsif $PokemonGlobal.coins<=0
			pbMessage(_INTL("You don't have any Coins to play!"))
			return
		elsif $PokemonGlobal.coins<value[0]
			pbMessage(_INTL("You don't have enough Coins to play!"))
			return
		end
		pbMessage(_INTL("It's a BlackJack Game."))
		if !pbConfirmMessage(_INTL("Do you want to play it?"))
			pbMessage(_INTL("See ya!!!"))
			return
		end
		loop do
			pbFadeOutIn {
				p = Play.new
				p.play
				p.endScene
			}
			if pbConfirmMessage(_INTL("Do you want to continue?"))
				# Check condition for playing
				if $PokemonGlobal.coins<=0
					pbMessage(_INTL("You don't have any Coins to play!"))
					break
				end
			else
				break
			end
		end
	end
end