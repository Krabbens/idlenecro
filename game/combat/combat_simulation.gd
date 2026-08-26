class_name CombatSimulation
extends RefCounted
## Fixed-step deterministic combat kernel for headless tests and runtime presentation.

signal actor_died(actor_id: int)

var seed: int
var tick: int = 0
var _rng: RandomNumberGenerator
var _actors: Dictionary[int, CombatantState] = {}
var _death_announced: Dictionary[int, bool] = {}


func _init(simulation_seed: int) -> void:
	seed = simulation_seed
	_rng = RandomNumberGenerator.new()
	_rng.seed = simulation_seed


func add_actor(actor: CombatantState) -> bool:
	if actor == null or _actors.has(actor.runtime_id):
		return false
	_actors[actor.runtime_id] = actor
	_death_announced[actor.runtime_id] = false
	return true


func add_periodic_effect(target_id: int, effect: PeriodicDamageEffect) -> bool:
	var target := _actors.get(target_id) as CombatantState
	if target == null or target.health.current == 0:
		return false
	target.add_periodic_effect(effect)
	return true


func step_tick() -> void:
	tick += 1
	var contacts: Array[DamageRequest] = []
	var actor_ids := _sorted_actor_ids()
	for actor_id in actor_ids:
		var actor := _actors[actor_id]
		if actor.health.current == 0 or tick % actor.attack_interval_ticks != 0:
			continue
		var target := _select_target(actor)
		if target != null:
			contacts.append(DamageRequest.new(actor.runtime_id, target.runtime_id, actor.attack_damage))
	for request in contacts:
		_apply_damage_request(request)
	for actor_id in actor_ids:
		_advance_effects(_actors[actor_id])
	_emit_new_deaths(actor_ids)


func roll_chance(chance: float) -> bool:
	assert(chance >= 0.0 and chance <= 1.0, "chance must be between zero and one")
	return _rng.randf() < chance


func state_digest() -> String:
	var parts: Array[String] = [str(seed), str(tick)]
	for actor_id in _sorted_actor_ids():
		var actor := _actors[actor_id]
		parts.append("%d:%d:%d" % [actor_id, actor.health.current, actor.position.x])
	return "|".join(parts)


func _sorted_actor_ids() -> Array[int]:
	var ids: Array[int] = []
	for actor_id in _actors.keys():
		ids.append(actor_id)
	ids.sort()
	return ids


func _select_target(attacker: CombatantState) -> CombatantState:
	var selected: CombatantState = null
	var selected_distance: int = 2147483647
	for actor_id in _sorted_actor_ids():
		var candidate := _actors[actor_id]
		if candidate.faction == attacker.faction or candidate.health.current == 0:
			continue
		var distance := absi(candidate.position.x - attacker.position.x) + absi(
			candidate.position.y - attacker.position.y
		)
		if distance > attacker.attack_range:
			continue
		if selected == null or distance < selected_distance or (
			distance == selected_distance and candidate.runtime_id < selected.runtime_id
		):
			selected = candidate
			selected_distance = distance
	return selected


func _apply_damage_request(request: DamageRequest) -> void:
	var target := _actors.get(request.target_id) as CombatantState
	if target == null or target.health.current == 0:
		return
	target.apply_damage(request.amount)


func _advance_effects(actor: CombatantState) -> void:
	if actor.health.current == 0:
		return
	var expired: Array[PeriodicDamageEffect] = []
	for effect in actor.effects:
		var periodic_damage := effect.advance_tick()
		if periodic_damage > 0:
			actor.apply_damage(periodic_damage)
		if effect.is_expired():
			expired.append(effect)
	for effect in expired:
		actor.effects.erase(effect)


func _emit_new_deaths(actor_ids: Array[int]) -> void:
	for actor_id in actor_ids:
		var actor := _actors[actor_id]
		if actor.health.current == 0 and not _death_announced[actor_id]:
			_death_announced[actor_id] = true
			actor_died.emit(actor_id)
