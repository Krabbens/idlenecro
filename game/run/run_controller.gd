class_name RunController
extends Node
## Owns application-level run transitions and advances combat at a fixed rate.

signal run_started(state: RunState)
signal encounter_started(simulation: CombatSimulation)
signal encounter_completed(essence_earned: int)
signal reward_offered(reward_ids: Array[StringName])
signal run_finished(victory: bool)

const SIMULATION_TICK_SECONDS: float = 0.05
const ENCOUNTER_COUNT: int = 3

var state: RunState
var speed_multiplier: float = 1.0
var is_paused: bool = false
var _simulation: CombatSimulation
var _tick_accumulator: float = 0.0


func _physics_process(delta: float) -> void:
	if state == null or state.status != RunState.Status.RUNNING or is_paused:
		return
	_tick_accumulator += delta * speed_multiplier
	while _tick_accumulator >= SIMULATION_TICK_SECONDS:
		_tick_accumulator -= SIMULATION_TICK_SECONDS
		_simulation.step_tick()
		if _simulation.is_battle_over():
			_finish_encounter()
			return


func start_run(selected_school: StringName = &"grave_caller", run_seed: int = 0) -> bool:
	if state != null and state.status in [RunState.Status.RUNNING, RunState.Status.AWAITING_REWARD]:
		return false
	var resolved_seed := run_seed
	if resolved_seed == 0:
		resolved_seed = int(Time.get_unix_time_from_system())
	state = RunState.new(resolved_seed, selected_school)
	_simulation = null
	_tick_accumulator = 0.0
	is_paused = false
	speed_multiplier = 1.0
	run_started.emit(state)
	return true


func start_encounter() -> bool:
	if state == null or state.status != RunState.Status.AWAITING_MAP:
		return false
	var encounter_seed := state.seed + state.current_node_index * 7919
	_simulation = CombatSimulation.new(encounter_seed)
	var enemy_health := 7 + state.current_node_index * 4
	var enemy_damage := 1 + state.current_node_index
	var ally := CombatantState.new(1, &"grave_caller", Vector2i(0, 0), 32, 4, 0, 8, 5)
	var enemy := CombatantState.new(
		10 + state.current_node_index,
		&"crypt",
		Vector2i(2, 0),
		enemy_health,
		enemy_damage,
		state.current_node_index,
		14,
		3
	)
	_simulation.add_actor(ally)
	# The first slice represents the Grave Caller and four summoned servants.
	# They are separate runtime actors so target selection, deaths and procs are
	# exercised by the same deterministic kernel used by larger encounters.
	for servant_index in range(4):
		_simulation.add_actor(
			CombatantState.new(
				2 + servant_index,
				&"grave_caller",
				Vector2i(-1, servant_index - 2),
				10,
				4,
				0,
				12,
				5
			)
		)
	_simulation.add_actor(enemy)
	if state.current_node_index > 0:
		_simulation.add_actor(
			CombatantState.new(
				20 + state.current_node_index,
				&"crypt",
				Vector2i(2, 1),
				enemy_health - 2,
				enemy_damage,
				0,
				18,
				3
			)
		)
	state.status = RunState.Status.RUNNING
	is_paused = false
	_tick_accumulator = 0.0
	encounter_started.emit(_simulation)
	return true


func choose_reward(reward_id: StringName) -> bool:
	if state == null or state.status != RunState.Status.AWAITING_REWARD:
		return false
	state.add_reward(reward_id)
	if state.current_node_index >= ENCOUNTER_COUNT - 1:
		state.status = RunState.Status.VICTORY
		run_finished.emit(true)
		return true
	state.current_node_index += 1
	state.status = RunState.Status.AWAITING_MAP
	return true


func set_paused(paused: bool) -> void:
	if state != null and state.status == RunState.Status.RUNNING:
		is_paused = paused


func set_speed(multiplier: float) -> void:
	if multiplier in [1.0, 2.0]:
		speed_multiplier = multiplier


func return_to_hub() -> void:
	state = null
	_simulation = null
	is_paused = false


func get_simulation() -> CombatSimulation:
	return _simulation


func _finish_encounter() -> void:
	if _simulation.winner_faction() != &"grave_caller":
		state.status = RunState.Status.DEFEAT
		run_finished.emit(false)
		return
	state.essence += 5 + state.current_node_index * 2
	state.status = RunState.Status.AWAITING_REWARD
	encounter_completed.emit(5 + state.current_node_index * 2)
	reward_offered.emit([
		&"soul_mark",
		&"grave_hymn",
		&"bone_debt",
	])
