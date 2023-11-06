#define FACTION_PLAYER_MINUTEMAN "playerMinuteman" //this needs to be moved to factions.dm when syndicating is merged.

//top outfit of everything Minuteman. Touch at own risk.

/datum/outfit/job/minuteman
	name = "Colonial Minuteman Empty"

	uniform = /obj/item/clothing/under/rank/security/officer/minutemen
	alt_uniform = null

	backpack = /obj/item/storage/backpack/security/cmm
	satchel = /obj/item/storage/backpack/satchel/sec/cmm
	duffelbag = /obj/item/storage/backpack/duffelbag //to-do: bug rye for cmm duffles
	satchel = /obj/item/storage/backpack/messenger //and these

	box = /obj/item/storage/box/survival

/datum/outfit/job/minuteman/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	if(visualsOnly)
		return
	H.faction |= list(FACTION_PLAYER_MINUTEMAN)

///assistant

/datum/outfit/job/minuteman/assistant
	name = "Volunteer (Minutemen)"
	jobtype = /datum/job/assistant

	r_pocket = /obj/item/radio
	belt = /obj/item/pda

///captains

/datum/outfit/job/minuteman/captain
	name = "Captain (Minutemen)"
	jobtype = /datum/job/captain

	id = /obj/item/card/id/gold
	belt = /obj/item/pda/captain
	gloves = /obj/item/clothing/gloves/color/captain


	backpack = /obj/item/storage/backpack/captain
	satchel = /obj/item/storage/backpack/satchel/cap
	duffelbag = /obj/item/storage/backpack/duffelbag/captain
	courierbag = /obj/item/storage/backpack/messenger/com

	accessory = /obj/item/clothing/accessory/medal/gold/captain

	ears = /obj/item/radio/headset/minutemen/alt/captain
	uniform = /obj/item/clothing/under/rank/command/minutemen
	alt_uniform = null
	suit = /obj/item/clothing/suit/toggle/lawyer/minutemen
	alt_suit = null
	dcoat = /obj/item/clothing/suit/hooded/wintercoat/captain

	shoes = /obj/item/clothing/shoes/combat
	head = /obj/item/clothing/head/cowboy/sec/minutemen
	backpack = /obj/item/storage/backpack
	backpack_contents = list(/obj/item/storage/box/ids=1,\
		/obj/item/melee/classic_baton/telescopic=1, /obj/item/modular_computer/tablet/preset/advanced = 1)

/datum/outfit/job/minuteman/captain/general
	name = "General (Minutemen)"

	head = /obj/item/clothing/head/caphat/minutemen
	ears = /obj/item/radio/headset/minutemen/alt/captain
	uniform = /obj/item/clothing/under/rank/command/minutemen
	suit = /obj/item/clothing/suit/armor/vest/capcarapace/minutemen
	shoes = /obj/item/clothing/shoes/combat

	box = /obj/item/storage/box/survival/engineer/radio
	backpack = /obj/item/storage/backpack
	backpack_contents = list(/obj/item/melee/classic_baton/telescopic=1, /obj/item/gun/ballistic/revolver/mateba=1)

///chemist

/datum/outfit/job/minuteman/chemist
	name = "Chemical Scientist (Minutemen)"
	jobtype = /datum/job/chemist

	glasses = /obj/item/clothing/glasses/science
	belt = /obj/item/pda/chemist
	shoes = /obj/item/clothing/shoes/sneakers/white
	suit =  /obj/item/clothing/suit/toggle/labcoat/chemist

	backpack = /obj/item/storage/backpack/chemistry
	satchel = /obj/item/storage/backpack/satchel/chem
	duffelbag = /obj/item/storage/backpack/duffelbag/med
	courierbag = /obj/item/storage/backpack/messenger/chem

	box = /obj/item/storage/box/survival/medical
	chameleon_extras = /obj/item/gun/syringe

///Chief Engineer
/datum/outfit/job/minuteman/ce
	name = "Foreman (Minutemen)"
	jobtype = /datum/job/chief_engineer

	id = /obj/item/card/id/silver

	backpack = /obj/item/storage/backpack/industrial
	satchel = /obj/item/storage/backpack/satchel/eng
	duffelbag = /obj/item/storage/backpack/duffelbag/engineering
	courierbag = /obj/item/storage/backpack/messenger/engi

	box = /obj/item/storage/box/survival/engineer
	pda_slot = ITEM_SLOT_LPOCKET
	l_pocket = /obj/item/pda/heads/ce

	chameleon_extras = /obj/item/stamp/ce


	ears = /obj/item/radio/headset/minutemen/alt
	uniform = /obj/item/clothing/under/rank/command/minutemen
	alt_uniform = null
	suit = /obj/item/clothing/suit/toggle/lawyer/minutemen
	alt_suit = null
	gloves = /obj/item/clothing/gloves/combat
	belt = /obj/item/storage/belt/utility/full
	shoes = /obj/item/clothing/shoes/combat
	head = /obj/item/clothing/head/cowboy/sec/minutemen
	backpack = /obj/item/storage/backpack
	backpack_contents = list(
		/obj/item/melee/classic_baton/telescopic=1,
		/obj/item/modular_computer/tablet/preset/advanced = 1
	)

