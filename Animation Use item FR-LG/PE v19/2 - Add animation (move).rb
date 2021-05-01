#--------------------------------------------------------------------------------------------------
# Don't touch or modify it
#--------------------------------------------------------------------------------------------------
# TM/HM
#--------------------------------------------------------------------------------------------------
def pbLearnMove(pkmn,move,ignoreifknown=false,bymachine=false,item=nil,&block)
  return false if !pkmn
  move = GameData::Move.get(move).id
  if pkmn.egg? && !$DEBUG
    pbMessage(_INTL("Eggs can't be taught any moves."),&block)
    return false
  end
  if pkmn.shadowPokemon?
    pbMessage(_INTL("Shadow Pokémon can't be taught any moves."),&block)
    return false
  end
  pkmnname = pkmn.name
  movename = GameData::Move.get(move).name
  if pkmn.hasMove?(move)
    pbMessage(_INTL("{1} already knows {2}.",pkmnname,movename),&block) if !ignoreifknown
    return false
  end
  if pkmn.numMoves<Pokemon::MAX_MOVES
    pkmn.learn_move(move)
		bymachine && !item.nil? ? UseAnimations.new.animationTMHM(item,pkmn,pkmnname,nil,movename,false,&block) : pbMessage(_INTL("\\se[]{1} learned {2}!\\se[Pkmn move learnt]",pkmnname,movename),&block)
    return true
  end
  loop do
    pbMessage(_INTL("{1} wants to learn {2}, but it already knows four moves.\1",pkmnname,movename),&block) if !bymachine
    pbMessage(_INTL("Please choose a move that will be replaced with {1}.",movename),&block)
    forgetmove = pbForgetMove(pkmn,move)
    if forgetmove>=0
      oldmovename = pkmn.moves[forgetmove].name
      oldmovepp   = pkmn.moves[forgetmove].pp
      pkmn.moves[forgetmove] = Pokemon::Move.new(move)   # Replaces current/total PP
      if bymachine && Settings::TAUGHT_MACHINES_KEEP_OLD_PP
        pkmn.moves[forgetmove].pp = [oldmovepp,pkmn.moves[forgetmove].total_pp].min
      end
			if bymachine && !item.nil?
        UseAnimations.new.animationTMHM(item,pkmn,pkmnname,oldmovename,movename,true,&block)
      else
				pbMessage(_INTL("1,\\wt[16] 2, and\\wt[16]...\\wt[16] ...\\wt[16] ... Ta-da!\\se[Battle ball drop]\1"),&block)
				pbMessage(_INTL("{1} forgot how to use {2}.\\nAnd...\1",pkmnname,oldmovename),&block)
				pbMessage(_INTL("\\se[]{1} learned {2}!\\se[Pkmn move learnt]",pkmnname,movename),&block)
			end
      pkmn.changeHappiness("machine") if bymachine
      return true
    elsif pbConfirmMessage(_INTL("Give up on learning {1}?",movename),&block)
      pbMessage(_INTL("{1} did not learn {2}.",pkmnname,movename),&block)
      return false
    end
  end
end

#-------------------------------------------------------------------------------------
# Modify use item in the screen 'party'
#-------------------------------------------------------------------------------------
def pbUseItemOnPokemon(item,pkmn,scene)
  itm = GameData::Item.get(item)
  # TM or HM
  if itm.is_machine?
    machine = itm.move
    return false if !machine
    movename = GameData::Move.get(machine).name
    if pkmn.shadowPokemon?
      pbMessage(_INTL("Shadow Pokémon can't be taught any moves.")) { scene.pbUpdate }
    elsif !pkmn.compatible_with_move?(machine)
      pbMessage(_INTL("{1} can't learn {2}.",pkmn.name,movename)) { scene.pbUpdate }
    else
      pbMessage(_INTL("\\se[PC access]You booted up {1}.\1",itm.name)) { scene.pbUpdate }
      if pbConfirmMessage(_INTL("Do you want to teach {1} to {2}?",movename,pkmn.name)) { scene.pbUpdate }
        if pbLearnMove(pkmn,machine,false,true,item) { scene.pbUpdate }
          $PokemonBag.pbDeleteItem(item) if itm.is_TR?
          return true
        end
      end
    end
    return false
  end
  # Other item
  ret = ItemHandlers.triggerUseOnPokemon(item,pkmn,scene)
  scene.pbClearAnnotations
  scene.pbHardRefresh
  useType = itm.field_use
  if ret && useType==1   # Usable on Pokémon, consumed
    $PokemonBag.pbDeleteItem(item)
    if !$PokemonBag.pbHasItem?(item)
      pbMessage(_INTL("You used your last {1}.",itm.name)) { scene.pbUpdate }
    end
  end
  return ret
end

