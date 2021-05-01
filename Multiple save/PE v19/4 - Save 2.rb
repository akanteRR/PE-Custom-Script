#--------------------#
# Set emergency save #
#--------------------#
def pbEmergencySave
  oldscene = $scene
  $scene = nil
  pbMessage(_INTL("The script is taking too long. The game will restart."))
  return if !$Trainer
	# It will store the last save file when you dont file save
	count = FileSave.count
	SaveData.changeFILEPATH($storenamefilesave.nil? ? FileSave.name : $storenamefilesave)
  if SaveData.exists?
    File.open(SaveData::FILE_PATH, 'rb') do |r|
      File.open(SaveData::FILE_PATH + '.bak', 'wb') do |w|
        while s = r.read(4096)
          w.write s
        end
      end
    end
  end
  if Game.save
    pbMessage(_INTL("\\se[]The game was saved.\\me[GUI save game] The previous save file has been backed up.\\wtnp[30]"))
  else
    pbMessage(_INTL("\\se[]Save failed.\\wtnp[30]"))
  end
  $scene = oldscene
end