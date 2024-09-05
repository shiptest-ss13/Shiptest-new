/obj/item/gun/ballistic/automatic/powered
	default_ammo_type = /obj/item/ammo_box/magazine/gauss
	reciever_flags = AMMO_RECIEVER_MAGAZINES|AMMO_RECIEVER_CELL

/obj/item/gun/ballistic/automatic/powered/examine_ammo_count(mob/user)
	var/list/dat = list()
	if(installed_cell)
		dat += span_notice("[src]'s cell is [round(installed_cell.charge / installed_cell.maxcharge, 0.1) * 100]% full.")
	else
		dat += span_notice("[src] doesn't seem to have a cell!")
	return dat

/obj/item/gun/ballistic/automatic/powered/can_shoot()
	if(QDELETED(installed_cell))
		return FALSE

	var/obj/item/ammo_casing/caseless/gauss/shot = chambered
	if(!shot)
		return FALSE
	if(installed_cell.charge < shot.energy_cost * burst_size)
		return FALSE
	return ..()

/obj/item/gun/ballistic/automatic/powered/before_firing(atom/target,mob/user)
	var/obj/item/ammo_casing/caseless/gauss/shot = chambered
	if(shot?.energy_cost)
		bullet_energy_cost = shot.energy_cost

/obj/item/gun/ballistic/automatic/powered/shoot_live_shot(mob/living/user, pointblank = FALSE, mob/pbtarget, message = 1, stam_cost = 0)
	installed_cell.use(bullet_energy_cost)
	return ..()

/obj/item/gun/ballistic/automatic/powered/reload(obj/item/new_mag, mob/living/user, params, force = FALSE)
	if(..())
		return TRUE
	if (!internal_cell && istype(new_mag, /obj/item/stock_parts/cell/gun))
		var/obj/item/stock_parts/cell/gun/new_cell = new_mag
		if(installed_cell)
			to_chat(user, span_warning("\The [new_mag] already has a cell"))
		insert_cell(user, new_cell)

/obj/item/gun/ballistic/automatic/powered/proc/insert_cell(mob/user, obj/item/stock_parts/cell/gun/C)
	if(user.transferItemToLoc(C, src))
		installed_cell = C
		to_chat(user, span_notice("You load the [C] into \the [src]."))
		playsound(src, load_sound, load_sound_volume, load_sound_vary)
		update_appearance()
		return TRUE
	else
		to_chat(user, span_warning("You cannot seem to get \the [src] out of your hands!"))
		return FALSE

/obj/item/gun/ballistic/automatic/powered/proc/eject_cell(mob/user, obj/item/stock_parts/cell/gun/tac_load = null)
	playsound(src, load_sound, load_sound_volume, load_sound_vary)
	installed_cell.forceMove(drop_location())
	var/obj/item/stock_parts/cell/gun/old_cell = installed_cell
	installed_cell = null
	user.put_in_hands(old_cell)
	old_cell.update_appearance()
	to_chat(user, span_notice("You pull the cell out of \the [src]."))
	update_appearance()

/obj/item/gun/ballistic/automatic/powered/screwdriver_act(mob/living/user, obj/item/I)
	if(installed_cell && !internal_cell)
		to_chat(user, span_notice("You begin unscrewing and pulling out the cell..."))
		if(I.use_tool(src, user, unscrewing_time, volume=100))
			to_chat(user, span_notice("You remove the power cell."))
			eject_cell(user)
	return ..()

/obj/item/gun/ballistic/automatic/powered/update_overlays()
	. = ..()
	if(!automatic_charge_overlays)
		return
	var/overlay_icon_state = "[icon_state]_charge"
	var/charge_ratio = get_charge_ratio()
	if(installed_cell)
		. += "[icon_state]_cell"
	if(charge_ratio == 0)
		. += "[icon_state]_cellempty"
	else
		if(!shaded_charge)
			var/mutable_appearance/charge_overlay = mutable_appearance(icon, overlay_icon_state)
			for(var/i in 1 to charge_ratio)
				charge_overlay.pixel_x = ammo_x_offset * (i - 1)
				charge_overlay.pixel_y = ammo_y_offset * (i - 1)
				. += new /mutable_appearance(charge_overlay)
		else
			. += "[icon_state]_charge[charge_ratio]"

/obj/item/gun/ballistic/automatic/powered/proc/get_charge_ratio()
	if(!installed_cell)
		return FALSE
	return CEILING(clamp(installed_cell.charge / installed_cell.maxcharge, 0, 1) * charge_sections, 1)// Sets the ratio to 0 if the gun doesn't have enough charge to fire, or if its power cell is removed.