///"Head Of Personnel"

/datum/outfit/job/minuteman/head_of_personnel
	name = "Bridge Officer (Minutemen)"
	jobtype = /datum/job/head_of_personnel

	id = /obj/item/card/id/silver
	belt = /obj/item/pda/heads/head_of_personnel

	backpack = /obj/item/storage/backpack/captain
	satchel = /obj/item/storage/backpack/satchel/cap
	duffelbag = /obj/item/storage/backpack/duffelbag/captain
	courierbag = /obj/item/storage/backpack/messenger/com

	chameleon_extras = list(/obj/item/gun/energy/e_gun, /obj/item/stamp/head_of_personnel)

	ears = /obj/item/radio/headset/minutemen/alt
	uniform = /obj/item/clothing/under/rank/command/minutemen
	alt_uniform = null
	suit = /obj/item/clothing/suit/toggle/lawyer/minutemen
	alt_suit = null

	shoes = /obj/item/clothing/shoes/combat
	head = /obj/item/clothing/head/cowboy/sec/minutemen
	backpack = /obj/item/storage/backpack
	backpack_contents = list(/obj/item/storage/box/ids=1,\
		/obj/item/melee/classic_baton/telescopic=1, /obj/item/modular_computer/tablet/preset/advanced = 1)

///Medical Doctor
/datum/outfit/job/minuteman/doctor
	name = "Field Medic (Minutemen)"
	jobtype = /datum/outfit/job/doctor

	belt = /obj/item/pda/medical
	l_hand = /obj/item/storage/firstaid/medical
	suit_store = /obj/item/flashlight/pen

	backpack = /obj/item/storage/backpack/medic
	satchel = /obj/item/storage/backpack/satchel/med
	duffelbag = /obj/item/storage/backpack/duffelbag/med
	courierbag = /obj/item/storage/backpack/messenger/med
	box = /obj/item/storage/box/survival/medical

	chameleon_extras = /obj/item/gun/syringe

	uniform = /obj/item/clothing/under/rank/security/officer/minutemen
	accessory = /obj/item/clothing/accessory/armband/medblue
	shoes = /obj/item/clothing/shoes/sneakers/white
	head = /obj/item/clothing/head/beret/med
	suit = null
	suit_store = null

///paramedic
/datum/outfit/job/minuteman/paramedic
	name = "BARD Combat Medic (Minutemen)"
	jobtype = /datum/outfit/job/paramedic

	shoes = /obj/item/clothing/shoes/sneakers/blue
	gloves = /obj/item/clothing/gloves/color/latex/nitrile
	belt = /obj/item/storage/belt/medical/paramedic
	l_pocket = /obj/item/pda/medical
	suit_store = /obj/item/flashlight/pen
	backpack_contents = list(/obj/item/roller=1)
	pda_slot = ITEM_SLOT_LPOCKET

	backpack = /obj/item/storage/backpack/medic
	satchel = /obj/item/storage/backpack/satchel/med
	duffelbag = /obj/item/storage/backpack/duffelbag/med
	courierbag = /obj/item/storage/backpack/messenger/para
	box = /obj/item/storage/box/survival/medical

	chameleon_extras = /obj/item/gun/syringe

	uniform = /obj/item/clothing/under/rank/medical/paramedic/emt
	alt_uniform = null
	head = /obj/item/clothing/head/soft/paramedic
	suit = /obj/item/clothing/suit/armor/vest
	alt_suit = null

///roboticist
/datum/outfit/job/minuteman/roboticist
	name = "Mech Technician (Minutemen)"
	jobtype = /datum/outfit/job/roboticist

	belt = /obj/item/storage/belt/utility/full
	l_pocket = /obj/item/pda/roboticist

	backpack = /obj/item/storage/backpack/science
	satchel = /obj/item/storage/backpack/satchel/tox
	courierbag = /obj/item/storage/backpack/messenger/tox


	uniform = /obj/item/clothing/under/rank/security/officer/minutemen
	shoes = /obj/item/clothing/shoes/combat
	ears = /obj/item/radio/headset/minutemen
	suit = /obj/item/clothing/suit/toggle/labcoat/science
	alt_suit = /obj/item/clothing/suit/toggle/suspenders/gray

///scientist
/datum/outfit/job/minuteman/scientist
	name = "Scientist (Minutemen)"
	jobtype = /datum/job/scientist

	uniform = /obj/item/clothing/under/rank/security/officer/minutemen
	backpack = /obj/item/storage/backpack/security/cmm

	belt = /obj/item/pda/toxins
	shoes = /obj/item/clothing/shoes/sneakers/white
	suit = /obj/item/clothing/suit/toggle/labcoat/science
	alt_suit = /obj/item/clothing/suit/toggle/suspenders/blue

	backpack = /obj/item/storage/backpack/science
	satchel = /obj/item/storage/backpack/satchel/tox
	courierbag = /obj/item/storage/backpack/messenger/tox

