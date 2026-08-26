class_name ActorDefinition
extends Resource
## Immutable content definition for one actor archetype.

@export var id: StringName
@export var localization_key: StringName
@export var tags: PackedStringArray
@export var base_health: int = 1
@export var base_attack: int = 1
@export var base_armor: int = 0
@export var footprint: Vector2 = Vector2.ONE
@export var ability_ids: Array[StringName] = []
@export var sprite_set_id: StringName
@export var ai_profile_id: StringName


func validate() -> Array[String]:
	var errors: Array[String] = []
	if id.is_empty():
		errors.append("id is required")
	if localization_key.is_empty():
		errors.append("localization_key is required")
	if base_health <= 0:
		errors.append("base_health must be positive")
	if base_attack < 0:
		errors.append("base_attack cannot be negative")
	if base_armor < 0:
		errors.append("base_armor cannot be negative")
	if footprint.x <= 0.0 or footprint.y <= 0.0:
		errors.append("footprint must be positive")
	return errors
