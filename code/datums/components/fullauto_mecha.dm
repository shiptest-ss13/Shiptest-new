#define AUTOFIRE_MOUSEUP 0
#define AUTOFIRE_MOUSEDOWN 1

/datum/component/automatic_fire_mecha
	var/client/clicker
	var/mob/living/shooter
	var/atom/target
	var/turf/target_loc //For dealing with locking on targets due to BYOND engine limitations (the mouse input only happening when mouse moves).
	var/autofire_stat = AUTOFIRE_STAT_IDLE
	var/mouse_parameters
	var/autofire_shot_delay = 0.1 SECONDS //Time between individual shots.
	var/mouse_status = AUTOFIRE_MOUSEUP //This seems hacky but there can be two MouseDown() without a MouseUp() in between if the user holds click and uses alt+tab, printscreen or similar.
	var/enabled = TRUE

	COOLDOWN_DECLARE(next_shot_cd)

/datum/component/automatic_fire_mecha/Initialize(_autofire_shot_delay)
	. = ..()
	if(!ismecha(parent))
		return COMPONENT_INCOMPATIBLE
	var/obj/mecha/parent_mech = parent
	// have wake up on initialize or pilot boardings / maybe on equip full auto gun?
	RegisterSignal(parent, COMSIG_MECH_ENTERED, PROC_REF(wake_up))
	RegisterSignal(parent, COMSIG_MECH_DISABLE_AUTOFIRE, PROC_REF(disable_autofire))
	RegisterSignal(parent, COMSIG_MECH_ENABLE_AUTOFIRE, PROC_REF(enable_autofire))
	RegisterSignal(parent, COMSIG_MECH_SET_AUTOFIRE_SPEED, PROC_REF(set_autofire_speed))
	if(_autofire_shot_delay)
		autofire_shot_delay = _autofire_shot_delay
	if(autofire_stat == AUTOFIRE_STAT_IDLE && ismob(parent_mech.occupant))
		var/mob/user = parent_mech.occupant
		wake_up(parent_mech, user)


/datum/component/automatic_fire_mecha/Destroy()
	autofire_off()
	return ..()

/datum/component/automatic_fire_mecha/process(delta_time)
	if(autofire_stat != AUTOFIRE_STAT_FIRING)
		STOP_PROCESSING(SSprojectiles, src)
		return

	process_shot()

/datum/component/automatic_fire_mecha/proc/wake_up(obj/mecha/mech, mob/user)
	SIGNAL_HANDLER

	if(autofire_stat == AUTOFIRE_STAT_ALERT)
		return //We've updated the firemode. No need for more.
	if(autofire_stat == AUTOFIRE_STAT_FIRING)
		stop_autofiring() //Let's stop shooting to avoid issues.
		return
	if(iscarbon(user))
		var/mob/living/carbon/arizona_ranger = user
		if(arizona_ranger == mech.occupant)
			autofire_on(arizona_ranger.client)


// There is a mech and there is a user piloting it. The component now waits for the mouse click.
/datum/component/automatic_fire_mecha/proc/autofire_on(client/usercli)
	SIGNAL_HANDLER

	if(autofire_stat != AUTOFIRE_STAT_IDLE)
		return
	autofire_stat = AUTOFIRE_STAT_ALERT
	if(!QDELETED(usercli))
		clicker = usercli
		shooter = clicker.mob
		RegisterSignal(clicker, COMSIG_CLIENT_MOUSEDOWN, PROC_REF(on_mouse_down))
	if(!QDELETED(shooter))
		RegisterSignal(shooter, COMSIG_MOB_LOGOUT, PROC_REF(autofire_off))
		UnregisterSignal(shooter, COMSIG_MOB_LOGIN)
	RegisterSignal(parent, list(COMSIG_PARENT_QDELETING, COMSIG_MECH_EXITED), PROC_REF(autofire_off))
	parent.RegisterSignal(src, COMSIG_AUTOFIRE_ONMOUSEDOWN, TYPE_PROC_REF(/obj/mecha, autofire_bypass_check))
	parent.RegisterSignal(parent, COMSIG_AUTOFIRE_SHOT, TYPE_PROC_REF(/obj/mecha, do_autofire))

