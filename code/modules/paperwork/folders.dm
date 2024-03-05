/obj/item/folder
	name = "folder"
	desc = "A folder."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "folder"
	w_class = WEIGHT_CLASS_SMALL
	pressure_resistance = 2
	resistance_flags = FLAMMABLE

/obj/item/folder/blue
	desc = "A blue folder."
	icon_state = "folder_blue"

/obj/item/folder/red
	desc = "A red folder."
	icon_state = "folder_red"

/obj/item/folder/yellow
	desc = "A yellow folder."
	icon_state = "folder_yellow"

/obj/item/folder/white
	desc = "A white folder."
	icon_state = "folder_white"

/obj/item/folder/solgov
	desc = "A blue folder with a SolGov seal."
	icon_state = "folder_solgov"

/obj/item/folder/terragov
	desc = "A green folder with a Terran Regency seal."
	icon_state = "folder_terragov"

/obj/item/folder/update_overlays()
	. = ..()
	if(contents.len)
		. += "folder_paper"


/obj/item/folder/attackby(obj/item/W, mob/user, params)
	if(burn_paper_product_attackby_check(W, user))
		return
	if(istype(W, /obj/item/paper) || istype(W, /obj/item/photo) || istype(W, /obj/item/documents) || istype(W, /obj/item/disk))
		if(!user.transferItemToLoc(W, src))
			return
		to_chat(user, "<span class='notice'>You put [W] into [src].</span>")
		update_appearance()
	else if(istype(W, /obj/item/pen))
		if(!user.is_literate())
			to_chat(user, "<span class='notice'>You scribble illegibly on the cover of [src]!</span>")
			return

		var/inputvalue = stripped_input(user, "What would you like to label the folder?", "Folder Labelling", "", MAX_NAME_LEN)

		if(!inputvalue)
			return

		if(user.canUseTopic(src, BE_CLOSE))
			name = "folder[(inputvalue ? " - '[inputvalue]'" : null)]"


/obj/item/folder/attack_self(mob/user)
	var/dat = "<title>[name]</title>"

	for(var/obj/item/I in src)
		dat += "<A href='?src=[REF(src)];remove=[REF(I)]'>Remove</A> - <A href='?src=[REF(src)];read=[REF(I)]'>[I.name]</A><BR>"
	user << browse(dat, "window=folder")
	onclose(user, "folder")
	add_fingerprint(usr)


/obj/item/folder/Topic(href, href_list)
	..()
	if(usr.stat != CONSCIOUS || HAS_TRAIT(usr, TRAIT_HANDS_BLOCKED))
		return

	if(usr.contents.Find(src))

		if(href_list["remove"])
			var/obj/item/I = locate(href_list["remove"]) in src
			if(istype(I))
				I.forceMove(usr.loc)
				usr.put_in_hands(I)

		if(href_list["read"])
			var/obj/item/I = locate(href_list["read"]) in src
			if(istype(I))
				usr.examinate(I)

		//Update everything
		attack_self(usr)
		update_appearance()

/obj/item/folder/documents
	name = "folder- 'TOP SECRET'"
	desc = "A folder stamped \"Top Secret - Property of Nanotrasen Corporation. Unauthorized distribution is punishable by death.\""

/obj/item/folder/documents/Initialize()
	. = ..()
	new /obj/item/documents/nanotrasen(src)
	update_appearance()

/obj/item/folder/syndicate
	icon_state = "folder_syndie"
	name = "folder- 'TOP SECRET'"
	desc = "A folder stamped \"Top Secret - Property of The Syndicate.\""

/obj/item/folder/syndicate/red
	icon_state = "folder_sred"

/obj/item/folder/syndicate/red/Initialize()
	. = ..()
	new /obj/item/documents/syndicate/red(src)
	update_appearance()

/obj/item/folder/syndicate/blue
	icon_state = "folder_sblue"

/obj/item/folder/syndicate/blue/Initialize()
	. = ..()
	new /obj/item/documents/syndicate/blue(src)
	update_appearance()

/obj/item/folder/syndicate/mining/Initialize()
	. = ..()
	new /obj/item/documents/syndicate/mining(src)
	update_appearance()

/obj/item/folder/solgov/red
	desc = "A blue folder with a SolGov seal."
	icon_state = "folder_solgovred"

/obj/item/folder/solgov/red/Initialize()
	. = ..()
	new /obj/item/documents/solgov(src)
	update_appearance()

/obj/item/folder/terragov/red
	desc = "A green folder with a Terran Regency seal."
	icon_state = "folder_terragovred"

/obj/item/folder/terragov/red/Initialize()
	. = ..()
	new /obj/item/documents/terragov(src)
	update_appearance()

/obj/item/folder/suns/red
	desc = "A green folder with a Terran Regency seal."
	icon_state = "folder_terragovred"

/obj/item/folder/suns/red/Initialize()
	. = ..()
	new /obj/item/documents/suns(src)
	update_appearance()
