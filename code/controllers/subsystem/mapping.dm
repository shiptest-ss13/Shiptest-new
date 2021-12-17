SUBSYSTEM_DEF(mapping)
	name = "Mapping"
	init_order = INIT_ORDER_MAPPING
	flags = SS_NO_FIRE

	var/list/nuke_tiles = list()
	var/list/nuke_threats = list()

	var/list/map_templates = list()

	var/list/ruins_templates = list()
	var/list/space_ruins_templates = list()
	var/list/lava_ruins_templates = list()
	var/list/ice_ruins_templates = list()
	var/list/sand_ruins_templates = list()
	var/list/jungle_ruins_templates = list()
	var/list/rock_ruins_templates = list()
	var/list/yellow_ruins_templates = list()

	var/list/maplist
	var/list/ship_purchase_list

	var/list/shuttle_templates = list()
	var/list/shelter_templates = list()
	var/list/areas_in_z = list()

	var/loading_ruins = FALSE

	///All possible biomes in assoc list as type || instance
	var/list/biomes = list()

	// Z-manager stuff
	var/station_start  // should only be used for maploading-related tasks
	var/space_levels_so_far = 0
	var/list/datum/space_level/z_list
	var/datum/space_level/empty_space

	/// List of all map zones
	var/list/map_zones = list()

/datum/controller/subsystem/mapping/Initialize(timeofday)
	if(initialized)
		return
	initialize_biomes()
	InitializeDefaultZLevels()
	repopulate_sorted_areas()
	process_teleport_locs()			//Sets up the wizard teleport locations
	preloadTemplates()
	run_map_generation()

	// Add the transit levels
	init_reserved_levels()

	repopulate_sorted_areas()
	return ..()

/* Nuke threats, for making the blue tiles on the station go RED
*   Used by the AI doomsday and the self destruct nuke.
*/

/datum/controller/subsystem/mapping/proc/add_nuke_threat(datum/nuke)
	nuke_threats[nuke] = TRUE
	check_nuke_threats()

/datum/controller/subsystem/mapping/proc/remove_nuke_threat(datum/nuke)
	nuke_threats -= nuke
	check_nuke_threats()

/datum/controller/subsystem/mapping/proc/check_nuke_threats()
	for(var/datum/d in nuke_threats)
		if(!istype(d) || QDELETED(d))
			nuke_threats -= d

	for(var/N in nuke_tiles)
		var/turf/open/floor/circuit/C = N
		C.update_icon()

/datum/controller/subsystem/mapping/Recover()
	flags |= SS_NO_INIT
	initialized = SSmapping.initialized
	map_templates = SSmapping.map_templates
	ruins_templates = SSmapping.ruins_templates
	space_ruins_templates = SSmapping.space_ruins_templates
	lava_ruins_templates = SSmapping.lava_ruins_templates
	// WS Edit Start - Whitesands
	sand_ruins_templates = SSmapping.sand_ruins_templates
	// WS Edit End - Whitesands
	shuttle_templates = SSmapping.shuttle_templates
	shelter_templates = SSmapping.shelter_templates

	z_list = SSmapping.z_list

#define INIT_ANNOUNCE(X) to_chat(world, "<span class='boldannounce'>[X]</span>"); log_world(X)
/datum/controller/subsystem/mapping/proc/LoadGroup(list/errorList, name, path, files, list/traits, list/default_traits, silent = FALSE)
	. = list()
	var/start_time = REALTIMEOFDAY

	if (!islist(files))  // handle single-level maps
		files = list(files)

	// check that the total z count of all maps matches the list of traits
	var/total_z = 0
	var/list/parsed_maps = list()
	for (var/file in files)
		var/full_path = "_maps/[path]/[file]"
		var/datum/parsed_map/pm = new(file(full_path))
		var/bounds = pm?.bounds
		if (!bounds)
			errorList |= full_path
			continue
		parsed_maps[pm] = total_z  // save the start Z of this file
		total_z += bounds[MAP_MAXZ] - bounds[MAP_MINZ] + 1

	if (!length(traits))  // null or empty - default
		for (var/i in 1 to total_z)
			traits += list(default_traits)
	else if (total_z != traits.len)  // mismatch
		INIT_ANNOUNCE("WARNING: [traits.len] trait sets specified for [total_z] z-levels in [path]!")
		if (total_z < traits.len)  // ignore extra traits
			traits.Cut(total_z + 1)
		while (total_z > traits.len)  // fall back to defaults on extra levels
			traits += list(default_traits)

	// preload the relevant space_level datums
	var/start_z = world.maxz + 1
	var/i = 0
	for (var/level in traits)
		add_new_zlevel("[name][i ? " [i + 1]" : ""]", level)
		++i

	// load the maps
	for (var/P in parsed_maps)
		var/datum/parsed_map/pm = P
		if (!pm.load(1, 1, start_z + parsed_maps[P], no_changeturf = TRUE))
			errorList |= pm.original_path
	if(!silent)
		INIT_ANNOUNCE("Loaded [name] in [(REALTIMEOFDAY - start_time)/10]s!")
	return parsed_maps

