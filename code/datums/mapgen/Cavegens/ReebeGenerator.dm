#define REEBE_DEFAULT_ATMOS "n2=100;TEMP=100.00"

//AREAS
/area/ruin/reebe
	ambientsounds = REEBE
	always_unpowered = FALSE

/area/ruin/reebe/Entered(atom/movable/AM)
	. = ..()
	if(ismob(AM))
		var/mob/M = AM
		if(M.client)
			addtimer(CALLBACK(M.client, /client/proc/play_reebe_ambience), 900)

//TURFS
/turf/open/chasm/reebe_void
	name = "void"
	desc = "A endless void. You can't really see the bottom, if there really is one."
	icon = 'icons/turf/floors.dmi'
	icon_state = "reebemap"
	smoothing_flags = NONE
	smoothing_groups = null
	canSmoothWith = null
	lighting
	layer = SPACE_LAYER
	baseturfs = /turf/open/chasm/reebe_void
	planetary_atmos = TRUE
	tiled_dirt = FALSE
	flags_1 = NOJAUNT_1
	initial_gas_mix = REEBE_DEFAULT_ATMOS
	light_range = 2
	light_power = 0.6
	light_color = COLOR_VERY_LIGHT_GRAY

/turf/open/chasm/reebe_void/examine(mob/user)
	. = ..()
	. += "<span class='warning'>You WILL fucking die if you step on this!!!</span>"

/turf/open/chasm/reebe_void/Initialize(mapload)
	. = ..()
	icon_state = "reebegame"

/turf/open/floor/bronze/light
	light_range = 2
	light_power = 0.6
	light_color = COLOR_VERY_LIGHT_GRAY
	initial_gas_mix = REEBE_DEFAULT_ATMOS

/turf/open/floor/grass/fairy/reebe
	desc = "Strangely glowing grass."
	initial_gas_mix = REEBE_DEFAULT_ATMOS
	light_range = 2
	light_power = 0.6
	light_color = COLOR_VERY_LIGHT_GRAY
	baseturfs = /turf/open/chasm/reebe_void

/turf/closed/mineral/random/reebe
	baseturfs = /turf/open/floor/grass/fairy/reebe
	initial_gas_mix = REEBE_DEFAULT_ATMOS
//LATICES
/obj/structure/lattice/clockwork
	name = "cog lattice"
	desc = "A lightweight support lattice. These hold the Justicar's station together."
	icon = 'icons/obj/smooth_structures/lattice_clockwork.dmi'
	smoothing_flags = list(SMOOTH_BITMASK)
	smoothing_groups = list(SMOOTH_GROUP_LATTICE, SMOOTH_GROUP_CATWALK, SMOOTH_GROUP_OPEN_FLOOR)
	canSmoothWith = list(SMOOTH_GROUP_CATWALK)

/obj/structure/lattice/catwalk/clockwork
	name = "clockwork catwalk"
	icon = 'icons/obj/smooth_structures/catwalk_clockwork.dmi'
	smoothing_flags = list(SMOOTH_BITMASK)
	smoothing_groups = list(SMOOTH_GROUP_LATTICE, SMOOTH_GROUP_CATWALK, SMOOTH_GROUP_OPEN_FLOOR)
	canSmoothWith = list(SMOOTH_GROUP_CATWALK)

//Reebe ambience replay
/client/proc/play_reebe_ambience()
	var/area/A = get_area(mob)
	if((!istype(A, /area/ruin/reebe)) && (!istype(A, /area/overmap_encounter/planetoid/reebe)))
		return
	var/sound = pick(REEBE)
	if(!played)
		SEND_SOUND(src, sound(sound, repeat = 0, wait = 0, volume = 25, channel = CHANNEL_AMBIENCE))
		played = TRUE
		addtimer(CALLBACK(src, /client/proc/ResetAmbiencePlayed), 600)
	addtimer(CALLBACK(src, /client/proc/play_reebe_ambience), 900)



//actual gen
/datum/map_generator/cave_generator/reebe
	open_turf_types = list(/turf/open/chasm/reebe_void = 1)
	closed_turf_types = list(/turf/open/chasm/reebe_void = 1)

	//closed_turf_types =  list()

	mob_spawn_chance = 1
	flora_spawn_chance = 6

	mob_spawn_list = list(
		/mob/living/simple_animal/hostile/asteroid/basilisk/watcher/forgotten = 1)

	flora_spawn_list = list(
		/obj/machinery/power/supermatter_crystal/shard/hugbox = 1,
		/obj/item/nuke_core/supermatter_sliver = 5,
		/obj/structure/lattice/clockwork = 60,
		/obj/structure/lattice/catwalk/clockwork = 60)
	feature_spawn_list = null

	initial_closed_chance = 0

