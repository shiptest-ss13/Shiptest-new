/datum/supply_pack/magazine
	group = "Magazines"
	crate_type = /obj/structure/closet/crate/secure/gear
	crate_name = "magazine crate"


/* VI */

/datum/supply_pack/magazine/co9mm_mag
	name = "9mm Commander Magazine Crate"
	desc = "Contains a 9mm magazine for the standard-issue Commander pistol, containing ten rounds."
	contains = list(/obj/item/ammo_box/magazine/co9mm)
	cost = 500
	faction = /datum/faction/nt

/datum/supply_pack/magazine/smgm9mm_mag
	name = "9mm SMG Magazine Crate"
	desc = "Contains a 9mm magazine for the Vector and Saber SMGs, containing thirty rounds."
	contains = list(/obj/item/ammo_box/magazine/smgm9mm)
	cost = 500
	faction = /datum/faction/nt
	faction_discount = 0
	faction_locked = TRUE


/* Hunter's Pride */

/datum/supply_pack/magazine/c38_mag
	name = ".38 Speedloader Crate"
	desc = "Contains a .38 speedloader for revolvers, containing six rounds."
	contains = list(/obj/item/ammo_box/c38)
	cost = 250
	faction_discount = 20
	faction = /datum/faction/srm

/datum/supply_pack/magazine/c38match
	name = ".38 Match Grade Speedloader"
	desc = "Contains one speedloader of match grade .38 ammunition, perfect for showing off trickshots."
	cost = 200
	small_item = TRUE
	contains = list(/obj/item/ammo_box/c38/match)
	crate_name = ".38 match crate"
	faction = /datum/faction/srm

/datum/supply_pack/magazine/c38dumdum
	name = ".38 DumDum Speedloader"
	desc = "Contains one speedloader of .38 DumDum ammunition, good for embedding in soft targets."
	cost = 200
	small_item = TRUE
	contains = list(/obj/item/ammo_box/c38/dumdum)
	crate_name = ".38 match crate"
	faction = /datum/faction/srm

/datum/supply_pack/magazine/m45_mag
	name = ".45 ACP Candor Magazine Crate"
	desc = "Contains a .45 ACP magazine for the Candor pistol, containing eight rounds."
	contains = list(/obj/item/ammo_box/magazine/m45)
	cost = 500
	faction = /datum/faction/srm

/datum/supply_pack/magazine/a44roum_speedloader
	name = ".44 Roumain Speedloader Crate"
	desc = "Contains a .44 Roumain speedloader for the HP Montagne, containing six rounds."
	contains = list(/obj/item/ammo_box/a44roum_speedloader)
	cost = 400
	faction = /datum/faction/srm

/* Serene Sporting */

/datum/supply_pack/magazine/m17_mag
	name = "Micro Target Magazine Crate"
	desc = "Contains a .22lr magazine for the Micro Target pistol, containing ten rounds."
	contains = list(/obj/item/ammo_box/magazine/m17)
	cost = 100

/datum/supply_pack/magazine/m12_mag
	name = "Sporter Magazine Crate"
	desc = "Contains a .22lr magazine for the Sporter Rifle, containing 25 rounds."
	contains = list(/obj/item/ammo_box/magazine/m12_sporter)
	cost = 200

/datum/supply_pack/magazine/m15_mag
	name = "Super Sporter Magazine Crate"
	desc = "Contains a 5.56 CLIP magazine for the Super Sporter Rifle, containing 20 rounds."
	contains = list(/obj/item/ammo_box/magazine/m15)
	cost = 300

/* Scarbie */

/datum/supply_pack/magazine/himehabu_mag
	name = "Himehabu Magazine Crate"
	desc = "Contains a .22lr magazine for the Himehabu pistol, containing ten rounds."
	contains = list(/obj/item/ammo_box/magazine/m22lr_himehabu)
	cost = 200
	faction = /datum/faction/syndicate/scarborough

/datum/supply_pack/magazine/asp_mag
	name = "Asp Magazine Crate"
	desc = "Contains a 5.7x39mm magazine for the Asp pistol, containing 12 rounds."
	contains = list(/obj/item/ammo_box/magazine/m57_39_asp)
	cost = 400
	faction = /datum/faction/syndicate/scarborough

/datum/supply_pack/magazine/m10mm_mag
	name = "Ringneck Magazine Crate"
	desc = "Contains a 10mm magazine for the Ringneck pistol, containing ten rounds."
	contains = list(/obj/item/ammo_box/magazine/m10mm_ringneck)
	cost = 500
	faction = /datum/faction/syndicate/scarborough

/datum/supply_pack/magazine/m9mm_rattlesnake
	name = "Rattlesnake Magazine Crate"
	desc = "Contains a 9mm magazine for the Rattlesnake machine pistol, contains 18 rounds."
	contains = list(/obj/item/ammo_box/magazine/m9mm_rattlesnake)
	cost = 500
	faction = /datum/faction/syndicate/scarborough

