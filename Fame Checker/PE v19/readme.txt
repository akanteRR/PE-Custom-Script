Puts graphics in "Graphics.rar - FameChecker" into '\Graphics\Pictures\FameChecker'
Puts graphics item 'FAMECHECKER.png' in "Graphics.rar - FameChecker" into '\Graphics\Items'
Puts script in "Fame Checker.rar" into "\Plugins\Fame Checker"

You can choose add new item or call script to use

1. Add new item in items.txt like this:
530,FAMECHECKER,Fame Checker,Fame Checker,8,0,"A device that enables you to recall what you've heard and seen about famous people.",2,0,6,
Of course, you can change this number "530".

2. Call: FameChecker.show

** How to use **

* First, add informations of famous in file '2 - Set value to store.rb'

2 actions:
  + Add: FameChecker.list
  + Add: FameChecker.infor (You need to add 6 times)

Write like examples, must add all values and read carefull comments to add

* Second, after add information, set it true if you want to see

See: famous person -> Call: FameChecker.seenList(name) -> name is value that you added in FameChecker.list(name, hash)
													    /\
													    || -> This name

See: information of famous -> Call: FameChecker.seenInfor(name, number) -> name is value that you added in FameChecker.list(name, hash)
								  |					    /\
								  |					    || -> This name
								  |
								  |------> number is order when you set FameChecker.infor, maximum is 5 and minimum is 0

-> If you set wrong method or call wrong method -> You will get error