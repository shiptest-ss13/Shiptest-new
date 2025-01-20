// Hey! Listen! Update _maps\map_catalogue.txt with your new ruins!

/datum/map_template/ruin/lavaland
	prefix = "_maps/RandomRuins/LavaRuins/"
	ruin_type = RUINTYPE_LAVA

/datum/map_template/ruin/lavaland/biodome/winter
	name = "Solarian Winter Biodome"
	id = "biodome-winter"
	description = "A Solarian frontier research facility created by the Pionierskompanien \
	This one seems to simulate the wintery climate of the northern provinces, including a sauna!"
	suffix = "lavaland_surface_biodome_winter.dmm"
	ruin_tags = list(RUIN_TAG_MINOR_COMBAT, RUIN_TAG_MINOR_LOOT, RUIN_TAG_SHELTER)

/datum/map_template/ruin/lavaland/buried_shrine
	name = "Buried Shrine"
	id = "buried_shrine"
	description = "An ancient temple belonging to some long-gone inhabitants, wrecked and buried by the volcanic activity of it's home planet."
	suffix = "lavaland_surface_buried_shrine.dmm"
	dynamic_mission_types = list(/datum/mission/ruin/signaled/kill/elite)

/datum/map_template/ruin/lavaland/lava_canyon
	name = "Lava Canyon"
	id = "lava_canyon"
	description = "Tectonic activity has gouged a large fissure into the surface of the planet here. Tucked in the crevasse, the remains of an ashwalker village lay in ashes."
	suffix = "lavaland_surface_lava_canyon.dmm"

/datum/map_template/ruin/lavaland/wrecked_factory
	name = "Wrecked Factory"
	id = "wreck_factory"
	description = "A  Nanotrasen processing facility, assaulted by a pirate raid that has killed most of the staff. The offices however, remain unbreached for now."
	suffix = "lavaland_surface_wrecked_factory.dmm"
	dynamic_mission_types = list(
		/datum/mission/ruin/nanotrasen_docs,
		/datum/mission/ruin/captain_medal,
		/datum/mission/ruin/brainchip
	)

/datum/mission/ruin/nanotrasen_docs
	name = "recover some nanotrasen files."
	value = 2500
	setpiece_item = /obj/item/documents/nanotrasen

/datum/mission/ruin/captain_medal
	name = "recover my lost medal."
	value = 1250
	setpiece_item = /obj/item/documents/nanotrasen

/datum/mission/ruin/brainchip
	name = "brainchip recovery"
	desc = "one of our cargo techs died with some important tech in his head. get it back"
	setpiece_item = /mob/living/carbon/human

/obj/effect/landmark/mission_poi/main/implanted
	var/implant_type = /obj/item/organ/cyberimp/brain/datachip

/obj/effect/landmark/mission_poi/main/implanted/use_poi(_type_to_spawn)
	var/mob/living/carbon/human/implanted = ..()
	if(istype(implanted, /mob/living/carbon/human))
		var/obj/item/organ/implant = new implant_type()
		implant.Insert(implanted)
		return implant

/datum/map_template/ruin/lavaland/fallenstar
	name = "Crashed Starwalker"
	id = "crashed_star"
	description = "A crashed pirate ship. It would seem that it's crew died a while ago."
	suffix = "lavaland_crashed_starwalker.dmm"
	dynamic_mission_types = list(/datum/mission/ruin/blackbox)

/datum/map_template/ruin/lavaland/abandonedlisteningpost
	name = "Abandoned Listening Post"
	id = "abandonedlistening"
	description = "An abandoned Cybersun listening post. Seems like the Ramzi Clique has an interest in the site."
	suffix = "lavaland_abandonedlisteningpost.dmm"
	dynamic_mission_types = list(/datum/mission/ruin/blackbox)
