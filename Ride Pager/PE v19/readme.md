Put `Scripts` in `\Plugins\Ride Pager`

# How to use

Add item in PBS. This is example.
> `639,RIDEPAGER,Ride Pager,Ride Pagers,8,0,"Use to ride pokemon.",2,0,6`

You can change 639 and description of item. It's easy.

### Add pokeride
Find file `4 - Set mount.rb` and read the first lines (include examples) to add new or edit pokeride.

### Add features in Ride Pager

#### Before use Ride Pager (first times)
Find file `2 - Register before using.rb` in folder `2 - Pokeride`

Add in `def self.register_before` with this form
> self.register_pokeride(module)

`module` is module that you created in file `4 - Set mount.rb`

#### After using
Add in event and touch to unclock it.
> RidePager.register_pokeride(module)

`module` is module that you created in file `4 - Set mount.rb`

### Delete features in Ride Pager
First, you don't add this feature (feature that you want to delete) in `def self.register_before`.

Second, add in event and touch to clock it.
> RidePager.unregister_pokeride(module)

`module` is module that you created in file `4 - Set mount.rb`

### Modify, add terrain tag
Find file `0 - Terrain tag - Passable.rb` in folder `3 - Function`

You can see terrain tag in first lines