// General or un-matched particles, make a new file if a few can be sorted together.
/particles/pollen
	icon = 'icons/effects/particles/pollen.dmi'
	icon_state = "pollen"
	width = 100
	height = 100
	count = 1000
	spawning = 4
	lifespan = 0.7 SECONDS
	fade = 1 SECONDS
	grow = -0.01
	velocity = list(0, 0)
	position = generator(GEN_CIRCLE, 0, 16, NORMAL_RAND)
	drift = generator(GEN_VECTOR, list(0, -0.2), list(0, 0.2))
	gravity = list(0, 0.95)
	scale = generator(GEN_VECTOR, list(0.3, 0.3), list(1,1), NORMAL_RAND)
	rotation = 30
	spin = generator(GEN_NUM, -20, 20)

/particles/echo
	icon = 'icons/effects/particles/echo.dmi'
	icon_state = list("echo1" = 1, "echo2" = 1, "echo3" = 2)
	width = 480
	height = 480
	count = 1000
	spawning = 0.5
	lifespan = 2 SECONDS
	fade = 1 SECONDS
	gravity = list(0, -0.1)
	position = generator(GEN_BOX, list(-240, -240), list(240, 240), NORMAL_RAND)
	drift = generator(GEN_VECTOR, list(-0.1, 0), list(0.1, 0))
	rotation = generator(GEN_NUM, 0, 360, NORMAL_RAND)

/particles/elzouse_leaves
	icon = 'icons/effects/particles/generic.dmi'
	icon_state = "curl"
	width = 32
	height = 36
	count = 5
	spawning = 0.025
	lifespan = 1 SECONDS
	fade = 0.5 SECONDS
	position = generator(GEN_BOX, list(-9,-9,0), list(9,18,0), NORMAL_RAND)
	scale = generator(GEN_VECTOR, list(0.9,0.9), list(1.1,1.1), NORMAL_RAND)
	gravity = list(0, -0.1)
	drift = generator(GEN_VECTOR, list(0, -0.2), list(0, 0.2))
	rotation = 30
	spin = generator(GEN_NUM, -20, 20)
