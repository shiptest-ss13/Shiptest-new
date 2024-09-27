/datum/dynamic_mission
	var/name = "Mission"
	var/author = ""
	var/desc = "Do something for me."
	var/faction = /datum/faction/independent
	var/value = 1000 /// The mission's payout.
	var/duration /// The amount of time in which to complete the mission. Setting it to 0 will result in no time limit
	var/weight = 0 /// The relative probability of this mission being selected. 0-weight missions are never selected.

	var/location_specific = TRUE
	/// The outpost that issued this mission. Passed in New().
	//var/datum/overmap/outpost/source_outpost
	var/datum/overmap/mission_location

	/// Should mission value scale proportionally to the deviation from the mission's base duration?
	var/dur_value_scaling = FALSE
	/// The maximum deviation of the mission's true value from the base value, as a proportion.
	var/val_mod_range = 0.2
	/// The maximum deviation of the mission's true duration from the base value, as a proportion.
	var/dur_mod_range = 0.1

	var/active = FALSE
	var/failed = FALSE
	var/dur_timer

	/// Assoc list of atoms "bound" to this mission; each atom is associated with a 2-element list. The first
	/// entry in that list is a bool that determines if the mission should fail when the atom qdeletes; the second
	/// is a callback to be invoked upon the atom's qdeletion.
	var/list/atom/movable/bound_atoms

/datum/dynamic_mission/New(_location)
	//source_outpost = _outpost
	mission_location = _location
	SSmissions.inactive_missions += list(src)
	//RegisterSignal(source_outpost, COMSIG_PARENT_QDELETING, PROC_REF(on_vital_delete))
	RegisterSignal(mission_location, COMSIG_PARENT_QDELETING, PROC_REF(on_vital_delete))
	RegisterSignal(mission_location, COMSIG_OVERMAP_LOADED, PROC_REF(on_planet_load))

	generate_mission_details()
	return ..()

/datum/dynamic_mission/Destroy()
	//UnregisterSignal(source_outpost, COMSIG_PARENT_QDELETING)
	UnregisterSignal(mission_location, COMSIG_PARENT_QDELETING, COMSIG_OVERMAP_LOADED)
	if(active)
		SSmissions.active_missions -= src
	else
		SSmissions.inactive_missions -= src
	//LAZYREMOVE(source_outpost.missions, src)
	//source_outpost = null
	for(var/bound in bound_atoms)
		remove_bound(bound)
	deltimer(dur_timer)
	return ..()

/datum/dynamic_mission/proc/on_vital_delete()
	qdel(src)

/datum/dynamic_mission/proc/generate_mission_details()
	var/val_mod = value * val_mod_range
	value = rand(value-val_mod, value+val_mod)
	if(duration)
		var/old_dur = duration
		var/dur_mod = duration * dur_mod_range
		duration = round(rand(duration-dur_mod, duration+dur_mod), 30 SECONDS)
		value = value * (dur_value_scaling ? old_dur / duration : 1)
	value = round(value, 50)

	author = random_species_name()
	return

/datum/dynamic_mission/proc/reward_flavortext()
	return list(
		MISSION_REWARD_CASH = "[value * 1.2] cr upon completion",
		MISSION_REWARD_ITEMS = "A nice slice of ham AND [value] cr",
		MISSION_REWARD_REP = "[value] cr and rep with [SSfactions.faction_name(src.faction)]",
	)

/datum/dynamic_mission/proc/start_mission()
	SSmissions.inactive_missions -= src
	active = TRUE
	if(duration)
		dur_timer = addtimer(VARSET_CALLBACK(src, failed, TRUE), duration, TIMER_STOPPABLE)
	SSmissions.active_missions += src

/datum/dynamic_mission/proc/on_planet_load(datum/overmap/dynamic/planet)
	SIGNAL_HANDLER

	if(!active)
		qdel(src)
		return
	if(!planet.spawned_mission_pois.len)
		stack_trace("[src] failed to start because it had no points of intrest to use for its mission")
		qdel(src)
		return

	spawn_mission_setpiece(planet)

/datum/dynamic_mission/proc/spawn_mission_setpiece(datum/overmap/dynamic/planet)
	return

/datum/dynamic_mission/proc/can_turn_in(atom/movable/item_to_check)
	return

/datum/dynamic_mission/proc/turn_in(atom/movable/item_to_turn_in, choice)
	if(can_turn_in(item_to_turn_in))
		spawn_reward(item_to_turn_in.loc, choice)
		do_sparks(3, FALSE, get_turf(item_to_turn_in))
		qdel(item_to_turn_in)
		qdel(src)

/datum/dynamic_mission/proc/spawn_reward(loc, choice)
	switch(choice)
		if(MISSION_REWARD_CASH)
			new /obj/item/spacecash/bundle(loc, value * 1.2)
		if(MISSION_REWARD_ITEMS)
			new /obj/item/spacecash/bundle(loc, value)
			new /obj/item/reagent_containers/food/snacks/spidereggsham(loc)
		//Rep probally not coming in this pr i think
		if(MISSION_REWARD_REP)
			new /obj/item/spacecash/bundle(loc, value * 1.2)

/datum/dynamic_mission/proc/can_complete()
	return !failed

