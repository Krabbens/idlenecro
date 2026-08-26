class_name CombatantState
extends RefCounted
## Runtime combat state; never stored in an ActorDefinition resource.

var runtime_id: int
var faction: StringName
var position: Vector2i
var health: Health
var attack_damage: int
var armor: int
var attack_interval_ticks: int
var attack_range: int
var effects: Array[PeriodicDamageEffect] = []


func _init(
		id: int,
		actor_faction: StringName,
		spawn_position: Vector2i,
		maximum_health: int,
		damage: int,
		armor_value: int = 0,
		attack_interval: int = 20,
		range_tiles: int = 1
	) -> void:
	assert(id >= 0, "runtime id must be non-negative")
	assert(not actor_faction.is_empty(), "faction must be set")
	assert(damage >= 0, "attack damage cannot be negative")
	assert(armor_value >= 0, "armor cannot be negative")
	assert(attack_interval > 0, "attack interval must be positive")
	runtime_id = id
	faction = actor_faction
	position = spawn_position
	health = Health.new(maximum_health)
	attack_damage = damage
	armor = armor_value
	attack_interval_ticks = attack_interval
	attack_range = range_tiles


func apply_damage(raw_amount: int) -> int:
	var mitigated := maxi(0, raw_amount - armor)
	return health.apply_damage(mitigated)


func add_periodic_effect(effect: PeriodicDamageEffect) -> void:
	effects.append(effect)
