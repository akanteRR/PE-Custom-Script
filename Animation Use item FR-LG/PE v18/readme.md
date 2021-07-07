# How to use 
Put main script above Main.
Put the images in Graphics\Pictures\Use Animations.

# Important 

# Items 

Find this command (ItemHandlers::UseOnPokemon) and add some lines for adding animation.
Example:

1) Evolution Stone
Find
ItemHandlers::UseOnPokemon.addIf(proc { |item| pbIsEvolutionStone?(item)},

above...
	pbFadeOutInWithMusic {
...add
      scene.pbUseAnimations(item,pkmn)
      scene.endUseAnimations

2) Item recover HP (Potion, max potion,etc)
Find
def pbHPItem(pkmn,restoreHP,scene)

change all into...

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

...Next, you need to find...
ItemHandlers::UseOnPokemon.add(:POTION,proc { |item,pkmn,scene|

...change line...
	next pbHPItem(pkmn,20,scene)
...into...
	next pbHPItem(item,pkmn,20,scene)
You do like it such as SUPERPOTION, HYPERPOTION,etc. All items use pbHPItem, just add item before pkmn

3) Item heals status (Awakening, antidote,etc)
Find
ItemHandlers::UseOnPokemon.add(:AWAKENING,proc { |item,pkmn,scene|

above...
	pkmn.healStatus
...add...
	scene.pbUseAnimations(item,pkmn)
...below...
	scene.pbDisplay(_INTL("{1} woke up.",pkmn.name))
...add...
	scene.endUseAnimations
You do like it such as ANTIDOTE, BURNHEAL,etc. All items use healStatus.

# Other items 
Max revive:
Find
ItemHandlers::UseOnPokemon.add(:MAXREVIVE,proc { |item,pkmn,scene|

above...
	pkmn.healHP
...add...
	scene.pbUseAnimations(item,pkmn)
...and remember add...
	scene.endUseAnimations
...below...
	scene.pbDisplay(_INTL("{1}'s HP was restored.",pkmn.name))
Do this with item like Max revive (the items have pkmn.healHP)

4) Item recover PP (Ether, max ether,etc)
Find
ItemHandlers::UseOnPokemon.add(:ETHER,proc { |item,pkmn,scene|

above...
	scene.pbDisplay(_INTL("PP was restored."))
...add...
	scene.pbUseAnimations(item,pkmn)
...and below...
	scene.pbDisplay(_INTL("PP was restored."))
...add...
	scene.endUseAnimations
You do like it such as Elixir, max elixir,etc.

# Other items 
PP Up:
Find
ItemHandlers::UseOnPokemon.add(:PPUP,proc { |item,pkmn,scene|

above...
	pkmn.moves[move].ppup += 1
...add...
	scene.pbUseAnimations(item,pkmn)
...below...
	scene.pbDisplay(_INTL("{1}'s PP increased.",movename))
...add...
	scene.endUseAnimations

5) Other Items
You do like this tip:
add...
	scene.pbUseAnimations(item,pkmn)
...when you want to show animation and add...
	scene.endUseAnimations
...when you want to delete this scene

# Remember 
Just add above this line...
	next true

# TM/HM 

Find
def pbLearnMove(pkmn,move,ignoreifknown=false,bymachine=false,&block)

Change all into...

def pbLearnMove(pkmn,move,ignoreifknown=false,bymachine=false,&block)
  return false if !pkmn
  movename = PBMoves.getName(move)
  if pkmn.egg? && !$DEBUG
    pbMessage(_INTL("Eggs can't be taught any moves."),&block)
    return false
  end
  if pkmn.shadowPokemon?
    pbMessage(_INTL("Shadow Pokémon can't be taught any moves."),&block)
    return false
  end
  pkmnname = pkmn.name
  if pkmn.hasMove?(move)
    pbMessage(_INTL("{1} already knows {2}.",pkmnname,movename),&block) if !ignoreifknown
    return false
  end
  if pkmn.numMoves<4
    pkmn.pbLearnMove(move)
    if bymachine
      UseAnimations.new.animationTMHM(move,pkmn,pkmnname,nil,movename,false,&block)
    else
      pbMessage(_INTL("\\se[]{1} learned {2}!\\se[Pkmn move learnt]",pkmnname,movename),&block)
    end
    return true
  end
  loop do
    pbMessage(_INTL("{1} wants to learn {2}, but it already knows four moves.\1",pkmnname,movename),&block) if !bymachine
    pbMessage(_INTL("Please choose a move that will be replaced with {1}.",movename),&block)
    forgetmove = pbForgetMove(pkmn,move)
    if forgetmove>=0
      oldmovename = PBMoves.getName(pkmn.moves[forgetmove].id)
      oldmovepp   = pkmn.moves[forgetmove].pp
      pkmn.moves[forgetmove] = PBMove.new(move)   # Replaces current/total PP
      if bymachine && !NEWEST_BATTLE_MECHANICS
        pkmn.moves[forgetmove].pp = [oldmovepp,pkmn.moves[forgetmove].totalpp].min
      end
      if bymachine
        UseAnimations.new.animationTMHM(move,pkmn,pkmnname,oldmovename,movename,true,&block)
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
