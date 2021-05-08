#-------------------------------------------------------------------------------
# Check Seasons like B2W2 by bo4p5687
#-------------------------------------------------------------------------------
PluginManager.register({
  :name => "Check Seasons like B2W2",
  :credits => "bo4p5687"
})
#-------------------------------------------------------------------------------
# Don't change
$season_number = 4
# Picture
module ShowSeasonBW2
  module_function
  def showPicture(name=nil)
    return name if name.nil?
    return Bitmap.new("Graphics/Pictures/Seasons/#{name}")
  end
  def pbSeason_Screen
    val = pbGetMetadata($game_map.map_id,MetadataOutdoor)
    if val && !pbMapInterpreterRunning?
      checked = 0
      loop do
        Graphics.update
        case checked
        when 0
          $season_number = pbGetSeason
          @viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
          @viewport.z=99999
          @season = Sprite.new(@viewport)
          if pbIsSpring
            @season.bitmap = self.showPicture("Spring")
          elsif pbIsSummer
            @season.bitmap = self.showPicture("Summer")
          elsif pbIsAutumn
            @season.bitmap = self.showPicture("Autumn")
          elsif pbIsWinter
            @season.bitmap = self.showPicture("Winter")
          else
            @season.bitmap = self.showPicture
          end
          @season.opacity = 150
          checked = 1
        when 1
          @season.opacity += 5
          checked = 2 if @season.opacity >= 255
        when 2
          Graphics.wait(30)
          checked = 3
        when 3
          @season.opacity -= 5
          checked = 4 if @season.opacity <= 0
        when 4
          @season.dispose 
          @viewport.dispose
          break
        end
      end
    else
      @checked = nil if $season_number != pbGetSeason
    end
  end
end
class Scene_Map
  alias season_map_update update
  def update
    ShowSeasonBW2.pbSeason_Screen if $season_number != pbGetSeason
    season_map_update
  end
end