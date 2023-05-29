/datum/planet_type
	var/name = "planet"
	var/desc = "A planet."
	var/planet = null
	var/ruin_type = null
	var/mapgen = null
	var/default_baseturf = null
	var/weather_controller_type = null
	var/icon_state = "globe"
	var/color = "#ffffff"
	var/weight = 20

/datum/planet_type/lava
	name = "lava planet"
	desc = "A world rich in seismic and volcanic activity. High temperatures and xenofauna dangers await anyone trying to brave it"
	planet = DYNAMIC_WORLD_LAVA
	icon_state = "globe"
	color = COLOR_ORANGE
	mapgen = /datum/map_generator/planet_generator/lava
	default_baseturf = /turf/open/floor/plating/asteroid/basalt/lava
	weather_controller_type = /datum/weather_controller/lavaland
	ruin_type = RUINTYPE_LAVA

/datum/planet_type/ice
	name = "frozen planet"
	desc = "A world with lots of water, currently in an ice age. Anyone venturing here would have to contend with both the cold, and the creatures on the world"
	planet = DYNAMIC_WORLD_ICE
	icon_state = "globe"
	color = COLOR_BLUE_LIGHT
	mapgen = /datum/map_generator/planet_generator/snow
	default_baseturf = /turf/open/floor/plating/asteroid/snow/icemoon
	weather_controller_type = /datum/weather_controller/snow_planet
	ruin_type = RUINTYPE_ICE

/datum/planet_type/jungle
	name = "jungle planet"
	desc = "A densely forested world, filled with vines, animals, and underbrush. Surprisingly habitable with a machete."
	planet = DYNAMIC_WORLD_JUNGLE
	icon_state = "globe"
	color = COLOR_LIME
	mapgen = /datum/map_generator/planet_generator/jungle
	default_baseturf = /turf/open/floor/plating/dirt/jungle
	weather_controller_type = /datum/weather_controller/lush
	ruin_type = RUINTYPE_JUNGLE

/datum/planet_type/rock
	name = "rock planet"
	desc = "A rocky red world in the midst of terraforming. While some plants have taken hold, it is widely hostile to life."
	planet = DYNAMIC_WORLD_ROCKPLANET
	icon_state = "globe"
	color = "#bd1313"
	mapgen = /datum/map_generator/planet_generator/rock
	default_baseturf = /turf/open/floor/plating/asteroid
	weather_controller_type = /datum/weather_controller/rockplanet
	ruin_type = RUINTYPE_ROCK

/datum/planet_type/sand
	name = "sand planet"
	desc = "A formerly vibrant world, turned to sand by the ravages of the ICW. The survivors of it are long mad by now."
	planet = DYNAMIC_WORLD_SAND
	icon_state = "globe"
	color = COLOR_GRAY
	mapgen = /datum/map_generator/planet_generator/sand
	default_baseturf = /turf/open/floor/plating/asteroid/whitesands
	weather_controller_type = /datum/weather_controller/desert
	ruin_type = RUINTYPE_SAND

/datum/planet_type/beach
	name = "beach planet"
	desc = "The platonic ideal of vacation spots. Warm, comfortable temperatures, breathable atmosphere."
	planet = DYNAMIC_WORLD_BEACHPLANET
	icon_state = "globe"
	color = "#c6b597"
	mapgen = /datum/map_generator/planet_generator/beach
	default_baseturf = /turf/open/floor/plating/asteroid/sand/lit
	weather_controller_type = /datum/weather_controller/lush
	ruin_type = RUINTYPE_BEACH

/datum/planet_type/reebe
	name = "???"
	desc = "Some sort of strange portal. There's no identification of what this is."
	planet = DYNAMIC_WORLD_REEBE
	icon_state = "wormhole"
	color = COLOR_YELLOW
	mapgen = /datum/map_generator/single_biome/reebe
	default_baseturf = /turf/open/chasm/reebe_void
	weather_controller_type = null
	weight = 0
	ruin_type = RUINTYPE_YELLOW

/datum/planet_type/asteroid
	name = "large asteroid"
	desc = "A large asteroid with significant traces of minerals."
	planet = DYNAMIC_WORLD_ASTEROID
	icon_state = "asteroid"
	color = COLOR_GRAY
	mapgen = /datum/map_generator/single_biome/asteroid
	// Space, because asteroid maps also include space turfs and the prospect of space turfs
	// existing without space as their baseturf scares me.
	default_baseturf = /turf/open/space
	weather_controller_type = null
	ruin_type = null // asteroid ruins when

/datum/planet_type/spaceruin
	name = "weak energy signal"
	desc = "A very weak energy signal originating from space."
	planet = DYNAMIC_WORLD_SPACERUIN
	icon_state = "strange_event"
	color = null
	mapgen = /datum/map_generator/single_turf/space
	default_baseturf = /turf/open/space
	weather_controller_type = null
	ruin_type = RUINTYPE_SPACE

/datum/planet_type/waste
	name = "waste disposal planet"
	desc = "A highly oxygenated world, coated in garbage, radiation, and rust."
	planet = DYNAMIC_WORLD_WASTEPLANET
	icon_state = "globe"
	color = "#a9883e"
	mapgen = /datum/map_generator/single_biome/wasteplanet
	default_baseturf = /turf/open/floor/plating/asteroid/wasteplanet
	weather_controller_type = /datum/weather_controller/chlorine
	ruin_type = RUINTYPE_WASTE

/datum/planet_type/gas_giant
	name = "gas giant"
	desc = "A floating ball of gas, with high gravity and even higher pressure."
	planet = DYNAMIC_WORLD_GAS_GIANT
	icon_state = "globe"
	color = COLOR_DARK_MODERATE_ORANGE
	mapgen = /datum/map_generator/single_biome/gas_giant
	default_baseturf = /turf/open/chasm/gas_giant
	weather_controller_type = null
	ruin_type = null //it's a Gas Giant. Not Cloud fuckin City
	weight = 5

/datum/planet_type/plasma_giant
	name = "plasma giant"
	desc = "A backbone of interstellar travel, the mighty plasma giant allows fuel collection to take place."
	planet = DYNAMIC_WORLD_PLASMA_GIANT
	color = COLOR_PURPLE
	mapgen = /datum/map_generator/single_biome/plasma_giant
	default_baseturf = /turf/open/chasm/gas_giant/plasma
	weight = 1
	icon_state = "globe"
