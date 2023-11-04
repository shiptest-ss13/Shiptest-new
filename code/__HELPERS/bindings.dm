#define AUXMOS (__detect_auxmos())

/proc/__detect_auxmos()
	if (world.system_type == UNIX)
		return "libauxmos"
	else
		return "auxmos"

/proc/finalize_gas_refs()
	return call_ext(AUXMOS, "byond:finalize_gas_refs_ffi")()

/datum/controller/subsystem/air/proc/auxtools_update_reactions()
	return call_ext(AUXMOS, "byond:update_reactions_ffi")()

/proc/auxtools_atmos_init(gas_data)
	return call_ext(AUXMOS, "byond:hook_init_ffi")(gas_data)

/proc/_auxtools_register_gas(gas)
	return call_ext(AUXMOS, "byond:hook_register_gas_ffi")(gas)

/turf/proc/__update_auxtools_turf_adjacency_info()
	return call_ext(AUXMOS, "byond:hook_infos_ffi")(src)

/turf/proc/update_air_ref(flag)
	return call_ext(AUXMOS, "byond:hook_register_turf_ffi")(src, flag)

/datum/controller/subsystem/air/proc/process_excited_groups_auxtools(remaining)
	return call_ext(AUXMOS, "byond:groups_hook_ffi")(src, remaining)

/datum/gas_mixture/proc/__auxtools_parse_gas_string(string)
	return call_ext(AUXMOS, "byond:parse_gas_string_ffi")(src, string)

/datum/controller/subsystem/air/proc/get_max_gas_mixes()
	return call_ext(AUXMOS, "byond:hook_max_gas_mixes_ffi")()

/datum/controller/subsystem/air/proc/get_amt_gas_mixes()
	return call_ext(AUXMOS, "byond:hook_amt_gas_mixes_ffi")()

/proc/equalize_all_gases_in_list(gas_list)
	return call_ext(AUXMOS, "byond:equalize_all_hook_ffi")(gas_list)

/datum/gas_mixture/proc/get_oxidation_power(temp)
	return call_ext(AUXMOS, "byond:oxidation_power_hook_ffi")(src, temp)

/datum/gas_mixture/proc/get_fuel_amount(temp)
	return call_ext(AUXMOS, "byond:fuel_amount_hook_ffi")(src, temp)

/datum/gas_mixture/proc/equalize_with(total)
	return call_ext(AUXMOS, "byond:equalize_with_hook_ffi")(src, total)

/datum/gas_mixture/proc/transfer_ratio_to(other, ratio)
	return call_ext(AUXMOS, "byond:transfer_ratio_hook_ffi")(src, other, ratio)

/datum/gas_mixture/proc/transfer_to(other, moles)
	return call_ext(AUXMOS, "byond:transfer_hook_ffi")(src, other, moles)

/datum/gas_mixture/proc/adjust_heat(temp)
	return call_ext(AUXMOS, "byond:adjust_heat_hook_ffi")(src, temp)

/datum/gas_mixture/proc/react(holder)
	return call_ext(AUXMOS, "byond:react_hook_ffi")(src, holder)

/datum/gas_mixture/proc/compare(other)
	return call_ext(AUXMOS, "byond:compare_hook_ffi")(src, other)

/datum/gas_mixture/proc/clear()
	return call_ext(AUXMOS, "byond:clear_hook_ffi")(src)

/datum/gas_mixture/proc/mark_immutable()
	return call_ext(AUXMOS, "byond:mark_immutable_hook_ffi")(src)

/datum/gas_mixture/proc/scrub_into(into, ratio_v, gas_list)
	return call_ext(AUXMOS, "byond:scrub_into_hook_ffi")(src, into, ratio_v, gas_list)

/datum/gas_mixture/proc/get_by_flag(flag_val)
	return call_ext(AUXMOS, "byond:get_by_flag_hook_ffi")(src, flag_val)

/datum/gas_mixture/proc/__remove_by_flag(into, flag_val, amount_val)
	return call_ext(AUXMOS, "byond:remove_by_flag_hook_ffi")(src, into, flag_val, amount_val)

/datum/gas_mixture/proc/divide(num_val)
	return call_ext(AUXMOS, "byond:divide_hook_ffi")(src, num_val)

/datum/gas_mixture/proc/multiply(num_val)
	return call_ext(AUXMOS, "byond:multiply_hook_ffi")(src, num_val)

/datum/gas_mixture/proc/subtract(num_val)
	return call_ext(AUXMOS, "byond:subtract_hook_ffi")(src, num_val)

/datum/gas_mixture/proc/add(num_val)
	return call_ext(AUXMOS, "byond:add_hook_ffi")(src, num_val)

