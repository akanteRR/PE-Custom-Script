Puts 'Script.rar' in '\Plugins\Album & Photo'
Puts 'Graphics.rar' in '\Graphics\Pictures'

# How to use 
Read in folder '1 - Photo' of 'Script.rar', read these files:
	0-1 - Guide.rb -> Guide you how to create scene with script (Read carefully)
	0-2 - Set value.rb -> Example if you want don't know how to add

Call script:
  Photo: Photo.show(name)
	name is name you set in '0-2 - Set value.rb'
	Example: you set like Photo.list("first", {...}) -> you call Photo.show("first")
  Album: Album.show

Buttons on keyboard (special)
+ Album
    Z: delete file
    X: close
+ Photo
    C: take photo
    X: close
    A: zoom_in
    S: zoom_out