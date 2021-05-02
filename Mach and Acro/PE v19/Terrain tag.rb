module Settings
  AcroBikeFileName = [
		"boyAcro", # Player A
		"girlAcro", # Player B
		"", # Player C
		"", # Player D
		"", # Player E
		"", # Player F
  ]

  # Image when biking (without press Z in keyboard)
  NormalBikeFileName =
  [
		"boy_bike", # Player A
		"girl_bike", # Player B
		"", # Player C
		"", # Player D
		"", # Player E
		"", # Player F
  ]
end

module GameData
  class TerrainTag
		attr_reader :acrobike
		attr_reader :acrobikelr
		attr_reader :acrobikeud
		attr_reader :machbike

		alias init_ab initialize
		def initialize(hash)
			init_ab(hash)
			@acrobike    = hash[:acrobike]    || false
			@acrobikelr  = hash[:acrobikelr]  || false
			@acrobikeud  = hash[:acrobikeud]  || false
			@machbike    = hash[:machbike]    || false
		end
	end
end

GameData::TerrainTag.register({
  :id                     => :AcroBikeUpDown,
  :id_number              => 18,
	:acrobikeud             => true,
	:acrobike               => true
})

GameData::TerrainTag.register({
  :id                     => :AcroBikeLeftRight,
  :id_number              => 19,
	:acrobikelr             => true,
	:acrobike               => true
})

GameData::TerrainTag.register({
  :id                     => :AcroBikeHop,
  :id_number              => 20,
	:acrobike               => true
})

GameData::TerrainTag.register({
  :id                     => :MachBike,
  :id_number              => 21,
	:machbike               => true
})