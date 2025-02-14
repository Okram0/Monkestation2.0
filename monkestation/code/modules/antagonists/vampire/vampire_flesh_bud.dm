// This is what makes someone a vampiric thrall.

/obj/item/organ/internal/flesh_bud
	name = "flesh bud"
	desc = "An abominable and sickly looking ball of flesh with tendrils soaked in a clear fluid. Almost like a brain tumor, but so much worse."
	icon = 'monkestation/icons/vampires/vampire_obj.dmi'
	icon_state = "flesh_bud"
	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_VAMPIRE_FLESH_BUD

	var/datum/antagonist/vampire/master_vampire

/obj/item/organ/internal/flesh_bud/on_insert(mob/living/carbon/organ_owner, special)
	. = ..()
	RegisterSignals(organ_owner, list(COMSIG_MOB_MIND_TRANSFERRED_INTO, COMSIG_MOB_MIND_INITIALIZED), PROC_REF(on_mind_added_to_owner))
	if (organ_owner.mind)
		add_thrall_datum(organ_owner.mind)

/obj/item/organ/internal/flesh_bud/on_remove(mob/living/carbon/organ_owner, special)
	. = ..()
	UnregisterSignal(organ_owner, list(COMSIG_MOB_MIND_TRANSFERRED_INTO, COMSIG_MOB_MIND_INITIALIZED))
	if (organ_owner.mind)
		remove_thrall_datum(organ_owner.mind)

/obj/item/organ/internal/flesh_bud/proc/add_thrall_datum(datum/mind/mind)
	RegisterSignals(mind, list(COMSIG_MIND_TRANSFERRED, COMSIG_QDELETING), PROC_REF(on_mind_removed_from_owner))

	var/datum/antagonist/vampire/antag_datum = mind.has_antag_datum(/datum/antagonist/vampire)
	if (antag_datum?.current_rank > 0)
		return

	mind.add_antag_datum(/datum/antagonist/vampire/thrall)

/obj/item/organ/internal/flesh_bud/proc/remove_thrall_datum(datum/mind/mind)
	UnregisterSignal(mind, list(COMSIG_MIND_TRANSFERRED, COMSIG_QDELETING), PROC_REF(on_mind_removed_from_owner))

	var/datum/antagonist/vampire/antag_datum = mind.has_antag_datum(/datum/antagonist/vampire)
	if (antag_datum?.current_rank > 0)
		return

	mind.remove_antag_datum(/datum/antagonist/vampire/thrall)

/obj/item/organ/internal/flesh_bud/proc/on_mind_added_to_owner(mob/living/carbon/owner)
	SIGNAL_HANDLER
	add_thrall_datum(owner.mind)

/obj/item/organ/internal/flesh_bud/proc/on_mind_removed_from_owner(datum/mind/mind)
	SIGNAL_HANDLER
	remove_thrall_datum(mind)