//security officers
/datum/outfit/job/minuteman/security
	name = "Minuteman (Minutemen)"
	jobtype = /datum/job/officer

	head = /obj/item/clothing/head/helmet/bulletproof/minutemen
	mask = /obj/item/clothing/mask/gas/sechailer/minutemen
	suit = /obj/item/clothing/suit/armor/vest/bulletproof
	alt_suit = null
	uniform = /obj/item/clothing/under/rank/security/officer/minutemen
	alt_uniform = null
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/combat
	ears = /obj/item/radio/headset/alt

	belt = /obj/item/storage/belt/military/minutemen

	l_pocket = /obj/item/flashlight/seclite
	r_pocket = /obj/item/tank/internals/emergency_oxygen/double
	box = /obj/item/storage/box/survival/engineer/radio
	backpack_contents = null

/datum/outfit/job/minuteman/security/armed
	name = "Minuteman (Minutemen) (Armed)"

	suit_store = /obj/item/gun/ballistic/automatic/assault/p16/minutemen
	belt = /obj/item/storage/belt/military/minutemen/loaded

/datum/outfit/job/minuteman/security/mech_pilot
	name = "Mech Pilot  (Minutemen)"

	suit = /obj/item/clothing/suit/armor/vest/alt
	gloves = /obj/item/clothing/gloves/tackler/combat/insulated
	glasses = /obj/item/clothing/glasses/hud/diagnostic
///miners
/datum/outfit/job/minuteman/miner
	name = "Industrial Miner (Minutemen)"
	jobtype = /datum/job/mining

	belt = /obj/item/pda/shaftminer
	l_pocket = /obj/item/reagent_containers/hypospray/medipen/survival
	uniform = /obj/item/clothing/under/rank/cargo/miner/hazard
	alt_uniform = null
	alt_suit = /obj/item/clothing/suit/toggle/hazard

	gloves = /obj/item/clothing/gloves/color/black
	shoes = /obj/item/clothing/shoes/combat
	backpack_contents = list(
		/obj/item/flashlight/seclite=1,
		/obj/item/stack/marker_beacon/ten=1,
		/obj/item/weldingtool=1
		)

///engineers
/datum/outfit/job/minuteman/engineer
	name = "Mechanic (Minutemen)"
	jobtype = /datum/job/engineer

	belt = /obj/item/storage/belt/utility/full/engi
	l_pocket = /obj/item/pda/engineering
	shoes = /obj/item/clothing/shoes/workboots
	r_pocket = /obj/item/t_scanner

	backpack = /obj/item/storage/backpack/industrial
	satchel = /obj/item/storage/backpack/satchel/eng
	duffelbag = /obj/item/storage/backpack/duffelbag/engineering
	courierbag = /obj/item/storage/backpack/messenger/engi

	uniform = /obj/item/clothing/under/rank/security/officer/minutemen
	accessory = /obj/item/clothing/accessory/armband/engine
	head = /obj/item/clothing/head/hardhat/dblue
	suit =  /obj/item/clothing/suit/hazardvest

	box = /obj/item/storage/box/survival/engineer
	pda_slot = ITEM_SLOT_LPOCKET
	backpack_contents = list(/obj/item/modular_computer/tablet/preset/advanced=1)


///warden
/datum/outfit/job/minuteman/warden
	name = "Field Commander (Minutemen)"
	jobtype = /datum/job/warden

	glasses = /obj/item/clothing/glasses/sunglasses
	ears = /obj/item/radio/headset/minutemen/alt
	uniform = /obj/item/clothing/under/rank/security/officer/minutemen
	accessory = /obj/item/clothing/accessory/armband
	head = /obj/item/clothing/head/cowboy/sec/minutemen
	suit = /obj/item/clothing/suit/armor/vest/bulletproof
	belt = /obj/item/storage/belt/military/minutemen
	shoes = /obj/item/clothing/shoes/combat

	l_pocket = /obj/item/flashlight/seclite
	r_pocket = /obj/item/tank/internals/emergency_oxygen/double

	box = /obj/item/storage/box/survival/engineer/radio
	backpack = /obj/item/storage/backpack
	backpack_contents = null

/datum/outfit/job/minuteman/warden/armed
	name = "Field Commander (Minutemen) (Armed)"

	suit_store = /obj/item/gun/ballistic/automatic/assault/p16/minutemen
	belt = /obj/item/storage/belt/military/minutemen/loaded

	backpack_contents = list(/obj/item/melee/classic_baton=1, /obj/item/gun/ballistic/automatic/pistol/commander=1, /obj/item/restraints/handcuffs=1, /obj/item/gun/energy/e_gun/advtaser=1)
