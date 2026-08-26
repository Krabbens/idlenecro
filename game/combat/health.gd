class_name Health
extends RefCounted
## Controls current and maximum health for one runtime actor.

signal changed(previous: int, current: int)
signal depleted

var current: int
var maximum: int


func _init(initial_maximum: int) -> void:
	assert(initial_maximum > 0, "maximum health must be positive")
	maximum = initial_maximum
	current = initial_maximum


func apply_damage(amount: int) -> int:
	if amount <= 0 or current == 0:
		return 0
	var previous := current
	current = maxi(0, current - amount)
	changed.emit(previous, current)
	if current == 0:
		depleted.emit()
	return previous - current
