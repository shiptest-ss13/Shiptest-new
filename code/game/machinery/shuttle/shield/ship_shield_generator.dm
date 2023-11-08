// magnetocore - the core of the shield generator
// magnetosphere - the shield itself, on the ship

// now you might be thinking, if its a magnetosphere doesnt it only protect from magnetic materials?
// cope about it it sounds cool

/obj/machinery/power/ship_shield_generator
	name = "shield generator"
	desc = "A high complex machinery which uses an projected electromagnetic field to protect the ship from damage."
	icon = 'icons/obj/machines/shield_generator.dmi'
	icon_state = "core-off"
	// we only need power to spool up the shield, no power is used if the core is already charged
	active_power_usage = 2000
	use_power = ACTIVE_POWER_USE
	power_channel = AREA_USAGE_EQUIP

	max_integrity = 1000
	integrity_failure = 250
	var/repair_integrity = 125

	/// The ship we are linked to.
	var/datum/overmap/ship/controlled/linked_ship
	/// The apc we are drawing power from.
	var/obj/machinery/power/apc/linked_apc

	/// The rate of charge per tick.
	var/charge_rate
	/// The maximum charge of the core.
	var/charge_max
	/// The current charge of the core.
	var/charge
	/// The ratio of power to charge
	var/charge_ratio = 2

	/// The rate of spooling per tick.
	var/spool_rate
	/// The current spool percent.
	var/spool_percent
	/// The penalty for spooling while inoperable.
	var/spool_inoperable_penalty = 0.8

	var/inoperable_announced = FALSE

/obj/machinery/power/ship_shield_generator/update_icon_state()
	..()
	if(!is_operational || isnull(powernet))
		icon_state = "core-depower"
	else if(!spool_percent)
		icon_state = "core-off"
	else if(spool_percent < 100)
		icon_state = "core-spool"
	else
		icon_state = "core-stable"

/obj/machinery/power/ship_shield_generator/update_overlays()
	. = ..()
	switch(spool_percent)
		if(0)
			return
		if(1 to 33)
			. += "startup"
		if(34 to 66)
			. += "idle"
		if(67 to 99)
			. += "activating"
		if(100)
			. += "actived"

/obj/machinery/power/ship_shield_generator/update_overlays()
	. = ..()
	if(!is_operational)
		return

/obj/machinery/power/ship_shield_generator/connect_to_shuttle(obj/docking_port/mobile/port, obj/docking_port/stationary/dock)
	var/datum/overmap/ship/controlled/port_ship = port.current_ship
	if(isnull(port_ship))
		return

	if(!isnull(port_ship.shield_generator) && port_ship.shield_generator != src)
		say("Unable to link to ship magnetosphere array, interference detected.")
		return

	port_ship.shield_generator = src
	linked_ship = port_ship
	linked_ship.broadcast("Link established to ship magnetosphere array.")

/obj/machinery/power/ship_shield_generator/process()
	if(isnull(linked_ship))
		return PROCESS_KILL

	if(spool_percent < 100)
		process_spooling()
		return

	if(charge >= charge_max)
		return
	process_charge()

/obj/machinery/power/ship_shield_generator/proc/update_charge(new_charge)
	if(new_charge > charge_max)
		new_charge = charge_max
	charge = new_charge
	update_appearance()

/obj/machinery/power/ship_shield_generator/proc/process_spooling()
	if(!is_operational || isnull(powernet)) // you are very punished for not powering this
		spool_percent = max((spool_percent * spool_inoperable_penalty) - spool_rate, 0)
		if(!inoperable_announced)
			linked_ship.broadcast("Magenetocore power failure.")
			inoperable_announced = TRUE

	else
		spool_percent += spool_rate

	if(spool_percent >= 100)
		spool_percent = 100
		use_power = NO_POWER_USE
		linked_ship.broadcast("Ferrofluid magnetocore at maximum velocity. Shield operational.")
		inoperable_announced = FALSE
	update_appearance()

/obj/machinery/power/ship_shield_generator/proc/process_charge()
	var/wanted_charge = min(charge_max - charge, charge_rate)
	var/wanted_power = min(wanted_charge * charge_ratio, powernet.avail)
	var/actual_charge = wanted_power / charge_ratio
	use_power(wanted_power)
	update_charge(charge + actual_charge)

/// Call this when the shield is hit with enough force to outright break it
/obj/machinery/power/ship_shield_generator/proc/charge_depleted()
	set_machine_stat(machine_stat|BROKEN)
	linked_ship.broadcast("Critical failure in magnetocore, unable to error correct.")
	spool_percent = 0
	playsound(src, 'sound/mecha/mech_shield_drop.ogg', 50)

/obj/machinery/power/ship_shield_generator/welder_act(mob/living/user, obj/item/weldingtool/welder)
	if(obj_integrity >= max_integrity)
		return

	if(!welder.isOn())
		balloon_alert(user, "welder off!")
		return TRUE

	if(welder.get_fuel() < 2)
		balloon_alert(user, "not enough fuel!")
		return TRUE

	var/repair_time = 2 SECONDS
	balloon_alert(user, "repairing...")
	while(do_after(user, repair_time, target = src))
		if(!welder.use(2))
			balloon_alert(user, "not enough fuel!")
			return TRUE

		obj_integrity = min(obj_integrity + repair_integrity, max_integrity)
		if(obj_integrity >= max_integrity)
			balloon_alert(user, "repaired.")
			set_machine_stat(machine_stat & ~BROKEN)
			return TRUE

		if(repair_time > 0.5 SECONDS)
			repair_time -= 0.5 SECONDS

	balloon_alert(user, "stopped!")
	return TRUE