/datum/supply_pack/magazine/a357_mag
	name = ".357 Speedloader Crate"
	desc = "Contains a .357 speedloader for revolvers, containing seven rounds."
	contains = list(/obj/item/ammo_box/a357)
	cost = 750
	faction_discount = 20
	faction = /datum/faction/syndicate/scarborough

/datum/supply_pack/magazine/sidewinder_mag
	name = "Sidewinder Magazine Crate"
	desc = "Contains a 30 round magazine for the Sidewinder SMG."
	contains = list(/obj/item/ammo_box/magazine/m57_39_sidewinder)
	cost = 750
	faction_discount = 20
	faction = /datum/faction/syndicate/scarborough

/datum/supply_pack/magazine/c45_cobra_mag
	name = "Cobra Magazine Crate"
	desc = "Contains a .45 magazine for the Cobra-20, containing 24 rounds."
	cost = 750
	contains = list(/obj/item/ammo_box/magazine/m45_cobra)
	faction_discount = 20
	faction = /datum/faction/syndicate/scarborough

/datum/supply_pack/magazine/short_hydra_mag
	name = "SBR-80 DMR Short Magazine Crate"
	desc = "Contains a 5.56x42mm CLIP made specially for the SBR-80 Designated Marksman Rifle, containing 20 rounds."
	contains = list(/obj/item/ammo_box/magazine/m556_42_hydra/small)
	cost = 1000
	faction = /datum/faction/syndicate/scarborough

/datum/supply_pack/magazine/hydra_mag
	name = "SMR-80 Rifle Magazine Crate"
	desc = "Contains a 5.56x42mm CLIP for the SMR-80 assault rifle, containing 30 rounds."
	contains = list(/obj/item/ammo_box/magazine/m556_42_hydra)
	cost = 1500
	faction = /datum/faction/syndicate/scarborough

/datum/supply_pack/magazine/boomslang_mag
	name = "Boomslang-90 Magazine Crate"
	desc = "Contains a 6.5 CLIP magazine for the Boomslang rifle platform, containing five rounds."
	contains = list(/obj/item/ammo_box/magazine/boomslang/short)
	cost = 1000
	faction = /datum/faction/syndicate/scarborough

/* CM Lancaster */

/datum/supply_pack/magazine/cm23_mag
	name = "CM-23 Magazine Crate"
	desc = "Contains a 10mm magazine for the CM-23 handgun."
	contains = list(/obj/item/ammo_box/magazine/cm23)
	cost = 500
	faction = /datum/faction/clip

/datum/supply_pack/magazine/cm70_mag
	name = "CM-70 Magazine Crate"
	desc = "Contains a 9mm magazine for the CM-70 machinepistol."
	contains = list(/obj/item/ammo_box/magazine/m9mm_cm70)
	cost = 750
	faction = /datum/faction/clip

/datum/supply_pack/magazine/cm357_mag
	name = "CM-357 Magazine Crate"
	desc = "Contains a .357 magazine for the CM-357 automag pistol."
	contains = list(/obj/item/ammo_box/magazine/cm357)
	cost = 1000
	faction = /datum/faction/clip

/datum/supply_pack/magazine/cm5_mag
	name = "CM-5 Magazine Crate"
	desc = "Contains a 9mm magazine for the CM-5 SMG."
	contains = list(/obj/item/ammo_box/magazine/cm5_9mm)
	cost = 750
	faction = /datum/faction/clip

/datum/supply_pack/magazine/cm82_mag
	name = "CM-82 Magazine Crate"
	desc = "Contains a 5.56mm magazine for the CM-82 rifle, containing thirty rounds. Notably, these are also compatable with the P-16 rifle."
	contains = list(/obj/item/ammo_box/magazine/p16)
	cost = 1000
	faction = /datum/faction/clip

/datum/supply_pack/magazine/skm_ammo
	name = "SKM Magazine Crate"
	desc = "Contains a 7.62x40mm magazine for the SKM rifles, containing twenty rounds."
	contains = list(/obj/item/ammo_box/magazine/skm_762_40)
	cost = 1000

/datum/supply_pack/magazine/f4_mag
	name = "F4 Magazine Crate"
	desc = "Contains a .308 magazine for SsG-04 and CM-F4 platform rifles, containing ten rounds."
	contains = list(/obj/item/ammo_box/magazine/f4_308)
	cost = 1000
	faction = /datum/faction/clip

/datum/supply_pack/magazine/f90
	name = "CM-F90 Magazine Crate"
	desc = "Contains a 5-round 6.5mm magazine for use with the CM-F90 sniper rifle."
	contains = list(/obj/item/ammo_box/magazine/f90)
	cost = 1000
	faction = /datum/faction/clip

/datum/supply_pack/magazine/cm15
	name = "CM-15 Magazine Crate"
	desc = "Contains an 8-round 12ga magazine for the CM-15 Automatic Shotgun."
	contains = list(/obj/item/ammo_box/magazine/cm15_12g)
	cost = 1500
	faction = /datum/faction/clip

