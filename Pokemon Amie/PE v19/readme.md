Put `Audio` in `Audio\SE`

Put `Graphics` in `Graphics\Pictures\Pokemon Amie`

Put `Scripts` in `Plugins\Pokemon Amie Refresh`

# How to use
> Call: `PkmnAR.show`

## Set value
You can change some values.

### Find in `2 - Set item.rb` of folder `0 - Set`
1. `MAX_AMIE` -> Maximum values you can get.
1. `HUNGRY_STEP` -> After these steps, pokemon will be hungry. Each pokemon has different steps (If you put it in PC)
1. `EAT` -> Set item pokemon can eat in this game.
### Find in `1 - Set.rb` of folder `1 - Scene`
`MAX_AROUND` -> After this times, pokemon will be happy.

## Call with pokemon (class Pokemon)
You can check these values
1. amie_affection
1. amie_fullness
1. amie_enjoyment
1. hunger
It works like cool, beauty, etc

Example:
```
pkmn = Pokemon.new(...)
pkmn.amie_affection = 100 # Set affection of this pokemon
pkmn.amie_fullness  = 100 # Set fullness of this pokemon
pkmn.amie_enjoyment = 100 # Set enjoyment of this pokemon
pkmn.hunger = 100 # Set number when pokemon hungry, it's related to HUNGRY_STEP
pkmn.reset_affection # Reset stats: amie_affection, amie_fullness and amie_enjoyment
```

## Check level of each stats
You can call: pkmn.amie_stats(number)

Number is number to check stats
1. 0 is amie_affection
1. 1 is amie_fullness
1. 2 is amie_enjoyment

## Change stats with methods
Find in `2 - Set item.rb` of folder `0 - Set`. You can see `def self.change_amie_stats(pkmn, method=nil)`

Explain values:
1. `pkmn` -> it's class Pokemon. (It's pkmn of this method `pkmn = Pokemon.new(...)`)
1. `method` -> Look at lines below to know. You can see `:walk`, `:send_battle`, etc. Set it when and where with your creation. You can add or delete or edit these methods, too.