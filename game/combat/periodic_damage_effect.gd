class_name PeriodicDamageEffect
extends RefCounted
## Deterministic damage effect advanced after direct contacts in a tick.

var id: StringName
var damage_per_proc: int
var interval_ticks: int
var remaining_ticks: int
var _elapsed_ticks: int = 0


func _init(
		effect_id: StringName,
		damage: int,
		interval: int,
		duration: int
) -> void:
	assert(not effect_id.is_empty(), "periodic effect id must be set")
	assert(damage > 0, "periodic damage must be positive")
	assert(interval > 0, "periodic interval must be positive")
	assert(duration > 0, "periodic duration must be positive")
	id = effect_id
	damage_per_proc = damage
	interval_ticks = interval
	remaining_ticks = duration


func advance_tick() -> int:
	if remaining_ticks <= 0:
		return 0
	remaining_ticks -= 1
	_elapsed_ticks += 1
	if _elapsed_ticks < interval_ticks:
		return 0
	_elapsed_ticks = 0
	return damage_per_proc


func is_expired() -> bool:
	return remaining_ticks <= 0
