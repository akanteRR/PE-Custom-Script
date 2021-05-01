#----------------------------------------#
# Save                                   #
#----------------------------------------#
# Custom message
def pbCustomMessageForSave(message,commands,index,&block)
  return pbMessage(message,commands,index,&block)
end
# Save screen
class PokemonSaveScreen
	def pbSaveScreen
    ret = false
		# Check for renaming
		FileSave.rename
		# Count save file
		count = FileSave.count
		# Start
    msg = _INTL("What do you want to do?")
		cmds = [_INTL("Delete"),_INTL("Save"),_INTL("Cancel")]
		cmd = pbCustomMessageForSave(msg,cmds,3)
		# Delete
		if cmd==0
			if count <= 0
				pbMessage(_INTL("No save file was found."))
			else
				cmds = [_INTL("Delete All File Save"),_INTL("Delete Only One File Save"),_INTL("Cancel")]
        cmd2 = pbCustomMessageForSave(msg,cmds,3)
				case cmd2
				# All
				when 0
					if pbConfirmMessageSerious(_INTL("Delete all saves?"))
            pbMessage(_INTL("Once data has been deleted, there is no way to recover it.\1"))
            if pbConfirmMessageSerious(_INTL("Delete the saved data anyway?"))
              pbMessage(_INTL("Deleting all data. Don't turn off the power.\\wtnp[0]"))
							haserrorwhendelete = false
							count.times { |i|
								name = FileSave.name(i+1, false)
								begin
									SaveData.delete_file(name)
								rescue
									haserrorwhendelete = true
								end
							}
							pbMessage(_INTL("You have at least one file that cant delete and have error")) if haserrorwhendelete
              Graphics.frame_reset
              pbMessage(_INTL("The save file was deleted."))
            end
          end
				# Only one
				when 1
					pbFadeOutIn {
            file = ScreenChooseFileSave.new(count)
            file.movePanel(2)
            file.endScene
            Graphics.frame_reset if file.deletefile
          }
				end
				# Return menu
				return false
			end
		else
			@scene.pbStartScreen
			# Save
			if cmd==1
				cmds = [_INTL("New Save File"),_INTL("Old Save File")]
				cmds << _INTL("Save current save file") if !$storenamefilesave.nil? && count>0
				cmds << _INTL("Cancel")
				cmd2 = pbCustomMessageForSave(msg,cmds, ($storenamefilesave.nil? && count>0 ? 3 : 4 ))
				# New save file
				case cmd2
				when 0
					SaveData.changeFILEPATH(FileSave.name(count+1))
					if Game.save
						pbMessage(_INTL("\\se[]{1} saved the game.\\me[GUI save game]\\wtnp[30]", $Trainer.name))
						ret = true
					else
						pbMessage(_INTL("\\se[]Save failed.\\wtnp[30]"))
						ret = false
					end
					SaveData.changeFILEPATH(!$storenamefilesave.nil? ? $storenamefilesave : FileSave.name)
				# Old save file
				when 1
					if count <= 0
						pbMessage(_INTL("No save file was found."))
					else
            pbFadeOutIn {
              file = ScreenChooseFileSave.new(count)
              file.movePanel
              file.endScene
              ret = file.staymenu
            }
					end
				end
				if !$storenamefilesave.nil? && count>0
					if cmd2 == 2
						SaveData.changeFILEPATH($storenamefilesave)
						if Game.save
							pbMessage(_INTL("\\se[]{1} saved the game.\\me[GUI save game]\\wtnp[30]", $Trainer.name))
							ret = true
						else
							pbMessage(_INTL("\\se[]Save failed.\\wtnp[30]"))
							ret = false
						end
						SaveData.changeFILEPATH(!$storenamefilesave.nil? ? $storenamefilesave : FileSave.name)
					end
				end
			# Cancel
			else
				pbSEPlay("GUI save choice")
			end
			@scene.pbEndScreen
		end
		return ret
	end
end