#-------------------------------------------------------------------------------------
# Use item from bag
#-------------------------------------------------------------------------------------
def pbMoveTutorChoose(move,movelist=nil,bymachine=false,oneusemachine=false,item=nil)
  ret = false
  move = GameData::Move.get(move).id
  if movelist!=nil && movelist.is_a?(Array)
    for i in 0...movelist.length
      movelist[i] = GameData::Move.get(movelist[i]).id
    end
  end
  pbFadeOutIn {
    movename = GameData::Move.get(move).name
    annot = pbMoveTutorAnnotations(move,movelist)
    scene = PokemonParty_Scene.new
    screen = PokemonPartyScreen.new(scene,$Trainer.party)
    screen.pbStartScene(_INTL("Teach which Pokémon?"),false,annot)
    loop do
      chosen = screen.pbChoosePokemon
      break if chosen<0
      pokemon = $Trainer.party[chosen]
      if pokemon.egg?
        pbMessage(_INTL("Eggs can't be taught any moves.")) { screen.pbUpdate }
      elsif pokemon.shadowPokemon?
        pbMessage(_INTL("Shadow Pokémon can't be taught any moves.")) { screen.pbUpdate }
      elsif movelist && !movelist.any? { |j| j==pokemon.species }
        pbMessage(_INTL("{1} can't learn {2}.",pokemon.name,movename)) { screen.pbUpdate }
      elsif !pokemon.compatible_with_move?(move)
        pbMessage(_INTL("{1} can't learn {2}.",pokemon.name,movename)) { screen.pbUpdate }
      else
        if pbLearnMove(pokemon,move,false,bymachine,item) { screen.pbUpdate }  # add for using animation item
          pkmn.add_first_move(move) if oneusemachine
          ret = true
          break
        end
      end
    end
    screen.pbEndScene
  }
  return ret   # Returns whether the move was learned by a Pokemon
end

def pbUseItem(bag,item,bagscene=nil)
  itm = GameData::Item.get(item)
  useType = itm.field_use
  if itm.is_machine?    # TM or TR or HM
    if $Trainer.pokemon_count == 0
      pbMessage(_INTL("There is no Pokémon."))
      return 0
    end
    machine = itm.move
    return 0 if !machine
    movename = GameData::Move.get(machine).name
    pbMessage(_INTL("\\se[PC access]You booted up {1}.\1",itm.name))
    if !pbConfirmMessage(_INTL("Do you want to teach {1} to a Pokémon?",movename))
      return 0
    elsif pbMoveTutorChoose(machine,nil,true,itm.is_TR?,item) # add for using animation item
      bag.pbDeleteItem(item) if itm.is_TR?
      return 1
    end
    return 0
  elsif useType==1 || useType==5   # Item is usable on a Pokémon
    if $Trainer.pokemon_count == 0
      pbMessage(_INTL("There is no Pokémon."))
      return 0
    end
    ret = false
    annot = nil
    if itm.is_evolution_stone?
      annot = []
      for pkmn in $Trainer.party
        elig = pkmn.check_evolution_on_use_item(item)
        annot.push((elig) ? _INTL("ABLE") : _INTL("NOT ABLE"))
      end
    end
    pbFadeOutIn {
      scene = PokemonParty_Scene.new
      screen = PokemonPartyScreen.new(scene,$Trainer.party)
      screen.pbStartScene(_INTL("Use on which Pokémon?"),false,annot)
      loop do
        scene.pbSetHelpText(_INTL("Use on which Pokémon?"))
        chosen = screen.pbChoosePokemon
        if chosen<0
          ret = false
          break
        end
        pkmn = $Trainer.party[chosen]
        if pbCheckUseOnPokemon(item,pkmn,screen)
          ret = ItemHandlers.triggerUseOnPokemon(item,pkmn,screen)
          if ret && useType==1   # Usable on Pokémon, consumed
            bag.pbDeleteItem(item)
            if !bag.pbHasItem?(item)
              pbMessage(_INTL("You used your last {1}.",itm.name)) { screen.pbUpdate }
              break
            end
          end
        end
      end
      screen.pbEndScene
      bagscene.pbRefresh if bagscene
    }
    return (ret) ? 1 : 0
  elsif useType==2   # Item is usable from Bag
    intret = ItemHandlers.triggerUseFromBag(item)
    case intret
    when 0 then return 0
    when 1 then return 1   # Item used
    when 2 then return 2   # Item used, end screen
    when 3                 # Item used, consume item
      bag.pbDeleteItem(item)
      return 1
    when 4                 # Item used, end screen and consume item
      bag.pbDeleteItem(item)
      return 2
    end
    pbMessage(_INTL("Can't use that here."))
    return 0
  end
  pbMessage(_INTL("Can't use that here."))
  return 0
end