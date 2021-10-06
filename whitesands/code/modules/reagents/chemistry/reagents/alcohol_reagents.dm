/datum/reagent/consumable/ethanol/spriters_bane
	name = "Spriter's Bane"
	description = "A drink to fill your very SOUL."
	color = "#800080"
	boozepwr = 30
	quality = DRINK_GOOD
	taste_description = "microsoft paints"
	glass_icon_state = "uglydrink"
	glass_name = "Spriter's Bane"
	glass_desc = "Tastes better than it looks."

/datum/reagent/consumable/ethanol/spriters_bane/on_mob_life(mob/living/carbon/C)
	switch(current_cycle)
		if(5 to 40)
			C.jitteriness += 3
			if(prob(10) && !C.eye_blurry)
				C.blur_eyes(6)
				to_chat(C, "<span class='warning'>That outline is so distracting, it's hard to look at anything else!</span>")
		if(40 to 100)
			C.Dizzy(10)
			if(prob(15))
				new /datum/hallucination/hudscrew(C)
		if(100 to INFINITY)
			if(prob(10) && !C.eye_blind)
				C.blind_eyes(6)
				to_chat(C, "<span class='userdanger'>Your vision fades as your eyes are outlined in black!</span>")
			else
				C.Dizzy(20)
	..()

/datum/reagent/consumable/ethanol/spriters_bane/expose_atom(atom/A, volume)
	A.AddComponent(/datum/component/outline)
	..()
	
	//edwrb custom mixes begin here

/datum/reagent/consumable/ethanol/freezer_burn
	name = "Freezer Burn"
	description = "Fire and ice combine in your mouth! Drinking slowly recommended."
	boozepwr = 40
	color = "#ba3100"
	quality = DRINK_FANTASTIC
	taste_description = "hot, spicy, refreshing mint."
	glass_icon_state = "freezer_burn"
	glass_name = "Freezer Burn"
	glass_desc = "Fire and ice combine in your mouth! Drinking slowly recommended."
	
/datum/reagent/consumable/freezer_burn/on_mob_life(mob/living/carbon/M)
	M.adjustFireLoss(-0.2, 0)
	..()
	. = 1

/datum/reagent/consumable/ethanol/out_of_touch
	name = "Out of Touch"
	description = "Perfect for when you're out of time."
	boozepwr = 40
	color = "#ff9200"
	quality = DRINK_FANTASTIC
	taste_description = "a dry, salty orange."
	glass_icon_state = "out_of_touch"
	glass_name = "Out of Touch"
	glass_desc = "Perfect for when you're out of time."
	
/datum/reagent/consumable/ethanol/out_of_touch/expose_obj(obj/O, reac_volume)
	if(istype(O, /obj/item/stack/sheet/metal))
		var/obj/item/stack/sheet/metal/M = O
		reac_volume = min(reac_volume, M.amount)
		new/obj/item/stack/tile/bronze(get_turf(M), reac_volume)
		M.use(reac_volume)

/datum/reagent/consumable/ethanol/darkest_chocolate
	name = "Darkest Chocolate"
	description = "Darkness within darkness awaits you, spaceman!"
	boozepwr = 40
	color = "#240c0c"
	quality = DRINK_FANTASTIC
	taste_description = "bitter chocolate dancing with alcohol and the spirit of the Irish."
	glass_icon_state = "darkest_chocolate"
	glass_name = "Darkest Chocolate"
	glass_desc = "Darkness within darkness awaits you, spaceman!"

/datum/reagent/consumable/ethanol/archmagus_brew
	name = "Archmagus' Brew"
	description = "Said to have been requested by a great Archmagus, hence the name. Tastes like tough love."
	boozepwr = 40
	color = "#c75295"
	quality = DRINK_FANTASTIC
	taste_description = "a slap in the face in the best possible way, friendship, and a bitter spike with a sour aftertaste!"
	glass_icon_state = "archmagus_brew"
	glass_name = "Archmagus' Brew"
	glass_desc = "Said to have been requested by a great Archmagus, hence the name. Tastes like tough love."

/datum/reagent/consumable/ethanol/out_of_lime
	name = "Out of Lime"
	description = "A spin on the classic. Artists and street fighters swear by this stuff."
	boozepwr = 40
	color = "#c75295"
	quality = DRINK_VERYGOOD
	taste_description = "alternate palettes, copycats, and fierce plus short."
	glass_icon_state = "out_of_lime"
	glass_name = "Out of Lime"
	glass_desc = "A spin on the classic. Artists and street fighters swear by this stuff."
