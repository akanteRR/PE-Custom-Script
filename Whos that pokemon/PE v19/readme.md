Puts `Script` in `\Plugins\Whos that pokemon`

Puts `Graphics` in `Graphics\Pictures\Whos That Pokemon`

# How to use
### Call script
> Call: WhosThatPkmn.show
> You can call WhosThatPkmn.show(true) if you want to guess form (case: pokemon has multi form)
> You can call WhosThatPkmn.show(false, true) - pokemon shows his shiny form but he doesn't show other form.
> You can call WhosThatPkmn.show(true, true) - pokemon shows his shiny form and he can show other form (if he can).
### Some values you can change
#### Write rules
Find and edit `RULES`
#### Coin play
Find and edit `COINS_PLAY`
#### Add new special words
Find and edit `SPECIAL_WORDS`
> Edit in "..."
#### Add black list (these pokemon doesn't appear in this game)
Find and edit `BLACK_LIST`
#### Add reward
There are 3 types reward
> Reward when you rotate wheel. Find and edit `REWARD_ITEM` and `REWARD_PKMN`
> Reward special, reward for your knowledge. Read comments to know more. Find and edit `SPECIAL_REWARD`
##### Level of pokemon (reward)
Find and edit `LEVEL_PKMN`, `LEVEL_PKMN_POINTS` and `LEVEL_PKMN_SPECIAL`
#### Set reward in wheel
Find this def
> def set_reward_wheel(angle). Set condition and your reward in this def
#### Set reward by points
Find this def
> def reward_points. Set condition and your reward in this def
