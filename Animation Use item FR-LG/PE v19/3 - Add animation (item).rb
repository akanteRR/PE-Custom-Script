#--------------------------------------------------------------------------------------------------
# See the file 'How to use' to learn how to edit this file
#--------------------------------------------------------------------------------------------------
# Item
#--------------------------------------------------------------------------------------------------
# 1. Evolution stone
# Need to add in script section. Change the script in script Section into this script below.
# Don't delete =begin and =end. It's just example if you dont know how to edit.
=begin
ItemHandlers::UseOnPokemon.addIf(proc { |item| GameData::Item.get(item).is_evolution_stone? },
  proc { |item,pkmn,scene|
    if pkmn.shadowPokemon?
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    newspecies = pkmn.check_evolution_on_use_item(item)
    if newspecies
			scene.pbUseAnimations(item,pkmn)
			scene.endUseAnimations
      pbFadeOutInWithMusic {
        evo = PokemonEvolutionScene.new
        evo.pbStartScreen(pkmn,newspecies)
        evo.pbEvolution(false)
        evo.pbEndScreen
        if scene.is_a?(PokemonPartyScreen)
          scene.pbRefreshAnnotations(proc { |p| !p.check_evolution_on_use_item(item).nil? })
          scene.pbRefresh
        end
      }
      next true
    end
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  }
)
=end

# 2. Item recover HP (Potion, Max potion, etc)
def pbHPItem(item,pkmn,restoreHP,scene)
  if !pkmn.able? || pkmn.hp==pkmn.totalhp
    scene.pbDisplay(_INTL("It won't have any effect."))
    return false
  end
  hpGain = pbItemRestoreHP(pkmn,restoreHP)
	scene.pbUseAnimations(item,pkmn)
  scene.pbRefresh
  scene.pbDisplay(_INTL("{1}'s HP was restored by {2} points.",pkmn.name,hpGain))
	scene.endUseAnimations
  return true
end

ItemHandlers::UseOnPokemon.add(:POTION,proc { |item,pkmn,scene|
	next pbHPItem(item,pkmn,20,scene)
})
# add more below this line if you have other

# 3. Item heals status (Awakening, Antidote, etc)
ItemHandlers::UseOnPokemon.add(:AWAKENING,proc { |item,pkmn,scene|
  if pkmn.fainted? || pkmn.status != :SLEEP
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
	scene.pbUseAnimations(item,pkmn)
  pkmn.heal_status
  scene.pbRefresh
  scene.pbDisplay(_INTL("{1} woke up.",pkmn.name))
	scene.endUseAnimations
  next true
})

ItemHandlers::UseOnPokemon.add(:MAXREVIVE,proc { |item,pkmn,scene|
  if !pkmn.fainted?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
	scene.pbUseAnimations(item,pkmn)
  pkmn.heal_HP
  pkmn.heal_status
  scene.pbRefresh
  scene.pbDisplay(_INTL("{1}'s HP was restored.",pkmn.name))
	scene.endUseAnimations
  next true
})
# add more below this line if you have other

# 4. Item recover PP (Ether, Max ether, etc)
ItemHandlers::UseOnPokemon.add(:ETHER,proc { |item,pkmn,scene|
  move = scene.pbChooseMove(pkmn,_INTL("Restore which move?"))
  next false if move<0
  if pbRestorePP(pkmn,move,10)==0
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
	scene.pbUseAnimations(item,pkmn)
  scene.pbDisplay(_INTL("PP was restored."))
	scene.endUseAnimations
  next true
})

ItemHandlers::UseOnPokemon.add(:PPUP,proc { |item,pkmn,scene|
  move = scene.pbChooseMove(pkmn,_INTL("Boost PP of which move?"))
  if move>=0
    if pkmn.moves[move].total_pp<=1 || pkmn.moves[move].ppup>=3
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
		scene.pbUseAnimations(item,pkmn)
    pkmn.moves[move].ppup += 1
    movename = pkmn.moves[move].name
    scene.pbDisplay(_INTL("{1}'s PP increased.",movename))
		scene.endUseAnimations
    next true
  end
  next false
})
# add more below this line if you have other

# 5. The other
# add more below this line if you have other