/datum/controller/subsystem/mapping/proc/run_map_generation()
	for(var/area/A in world)
		A.RunGeneration()

/datum/controller/subsystem/mapping/proc/mapvote()
	SSvote.initiate_vote("map", "automatic map rotation", TRUE) //WS Edit - Ghost Voting Rework

/datum/controller/subsystem/mapping/proc/changemap(datum/map_template/map)

/datum/controller/subsystem/mapping/proc/preloadTemplates(path = "_maps/templates/") //see master controller setup
	var/list/filelist = flist(path)
	for(var/map in filelist)
		var/datum/map_template/T = new(path = "[path][map]", rename = "[map]")
		map_templates[T.name] = T

	preloadRuinTemplates()
	preloadShuttleTemplates()
	load_ship_templates()
	preloadShelterTemplates()

/datum/controller/subsystem/mapping/proc/preloadRuinTemplates()
	// Still supporting bans by filename
	var/list/banned = generateMapList("[global.config.directory]/lavaruinblacklist.txt")
	banned += generateMapList("[global.config.directory]/spaceruinblacklist.txt")
	banned += generateMapList("[global.config.directory]/iceruinblacklist.txt")
	banned += generateMapList("[global.config.directory]/sandruinblacklist.txt")

	for(var/item in sortList(subtypesof(/datum/map_template/ruin), /proc/cmp_ruincost_priority))
		var/datum/map_template/ruin/ruin_type = item
		// screen out the abstract subtypes
		if(!initial(ruin_type.id))
			continue
		var/datum/map_template/ruin/R = new ruin_type()

		if(banned.Find(R.mappath))
			continue

		map_templates[R.name] = R
		ruins_templates[R.name] = R

		if(istype(R, /datum/map_template/ruin/lavaland))
			lava_ruins_templates[R.name] = R
		else if(istype(R, /datum/map_template/ruin/whitesands))
			sand_ruins_templates[R.name] = R
		else if(istype(R, /datum/map_template/ruin/jungle))
			jungle_ruins_templates[R.name] = R
		else if(istype(R, /datum/map_template/ruin/icemoon))
			ice_ruins_templates[R.name] = R
		else if(istype(R, /datum/map_template/ruin/space))
			space_ruins_templates[R.name] = R
		else if(istype(R, /datum/map_template/ruin/rockplanet))
			rock_ruins_templates[R.name] = R
		else if(istype(R, /datum/map_template/ruin/reebe))
			yellow_ruins_templates[R.name] = R


/datum/controller/subsystem/mapping/proc/preloadShuttleTemplates()
	for(var/item in subtypesof(/datum/map_template/shuttle))
		var/datum/map_template/shuttle/shuttle_type = item
		if(!(initial(shuttle_type.file_name)))
			continue

		var/datum/map_template/shuttle/S = new shuttle_type()

		shuttle_templates[S.file_name] = S
		map_templates[S.file_name] = S

#define CHECK_STRING_EXISTS(X) if(!istext(data[X])) { log_world("[##X] missing from json!"); continue; }
#define CHECK_LIST_EXISTS(X) if(!islist(data[X])) { log_world("[##X] missing from json!"); continue; }
/datum/controller/subsystem/mapping/proc/load_ship_templates()
	maplist = list()
	ship_purchase_list = list()
	var/list/filelist = flist("_maps/configs/")
	for(var/filename in filelist)
		var/file = file("_maps/configs/" + filename)
		if(!file)
			log_world("Could not open map config: [filename]")
			continue
		file = file2text(file)
		if(!file)
			log_world("map config is not text: [filename]")
			continue

		var/list/data = json_decode(file)
		if(!data)
			log_world("map config is not json: [filename]")
			continue

		CHECK_STRING_EXISTS("map_name")
		CHECK_STRING_EXISTS("map_path")
		CHECK_LIST_EXISTS("job_slots")
		var/datum/map_template/shuttle/S = new(data["map_path"], data["map_name"], TRUE)
		S.file_name = data["map_path"]
		S.category = "shiptest"

		if(istext(data["map_short_name"]))
			S.short_name = data["map_short_name"]
		else
			S.short_name = copytext(S.name, 1, 20)
		if(istext(data["prefix"]))
			S.prefix = data["prefix"]
		if(islist(data["namelist"]))
			S.name_categories = data["namelist"]

		S.job_slots = list()
		var/list/job_slot_list = data["job_slots"]
		for(var/job in job_slot_list)
			var/datum/job/job_slot
			var/value = job_slot_list[job]
			var/slots
			if(isnum(value))
				job_slot = SSjob.GetJob(job)
				slots = value
			else if(islist(value))
				var/datum/outfit/job_outfit = text2path(value["outfit"])
				if(isnull(job_outfit))
					stack_trace("Invalid job outfit! [value["outfit"]] on [S.name]'s config! Defaulting to assistant clothing.")
					job_outfit = /datum/outfit/job/assistant
				job_slot = new /datum/job(job, job_outfit)
				job_slot.wiki_page = value["wiki_page"]
				job_slot.exp_requirements = value["exp_requirements"]
				job_slot.officer = value["officer"]
				slots = value["slots"]

			if(!job_slot || !slots)
				stack_trace("Invalid job slot entry! [job]: [value] on [S.name]'s config! Excluding job.")
				continue

			S.job_slots[job_slot] = slots
		if(isnum(data["cost"]))
			S.cost = data["cost"]
			ship_purchase_list["[S.name] ([S.cost] [CONFIG_GET(string/metacurrency_name)]s)"] = S

		shuttle_templates[S.file_name] = S
		map_templates[S.file_name] = S
		if(isnum(data["roundstart"]) && data["roundstart"])
			maplist[S.name] = S