/* NT */

/datum/supply_pack/magazine/wt550_mag
	name = "WT-550 Auto Rifle Magazine Crate"
	desc = "Contains a 20-round magazine for the WT-550 Auto Rifle. Each magazine is designed to facilitate rapid tactical reloads."
	cost = 750
	contains = list(/obj/item/ammo_box/magazine/wt550m9)
	faction_discount = 20
	faction = /datum/faction/nt

/datum/supply_pack/magazine/ap_wt550_mag
	name = "WT-550 Auto Rifle AP Magazine Crate"
	desc = "Contains one magazine of armor-piercing ammunition for the WT-550 Auto Rifle."
	cost = 1000
	contains = list(/obj/item/ammo_box/magazine/wt550m9/ap)
	faction = /datum/faction/nt

/* SolGov */

/datum/supply_pack/magazine/mag_556mm
	name = "5.56 Pistole C Magazine Crate"
	desc = "Contains a 5.56mm magazine for the Pistole C, containing twelve rounds."
	contains = list(/obj/item/ammo_box/magazine/pistol556mm)
	cost = 750
	faction = /datum/faction/solgov

/datum/supply_pack/magazine/fms_mag
	name = "Ferromagnetic Slug Magazine Crate"
	desc = "Contains a ferromagnetic slug magazine for the Model H pistol, containing ten rounds."
	contains = list(/obj/item/ammo_box/magazine/modelh)
	cost = 750
	faction = /datum/faction/solgov

/datum/supply_pack/magazine/gar_ammo
	name = "GAR Ferromagnetic Lance Magazine Crate"
	desc = "Contains a ferromagnetic lance magazine for the GAR rifle, containing thirty two rounds."
	contains = list(/obj/item/ammo_box/magazine/gar)
	cost = 1000
	faction = /datum/faction/solgov

/datum/supply_pack/magazine/claris_ammo
	name = "Claris Ferromagnetic Pellet Speedloader Crate"
	desc = "Contains a ferromagnetic pellet speedloader for the Claris rifle, containing twenty two rounds."
	contains = list(/obj/item/ammo_box/amagpellet_claris)
	cost = 1000
	faction = /datum/faction/solgov

/* Inteq */

/datum/supply_pack/magazine/mongrel_mag
	name = "Mongrel Magazine Crate"
	desc = "Contains a 10mm magazine for the SKM-44v 'Mongrel' SMG, containing twenty-four rounds."
	contains = list(/obj/item/ammo_box/magazine/smgm10mm)
	cost = 750
	faction = /datum/faction/inteq

/* Shotguns */

/datum/supply_pack/magazine/bulldog
	name = "Bulldog Magazine Crate"
	desc = "Contains an 8-round 12ga box magazine for the Bulldog weapons platform."
	contains = list(/obj/item/ammo_box/magazine/m12g_bulldog)
	cost = 1000
	faction = /datum/faction/syndicate/scarborough


/* energy weapons */

/datum/supply_pack/magazine/guncell
	name = "Weapon Cell Crate"
	desc = "Contains a weapon cell, compatible with laser guns."
	contains = list(/obj/item/stock_parts/cell/gun)
	faction = /datum/faction/nt
	cost = 500

/datum/supply_pack/magazine/solgovcell
	name = "SolCon Weapon Cell Crate"
	desc = "Contains a Solarian weapon cell, compatible with Solarian gauss weaponry."
	contains = list(/obj/item/stock_parts/cell/gun/solgov)
	cost = 500
	faction = /datum/faction/solgov
	faction_discount = 0
	faction_locked = TRUE

/datum/supply_pack/magazine/upgradedguncell
	name = "Upgraded Weapon Cell Crate"
	desc = "Contains an upgraded weapon cell, compatible with laser guns. For NT use only."
	contains = list(/obj/item/stock_parts/cell/gun/upgraded)
	cost = 1500
	faction = /datum/faction/nt
	faction_discount = 0
	faction_locked = TRUE

/* etherbor */

/datum/supply_pack/magazine/guncell/kalix
	name = "Etherbor Cell Crate"
	desc = "Contains an Etherbor weapon cell, compatible with Etherbor armaments with a slightly higher capacity."
	contains = list(/obj/item/stock_parts/cell/gun/kalix)
	cost = 600
	faction = /datum/faction/pgf

/datum/supply_pack/magazine/guncell/pgf
	name = "Etherbor Cell Crate"
	desc = "Contains a military-grade Etherbor weapon cell produced for the PGFMC, compatible with Etherbor armaments with a significantly higher capacity."
	contains = list(/obj/item/stock_parts/cell/gun/pgf)
	cost = 1500
	faction = /datum/faction/pgf
	faction_discount = 0
	faction_locked = TRUE

/* Expand once the energy weapons have been actually expanded upon */