/datum/component/automatic_fire_mecha/proc/autofire_off(datum/source)
	SIGNAL_HANDLER
	if(autofire_stat == AUTOFIRE_STAT_IDLE)
		return
	if(autofire_stat == AUTOFIRE_STAT_FIRING)
		stop_autofiring()

	autofire_stat = AUTOFIRE_STAT_IDLE

	if(!QDELETED(clicker))
		UnregisterSignal(clicker, list(COMSIG_CLIENT_MOUSEDOWN, COMSIG_CLIENT_MOUSEUP, COMSIG_CLIENT_MOUSEDRAG))
	mouse_status = AUTOFIRE_MOUSEUP //In regards to the component there's no click anymore to care about.
	clicker = null
	if(!QDELETED(shooter))
		RegisterSignal(shooter, COMSIG_MOB_LOGIN, PROC_REF(on_client_login))
		UnregisterSignal(shooter, COMSIG_MOB_LOGOUT)
	UnregisterSignal(parent, list(COMSIG_PARENT_QDELETING, COMSIG_MECH_EXITED))
	shooter = null
	parent.UnregisterSignal(parent, COMSIG_AUTOFIRE_SHOT)
	parent.UnregisterSignal(src, COMSIG_AUTOFIRE_ONMOUSEDOWN)

/datum/component/automatic_fire_mecha/proc/on_client_login(mob/source)
	SIGNAL_HANDLER
	if(!source.client)
		return
	if(source.is_holding(parent))
		autofire_on(source.client)

/datum/component/automatic_fire_mecha/proc/on_mouse_down(client/source, atom/_target, turf/location, control, params)
	SIGNAL_HANDLER
	var/list/modifiers = params2list(params) //If they're shift+clicking, for example, let's not have them accidentally shoot.

	if(!enabled)
		return
	if(LAZYACCESS(modifiers, SHIFT_CLICK))
		return
	if(LAZYACCESS(modifiers, CTRL_CLICK))
		return
	if(LAZYACCESS(modifiers, MIDDLE_CLICK))
		return
	if(LAZYACCESS(modifiers, ALT_CLICK))
		return
	if(source.mob.throw_mode)
		return
	if(get_dist(source.mob, _target) < 2) //Adjacent clicking.
		return

	if(isnull(location)) //Clicking on a screen object.
		if(_target.plane != CLICKCATCHER_PLANE) //The clickcatcher is a special case. We want the click to trigger then, under it.
			return //If we click and drag on our worn backpack, for example, we want it to open instead.
		_target = params2turf(modifiers["screen-loc"], get_turf(source.eye), source)
		if(!_target)
			CRASH("Failed to get the turf under clickcatcher")

	if(SEND_SIGNAL(src, COMSIG_AUTOFIRE_ONMOUSEDOWN, source, _target, location, control, params) & COMPONENT_AUTOFIRE_ONMOUSEDOWN_BYPASS)
		return

	source.click_intercept_time = world.time //From this point onwards Click() will no longer be triggered.

	if(autofire_stat == (AUTOFIRE_STAT_IDLE))
		CRASH("on_mouse_down() called with [autofire_stat] autofire_stat")
	if(autofire_stat == AUTOFIRE_STAT_FIRING)
		stop_autofiring() //This can happen if we click and hold and then alt+tab, printscreen or other such action. MouseUp won't be called then and it will keep autofiring.

	target = _target
	target_loc = get_turf(target)
	mouse_parameters = params
	INVOKE_ASYNC(src, PROC_REF(start_autofiring))


//Dakka-dakka
/datum/component/automatic_fire_mecha/proc/start_autofiring()
	if(autofire_stat == AUTOFIRE_STAT_FIRING)
		return //Already pew-pewing.
	autofire_stat = AUTOFIRE_STAT_FIRING

	clicker.mouse_override_icon = 'icons/effects/mouse_pointers/weapon_pointer.dmi'
	clicker.mouse_pointer_icon = clicker.mouse_override_icon

	if(mouse_status == AUTOFIRE_MOUSEUP) //See mouse_status definition for the reason for this.
		RegisterSignal(clicker, COMSIG_CLIENT_MOUSEUP, PROC_REF(on_mouse_up))
		mouse_status = AUTOFIRE_MOUSEDOWN

	RegisterSignal(shooter, COMSIG_MOB_SWAP_HANDS, PROC_REF(stop_autofiring))

	if(ismecha(parent))
		var/obj/mecha/shoota = parent
		if(!shoota.on_autofire_start(shooter=shooter)) //This is needed because the minigun has a do_after before firing and signals are async.
			stop_autofiring()
			return
	if(autofire_stat != AUTOFIRE_STAT_FIRING)
		return //Things may have changed while on_autofire_start() was being processed, due to do_after's sleep.

	if(!process_shot()) //First shot is processed instantly.
		return //If it fails, such as when the gun is empty, then there's no need to schedule a second shot.

	START_PROCESSING(SSprojectiles, src)
	RegisterSignal(clicker, COMSIG_CLIENT_MOUSEDRAG, PROC_REF(on_mouse_drag))


