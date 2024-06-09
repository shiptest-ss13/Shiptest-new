/obj/item/attachment/bayonet
	name = "bayonet"
	desc = "Stabby-Stabby"
	icon_state = "bayonet"
	force = 15
	throwforce = 10
	pixel_shift_x = 1
	pixel_shift_y = 4
	pickup_sound =  'sound/items/handling/knife1_pickup.ogg'
	drop_sound = 'sound/items/handling/knife3_drop.ogg'
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	sharpness = IS_SHARP_ACCURATE

	spread_mod = 1

/obj/item/attachment/bayonet/PreAttack(obj/item/gun/gun, atom/target, mob/living/user, list/params)
	if(user.a_intent == INTENT_HARM && user.CanReach(target, src, TRUE))
		melee_attack_chain(user, target, params)
		return COMPONENT_NO_ATTACK