#undef CHECK_STRING_EXISTS
#undef CHECK_LIST_EXISTS

/datum/controller/subsystem/mapping/proc/preloadShelterTemplates()
	for(var/item in subtypesof(/datum/map_template/shelter))
		var/datum/map_template/shelter/shelter_type = item
		if(!(initial(shelter_type.mappath)))
			continue
		var/datum/map_template/shelter/S = new shelter_type()

		shelter_templates[S.shelter_id] = S
		map_templates[S.shelter_id] = S

///Initialize all biomes, assoc as type || instance
/datum/controller/subsystem/mapping/proc/initialize_biomes()
	for(var/biome_path in subtypesof(/datum/biome))
		var/datum/biome/biome_instance = new biome_path()
		biomes[biome_path] += biome_instance

/datum/controller/subsystem/mapping/proc/reg_in_areas_in_z(list/areas)
	for(var/B in areas)
		var/area/A = B
		A.reg_in_areas_in_z()

/// Creates basic physical levels so we dont have to do that during runtime every time, nothing bad will happen if this wont run, as allocation will handle adding new levels
/datum/controller/subsystem/mapping/proc/init_reserved_levels()
	add_new_zlevel("Free Allocation Level", allocation_type = ALLOCATION_FREE)
	add_new_zlevel("Quadrant Allocation Level", allocation_type = ALLOCATION_QUADRANT)


/datum/controller/subsystem/mapping/proc/safety_clear_transit_dock(obj/docking_port/stationary/transit/T, obj/docking_port/mobile/M, list/returning)
	M.setTimer(0)
	var/error = M.initiate_docking(M.destination, M.preferred_direction)
	if(!error)
		returning += M
		qdel(T, TRUE)

/datum/controller/subsystem/mapping/proc/get_map_zone_weather_controller(atom/Atom)
	var/datum/map_zone/mapzone = get_map_zone(Atom)
	if(!mapzone)
		return
	mapzone.assert_weather_controller()
	return mapzone.weather_controller

/datum/controller/subsystem/mapping/proc/get_map_zone_id(mapzone_id)
	var/datum/map_zone/returned_mapzone
	for(var/datum/map_zone/iterated_mapzone as anything in map_zones)
		if(iterated_mapzone.id == mapzone_id)
			returned_mapzone = iterated_mapzone
			break
	return returned_mapzone

/datum/controller/subsystem/mapping/proc/get_free_allocation(allocation_type, size_x, size_y)
	var/list/allocation_list
	var/list/levels_to_check = z_list.Copy()
	var/created_new_level = FALSE
	while(TRUE)
		for(var/datum/space_level/iterated_level as anything in levels_to_check)
			if(iterated_level.allocation_type != allocation_type)
				continue
			allocation_list = find_allocation_in_level(iterated_level, size_x, size_y)
			if(allocation_list)
				return allocation_list

		if(created_new_level)
			WARNING("MAPPING: We have failed to find allocation after creating a new level just for it, something went terribly wrong")
			return FALSE
		/// None of the levels could faciliate a new allocation, make a new one
		created_new_level = TRUE
		levels_to_check.Cut()
		levels_to_check += add_new_zlevel("assblast usa", allocation_type = allocation_type)

#define ALLOCATION_FIND_JUMP_DIST 5

/datum/controller/subsystem/mapping/proc/find_allocation_in_level(datum/space_level/level, size_x, size_y)
	var/target_x = 1
	var/target_y = 1
	/// Not perfect, checks 2 points, but something inbetween them could be intersecting. TODO: fix
	while(target_x < world.maxx)
		while(target_y < world.maxx)
			var/upper_target_x = target_x+size_x
			var/upper_target_y = target_y+size_y

			if((target_x < 1 || target_x > world.maxx) || (target_y < 1 || upper_target_y > world.maxy))
				return //Out of bounds

			if(level.is_box_free(target_x, target_y, upper_target_x, upper_target_y))
				return list(target_x, target_y, level.z_value) //hallelujah we found the unallocated spot
			
			target_y += ALLOCATION_FIND_JUMP_DIST
		
		target_x += ALLOCATION_FIND_JUMP_DIST

#undef ALLOCATION_FIND_JUMP_DIST