/datum/component/automatic_fire_mecha/proc/on_mouse_up(datum/source, atom/object, turf/location, control, params)
	SIGNAL_HANDLER
	UnregisterSignal(clicker, COMSIG_CLIENT_MOUSEUP)
	mouse_status = AUTOFIRE_MOUSEUP
	if(autofire_stat == AUTOFIRE_STAT_FIRING)
		stop_autofiring()
	return COMPONENT_CLIENT_MOUSEUP_INTERCEPT


/datum/component/automatic_fire_mecha/proc/stop_autofiring(datum/source, atom/object, turf/location, control, params)
	SIGNAL_HANDLER
	if(autofire_stat != AUTOFIRE_STAT_FIRING)
		return
	STOP_PROCESSING(SSprojectiles, src)
	autofire_stat = AUTOFIRE_STAT_ALERT
	if(clicker)
		clicker.mouse_override_icon = null
		clicker.mouse_pointer_icon = clicker.mouse_override_icon
		UnregisterSignal(clicker, COMSIG_CLIENT_MOUSEDRAG)
	if(!QDELETED(shooter))
		UnregisterSignal(shooter, COMSIG_MOB_SWAP_HANDS)
	target = null
	target_loc = null
	mouse_parameters = null

/datum/component/automatic_fire_mecha/proc/on_mouse_drag(client/source, atom/src_object, atom/over_object, turf/src_location, turf/over_location, src_control, over_control, params)
	SIGNAL_HANDLER
	if(isnull(over_location)) //This happens when the mouse is over an inventory or screen object, or on entering deep darkness, for example.
		var/list/modifiers = params2list(params)
		var/new_target = params2turf(modifiers["screen-loc"], get_turf(source.eye), source)
		mouse_parameters = params
		if(!new_target)
			if(QDELETED(target)) //No new target acquired, and old one was deleted, get us out of here.
				stop_autofiring()
				CRASH("on_mouse_drag failed to get the turf under screen object [over_object.type]. Old target was incidentally QDELETED.")
			target = get_turf(target) //If previous target wasn't a turf, let's turn it into one to avoid locking onto a potentially moving target.
			target_loc = target
			CRASH("on_mouse_drag failed to get the turf under screen object [over_object.type]")
		target = new_target
		target_loc = new_target
		return
	target = over_object
	target_loc = get_turf(over_object)
	mouse_parameters = params


/datum/component/automatic_fire_mecha/proc/process_shot()
	if(autofire_stat != AUTOFIRE_STAT_FIRING)
		return FALSE
	if(!COOLDOWN_FINISHED(src, next_shot_cd))
		return TRUE
	if(QDELETED(target) || get_turf(target) != target_loc) //Target moved or got destroyed since we last aimed.
		target = target_loc //So we keep firing on the emptied tile until we move our mouse and find a new target.
	if(get_dist(shooter, target) <= 0)
		target = get_step(shooter, shooter.dir) //Shoot in the direction faced if the mouse is on the same tile as we are.
		target_loc = target
	else if(!in_view_range(shooter, target))
		stop_autofiring() //Elvis has left the building.
		return FALSE
	COOLDOWN_START(src, next_shot_cd, autofire_shot_delay)
	if(SEND_SIGNAL(parent, COMSIG_AUTOFIRE_SHOT, target, shooter, mouse_parameters) & COMPONENT_AUTOFIRE_SHOT_SUCCESS)
		return TRUE
	stop_autofiring()
	return FALSE

// Gun procs.

/obj/mecha/proc/on_autofire_start(datum/source, atom/target, mob/living/shooter, params)
	if(shooter.stat)
		return FALSE
	return TRUE


/obj/mecha/proc/autofire_bypass_check(datum/source, client/clicker, atom/target, turf/location, control, params)
	SIGNAL_HANDLER
	if(clicker.mob != occupant)
		return COMPONENT_AUTOFIRE_ONMOUSEDOWN_BYPASS


/obj/mecha/proc/do_autofire(datum/source, atom/target, mob/living/shooter, params)
	SIGNAL_HANDLER
	if(shooter.incapacitated())
		return NONE
	INVOKE_ASYNC(src, PROC_REF(do_autofire_shot), source, target, shooter, params)
	return COMPONENT_AUTOFIRE_SHOT_SUCCESS //All is well, we can continue shooting.


/obj/mecha/proc/do_autofire_shot(datum/source, atom/target, mob/living/shooter, params)
	click_action(target,shooter,params)

/datum/component/automatic_fire_mecha/proc/disable_autofire(datum/source)
	enabled = FALSE

/datum/component/automatic_fire_mecha/proc/enable_autofire(datum/source)
	enabled = TRUE

/datum/component/automatic_fire_mecha/proc/set_autofire_speed(datum/source, newspeed)
	autofire_shot_delay = newspeed

#undef AUTOFIRE_MOUSEUP
#undef AUTOFIRE_MOUSEDOWN
