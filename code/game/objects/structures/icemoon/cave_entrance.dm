GLOBAL_LIST_INIT(ore_probability, list(
	/obj/item/stack/ore/uranium = 50,
	/obj/item/stack/ore/iron = 50,
	/obj/item/stack/ore/plasma = 75,
	/obj/item/stack/ore/silver = 50,
	/obj/item/stack/ore/gold = 50,
	/obj/item/stack/ore/diamond = 25,
	/obj/item/stack/ore/bananium = 5,
	/obj/item/stack/ore/titanium = 75,
	/obj/item/pickaxe/diamond = 5,
	/obj/item/t_scanner/adv_mining_scanner/lesser = 5,
	/obj/item/kinetic_crusher = 5,
	/obj/effect/mob_spawn/human/corpse/damaged/legioninfested = 5,
	/obj/item/tank/jetpack/suit = 5,
	/obj/item/survivalcapsule = 5,
	/obj/item/reagent_containers/hypospray/medipen/survival = 5,
	/obj/item/card/mining_point_card = 5,
	/obj/item/extraction_pack = 5,
	/obj/item/reagent_containers/food/drinks/beer = 5,
	))

/obj/structure/spawner/ice_moon
	name = "cave entrance"
	desc = "A hole in the ground, filled with monsters ready to defend it."
	icon = 'icons/mob/nest.dmi'
	icon_state = "hole"
	faction = list("mining")
	max_mobs = 3
	max_integrity = 250
	mob_types = list(/mob/living/simple_animal/hostile/asteroid/wolf)
	move_resist = INFINITY
	anchored = TRUE

/obj/structure/spawner/ice_moon/Initialize()
	. = ..()
	clear_rock()

/**
 * Clears rocks around the spawner when it is created
 *
 */
/obj/structure/spawner/ice_moon/proc/clear_rock()
	for(var/turf/F in RANGE_TURFS(2, src))
		if(abs(src.x - F.x) + abs(src.y - F.y) > 3)
			continue
		if(ismineralturf(F))
			var/turf/closed/mineral/M = F
			M.ScrapeAway(null, CHANGETURF_IGNORE_AIR)

/obj/structure/spawner/ice_moon/deconstruct(disassembled)
	destroy_effect()
	drop_loot()
	return ..()

/**
 * Effects and messages created when the spawner is destroyed
 *
 */
/obj/structure/spawner/ice_moon/proc/destroy_effect()
	playsound(loc,'sound/effects/explosionfar.ogg', 200, TRUE)
	visible_message("<span class='boldannounce'>[src] collapses, sealing everything inside!</span>\n<span class='warning'>Ores fall out of the cave as it is destroyed!</span>")

/**
 * Drops items after the spawner is destroyed
 *
 */
/obj/structure/spawner/ice_moon/proc/drop_loot()
	for(var/type in GLOB.ore_probability)
		var/chance = GLOB.ore_probability[type]
		if(!prob(chance))
			continue
		new type(loc, rand(5, 10))

/obj/structure/spawner/ice_moon/polarbear
	max_mobs = 1
	spawn_time = 60 SECONDS
	mob_types = list(/mob/living/simple_animal/hostile/asteroid/polarbear)

/obj/structure/spawner/ice_moon/polarbear/clear_rock()
	for(var/turf/F in RANGE_TURFS(1, src))
		if(ismineralturf(F))
			var/turf/closed/mineral/M = F
			M.ScrapeAway(null, CHANGETURF_IGNORE_AIR)

/obj/structure/spawner/ice_moon/demonic_portal
	name = "demonic portal"
	desc = "A portal that goes to another world, normal creatures couldn't survive there. When it collapses, who knows where it will go?"
	icon_state = "nether"
	mob_types = list(/mob/living/simple_animal/hostile/asteroid/ice_demon)
	light_range = 1
	light_color = COLOR_SOFT_RED

/obj/structure/spawner/ice_moon/demonic_portal/clear_rock()
	for(var/turf/F in RANGE_TURFS(3, src))
		if(abs(src.x - F.x) + abs(src.y - F.y) > 5)
			continue
		if(ismineralturf(F))
			var/turf/closed/mineral/M = F
			M.ScrapeAway(null, CHANGETURF_IGNORE_AIR)

/obj/structure/spawner/ice_moon/demonic_portal/Initialize()
	. = ..()
	AddComponent(/datum/component/gps, "Netheric Signal")

/obj/structure/spawner/ice_moon/demonic_portal/destroy_effect()
	new /obj/effect/collapsing_demonic_portal(loc)

/obj/structure/spawner/ice_moon/demonic_portal/drop_loot()
	return

/obj/structure/spawner/ice_moon/demonic_portal/ice_whelp
	mob_types = list(/mob/living/simple_animal/hostile/asteroid/ice_whelp)

/obj/structure/spawner/ice_moon/demonic_portal/snowlegion
	mob_types = list(/mob/living/simple_animal/hostile/asteroid/hivelord/legion/snow)

/obj/effect/collapsing_demonic_portal
	name = "collapsing demonic portal"
	desc = "It's slowly fading! Get ready to fight whatever comes through!"
	layer = TABLE_LAYER
	icon = 'icons/mob/nest.dmi'
	icon_state = "nether"
	anchored = TRUE
	density = TRUE

