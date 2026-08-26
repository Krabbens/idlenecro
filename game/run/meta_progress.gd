class_name MetaProgress
extends RefCounted
## Persistent unlocks and currencies; never contains temporary run state.

var grave_dust: int = 0
var seals: Dictionary[StringName, int] = {}
var unlocked_schools: Array[StringName] = [&"grave_caller"]
var highest_confirmed_chapter: int = 0
var claimed_one_time_rewards: Array[StringName] = []


func to_dict() -> Dictionary:
	return {
		"grave_dust": grave_dust,
		"seals": seals.duplicate(),
		"unlocked_schools": unlocked_schools.duplicate(),
		"highest_confirmed_chapter": highest_confirmed_chapter,
		"claimed_one_time_rewards": claimed_one_time_rewards.duplicate(),
	}


static func from_dict(raw: Dictionary) -> MetaProgress:
	var progress := MetaProgress.new()
	progress.grave_dust = maxi(0, int(raw.get("grave_dust", 0)))
	var raw_seals: Variant = raw.get("seals", {})
	if raw_seals is Dictionary:
		for key in (raw_seals as Dictionary).keys():
			progress.seals[StringName(key)] = maxi(0, int((raw_seals as Dictionary)[key]))
	var raw_schools: Variant = raw.get("unlocked_schools", [&"grave_caller"])
	if raw_schools is Array:
		progress.unlocked_schools.clear()
		for school in raw_schools as Array:
			if not StringName(school).is_empty():
				progress.unlocked_schools.append(StringName(school))
		if progress.unlocked_schools.is_empty():
			progress.unlocked_schools.append(&"grave_caller")
	progress.highest_confirmed_chapter = maxi(0, int(raw.get("highest_confirmed_chapter", 0)))
	var raw_claimed: Variant = raw.get("claimed_one_time_rewards", [])
	if raw_claimed is Array:
		for reward in raw_claimed as Array:
			if not StringName(reward).is_empty():
				progress.claimed_one_time_rewards.append(StringName(reward))
	return progress