/datum/dynamic_mission/proc/get_tgui_info(list/items_on_pad)
	var/time_remaining = max(dur_timer ? timeleft(dur_timer) : duration, 0)

	var/act_str = ""
	if(can_complete())
		act_str = "Turn in"

	var/can_turn_in = FALSE
	var/list/acceptable_items = list()
	for(var/atom/movable/item_on_pad in items_on_pad)
		if(can_turn_in(item_on_pad))
			acceptable_items += list(item_on_pad.name)
			can_turn_in = TRUE
			break

	return list(
		"ref" = REF(src),
		"name" = src.name,
		"author" = src.author,
		"desc" = src.desc,
		"rewards" = src.reward_flavortext(),
		"faction" = SSfactions.faction_name(src.faction),
		"location" = "X[mission_location.x]/Y[mission_location.y]: [mission_location.name]",
		"x" = mission_location.x,
		"y" = mission_location.y,
		"duration" = src.duration,
		"remaining" = time_remaining,
		"timeStr" = time2text(time_remaining, "mm:ss"),
		"progressStr" = get_progress_string(),
		"actStr" = act_str,
		"canTurnIn" = can_turn_in,
		"validItems" = acceptable_items
	)

/datum/dynamic_mission/proc/get_progress_string()
	return "null"

/**
 * Spawns a "bound" atom of the given type at the given location. When the "bound" atom
 * is qdeleted, the passed-in callback is invoked, and, by default, the mission fails.
 *
 * Intended to be used to spawn mission-linked atoms that can have
 * references saved without causing harddels.
 *
 * Arguments:
 * * a_type - The type of the atom to be spawned. Must be of type /atom/movable.
 * * a_loc - The location to spawn the bound atom at.
 * * destroy_cb - The callback to invoke when the bound atom is qdeleted. Default is null.
 * * fail_on_delete - Bool; whether the mission should fail when the bound atom is qdeleted. Default TRUE.
 * * sparks - Whether to spawn sparks after spawning the bound atom. Default TRUE.
 */
/datum/dynamic_mission/proc/spawn_bound(atom/movable/a_type, a_loc, destroy_cb = null, fail_on_delete = TRUE, sparks = TRUE)
	if(!ispath(a_type, /atom/movable))
		CRASH("[src] attempted to spawn bound atom of invalid type [a_type]!")
	var/atom/movable/bound = new a_type(a_loc)
	if(sparks)
		do_sparks(3, FALSE, get_turf(bound))
	LAZYSET(bound_atoms, bound, list(fail_on_delete, destroy_cb))
	RegisterSignal(bound, COMSIG_PARENT_QDELETING, PROC_REF(bound_deleted))
	return bound

/datum/dynamic_mission/proc/set_bound(atom/movable/bound, destroy_cb = null, fail_on_delete = TRUE, sparks = TRUE)
	if(sparks)
		do_sparks(3, FALSE, get_turf(bound))
	LAZYSET(bound_atoms, bound, list(fail_on_delete, destroy_cb))
	RegisterSignal(bound, COMSIG_PARENT_QDELETING, PROC_REF(bound_deleted))
	return bound

/**
 * Removes the given atom from the mission's bound items, then qdeletes it.
 * Does not invoke the callback or fail the mission; optionally creates sparks.
 *
 * Arguments:
 * * bound - The bound atom to recall.
 * * sparks - Whether to spawn sparks on the turf the bound atom is located on. Default TRUE.
 */
/datum/dynamic_mission/proc/recall_bound(atom/movable/bound, sparks = TRUE)
	if(sparks)
		do_sparks(3, FALSE, get_turf(bound))
	remove_bound(bound)
	qdel(bound)

/// Signal handler for the qdeletion of bound atoms.
/datum/dynamic_mission/proc/bound_deleted(atom/movable/bound, force)
	SIGNAL_HANDLER
	var/list/bound_info = bound_atoms[bound]
	// first value in bound_info is whether to fail on item destruction
	failed = bound_info[1]
	// second value is callback to fire on atom destruction
	if(bound_info[2] != null)
		var/datum/callback/CB = bound_info[2]
		CB.Invoke()
	remove_bound(bound)

/**
 * Removes the given bound atom from the list of bound atoms.
 * Does not invoke the associated callback or fail the mission.
 *
 * Arguments:
 * * bound - The bound atom to remove.
 */
/datum/dynamic_mission/proc/remove_bound(atom/movable/bound)
	UnregisterSignal(bound, COMSIG_PARENT_QDELETING)
	// delete the callback
	qdel(LAZYACCESSASSOC(bound_atoms, bound, 2))
	// remove info from our list
	LAZYREMOVE(bound_atoms, bound)

/obj/effect/landmark/mission_poi
	icon = 'icons/effects/mission_poi.dmi'
	icon_state = "main_thingy"
	///Assume the item we want is included in the map and we simple have to return it
	var/already_spawned = FALSE
	///Only used if we dont pass a type in the mission.
	var/type_to_spawn

/obj/effect/landmark/mission_poi/Initialize()
	. = ..()
	SSmissions.unallocated_pois += list(src)

/obj/effect/landmark/mission_poi/Destroy()
	SSmissions.unallocated_pois -= src
	. = ..()

/obj/effect/landmark/mission_poi/proc/use_poi(_type_to_spawn)
	var/atom/item_of_intrest
	//Only use the type_to_spawn we have if a type is not passed
	if(ispath(_type_to_spawn))
		type_to_spawn = _type_to_spawn
	if(already_spawned) //Search for the item
		for(var/atom/movable/item_in_poi as anything in get_turf(src))
			if(istype(item_in_poi, type_to_spawn))
				item_of_intrest = item_in_poi
		stack_trace("[src] is meant to have its item prespawned but could not find it on its tile, resorting to spawning the type instead.")
	else //Spawn the item
		item_of_intrest = new type_to_spawn(loc)
	// We dont have an item to return
	if(!istype(item_of_intrest))
		CRASH("[src] did not return a item_of_intrest")
	qdel(src)
	return item_of_intrest

/// Instead of spawning something its used to find a matching item already in the map and returns that. For if you want to use an already exisiting part of the ruin.
/obj/effect/landmark/mission_poi/pre_loaded
	already_spawned = TRUE

