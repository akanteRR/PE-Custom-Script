def pbSetUpSystem(num=0)
  begin
    trainer       = nil
    framecount    = 0
    game_system   = nil
    pokemonSystem = nil
    havedata = false
    # Count savefile
    dir = DIR_SAVE_GAME; filename = FILENAME_SAVE_GAME
    savefile = "#{dir}/#{filename}#{num+1}.rxdata"
    File.open(savefile) { |f|
      trainer       = Marshal.load(f)
      framecount    = Marshal.load(f)
      game_system   = Marshal.load(f)
      pokemonSystem = Marshal.load(f)
    }
    raise "Corrupted file" if !trainer.is_a?(PokeBattle_Trainer)
    raise "Corrupted file" if !framecount.is_a?(Numeric)
    raise "Corrupted file" if !game_system.is_a?(Game_System)
    raise "Corrupted file" if !pokemonSystem.is_a?(PokemonSystem)
    havedata = true
  rescue
    game_system   = Game_System.new
    pokemonSystem = PokemonSystem.new
  end
  if !$INEDITOR
    $game_system   = game_system
    $PokemonSystem = pokemonSystem
    pbSetResizeFactor([$PokemonSystem.screensize,3].min)
  else
    pbSetResizeFactor(1.0)
  end
  # Load constants
  begin
    consts = pbSafeLoad("Data/Constants.rxdata")
    consts = [] if !consts
  rescue
    consts = []
  end
  for script in consts
    next if !script
    eval(Zlib::Inflate.inflate(script[2]),nil,script[1])
  end
  if LANGUAGES.length>=2
    pokemonSystem.language = pbChooseLanguage if !havedata
    pbLoadMessages("Data/"+LANGUAGES[pokemonSystem.language][1])
  end
end