extends SceneTree
## Minimal headless smoke runner; domain tests will be added in E1.

var _failures: int = 0


func _initialize() -> void:
	_check_project_identity()
	_check_display_contract()
	_check_documentation_contract()
	_check_combat_contract()
	_check_save_contract()
	_check_vertical_slice_flow()
	if _failures == 0:
		print("IdleNecro baseline smoke passed.")
		quit(0)
		return
	print("IdleNecro baseline smoke failed: %d failure(s)." % _failures)
	quit(1)


func _check_project_identity() -> void:
	var project_name: String = str(
		ProjectSettings.get_setting("application/config/name", "")
	)
	_expect(project_name == "idlenecro", "project name must remain idlenecro")


func _check_display_contract() -> void:
	var stretch_mode: String = str(
		ProjectSettings.get_setting("display/window/stretch/mode", "")
	)
	var aspect: String = str(
		ProjectSettings.get_setting("display/window/stretch/aspect", "")
	)
	_expect(stretch_mode == "canvas_items", "UI stretch mode must be canvas_items")
	_expect(aspect == "expand", "UI aspect mode must be expand")


func _check_documentation_contract() -> void:
	_expect(
		FileAccess.file_exists("res://agents/00_product_vision.md"),
		"product vision must remain available"
	)
	_expect(
		FileAccess.file_exists("res://agents/04_technical_architecture.md"),
		"technical architecture must remain available"
	)


func _check_combat_contract() -> void:
	var health := Health.new(10)
	_expect(health.apply_damage(3) == 3, "health should report applied damage")
	_expect(health.current == 7, "health should reduce current value")
	var effect := PeriodicDamageEffect.new(&"test_poison", 2, 2, 4)
	_expect(effect.advance_tick() == 0, "periodic effect should wait for its interval")
	_expect(effect.advance_tick() == 2, "periodic effect should proc on its interval")

	var first := _simulate_combat(42)
	var second := _simulate_combat(42)
	_expect(first == second, "same seed must produce the same combat digest")


func _check_save_contract() -> void:
	var original := SaveData.new()
	original.last_seen_utc = 1_000
	original.meta_progress.grave_dust = 7
	original.suspended_run = {"seed": 424242, "status": RunState.Status.SUSPENDED}
	var restored := SaveData.from_dict(original.to_dict())
	_expect(restored.validate().is_empty(), "save round-trip should validate")
	_expect(restored.meta_progress.grave_dust == 7, "save round-trip should preserve meta progress")
	_expect(restored.suspended_run.get("seed", 0) == 424242, "save round-trip should preserve suspended run")
	var migrated := SaveData.from_dict({"schema_version": 0, "meta_progress": {"grave_dust": 2}})
	_expect(migrated.schema_version == SaveData.CURRENT_SCHEMA_VERSION, "v0 save should migrate to v1")
	_expect(migrated.offline_claim_state.get("claimed_until_utc", -1) == 0, "migration should add offline clock")


func _simulate_combat(simulation_seed: int) -> String:
	var simulation := CombatSimulation.new(simulation_seed)
	var ally := CombatantState.new(1, &"grave_caller", Vector2i(0, 0), 10, 2, 0, 1, 2)
	var enemy := CombatantState.new(2, &"crypt", Vector2i(1, 0), 6, 1, 0, 1, 2)
	simulation.add_actor(ally)
	simulation.add_actor(enemy)
	simulation.add_periodic_effect(2, PeriodicDamageEffect.new(&"test_decay", 1, 2, 4))
	for _tick in range(4):
		simulation.step_tick()
	return simulation.state_digest()


func _check_vertical_slice_flow() -> void:
	var controller := RunController.new()
	_expect(controller.start_run(&"grave_caller", 424242), "run should start")
	for encounter_index in range(RunController.ENCOUNTER_COUNT):
		_expect(controller.start_encounter(), "encounter should start")
		for _tick in range(120):
			controller._physics_process(0.05)
			if controller.state.status != RunState.Status.RUNNING:
				break
		_expect(
			controller.state.status == RunState.Status.AWAITING_REWARD,
			"victorious encounter should offer a reward (status=%d digest=%s)" % [
				controller.state.status,
				controller.get_simulation().state_digest(),
			]
		)
		_expect(
			controller.choose_reward(&"soul_mark"),
			"reward choice should advance the run"
		)
	_expect(
		controller.state.status == RunState.Status.VICTORY,
		"three encounters should finish the vertical slice"
	)
	controller.free()

	var defeat_controller := RunController.new()
	_expect(defeat_controller.start_run(&"grave_caller", 424243), "defeat run should start")
	_expect(defeat_controller.start_encounter(), "defeat encounter should start")
	var defeat_actors := defeat_controller.get_simulation().get_actors()
	for actor in defeat_actors:
		if actor.faction == &"grave_caller":
			actor.health.apply_damage(999)
	defeat_controller._physics_process(0.05)
	_expect(
		defeat_controller.state.status == RunState.Status.DEFEAT,
		"dead hero should end the encounter as a defeat"
	)
	defeat_controller.free()


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures += 1
	push_error(message)
