class_name EncounterDefinition
extends Resource
## Immutable content definition for one encounter node.

enum NodeType { COMBAT, ELITE, RITUAL, EVENT, RELIQUARY, BOSS }

@export var id: StringName
@export var biome_id: StringName
@export var node_type: NodeType = NodeType.COMBAT
@export var difficulty: int = 1
@export var spawn_group_ids: Array[StringName] = []
@export var modifier_ids: Array[StringName] = []
@export var reward_table_id: StringName
@export var variant_seed_salt: int = 0


func validate() -> Array[String]:
	var errors: Array[String] = []
	if id.is_empty():
		errors.append("id is required")
	if biome_id.is_empty():
		errors.append("biome_id is required")
	if difficulty <= 0:
		errors.append("difficulty must be positive")
	if spawn_group_ids.is_empty() and node_type in [NodeType.COMBAT, NodeType.ELITE, NodeType.BOSS]:
		errors.append("combat encounter needs at least one spawn group")
	if reward_table_id.is_empty():
		errors.append("reward_table_id is required")
	return errors
