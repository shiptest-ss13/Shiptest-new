SUBSYSTEM_DEF(autotransfer)
	name = "Autotransfer Vote"
	flags = SS_KEEP_TIMING | SS_BACKGROUND
	wait = 1 MINUTES

	COOLDOWN_DECLARE(next_vote)

/datum/controller/subsystem/autotransfer/Initialize(timeofday)
	COOLDOWN_START(src, next_vote, CONFIG_GET(number/vote_autotransfer_initial))
	return ..()

/datum/controller/subsystem/autotransfer/fire()
	if(COOLDOWN_FINISHED(src, next_vote))
		SSvote.initiate_vote(/datum/vote/transfer_vote, "The Server", forced = TRUE)
		COOLDOWN_START(src, next_vote, CONFIG_GET(number/vote_autotransfer_interval))

/datum/controller/subsystem/autotransfer/Recover()
	next_vote = SSautotransfer.next_vote
