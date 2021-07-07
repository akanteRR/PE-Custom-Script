Puts scripts 'Pokegear - HGSS.rar' in '\Plugins\Pokegear - HGSS'
Puts graphics 'Graphics.rar' in '\Graphics\Pictures\Pokegear HGSS'

# How to use 

Graphics:
  You need to set script before adding new graphics

Script:
  Read the comment lines (line has # before line)
  Find and read in these files:
	2 - Constant.rb
	97 - Store (use in third feature).rb
	98 - Custom 2 (Use function of Custom).rb
	99 - Set value.rb
  You can set seen or not seen features in pokegear with this call: 
	PokegearHGSS.seen(name, boolean)
	  name -> You set in 99 - Set value.rb
	  boolean -> true / false. If true, you can see after you set false