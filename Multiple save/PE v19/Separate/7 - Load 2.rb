#----------------------------------------#
# Load                                   #
#----------------------------------------#
class PokemonLoadScreen
  def pbStartDeleteScreen
    @scene.pbStartDeleteScene
    @scene.pbStartScene2
		count = FileSave.count
		if count<0
			pbMessage(_INTL("No save file was found."))
		else
			msg = _INTL("What do you want to do?")
			cmds = [_INTL("Delete All File Save"),_INTL("Delete Only One File Save"),_INTL("Cancel")]
			cmd = pbCustomMessageForSave(msg,cmds,3)
			case cmd
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
			when 1
        pbFadeOutIn {
          file = ScreenChooseFileSave.new(count)
          file.movePanel(2)
          file.endScene
          Graphics.frame_reset if file.deletefile
        }
			end
		end
    @scene.pbEndScene
    $scene = pbCallTitle
  end
end