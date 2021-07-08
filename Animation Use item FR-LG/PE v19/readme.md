# How to use 

Put these files in File.rar in Plugins\Animation use item:

 1 - Animation use item.rb

 2 - Add animation (move).rb

 3 - Add animation (item).rb

 meta.txt

Put the images in Graphics\Pictures\Use Animations.



# Important 



# TM/HM 

I made everything in file '2 - Add animation (move).rb'

Don't change or modify if you don't know what you do.



# Items 

Modify items in file '3 - Add animation (item).rb'



Find this command (ItemHandlers::UseOnPokemon) and add some lines for adding animation.

Example:



1) Evolution Stone (find in file)

Find

ItemHandlers::UseOnPokemon.addIf(proc { |item| GameData::Item.get(item).is_evolution_stone? },



above

pbFadeOutInWithMusic {



add

      scene.pbUseAnimations(item,pkmn)

      scene.endUseAnimations



2) Item recover HP (Potion, max potion,etc) - (add new method)

Find something like

ItemHandlers::UseOnPokemon.add(:POTION,proc { |item,pkmn,scene|



copy all in file '3 - Add animation (item).rb' and change line...

	next pbHPItem(pkmn,20,scene)

...into

	next pbHPItem(item,pkmn,20,scene)

You do like it such as SUPERPOTION, HYPERPOTION,etc. All items use pbHPItem, just add item before pkmn



3) Item heals status (Awakening, antidote,etc) - (add new method)

Find something like

ItemHandlers::UseOnPokemon.add(:AWAKENING,proc { |item,pkmn,scene|



copy all in file '3 - Add animation (item).rb' and above...

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

Find something like

ItemHandlers::UseOnPokemon.add(:MAXREVIVE,proc { |item,pkmn,scene|



copy all in file '3 - Add animation (item).rb' and above...

	pkmn.healHP

...add...

	scene.pbUseAnimations(item,pkmn)

...and remember add...

	scene.endUseAnimations

...below...

	scene.pbDisplay(_INTL("{1}'s HP was restored.",pkmn.name))

Do this with item like Max revive (the items have pkmn.healHP)



4) Item recover PP (Ether, max ether,etc) - (add new method)

Find something like

ItemHandlers::UseOnPokemon.add(:ETHER,proc { |item,pkmn,scene|



copy all in file '3 - Add animation (item).rb' and above...

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

Find something like

ItemHandlers::UseOnPokemon.add(:PPUP,proc { |item,pkmn,scene|



copy all in file '3 - Add animation (item).rb' and above...

	pkmn.moves[move].ppup += 1

...add...

	scene.pbUseAnimations(item,pkmn)

...below...

	scene.pbDisplay(_INTL("{1}'s PP increased.",movename))

...add...

	scene.endUseAnimations



5) Other Items

You do like this tip:



copy all in file '3 - Add animation (item).rb' and add...

	scene.pbUseAnimations(item,pkmn)

...when you want to show animation and add...

	scene.endUseAnimations

...when you want to delete this scene...



# Remember  

Just add above this line...

	next true