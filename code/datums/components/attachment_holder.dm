/datum/component/attachment_holder
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS

	var/list/valid_types = null
	var/list/slot_room = null
	var/list/slot_offsets = null
	var/list/obj/item/attachments = list()

/datum/component/attachment_holder/Initialize(
	list/slot_room = null,
	list/valid_types = null,
	list/slot_offsets = null,
	list/default_attachments = null
	)

	if(!isgun(parent))
		return COMPONENT_INCOMPATIBLE

	src.slot_room = slot_room
	src.valid_types = valid_types
	src.slot_offsets = slot_offsets

	RegisterSignal(parent, COMSIG_PARENT_ATTACKBY, PROC_REF(handle_attack))
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(handle_examine))
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE_MORE, PROC_REF(handle_examine_more))
	RegisterSignal(parent, COMSIG_PARENT_QDELETING, PROC_REF(handle_qdel))
	RegisterSignal(parent, COMSIG_ITEM_PRE_ATTACK, PROC_REF(handle_item_pre_attack))
	RegisterSignal(parent, COMSIG_CLICK_CTRL_SHIFT, PROC_REF(handle_ctrl_shift_click))
	RegisterSignal(parent, COMSIG_ATOM_UPDATE_OVERLAYS, PROC_REF(handle_overlays))

	if(default_attachments)
		for(var/obj/item/attachment/attachment in default_attachments)
			INVOKE_ASYNC(src, PROC_REF(do_attach), attachment, null)

/datum/component/attachment_holder/proc/handle_overlays(obj/item/parent, list/overlays)
	SIGNAL_HANDLER

	for(var/obj/item/attachment/attach as anything in attachments)
		var/slot = SEND_SIGNAL(attach, COMSIG_ATTACHMENT_GET_SLOT)
		slot = attachment_slot_from_bflag(slot)
		var/list/attach_overlays = list()
		SEND_SIGNAL(attach, COMSIG_ATTACHMENT_UPDATE_OVERLAY, attach_overlays)
		for(var/mutable_appearance/overlay as anything in attach_overlays)
			if(slot_offsets && slot_offsets[slot])
				var/matrix/overlay_matrix = new
				overlay_matrix.Translate(slot_offsets[slot]["x"] - attach.pixel_shift_x, slot_offsets[slot]["y"] - attach.pixel_shift_y)
				overlay.transform = overlay_matrix
			overlays += overlay

/datum/component/attachment_holder/proc/handle_qdel()
	SIGNAL_HANDLER
	qdel(src)

/datum/component/attachment_holder/Destroy(force, silent)
	QDEL_LIST(attachments)
	attachments = null
	return ..()

/datum/component/attachment_holder/proc/attachments_to_list(only_toggles = FALSE)
	. = list()
	for(var/obj/item/attachment/attach as anything in attachments)
		if(attach.name in .)
			stack_trace("two attachments with same name; this shouldn't happen and will cause failures")
			continue
		if(only_toggles && !attach.has_toggle)
			continue
		.[attach.name] = attach

/datum/component/attachment_holder/proc/handle_ctrl_shift_click(obj/item/parent, mob/user)
	SIGNAL_HANDLER

	INVOKE_ASYNC(src, PROC_REF(do_attachment_radial), parent, user)

/datum/component/attachment_holder/proc/do_attachment_radial(obj/item/parent, mob/user)
	var/list/attachments_as_list = attachments_to_list(TRUE)
	var/selection = show_radial_menu(user, parent, attachments_as_list)
	var/obj/item/attach = attachments_as_list[selection]
	if(!attach)
		return
	SEND_SIGNAL(attach, COMSIG_ATTACHMENT_TOGGLE, parent, user)
	parent.update_icon()

/datum/component/attachment_holder/proc/handle_examine(obj/item/parent, mob/user, list/examine_list)
	if(length(attachments))
		examine_list += "<span class='notice'>It has [length(attachments)] attachments.</span>"

	for(var/obj/item/attach as anything in attachments)
		SEND_SIGNAL(attach, COMSIG_ATTACHMENT_EXAMINE, user, examine_list)

/datum/component/attachment_holder/proc/handle_examine_more(obj/item/parent, mob/user, list/examine_list)
	if(!length(attachments))
		return
	examine_list += "<span class='notice'>It has the following attachments:</span>"
	for(var/obj/item/attach as anything in attachments)
		examine_list += "<span class='notice'>\t- [attach.name]</span>"
	examine_list += "<span class='notice'>\tThey can be removed with a <i>crowbar</i></span>"
	for(var/obj/item/attach as anything in attachments)
		SEND_SIGNAL(attach, COMSIG_ATTACHMENT_EXAMINE_MORE, user, examine_list)

/datum/component/attachment_holder/proc/do_attach(obj/item/attachment, mob/user)
	var/slot = SEND_SIGNAL(attachment, COMSIG_ATTACHMENT_GET_SLOT)
	slot = attachment_slot_from_bflag(slot)
	if(!(attachment.type in valid_types))
		to_chat(user, "<span class='notice'>[attachment] is not a valid attachment for this [parent]!</span>")
		return
	if(!slot_room[slot])
		to_chat(user, "<span class='notice'>[parent] does not contain room for [attachment]!</span>")
		return
	slot_room[slot]--
	. = SEND_SIGNAL(attachment, COMSIG_ATTACHMENT_ATTACH, parent, user)
	if(.)
		attachments += attachment
		var/atom/parent = src.parent
		parent.update_icon()
	
/datum/component/attachment_holder/proc/do_detach(obj/item/attachment, mob/user)
	var/slot = SEND_SIGNAL(attachment, COMSIG_ATTACHMENT_GET_SLOT)
	slot = attachment_slot_from_bflag(slot)
	if(slot in slot_room)
		slot_room[slot]++
	. = SEND_SIGNAL(attachment, COMSIG_ATTACHMENT_DETACH, parent, user)
	if(.)
		attachments -= attachment
		var/atom/parent = src.parent
		parent.update_icon()

/datum/component/attachment_holder/proc/handle_detach(obj/item/parent, obj/item/tool, mob/user)
	var/list/list = list()
	for(var/obj/item/attach as anything in attachments)
		list[attach.name] = attach
	var/selected = tgui_input_list(user, "Select Attachment", "Detach", list)
	if(!parent.Adjacent(user) || !selected || !tool || !tool.use_tool(parent, user, 2 SECONDS * tool.toolspeed))
		return
	do_detach(list[selected], user)

/datum/component/attachment_holder/proc/handle_attack(obj/item/parent, obj/item/item, mob/user)
	SIGNAL_HANDLER

	if(!user.Adjacent(parent))
		return

	if(item.tool_behaviour == TOOL_CROWBAR && length(attachments))
		INVOKE_ASYNC(src, PROC_REF(handle_detach), parent, item, user)
		return TRUE

	if(HAS_TRAIT(item, TRAIT_ATTACHABLE))
		INVOKE_ASYNC(src, PROC_REF(do_attach), item, user)
		return TRUE

	for(var/obj/item/attach as anything in attachments)
		if(SEND_SIGNAL(attach, COMSIG_ATTACHMENT_ATTACK, parent, item, user))
			parent.update_icon()
			return TRUE

/datum/component/attachment_holder/proc/handle_item_pre_attack(obj/item/parent, atom/target_atom, mob/user, params)
	SIGNAL_HANDLER

	for(var/obj/item/attach as anything in attachments)
		if(SEND_SIGNAL(attach, COMSIG_ATTACHMENT_PRE_ATTACK, parent, target_atom, user, params))
			user.do_attack_animation(target_atom)
			parent.update_icon()
			return TRUE