/datum/gas_mixture/proc/adjust_multi(...)
	var/list/args_copy = args.Copy()
	args_copy.Insert(1, src)
	return call_ext(AUXMOS, "byond:adjust_multi_hook_ffi")(arglist(args_copy))

/datum/gas_mixture/proc/adjust_moles_temp(id_val, num_val, temp_val)
	return call_ext(AUXMOS, "byond:adjust_moles_temp_hook_ffi")(src, id_val, num_val, temp_val)

/datum/gas_mixture/proc/adjust_moles(id_val, num_val)
	return call_ext(AUXMOS, "byond:adjust_moles_hook_ffi")(src, id_val, num_val)

/datum/gas_mixture/proc/set_moles(gas_id, amt_val)
	return call_ext(AUXMOS, "byond:set_moles_hook_ffi")(src, gas_id, amt_val)

/datum/gas_mixture/proc/get_moles(gas_id)
	return call_ext(AUXMOS, "byond:get_moles_hook_ffi")(src, gas_id)

/datum/gas_mixture/proc/set_volume(vol_arg)
	return call_ext(AUXMOS, "byond:set_volume_hook_ffi")(src, vol_arg)

/datum/gas_mixture/proc/partial_heat_capacity(gas_id)
	return call_ext(AUXMOS, "byond:partial_heat_capacity_ffi")(src, gas_id)

/datum/gas_mixture/proc/set_temperature(arg_temp)
	return call_ext(AUXMOS, "byond:set_temperature_hook_ffi")(src, arg_temp)

/datum/gas_mixture/proc/get_gases()
	return call_ext(AUXMOS, "byond:get_gases_hook_ffi")(src)

/datum/gas_mixture/proc/temperature_share(...)
	var/list/args_copy = args.Copy()
	args_copy.Insert(1, src)
	return call_ext(AUXMOS, "byond:temperature_share_hook_ffi")(arglist(args_copy))

/datum/gas_mixture/proc/copy_from(giver)
	return call_ext(AUXMOS, "byond:copy_from_hook_ffi")(src, giver)

/datum/gas_mixture/proc/__remove(into, amount_arg)
	return call_ext(AUXMOS, "byond:remove_hook_ffi")(src, into, amount_arg)

/datum/gas_mixture/proc/__remove_ratio(into, ratio_arg)
	return call_ext(AUXMOS, "byond:remove_ratio_hook_ffi")(src, into, ratio_arg)

/datum/gas_mixture/proc/merge(giver)
	return call_ext(AUXMOS, "byond:merge_hook_ffi")(src, giver)

/datum/gas_mixture/proc/thermal_energy()
	return call_ext(AUXMOS, "byond:thermal_energy_hook_ffi")(src)

/datum/gas_mixture/proc/return_volume()
	return call_ext(AUXMOS, "byond:return_volume_hook_ffi")(src)

/datum/gas_mixture/proc/return_temperature()
	return call_ext(AUXMOS, "byond:return_temperature_hook_ffi")(src)

/datum/gas_mixture/proc/return_pressure()
	return call_ext(AUXMOS, "byond:return_pressure_hook_ffi")(src)

/datum/gas_mixture/proc/total_moles()
	return call_ext(AUXMOS, "byond:total_moles_hook_ffi")(src)

/datum/gas_mixture/proc/set_min_heat_capacity(arg_min)
	return call_ext(AUXMOS, "byond:min_heat_cap_hook_ffi")(src, arg_min)

/datum/gas_mixture/proc/heat_capacity()
	return call_ext(AUXMOS, "byond:heat_cap_hook_ffi")(src)

/datum/gas_mixture/proc/__gasmixture_unregister()
	return call_ext(AUXMOS, "byond:unregister_gasmixture_hook_ffi")(src)

/datum/gas_mixture/proc/__gasmixture_register()
	return call_ext(AUXMOS, "byond:register_gasmixture_hook_ffi")(src)

/proc/process_atmos_callbacks(remaining)
	return call_ext(AUXMOS, "byond:atmos_callback_handle_ffi")(remaining)

/proc/__auxmos_shutdown()
	return call_ext(AUXMOS, "byond:auxmos_shutdown_ffi")()

/datum/controller/subsystem/air/proc/process_turfs_auxtools(remaining)
	return call_ext(AUXMOS, "byond:process_turf_hook_ffi")(src, remaining)

/datum/controller/subsystem/air/proc/finish_turf_processing_auxtools(time_remaining)
	return call_ext(AUXMOS, "byond:finish_process_turfs_ffi")(time_remaining)

/datum/controller/subsystem/air/proc/thread_running()
	return call_ext(AUXMOS, "byond:thread_running_hook_ffi")()

/datum/controller/subsystem/air/proc/process_turf_equalize_auxtools(remaining)
	return call_ext(AUXMOS, "byond:equalize_hook_ffi")(src, remaining)
