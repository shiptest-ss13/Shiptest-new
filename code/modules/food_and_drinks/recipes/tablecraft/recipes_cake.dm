
// see code/module/crafting/table.dm

////////////////////////////////////////////////CAKE////////////////////////////////////////////////

/datum/crafting_recipe/food/carrotcake
	name = "Carrot cake"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/reagent_containers/food/snacks/grown/carrot = 2
	)
	result = /obj/item/food/cake/carrot
	subcategory = CAT_CAKE

/datum/crafting_recipe/food/cheesecake
	name = "Cheese cake"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/reagent_containers/food/snacks/cheesewedge = 2
	)
	result = /obj/item/food/cake/cheese
	subcategory = CAT_CAKE

/datum/crafting_recipe/food/applecake
	name = "Apple cake"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/reagent_containers/food/snacks/grown/apple = 2
	)
	result = /obj/item/food/cake/apple
	subcategory = CAT_CAKE

/datum/crafting_recipe/food/orangecake
	name = "Orange cake"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/reagent_containers/food/snacks/grown/citrus/orange = 2
	)
	result = /obj/item/food/cake/orange
	subcategory = CAT_CAKE

/datum/crafting_recipe/food/limecake
	name = "Lime cake"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/reagent_containers/food/snacks/grown/citrus/lime = 2
	)
	result = /obj/item/food/cake/lime
	subcategory = CAT_CAKE

/datum/crafting_recipe/food/lemoncake
	name = "Lemon cake"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/reagent_containers/food/snacks/grown/citrus/lemon = 2
	)
	result = /obj/item/food/cake/lemon
	subcategory = CAT_CAKE

/datum/crafting_recipe/food/chocolatecake
	name = "Chocolate cake"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/reagent_containers/food/snacks/chocolatebar = 2
	)
	result = /obj/item/food/cake/chocolate
	subcategory = CAT_CAKE

/datum/crafting_recipe/food/birthdaycake
	name = "Birthday cake"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/candle = 1,
		/datum/reagent/consumable/sugar = 5,
		/datum/reagent/consumable/caramel = 2
	)
	result = /obj/item/food/cake/birthday
	subcategory = CAT_CAKE

/datum/crafting_recipe/food/energycake
	name = "Energy cake"
	reqs = list(
		/obj/item/food/cake/birthday = 1,
		/obj/item/melee/transforming/energy/sword = 1,
	)
	blacklist = list(/obj/item/food/cake/birthday/energy)
	result = /obj/item/food/cake/birthday/energy
	subcategory = CAT_CAKE

/datum/crafting_recipe/food/braincake
	name = "Brain cake"
	reqs = list(
		/obj/item/organ/brain = 1,
		/obj/item/food/cake/plain = 1
	)
	result = /obj/item/food/cake/brain
	subcategory = CAT_CAKE

/datum/crafting_recipe/food/slimecake
	name = "Slime cake"
	reqs = list(
		/obj/item/slime_extract = 1,
		/obj/item/food/cake/plain = 1
	)
	result = /obj/item/food/cake/slimecake
	subcategory = CAT_CAKE

/datum/crafting_recipe/food/pumpkinspicecake
	name = "Pumpkin spice cake"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/reagent_containers/food/snacks/grown/pumpkin = 2
	)
	result = /obj/item/food/cake/pumpkinspice
	subcategory = CAT_CAKE

/datum/crafting_recipe/food/holycake
	name = "Angel food cake"
	reqs = list(
		/datum/reagent/water/holywater = 15,
		/obj/item/food/cake/plain = 1
	)
	result = /obj/item/food/cake/holy_cake
	subcategory = CAT_CAKE

/datum/crafting_recipe/food/poundcake
	name = "Pound cake"
	reqs = list(
		/obj/item/food/cake/plain = 4
	)
	result = /obj/item/food/cake/pound_cake
	subcategory = CAT_CAKE

/datum/crafting_recipe/food/hardwarecake
	name = "Hardware cake"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/circuitboard = 2,
		/datum/reagent/toxin/acid = 5
	)
	result = /obj/item/food/cake/hardware_cake
	subcategory = CAT_CAKE

/datum/crafting_recipe/food/bscvcake
	name = "blackberry and strawberry vanilla cake"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/reagent_containers/food/snacks/grown/berries = 5
	)
	result = /obj/item/food/cake/bsvc
	subcategory = CAT_CAKE

/datum/crafting_recipe/food/clowncake
	name = "clown cake"
	always_availible = FALSE
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/reagent_containers/food/snacks/sundae = 2,
		/obj/item/reagent_containers/food/snacks/grown/banana = 5
	)
	result = /obj/item/food/cake/clown_cake
	subcategory = CAT_CAKE

/datum/crafting_recipe/food/vanillacake
	name = "vanilla cake"
	always_availible = FALSE
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/reagent_containers/food/snacks/grown/vanillapod = 2
	)
	result = /obj/item/food/cake/vanilla_cake
	subcategory = CAT_CAKE
