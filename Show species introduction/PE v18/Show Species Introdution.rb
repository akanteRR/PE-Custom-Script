#===============================================================================
# * Show Species Introdution - by FL (Credits will be apreciated)
#===============================================================================
#
# This script is for Pokémon Essentials. It shows a picture with the pokémon
# species in a border, show a message with the name and kind, play it cry and
# mark it as seen in pokédex. Good to make the starter selection event.
#
#===============================================================================
#
# bo4p5687 (update)
#
#===============================================================================
#
# Call: showSpeciesIntro(specie,seen,gender,form,shiny,shadow)
# 
# The specie is the species number
# Seen: if set true, specie will show on pokedex
# Gender: 0 -> male; 1 -> female
#   if pokemon don't have gender, set 0 or number isn't 1
# Form: set number of form
# Shiny: set true, it shows shiny pokemon
# Shadow: set true, it shows shadow pokemon
#
# Ex: 
# 'showSpeciesIntro(4)' shows Charmander
# 'showSpeciesIntro(PBSpecies::CHIKORITA)' shows Chikorita
# 'showSpeciesIntro(422,false,0,1)' shows Shellos in East Sea form.
#
#===============================================================================
PluginManager.register({
  :name => "Show Species Introdution",
  :credits => ["FL (original),bo4p5687 (update)"]
})
#===============================================================================
# Gender: 0: male/no gender; 1: female
# Form: 0, 1, 2, 3, etc
def showSpeciesIntro(specie,seen=true,gender=0,form=0,shiny=false,shadow=false)
  name=PBSpecies.getName(specie)
  kind=pbGetMessage(MessageTypes::Kinds,specie)
  if specie.is_a?(String) || specie.is_a?(Symbol)
    raise _INTL("Species does not exist ({1}).",specie) if !hasConst?(PBSpecies,specie)
    specie = getID(PBSpecies,specie)
  end
  if seen
    $Trainer.seen[specie] = true
    pbSeenForm(specie,gender,form)
  end
  bitmap = pbCheckPokemonBitmapFiles([specie,false,gender==1,shiny,form,shadow])
  pbPlayCry(specie)
  if bitmap # to prevent crashes
    iconwindow=PictureWindow.new(bitmap)
    iconwindow.x=(Graphics.width/2)-(iconwindow.width/2)
    iconwindow.y=((Graphics.height-96)/2)-(iconwindow.height/2)
    pbMessage(_INTL("{1}. {2} POKéMON.",name,kind))
    iconwindow.dispose
  end
end