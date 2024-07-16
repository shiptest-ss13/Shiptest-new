/*
 * Fireaxe
 */
/obj/item/fireaxe  // DEM AXES MAN, marker -Agouri
	icon_state = "fireaxe0"
	base_icon_state = "fireaxe"
	lefthand_file = 'icons/mob/inhands/weapons/axes_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/axes_righthand.dmi'
	name = "fire axe"
	desc = "Truly, the weapon of a madman. Who would think to fight fire with an axe?"
	force = 5
	throwforce = 15
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	attack_verb = list("attacked", "chopped", "cleaved", "torn", "cut")
	hitsound = 'sound/weapons/bladeslice.ogg'
	sharpness = IS_SHARP
	max_integrity = 200
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 100, "acid" = 30)
	resistance_flags = FIRE_PROOF
	var/wielded = FALSE // track wielded status on item

/obj/item/fireaxe/Initialize()
	. = ..()
	RegisterSignal(src, COMSIG_TWOHANDED_WIELD, PROC_REF(on_wield))
	RegisterSignal(src, COMSIG_TWOHANDED_UNWIELD, PROC_REF(on_unwield))

/obj/item/fireaxe/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/butchering, 100, 80, 0 , hitsound) //axes are not known for being precision butchering tools
	AddComponent(/datum/component/two_handed, force_unwielded=5, force_wielded=24, icon_wielded="[base_icon_state]1")

/// triggered on wield of two handed item
/obj/item/fireaxe/proc/on_wield(obj/item/source, mob/user)
	SIGNAL_HANDLER

	wielded = TRUE

/// triggered on unwield of two handed item
/obj/item/fireaxe/proc/on_unwield(obj/item/source, mob/user)
	SIGNAL_HANDLER

	wielded = FALSE

/obj/item/fireaxe/update_icon_state()
	icon_state = "[base_icon_state]0"
	return ..()

/obj/item/fireaxe/afterattack(atom/A, mob/user, proximity)
	. = ..()
	if(!proximity)
		return
	if(wielded) //destroys windows and grilles in one hit
		if(istype(A, /obj/structure/window) || istype(A, /obj/structure/grille))
			var/obj/structure/W = A
			W.obj_destruction("fireaxe")

/*
 * Bone Axe
 */
/obj/item/fireaxe/boneaxe  // Blatant imitation of the fireaxe, but made out of bone.
	icon_state = "bone_axe0"
	base_icon_state = "bone_axe"
	name = "bone axe"
	desc = "A large, vicious axe crafted out of several sharpened bone plates and crudely tied together. Made of monsters, by killing monsters, for killing monsters."
	icon = 'icons/obj/items_and_weapons.dmi'

/obj/item/fireaxe/boneaxe/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/two_handed, force_unwielded=5, force_wielded=23, icon_wielded="[base_icon_state]1")

/*
 * Dumb Cute Comment Title - Gorlex Hammers
 */
/obj/item/fireaxe/sledgehammer //add wall + structure damage later once Gristlebee's pr is merged
	icon_state = "fire_axe0"
	base icon_state = "fireaxe"
	lefthand_file = 'icons/mob/inhands/weapons/axes_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/axes_righthand.dmi'
	name = "breaching sledgehammer"
	desc = "A large, slow hammer used by the Gorlex Marauder splinters. As powerful as a weapon as it is a shipbreaking and mining tool."
	force = 5
	armour_penetration = 40
	attack_verb = list("bashed", "smashed", "crushed", "smacked")
	hitsound = 'sound/weapons/smash.ogg'
	sharpness = IS_BLUNT
	tool_behaviour = TOOL_MINING
	toolspeed = 0.5
	usesound = list('sound/effects/picaxe1.ogg', 'sound/effects/picaxe2.ogg', 'sound/effects/picaxe3.ogg')

/obj/item/fireaxe/sledgehammer/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/two_handed, force_unwielded=5, force_wielded=30, icon_wielded="[base_icon_state]1")

/obj/item/fireaxe/sledgehammer/melee_attack_chain(mob/user, atom/target, params)
	..()
	user.changeNext_move(CLICK_CD_MELEE * 1.7)
