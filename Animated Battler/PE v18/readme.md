Puts script in 'Script.rb' above Main

#** Change value **
You can set wait frame or repeat frame

What is wait frame? -> One frame moves other frame after 'wait frame' frame.
What is repeat frame? -> After finishing all frames one times, it return again. Finish animated bitmap when finishing 'repeat frame' times.

Find in 'module RepeatAnimate'

Set trainer:
  + wait frame in WaitT
  + repeat frame in Trainer

Set pokemon:
  + wait frame in WaitP
  + repeat frame in Pokemon
