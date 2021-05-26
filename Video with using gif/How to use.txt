Puts the script in 'Video with using Gif.rar' in folder '\Plugins\Video with using Gif'
Create folder with name like DirGif (default: 'Gif') in root folder and in Audio/BGM
Puts files gif in Gif folder and files sound in Audio/BGM/Gif (Gif is example name)

** Set script for using **
You have 2 methods for call script

One time:
Video.once(true,true,true,true) {arr}

Multiple times:
Video.multi(true,true,true,true) {arr}

* Meaning:

Word 'true':
First  -> set 'can next'  -> Player can press button next
Second -> set 'can back'  -> Player can press button back
Third  -> set 'can pause' -> Player can press button pause
Fourth -> set 'can stop'  -> Player can press button stop
...and vice-versa...

Word 'arr':
It's array. You need to set for playing video
Form:
arr = [
[name, volume, pitch],
[name, volume, pitch]
]

name ->  Name of file, you can add name folder that contains gif and bgm (it must be same name) before name gif
   Example: "a/3" -> a: name of folder, 3: name of gif
volume -> Set volume of this gif. If you don't set, just leave it. Script will set 100
pitch  -> Set pitch of this gif. If you don't set, just leave it. Script will set 100

You can see examples in this link: https://youtu.be/DDCAWq-eEPk

** Set in the script **
You can some values in this script:
	DirGif
	StopKey
	BackKey
	NextKey
	PauseKey
	TimesKey

* Meaning:
DirGif ->  Folder contains gifs and you need to set folder like this Audio/BGM/. If you don't set, script will create for you but there aren't file in this.
StopKey, BackKey, NextKey, PauseKey, TimesKey -> Key on keyboard.

