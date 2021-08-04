Put `Scripts` in `\Plugins\Battle-Worn Opponents`

# How to use

1. Set rules before battle starts. Call: `setBattleRule("battle-worm")`
1. Set to use this feature.

```
You want to set all anormal features in opponent party
-> Call: BattleWorm.random_all
In case you just want to set 1 feature or 2 features.
-> Call: BattleWorm.random_faint  # -> Random pokemon can faint or need to faint
-> Call: BattleWorm.random_hp     # -> Random hp of pokemon (percentage of max hp or exact hp)
-> Call: BattleWorm.random_status # -> Random status on pokemon (pokemon can have bad status or not)
```

3. Set each value. If not, it will give special case.

Each case need to set array.
```
* Faint
If you want first pokemon that faint, you will set BattleWorm.set_faint([true])
If you want second pokemon that faint, you will set BattleWorm.set_faint([false, true])
If you want this rate that is 50%, you will not set anything
* HP
If you want first pokemon that have 50% of total HP, you will set BattleWorm.set_hp([50])
If you want first pokemon that have 50 points of total HP, you will set BattleWorm.set_hp([50], false)
-> This case will set all pokemon in this array that have X points of total HP
If this points is greater than total HP, this script will set total HP
If this points is less than 0, this script will set 0
* Status
If you want first pokemon that have status 'Sleep', you will set BattleWorm.set_status([:SLEEP])
If you want second pokemon that have status 'Poison', you will set BattleWorm.set_status([:POISON])
If you doesn't set, this script will random status (include None status)
```
