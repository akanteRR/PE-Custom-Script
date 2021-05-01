#----------------------------------------#
# Load                                   #
#----------------------------------------#
class PokemonLoadScreen
  def initialize(scene)
    @scene = scene
  end

	def pbStartLoadScreen
    commands = []
    cmd_continue     = -1
    cmd_new_game     = -1
    cmd_options      = -1
    cmd_debug        = -1
    cmd_quit         = -1
    show_continue    = FileSave.count>0
    commands[cmd_continue = commands.length] = _INTL('Load Game') if show_continue
    commands[cmd_new_game = commands.length]  = _INTL('New Game')
    commands[cmd_options = commands.length]   = _INTL('Options')
    commands[cmd_debug = commands.length]     = _INTL('Debug') if $DEBUG
    commands[cmd_quit = commands.length]      = _INTL('Quit Game')
		@scene.pbStartScene(commands, false, nil, 0, 0)
		@scene.pbStartScene2
    loop do
      command = @scene.pbChoose(commands)
      pbPlayDecisionSE if command != cmd_quit
      case command
      when cmd_continue
				pbFadeOutIn {
					file = ScreenChooseFileSave.new(FileSave.count)
					file.movePanel(1)
					@scene.pbEndScene if !file.staymenu
					file.endScene
					return if !file.staymenu
				}
      when cmd_new_game
        @scene.pbEndScene
        Game.start_new
        return
			when cmd_options
        pbFadeOutIn do
          scene = PokemonOption_Scene.new
          screen = PokemonOptionScreen.new(scene)
          screen.pbStartScreen(true)
        end
      when cmd_debug
        pbFadeOutIn { pbDebugMenu(false) }
      when cmd_quit
        pbPlayCloseMenuSE
        @scene.pbEndScene
        $scene = nil
        return
      else
        pbPlayBuzzerSE
      end
    end
  end
end