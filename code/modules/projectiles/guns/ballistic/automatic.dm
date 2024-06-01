
/obj/item/gun/ballistic/automatic
	w_class = WEIGHT_CLASS_NORMAL
	can_suppress = TRUE

	gun_firemodes = list(FIREMODE_SEMIAUTO)
	default_firemode = FIREMODE_SEMIAUTO
	semi_auto = TRUE
	fire_sound = 'sound/weapons/gun/smg/shot.ogg'
	fire_sound_volume = 90
	vary_fire_sound = FALSE
	rack_sound = 'sound/weapons/gun/smg/smgrack.ogg'
	suppressed_sound = 'sound/weapons/gun/smg/shot_suppressed.ogg'
	weapon_weight = WEAPON_MEDIUM
	pickup_sound =  'sound/items/handling/rifle_pickup.ogg'

	fire_delay = 0.4 SECONDS
	wield_delay = 1 SECONDS
	spread = 0
	spread_unwielded = 13
	recoil = 0
	recoil_unwielded = 4
	wield_slowdown = 0.35


// SNIPER //

/obj/item/gun/ballistic/automatic/sniper_rifle
	name = "sniper rifle"
	desc = "An anti-material rifle chambered in .50 BMG with a scope mounted on it. Its prodigious bulk requires both hands to use."
	icon_state = "sniper"
	item_state = "sniper"
	fire_sound = 'sound/weapons/gun/sniper/shot.ogg'
	fire_sound_volume = 90
	vary_fire_sound = FALSE
	load_sound = 'sound/weapons/gun/sniper/mag_insert.ogg'
	rack_sound = 'sound/weapons/gun/sniper/rack.ogg'
	suppressed_sound = 'sound/weapons/gun/general/heavy_shot_suppressed.ogg'
	recoil = 2
	weapon_weight = WEAPON_HEAVY
	mag_type = /obj/item/ammo_box/magazine/sniper_rounds
	burst_size = 1
	w_class = WEIGHT_CLASS_NORMAL
	zoomable = TRUE
	zoom_amt = 10 //Long range, enough to see in front of you, but no tiles behind you.
	zoom_out_amt = 5
	slot_flags = ITEM_SLOT_BACK
	actions_types = list()
	show_magazine_on_sprite = TRUE
	manufacturer = MANUFACTURER_SCARBOROUGH

	spread = -5
	spread_unwielded = 20
	recoil = 5
	recoil_unwielded = 50
	wield_slowdown = 1
	wield_delay = 1.3 SECONDS

/obj/item/gun/ballistic/automatic/sniper_rifle/syndicate
	name = "syndicate sniper rifle"
	desc = "A heavily-modified .50 BMG anti-material rifle utilized by Syndicate agents. Requires both hands to fire."
	can_suppress = TRUE
	can_unsuppress = TRUE

// Old Semi-Auto Rifle //

/obj/item/gun/ballistic/automatic/surplus //TODO: NEEDS TO BE REPLACED WITH PISTOL CARBINES OR LOWCAL SEMI-AUTO RIFLES
	name = "surplus rifle"
	desc = "One of countless cheap, obsolete rifles found throughout the Frontier. Its lack of lethality renders it mostly a deterrent. Chambered in 10mm."
	icon_state = "surplus"
	item_state = "moistnugget"
	weapon_weight = WEAPON_HEAVY
	mag_type = /obj/item/ammo_box/magazine/m10mm/rifle
	fire_delay = 0.5 SECONDS
	burst_size = 1
	can_unsuppress = TRUE
	can_suppress = TRUE
	w_class = WEIGHT_CLASS_HUGE
	slot_flags = ITEM_SLOT_BACK
	show_magazine_on_sprite = TRUE

// Laser rifle (rechargeable magazine) //

/obj/item/gun/ballistic/automatic/laser //TODO: REMOVE
	name = "laser rifle"
	desc = "Though sometimes mocked for the relatively weak firepower of their energy weapons, the logistic miracle of rechargeable ammunition has given Nanotrasen a decisive edge over many a foe."
	icon_state = "oldrifle"
	item_state = "arg"
	mag_type = /obj/item/ammo_box/magazine/recharge
	fire_delay = 0.2 SECONDS
	can_suppress = FALSE
	burst_size = 0
	fire_sound = 'sound/weapons/laser.ogg'
	casing_ejector = FALSE

/obj/item/gun/ballistic/automatic/ebr //fuck this gun, its getting wiped soon enough
	name = "\improper M514 EBR"
	desc = "A reliable, high-powered battle rifle often found in the hands of Syndicate personnel and remnants, chambered in .308. Effective against personnel and armor alike."
	icon = 'icons/obj/guns/48x32guns.dmi'
	lefthand_file = 'icons/mob/inhands/weapons/64x_guns_left.dmi'
	righthand_file = 'icons/mob/inhands/weapons/64x_guns_right.dmi'
	icon_state = "ebr"
	item_state = "ebr"
	zoomable = TRUE
	show_magazine_on_sprite = TRUE
	weapon_weight = WEAPON_MEDIUM
	w_class = WEIGHT_CLASS_BULKY
	mag_type = /obj/item/ammo_box/magazine/ebr
	fire_sound = 'sound/weapons/gun/rifle/shot_alt2.ogg'
	burst_size = 0
	manufacturer = MANUFACTURER_SCARBOROUGH

	wield_slowdown = 2
	spread = -4

/obj/item/gun/ballistic/automatic/gal
	name = "\improper CM-GAL-S"
	desc = "The standard issue DMR of CLIP. Dates back to the Xenofauna War, this particular model is in a carbine configuration, and, as such, is shorter than the standard model. Chambered in .308."
	icon = 'icons/obj/guns/48x32guns.dmi'
	fire_sound = 'sound/weapons/gun/rifle/shot.ogg'
	icon_state = "gal"
	item_state = "gal"
	zoomable = TRUE
	show_magazine_on_sprite = TRUE
	weapon_weight = WEAPON_MEDIUM
	w_class = WEIGHT_CLASS_BULKY
	mag_type = /obj/item/ammo_box/magazine/gal
	fire_sound = 'sound/weapons/gun/rifle/gal.ogg'
	burst_size = 0
	actions_types = list()
	manufacturer = MANUFACTURER_MINUTEMAN

	wield_slowdown = 2
	spread = -4
	fire_select_icon_state_prefix = "clip_"
	adjust_fire_select_icon_state_on_safety = TRUE

/obj/item/gun/ballistic/automatic/gal/inteq
	name = "\improper SsG-04"
	desc = "A marksman rifle purchased from CLIP and modified to suit IRMG's needs. Chambered in .308."
	icon_state = "gal-inteq"
	item_state = "gal-inteq"

/obj/item/gun/ballistic/automatic/zip_pistol
	name = "makeshift pistol"
	desc = "A makeshift zip gun cobbled together from various scrap bits and chambered in 9mm. It's a miracle it even works."
	icon_state = "ZipPistol"
	item_state = "ZipPistol"
	mag_type = /obj/item/ammo_box/magazine/zip_ammo_9mm
	can_suppress = FALSE
	actions_types = list()
	can_bayonet = FALSE
	show_magazine_on_sprite = TRUE
	weapon_weight = WEAPON_LIGHT
