# Disadvantage:

If you use this script, you must count the quantity of the letters, inclunding space when you press space bar, "." , "," , "?", etc but don't press enter.

Example:

["How do I do this?"] # 17 letters, including space and "?"



# How to count?

In Event Commands, go to Script and add this:

TEST = ["text","text2"] # this is an example, you should put your sentence in this ""

for i in 0...TEST.length

   Kernel.pbMessage(_INTL("#{TEST[i].length}"))

end

The reasons: this script will show again your choice in header and there are the limit for this.



# How to use:

- Add a new item or call this script: pbHelpBook

If you want this is an item, add in item.txt like this ( you can change 531):

531,ADVENTURERULES,Adventure rules,Adventure rules,8,0,"This book contains all points a new trainer needs to know on a journey. It was handmade by a kind friend.",2,0,6,

About how to add new line, you should read the first lines.



Puts the images 'Graphics' in foder: Graphics\Pictures\Help

Puts item's image in '\Graphics\Icons'

Puts script above Main