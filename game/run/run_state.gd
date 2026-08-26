class_name RunState
extends RefCounted
## Runtime state for one deterministic run; definitions remain immutable Resources.

enum Status { AWAITING_MAP, RUNNING, AWAITING_REWARD, VICTORY, DEFEAT, SUSPENDED }

var schema_version: int = 1
var content_version: int = 1
var seed: int
var school_id: StringName
var chapter_index: int = 0
var current_node_index: int = 0
var build: Array[StringName] = []
var essence: int = 0
var status: Status = Status.AWAITING_MAP


func _init(run_seed: int, selected_school: StringName) -> void:
	assert(not selected_school.is_empty(), "school id must be set")
	seed = run_seed
	school_id = selected_school


func add_reward(reward_id: StringName) -> void:
	assert(not reward_id.is_empty(), "reward id must be set")
	build.append(reward_id)


func to_snapshot() -> Dictionary:
	return {
		"schema_version": schema_version,
		"content_version": content_version,
		"seed": seed,
		"school_id": school_id,
		"chapter_index": chapter_index,
		"current_node_index": current_node_index,
		"build": build.duplicate(),
		"essence": essence,
		"status": status,
	}
