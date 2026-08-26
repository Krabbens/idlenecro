class_name AbilityDefinition
extends Resource
## Immutable content definition for one automatic ability.

enum TargetType { SELF, ALLY, ENEMY, AREA }

@export var id: StringName
@export var localization_key: StringName
@export var tags: PackedStringArray
@export var target_type: TargetType = TargetType.ENEMY
@export var cost: int = 0
@export var cooldown_ticks: int = 1
@export var contact_tick: int = 0
@export var range_tiles: int = 1
@export var effect_ids: Array[StringName] = []
@export var vfx_id: StringName
@export var audio_id: StringName


func validate() -> Array[String]:
	var errors: Array[String] = []
	if id.is_empty():
		errors.append("id is required")
	if localization_key.is_empty():
		errors.append("localization_key is required")
	if cost < 0:
		errors.append("cost cannot be negative")
	if cooldown_ticks <= 0:
		errors.append("cooldown_ticks must be positive")
	if contact_tick < 0 or contact_tick >= cooldown_ticks:
		errors.append("contact_tick must be inside cooldown")
	if range_tiles <= 0:
		errors.append("range_tiles must be positive")
	return errors