/obj/effect/collapsing_demonic_portal/Initialize()
	. = ..()
	playsound(loc,'sound/effects/tendril_destroyed.ogg', 200, FALSE, 50, TRUE, TRUE)
	visible_message("<span class='boldannounce'>[src] begins to collapse! As it fails, it connects to a random dimensional point and pulls through what it finds!</span>")
	animate(src, transform = matrix().Scale(0, 1), alpha = 50, time = 5 SECONDS)
	addtimer(CALLBACK(src, .proc/collapse), 5 SECONDS)

/**
 * Handles portal deletion
 *
 */
/obj/effect/collapsing_demonic_portal/proc/collapse()
	drop_loot()
	qdel(src)

/**
 * Drops loot from the portal. Uses variable difficulty based on drops- more valulable rewards will also add additional enemies to the attack wave.
 * If you manage to win big and get a bunch of major rich loot, you will also be faced with a big mob of angries.
 * Absolutely deranged use of probability code below, trigger warning
 */
/obj/effect/collapsing_demonic_portal/proc/drop_loot()
	visible_message("<span class='warning'>Something slips out of [src]!</span>")
	var/loot = rand(1, 24)
	switch(loot)
		if(1)//Clown hell. God help you if you roll this.
			visible_message("<span class='userdanger'>You can hear screaming and joyful honking.</span>")//now THIS is what we call a critical failure
			if(prob(35))
				new /mob/living/simple_animal/hostile/clown/clownhulk(loc)
			new /mob/living/simple_animal/hostile/clown/longface(loc)
			if(prob(35))
				new /mob/living/simple_animal/hostile/clown/banana(loc)
			if(prob(35))
				new /mob/living/simple_animal/hostile/clown/fleshclown(loc)
				new /mob/living/simple_animal/hostile/clown/fleshclown(loc)
			new /mob/living/simple_animal/hostile/clown/honkling(loc)
			if(prob(35))
				new /mob/living/simple_animal/hostile/clown/clownhulk/chlown(loc)
			if(prob(25))
				new /mob/living/simple_animal/hostile/clown/mutant/blob(loc)//oh god oh fuck
			if(prob(25))
				new /obj/item/veilrender/honkrender/honkhulkrender(loc)
			else
				new /obj/item/veilrender/honkrender(loc)
			if(prob(25))
				new /obj/item/storage/backpack/duffelbag/clown/syndie(loc)
				new /mob/living/simple_animal/hostile/clown/fleshclown(loc)
			else
				new /obj/item/storage/backpack/duffelbag/clown/cream_pie(loc)
			if(prob(25))
				new /obj/item/borg/upgrade/transform/clown(loc)
			if(prob(25))
				new /obj/item/megaphone/clown(loc)
			if(prob(25))
				new /obj/item/clothing/suit/space/hardsuit/clown
				new /mob/living/simple_animal/hostile/clown/fleshclown(loc)
			if(prob(25))
				new /obj/item/gun/magic/staff/honk(loc)
				new /mob/living/simple_animal/hostile/clown/fleshclown(loc)
			if(prob(15))
				new /obj/item/clothing/shoes/clown_shoes/banana_shoes/combat(loc)
				new /mob/living/simple_animal/hostile/clown/fleshclown(loc)
			new /obj/item/stack/sheet/mineral/bananium(loc)
			new /turf/open/floor/mineral/bananium(loc)
		if(2)//basic demonic incursion
			visible_message("<span class='userdanger'>You glimpse an indescribable abyss in the portal. Horrifying monsters appear in a gout of flame.</span>")
			if(prob(25))
				new /obj/item/clothing/glasses/godeye(loc)
				new /mob/living/simple_animal/hostile/netherworld/migo(loc)
			if(prob(35))
				new /obj/item/wisp_lantern(loc)
				new /mob/living/simple_animal/hostile/netherworld/blankbody(loc)
			if(prob(25))
				new /obj/item/organ/heart/demon(loc)
				new /mob/living/simple_animal/hostile/netherworld(loc)
			if(prob(5))
				new /obj/item/his_grace(loc)//trust me, it's not worth the trouble.
				new /mob/living/simple_animal/hostile/netherworld/migo(loc)
				new /mob/living/simple_animal/hostile/netherworld/blankbody(loc)
			if(prob(35))
				new /obj/item/nullrod/staff(loc)
			if(prob(50))
				new /obj/item/clothing/suit/space/hardsuit/quixote/dimensional(loc)
			else
				new /obj/item/immortality_talisman(loc)
			new /mob/living/simple_animal/hostile/netherworld/blankbody(loc)
			new /mob/living/simple_animal/hostile/netherworld/migo(loc)
			new /mob/living/simple_animal/hostile/netherworld(loc)
			new /turf/open/indestructible/necropolis(loc)
		if(3)//skeleton/religion association, now accepting YOUR BONES
			visible_message("<span class='userdanger'>Bones rattle and strained voices chant a forgotten god's name.</span>")
			if(prob(50))
				new /obj/item/reagent_containers/glass/bottle/potion/flight(loc)
			else
				new /obj/item/clothing/neck/necklace/memento_mori(loc)
				new /mob/living/simple_animal/hostile/skeleton(loc)
			if(prob(15))
				new /obj/item/storage/box/holy_grenades(loc)
				new /mob/living/simple_animal/hostile/skeleton/templar(loc)
				new /mob/living/simple_animal/hostile/skeleton/templar(loc)
			if(prob(35))
				new /obj/item/claymore(loc)
			if(prob(25))
				new /obj/item/staff/bostaff(loc)
				new /mob/living/simple_animal/hostile/skeleton(loc)
			if(prob(35))
				new /obj/item/disk/design_disk/adv/cleric_mace(loc)
				new /mob/living/simple_animal/hostile/skeleton(loc)
			if(prob(25))
				new /obj/item/shield/riot/roman(loc)
			if(prob(35))
				new /obj/item/disk/design_disk/adv/knight_gear
				new /mob/living/simple_animal/hostile/skeleton(loc)
			new /obj/item/instrument/trombone(loc)
			new /obj/item/stack/sheet/bone
			new /obj/item/stack/sheet/bone
			new /mob/living/simple_animal/hostile/skeleton/templar(loc)
			new /mob/living/simple_animal/hostile/skeleton/templar(loc)
			new /turf/open/floor/mineral/silver(loc)
		if(4)//hogwart's school of witchcraft and wizardry. Featuring incredible loot at incredibly low chances
			visible_message("<span class='userdanger'>Candlelight and magic ooze through the dying portal.</span>")
			if(prob(10))
				new /obj/item/organ/heart/cursed/wizard(loc)
			if(prob(25))
				new /obj/item/book/granter/spell/summonitem(loc)
				new /mob/living/simple_animal/hostile/wizard(loc)
			if(prob(15))
				new /obj/item/book/granter/spell/sacredflame(loc)
				new /mob/living/simple_animal/hostile/wizard(loc)
			if(prob(15))
				new /obj/item/gun/magic/staff/chaos(loc)
				new /mob/living/simple_animal/hostile/dark_wizard(loc)
			if(prob(15))
				new /obj/item/mjollnir
				new /mob/living/simple_animal/hostile/wizard(loc)
			if(prob(15))
				new /obj/item/book/granter/spell/charge(loc)
				new /mob/living/simple_animal/hostile/wizard(loc)
			if(prob(10))
				new /obj/item/book/granter/spell/fireball(loc)
				new /mob/living/simple_animal/hostile/wizard(loc)
			if(prob(10))
				new /obj/item/gun/magic/wand/polymorph(loc)
				new /mob/living/simple_animal/hostile/wizard(loc)
			if(prob(15))
				new /obj/item/guardiancreator/choose(loc)
				new /mob/living/simple_animal/hostile/wizard(loc)
			new /obj/item/upgradescroll(loc)
			new /obj/item/gun/magic/wand/fireball/inert(loc)
			new /mob/living/simple_animal/hostile/dark_wizard(loc)
			new /mob/living/simple_animal/hostile/dark_wizard(loc)
			new /turf/open/floor/wood/ebony(loc)
		if(5)//syndicate incursion. Again, high-quality loot at low chances, this time with excessive levels of danger
			visible_message("<span class='userdanger'>Radio chatter echoes out from the portal. Red-garbed figures step through, weapons raised.</span>")
			new /mob/living/simple_animal/hostile/syndicate/ranged/smg/space(loc)
			new /mob/living/simple_animal/hostile/syndicate/melee/sword/space/stormtrooper(loc)
			if(prob(15))
				new /obj/item/clothing/suit/space/hardsuit/syndi
				new /mob/living/simple_animal/hostile/syndicate/ranged/smg/space(loc)
			if(prob(25))//the real prize
				new /obj/effect/spawner/lootdrop/donkpockets(loc)
				new /obj/effect/spawner/lootdrop/donkpockets(loc)
				new /obj/effect/spawner/lootdrop/donkpockets(loc)
			if(prob(25))
				new /obj/item/clothing/shoes/magboots/syndie(loc)
			if(prob(15))
				new /obj/item/wrench/combat(loc)
				new /obj/item/storage/toolbox/syndicate(loc)
				new /mob/living/simple_animal/hostile/syndicate/melee/sword/space(loc)
			if(prob(15))
				new /obj/item/storage/fancy/cigarettes/cigpack_syndicate
			if(prob(10))
				new /obj/item/robot_module/syndicate(loc)
				new /mob/living/simple_animal/hostile/syndicate/ranged/smg
			if(prob(15))
				new /mob/living/simple_animal/hostile/syndicate/melee/sword/space(loc)
				new /obj/item/guardiancreator/tech(loc)
			if(prob(35))
				new /obj/item/storage/belt/military(loc)
			if(prob(15))
				new /obj/item/shield/energy(loc)
				new /mob/living/simple_animal/hostile/syndicate/melee/sword/space(loc)
			if(prob(25))
				new /obj/item/card/emag(loc)
			new /turf/open/floor/mineral/plastitanium/red(loc)
		if(6)//;HELP BLOB IN MEDICAL
			visible_message("<span class='userdanger'>You hear a robotic voice saying something about a \"Delta-level biohazard\".</span>")
			if(prob(25))
				new /obj/item/storage/box/hypospray/CMO(loc)
				new /mob/living/simple_animal/hostile/blob/blobspore/weak(loc)
			if(prob(35))
				new /obj/item/defibrillator(loc)
				new /mob/living/simple_animal/hostile/blob/blobspore/weak(loc)
			if(prob(25))
				new /obj/item/circuitboard/machine/sleeper(loc)
			if(prob(35))
				new /obj/item/storage/firstaid/advanced(loc)
				new /mob/living/simple_animal/hostile/blob/blobspore/weak(loc)
			if(prob(15))
				new /obj/item/storage/firstaid/tactical(loc)
				new /mob/living/simple_animal/hostile/blob/blobspore/weak(loc)
			else
				new /obj/item/storage/firstaid/regular(loc)
			if(prob(25))
				new /obj/item/rod_of_asclepius(loc)
			if(prob(15))
				new /obj/effect/mob_spawn/human/corpse/solgov/infantry(loc)
			else
				new /obj/effect/mob_spawn/human/doctor(loc)
			if(prob(15))
				new /obj/effect/mob_spawn/human/corpse/solgov/infantry(loc)
			else
				new /obj/effect/mob_spawn/human/doctor(loc)
			if(prob(15))
				new /obj/effect/mob_spawn/human/corpse/solgov/infantry(loc)
			else
				new /obj/effect/mob_spawn/human/doctor(loc)
			new /obj/item/healthanalyzer(loc)
			new /turf/open/floor/carpet/nanoweave/beige(loc)
			new /mob/living/simple_animal/hostile/blob/blobbernaut/independent(loc)
			new /mob/living/simple_animal/hostile/blob/blobspore/weak(loc)
			new /mob/living/simple_animal/hostile/blob/blobspore/weak(loc)
		if(7)//teleporty ice world. Incomplete.
			visible_message("<span class='userdanger'>You glimpse a frozen, empty plane. Something stirs in the fractal abyss.</span>")
			if(prob(35))
				new /obj/item/warp_cube/red(loc)
				new /mob/living/simple_animal/hostile/asteroid/ice_demon(loc)
			if(prob(20))
				new /obj/item/teleportation_scroll/apprentice(loc)
				new /mob/living/simple_animal/hostile/asteroid/ice_demon(loc)
			if(prob(25))
				new /obj/item/clothing/suit/drfreeze_coat(loc)
				new /obj/item/clothing/under/costume/drfreeze(loc)
				new /mob/living/simple_animal/hostile/asteroid/ice_demon(loc)
			if(prob(30))
				new /obj/item/gun/magic/wand/teleport(loc)
				new /mob/living/simple_animal/hostile/asteroid/ice_demon(loc)
			if(prob(45))
				new /obj/item/clothing/shoes/winterboots/ice_boots(loc)
				new /mob/living/simple_animal/hostile/bear/snow(loc)
				new /obj/effect/decal/remains/human(loc)
			new /mob/living/simple_animal/hostile/asteroid/ice_demon(loc)
			new /turf/open/floor/plating/ice/smooth(loc)
		if(8)//FUCK FUCK HELP SWARMERS IN VAULT
			visible_message("<span class='userdanger'>Something beeps. Small, glowing forms spill out of the portal en masse!</span>")
			new /mob/living/simple_animal/hostile/swarmer/ai(loc)
			new /mob/living/simple_animal/hostile/swarmer/ai(loc)
			new /mob/living/simple_animal/hostile/swarmer/ai(loc)
			if(prob(35))
				new /obj/item/construction/rcd/loaded(loc)
				new /mob/living/simple_animal/hostile/swarmer/ai(loc)
			if(prob(45))
				new /obj/item/holosign_creator/atmos(loc)
				new /mob/living/simple_animal/hostile/swarmer/ai(loc)
			if(prob(25))
				new /obj/item/circuitboard/machine/vendor(loc)
				new /obj/item/vending_refill/engivend(loc)
				new /mob/living/simple_animal/hostile/swarmer/ai(loc)
			if(prob(45))
				new /obj/item/tank/jetpack/oxygen(loc)
				new /mob/living/simple_animal/hostile/swarmer/ai(loc)
			if(prob(25))
				new /obj/item/storage/toolbox/infiltrator(loc)
				new /mob/living/simple_animal/hostile/swarmer/ai(loc)
				new /mob/living/simple_animal/hostile/swarmer/ai(loc)
			if(prob(25))
				new /obj/machinery/portable_atmospherics/canister/oxygen(loc)
				new /mob/living/simple_animal/hostile/swarmer/ai(loc)
			if(prob(25))
				new /mob/living/simple_animal/hostile/swarmer/ai(loc)
				new /mob/living/simple_animal/hostile/swarmer/ai(loc)
				new /obj/item/clothing/gloves/color/latex/engineering(loc)
			new /obj/effect/mob_spawn/human/engineer(loc)
			new /turf/open/floor/circuit/telecomms(loc)
		if(9)//Literally blood-drunk.
			visible_message("<span class='userdanger'>Blood sprays from the portal. An ichor-drenched figure steps through!</span>")
			new /obj/effect/gibspawner/human(loc)
			new /obj/effect/gibspawner/human(loc)
			new /obj/effect/gibspawner/human(loc)
			new /mob/living/simple_animal/hostile/megafauna/blood_drunk_miner/doom(loc)
			if(prob(25))
				new /obj/item/seeds/tomato/blood(loc)
			new /turf/open/floor/plating/asteroid/basalt(loc)
		if(10)//Now's your chance to be a [[BIG SHOT]]
			visible_message("<span class='userdanger'>You hear the sound of big money and bigger avarice.</span>")
			new /obj/structure/cursed_slot_machine(loc)
			if(prob(25))
				new /obj/item/stack/spacecash/c1000(loc)
				new /obj/item/stack/spacecash/c1000(loc)
				new /obj/item/coin/gold(loc)
				new /mob/living/simple_animal/hostile/faithless(loc)
			if(prob(25))
				new /obj/item/coin/gold(loc)
				new /obj/item/coin/gold(loc)
				new /obj/item/stack/sheet/mineral/gold/twenty(loc)
			if(prob(25))
				new /obj/item/storage/fancy/cigarettes/cigpack_robustgold(loc)
			if(prob(25))
				new /obj/item/clothing/head/collectable/petehat(loc)
				new /mob/living/simple_animal/hostile/faithless(loc)
			new /mob/living/simple_animal/hostile/faithless(loc)
			new /mob/living/simple_animal/hostile/faithless(loc)
			new /turf/open/floor/mineral/gold(loc)
		if(11)//hivebot factory
			visible_message("<span class='userdanger'>You catch a brief glimpse of a vast production complex. One of the assembly lines outputs through the portal!</span>")
			if(prob(35))
				new /obj/item/stack/sheet/mineral/adamantine/ten(loc)
				new /obj/item/stack/sheet/mineral/runite/ten(loc)
				new /obj/item/stack/sheet/mineral/mythril/ten(loc)
				new /mob/living/simple_animal/hostile/hivebot/strong(loc)
			if(prob(35))
				new /obj/item/stack/circuit_stack(loc)
				new /mob/living/simple_animal/hostile/hivebot/mechanic(loc)
			if(prob(35))
				new /obj/item/circuitboard/machine/bluespace_miner(loc)
				new /mob/living/simple_animal/hostile/hivebot/range(loc)
			if(prob(35))
				new /obj/item/stack/sheet/mineral/adamantine/ten(loc)
				new /obj/item/stack/sheet/mineral/runite/ten(loc)
				new /obj/item/stack/sheet/mineral/mythril/ten(loc)
				new /mob/living/simple_animal/hostile/hivebot/strong(loc)
			if(prob(50))
				new /obj/item/stack/sheet/metal/fifty(loc)
				new /obj/item/stack/sheet/glass/fifty(loc)
				new /obj/item/stack/cable_coil/yellow(loc)
				new /obj/item/storage/box/lights/bulbs(loc)
				new /mob/living/simple_animal/hostile/hivebot(loc)
			new /mob/living/simple_animal/hostile/hivebot(loc)
			new /mob/living/simple_animal/hostile/hivebot/strong(loc)
			new /obj/machinery/conveyor(loc)
			new /turf/open/floor/circuit/red(loc)
		if(12)//miner's last moments
			visible_message("<span class='userdanger'>The familiar sound of an ash storm greets you. A miner steps through the portal, stumbles, and collapses.</span>")
			if(prob(15))
				new /obj/item/disk/design_disk/modkit_disc/resonator_blast(loc)
			if(prob(15))
				new /obj/item/disk/design_disk/modkit_disc/rapid_repeater(loc)
			if(prob(15))
				new /obj/item/disk/design_disk/modkit_disc/mob_and_turf_aoe(loc)
			if(prob(15))
				new /obj/item/disk/design_disk/modkit_disc/bounty(loc)
			if(prob(25))
				new /obj/item/vending_refill/mining_equipment(loc)
				new /mob/living/simple_animal/hostile/asteroid/goliath/beast(loc)
			if(prob(25))
				new /obj/item/reagent_containers/hypospray/medipen/survival(loc)
			if(prob(25))
				new /obj/item/fulton_core(loc)
				new /obj/item/extraction_pack(loc)
				new /mob/living/simple_animal/hostile/asteroid/goliath/beast(loc)
			if(prob(25))
				new /obj/item/t_scanner/adv_mining_scanner/lesser(loc)
				new /mob/living/simple_animal/hostile/asteroid/goliath/beast(loc)
			if(prob(50))
				new /obj/item/kinetic_crusher(loc)
			else
				new /obj/item/gun/energy/kinetic_accelerator(loc)
			new /mob/living/simple_animal/hostile/asteroid/goliath/beast(loc)
			new /mob/living/simple_animal/hostile/asteroid/goliath/beast(loc)
			new /mob/living/simple_animal/hostile/asteroid/goliath/beast/ancient(loc)
			new /obj/effect/mob_spawn/human/miner(loc)
			new /turf/open/floor/plating/asteroid/basalt(loc)
		if(13)//sailing the ocean blue
			visible_message("<span class='userdanger'>Water pours out of the portal, followed by a strange vessel. It's occupied.</span>")
			new /obj/vehicle/ridden/lavaboat/dragon(loc)
			new /obj/item/oar(loc)
			if(prob(50))
				new /obj/item/clothing/under/costume/sailor(loc)
			if(prob(50))
				new /obj/item/pneumatic_cannon/speargun(loc)
				new /obj/item/throwing_star/magspear(loc)
				new /obj/item/throwing_star/magspear(loc)
				new /obj/item/throwing_star/magspear(loc)
				new /mob/living/simple_animal/hostile/carp(loc)
			if(prob(25))
				new /obj/item/clothing/suit/space/hardsuit/carp(loc)
				new /mob/living/simple_animal/hostile/carp(loc)
			if(prob(25))
				new /obj/item/gun/magic/hook(loc)
				new /mob/living/simple_animal/hostile/carp(loc)
			if(prob(35))
				new /obj/item/reagent_containers/food/snacks/carpmeat(loc)
				new /obj/item/reagent_containers/food/snacks/carpmeat(loc)
			if(prob(25))
				new /obj/item/guardiancreator/carp/choose
				new /mob/living/simple_animal/hostile/carp/megacarp(loc)
			new /mob/living/simple_animal/hostile/carp/megacarp(loc)
			new /mob/living/simple_animal/hostile/carp(loc)
			new /turf/open/water(loc)
		if(14)//hydroponics forest
			visible_message("<span class='userdanger'>You catch a glimpse of a strange forest. Smells like weed and bad choices.</span>")
			if(prob(25))
				new /obj/item/circuitboard/machine/biogenerator(loc)
			if(prob(25))
				new /obj/item/circuitboard/machine/seed_extractor(loc)
				new /mob/living/simple_animal/hostile/venus_human_trap(loc)
			if(prob(25))
				new /obj/item/circuitboard/machine/plantgenes(loc)
			else
				new /obj/item/circuitboard/machine/hydroponics(loc)
			if(prob(15))
				new /obj/item/seeds/gatfruit(loc)
				new /mob/living/simple_animal/hostile/venus_human_trap(loc)
			if(prob(25))
				new /obj/item/seeds/random(loc)
			if(prob(35))
				new /obj/item/seeds/random(loc)
			if(prob(25))
				new /obj/item/seeds/random(loc)
			if(prob(25))
				new /obj/item/seeds/cannabis(loc)
			new /obj/item/clothing/gloves/botanic_leather(loc)
			new /obj/item/cultivator/rake(loc)
			new /obj/structure/spacevine(loc)
			new /mob/living/simple_animal/hostile/venus_human_trap(loc)
			new /turf/open/floor/plating/grass(loc)
		if(15)//fallout ss13
			visible_message("<span class='userdanger'>You hear a geiger counter click and smell ash.</span>")
			if(prob(50))
				new /obj/item/reagent_containers/food/drinks/drinkingglass/filled/nuka_cola(loc)
				new /obj/item/reagent_containers/food/drinks/drinkingglass/filled/nuka_cola(loc)
				new /obj/item/reagent_containers/food/drinks/drinkingglass/filled/nuka_cola(loc)
				new /mob/living/simple_animal/hostile/cockroach/glockroach(loc)
			if(prob(50))
				new /obj/structure/radioactive/stack(loc)
				new /mob/living/simple_animal/hostile/cockroach/glockroach(loc)
			if(prob(35))
				new /obj/item/stack/sheet/mineral/uranium/twenty(loc)
				new /mob/living/simple_animal/hostile/cockroach/glockroach(loc)
			if(prob(35))
				new /obj/item/clothing/head/radiation(loc)
				new /obj/item/clothing/suit/radiation(loc)
			new /obj/item/geiger_counter(loc)
			new /mob/living/simple_animal/hostile/cockroach/glockroach(loc)
			new /turf/open/floor/plating/dirt(loc)
		if(16)//the cultists amoung us
			visible_message("<span class='userdanger'>Chanting and a hateful red glow spill through the portal.</span>")
			if(prob(50))
				new /obj/item/soulstone/anybody(loc)
				new /obj/item/soulstone/anybody(loc)
				new /obj/structure/constructshell(loc)
				new /mob/living/simple_animal/hostile/construct/proteon/hostile(loc)
			if(prob(35))
				new /obj/item/borg/upgrade/modkit/lifesteal(loc)
				new /obj/item/bedsheet/cult(loc)
				new /mob/living/simple_animal/hostile/construct/wraith/hostile(loc)
			if(prob(50))
				new /obj/item/stack/sheet/runed_metal/ten(loc)
			if(prob(35))
				new /obj/item/sharpener/cult(loc)
				new /mob/living/simple_animal/hostile/construct/artificer/hostile(loc)
			if(prob(25))
				new /obj/item/clothing/suit/space/hardsuit/cult(loc)
				new /mob/living/simple_animal/hostile/construct/proteon/hostile(loc)
			new /mob/living/simple_animal/hostile/construct/juggernaut/hostile(loc)
			new /mob/living/simple_animal/hostile/construct/wraith/hostile(loc)
			new /obj/structure/destructible/cult/pylon(loc)
			new /turf/open/floor/plasteel/cult(loc)
		if(17)//the backroom freezer
			visible_message("<span class='userdanger'>The faint hallogen glow of a faraway kitchen greets you.</span>")
			if(prob(45))
				new /obj/item/kitchen/knife/bloodletter(loc)
				new /mob/living/simple_animal/hostile/killertomato(loc)
			if(prob(45))
				new /obj/item/clothing/gloves/butchering(loc)
				new /mob/living/simple_animal/hostile/killertomato(loc)
			if(prob(45))
				new /obj/item/reagent_containers/food/snacks/store/bread/meat(loc)
				new /obj/item/reagent_containers/food/snacks/store/bread/meat(loc)
				new /obj/item/reagent_containers/food/snacks/store/bread/meat(loc)
			if(prob(45))
				new /obj/item/reagent_containers/food/snacks/store/cake/trumpet(loc)
			if(prob(35))
				new /obj/item/reagent_containers/food/snacks/pizza/dank(loc)
			if(prob(15))
				new /obj/item/reagent_containers/food/snacks/meat/steak/gondola(loc)
				new /mob/living/simple_animal/hostile/killertomato(loc)
			if(prob(25))
				new /obj/item/reagent_containers/food/snacks/burger/roburgerbig(loc)
				new /mob/living/simple_animal/hostile/killertomato(loc)
			if(prob(35))
				new /obj/item/kitchen/knife/butcher(loc)
				new /mob/living/simple_animal/hostile/killertomato(loc)
			if(prob(25))
				new /obj/item/flamethrower/full(loc)
				new /mob/living/simple_animal/hostile/killertomato(loc)
			new /mob/living/simple_animal/hostile/alien/maid(loc)
			new /turf/open/floor/plasteel/kitchen_coldroom/freezerfloor(loc)
		if(18)//legion miniboss
			visible_message("<span class='userdanger'>The ground quakes. An immense figure reaches through the portal, crouching to squeeze through.</span>")
			new /mob/living/simple_animal/hostile/big_legion(loc)
			if(prob(50))
				new /obj/structure/closet/crate/necropolis/tendril(loc)
			new /turf/open/indestructible/necropolis(loc)
		if(19)//xenobiologist's hubris
			visible_message("<span class='userdanger'>You catch a glimpse of a wobbling sea of slimy friends. An abused-looking keeper slips through the portal.</span>")
			if(prob(25))
				new /obj/item/slime_extract/adamantine(loc)
			if(prob(25))
				new /obj/item/slime_extract/gold(loc)
			if(prob(45))
				new /obj/item/extinguisher/advanced(loc)
			if(prob(15))
				new /obj/item/slimepotion/slime/renaming(loc)
				new /mob/living/simple_animal/slime/random(loc)
			if(prob(25))
				new /obj/item/slimepotion/slime/sentience(loc)
				new /mob/living/simple_animal/slime/random(loc)
			if(prob(15))
				new /obj/item/slimepotion/transference(loc)
				new /mob/living/simple_animal/slime/random(loc)
			if(prob(35))
				new /obj/item/circuitboard/computer/xenobiology(loc)
				new /obj/item/slime_extract/grey(loc)
				new /mob/living/simple_animal/slime/random(loc)
			if(prob(35))
				new /obj/item/circuitboard/machine/processor/slime(loc)
				new /mob/living/simple_animal/slime/random(loc)
			if(prob(15))
				new /obj/item/slime_cookie/purple(loc)
			if(prob(25))
				new /obj/item/storage/box/monkeycubes(loc)
				new /mob/living/simple_animal/slime/random(loc)
			if(prob(15))
				new /obj/item/slimepotion/speed(loc)
				new /mob/living/simple_animal/slime/random(loc)
			if(prob(15))
				new /obj/item/slimepotion/slime/slimeradio(loc)
				new /mob/living/simple_animal/slime/random(loc)
			if(prob(15))
				new /mob/living/simple_animal/pet/dog/corgi/puppy/slime(loc)
			new /obj/effect/mob_spawn/human/scientist(loc)
			new /turf/open/floor/mineral/titanium/purple(loc)
			new /mob/living/simple_animal/slime/random(loc)
		if(20)//lost abductor
			visible_message("<span class='userdanger'>You glimpse a frigid wreckage. A large block of something slips through the portal.</span>")
			if(prob(25))
				new /obj/item/stack/sheet/mineral/abductor(loc)
				new /mob/living/simple_animal/hostile/asteroid/polarbear(loc)
			if(prob(25))
				new /obj/item/clothing/under/abductor(loc)
				new /mob/living/simple_animal/hostile/asteroid/polarbear(loc)
			if(prob(15))
				new /obj/item/weldingtool/abductor(loc)
			if(prob(25))
				new /obj/item/scalpel/alien(loc)
			if(prob(10))
				new /obj/item/circuitboard/machine/plantgenes/vault(loc)
				new /mob/living/simple_animal/hostile/asteroid/polarbear(loc)
			if(prob(25))
				new /obj/item/wrench/abductor(loc)
				new /obj/item/screwdriver/abductor(loc)
			if(prob(25))
				new /obj/item/crowbar/abductor(loc)
				new /obj/item/multitool/abductor(loc)
			if(prob(15))
				new /obj/item/abductor_machine_beacon/chem_dispenser(loc)
				new /mob/living/simple_animal/hostile/asteroid/polarbear(loc)
			new /obj/structure/fluff/iced_abductor(loc)
			new /mob/living/simple_animal/hostile/asteroid/polarbear(loc)
			new /turf/open/floor/mineral/abductor(loc)
		if(21)//hey, free elite tumor!
			visible_message("<span class='userdanger'>A large, pulsating structure falls through the portal.</span>")
			new /obj/structure/elite_tumor(loc)
			new /turf/open/floor/plating/asteroid/basalt(loc)
		if(22)//*you flush the toilet.*
			visible_message("<span class='userdanger'>You hear the faint noise of a long flush.</span>")
			new /obj/structure/toilet(loc)
			new /obj/effect/decal/remains(loc)
			new /obj/item/newspaper(loc)
			new /turf/open/floor/plastic(loc)
			new /obj/item/camera/rewind/loot(loc)
		if(23)//Research & Zombies
			visible_message("<span class='userdanger'>Flashing lights and quarantine alarms echo through the portal. You smell rotting flesh and plasma.</span>")
			if(prob(30))
				new /obj/item/storage/box/rndboards(loc)
				new /mob/living/simple_animal/hostile/zombie(loc)
			if(prob(25))
				new /obj/item/card/id/departmental_budget/sci(loc)
				new /mob/living/simple_animal/hostile/zombie(loc)
			if(prob(15))
				new /obj/item/storage/box/stockparts/deluxe(loc)
				new /mob/living/simple_animal/hostile/zombie(loc)
				new /mob/living/simple_animal/hostile/zombie(loc)
				new /mob/living/simple_animal/hostile/zombie(loc)
			else
				new /obj/item/storage/box/stockparts(loc)
				new /mob/living/simple_animal/hostile/zombie(loc)
			if(prob(30))
				new /obj/item/circuitboard/machine/rdserver(loc)
				new /mob/living/simple_animal/hostile/zombie(loc)
			if(prob(30))
				new /obj/item/research_notes/loot/big(loc)
				new /mob/living/simple_animal/hostile/zombie(loc)
			else
				new /obj/item/research_notes/loot/medium(loc)
			if(prob(30))
				new /obj/item/research_notes/loot/medium(loc)
				new /mob/living/simple_animal/hostile/zombie(loc)
			else
				new /obj/item/research_notes/loot/small(loc)
			if(prob(15))
				new /obj/item/pneumatic_cannon(loc)
				new /mob/living/simple_animal/hostile/zombie(loc)
			if(prob(35))
				new /obj/item/research_notes/loot/medium(loc)
				new /mob/living/simple_animal/hostile/zombie(loc)
			else
				new /obj/item/research_notes/loot/small(loc)
			new/turf/open/floor/mineral/titanium/purple(loc)
			new /mob/living/simple_animal/hostile/zombie(loc)
		if(24)//Silverback's locker room
			visible_message("<span class='userdanger'>You catch a glimpse of verdant green. Smells like a locker room.</span>")
			new /mob/living/simple_animal/hostile/gorilla(loc)
			new /mob/living/simple_animal/hostile/gorilla(loc)
			if(prob(15))
				new /obj/item/reagent_containers/hypospray/medipen/magillitis(loc)
				new /mob/living/simple_animal/hostile/gorilla(loc)
			if(prob(25))
				new /obj/item/dnainjector/thermal(loc)
				new /mob/living/simple_animal/hostile/gorilla(loc)
			if(prob(15))
				new /obj/item/storage/box/gorillacubes(loc)
				new /mob/living/simple_animal/hostile/gorilla(loc)
			if(prob(25))
				new /obj/item/dnainjector/hulkmut(loc)
				new /mob/living/simple_animal/hostile/gorilla(loc)
			if(prob(25))
				new /obj/item/dnainjector/firemut(loc)
				new /mob/living/simple_animal/hostile/gorilla(loc)
			if(prob(25))
				new /obj/item/dnainjector/gigantism(loc)
			if(prob(25))
				new /obj/item/dnainjector/dwarf(loc)
			if(prob(15))
				new /obj/item/dnainjector/firebreath(loc)
				new /mob/living/simple_animal/hostile/gorilla(loc)
			if(prob(15))
				new /mob/living/simple_animal/hostile/gorilla(loc)
				new /obj/item/dnainjector/telemut/darkbundle(loc)
			if(prob(25))
				new /obj/item/dnainjector/insulated(loc)
				new /mob/living/simple_animal/hostile/gorilla(loc)
			new /obj/item/sequence_scanner(loc)
			new /obj/structure/flora/grass/jungle(loc)
			new /turf/open/floor/plating/grass/jungle(loc)


