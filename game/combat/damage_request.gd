class_name DamageRequest
extends RefCounted
## Immutable damage intent resolved after target selection.

var source_id: int
var target_id: int
var amount: int


func _init(source: int, target: int, raw_amount: int) -> void:
	assert(source >= 0 and target >= 0, "damage ids must be non-negative")
	assert(raw_amount >= 0, "damage amount cannot be negative")
	source_id = source
	target_id = target
	amount = raw_amount
