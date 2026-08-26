class_name MainScreen
extends Control
## Placeholder vertical-slice UI; final themed components belong to E5.

var _controller: RunController
var _content: VBoxContainer
var _status_label: Label
var _details_label: Label
var _last_status: int = -1
var _last_digest: String = ""


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	queue_redraw()
	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 32)
	margin.add_theme_constant_override("margin_top", 24)
	margin.add_theme_constant_override("margin_right", 32)
	margin.add_theme_constant_override("margin_bottom", 24)
	add_child(margin)
	var root := VBoxContainer.new()
	root.add_theme_constant_override("separation", 12)
	margin.add_child(root)
	var title := Label.new()
	title.text = "IDLENECRO  /  CZARNY RELIKWIARZ"
	title.add_theme_font_size_override("font_size", 26)
	root.add_child(title)
	_status_label = Label.new()
	_status_label.add_theme_font_size_override("font_size", 18)
	root.add_child(_status_label)
	_details_label = Label.new()
	_details_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	root.add_child(_details_label)
	_content = VBoxContainer.new()
	_content.add_theme_constant_override("separation", 10)
	root.add_child(_content)


func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color("111318"), true)


func setup(controller: RunController) -> void:
	_controller = controller
	_controller.run_started.connect(_on_run_started)
	_controller.encounter_started.connect(_on_encounter_started)
	_controller.reward_offered.connect(_on_reward_offered)
	_controller.run_finished.connect(_on_run_finished)
	_show_hub()


func _process(_delta: float) -> void:
	if _controller == null or _controller.state == null:
		return
	var state := _controller.state
	var digest := ""
	if state.status == RunState.Status.RUNNING and _controller.get_simulation() != null:
		digest = _controller.get_simulation().state_digest()
		if digest != _last_digest:
			_last_digest = digest
			_details_label.text = _combat_details()
	if state.status != _last_status:
		_last_status = state.status
		_refresh_for_state()


func _refresh_for_state() -> void:
	if _controller.state == null:
		_show_hub()
		return
	match _controller.state.status:
		RunState.Status.AWAITING_MAP:
			_show_map()
		RunState.Status.RUNNING:
			_show_combat()
		RunState.Status.AWAITING_REWARD:
			_show_reward()
		RunState.Status.VICTORY, RunState.Status.DEFEAT:
			_show_summary()


func _show_hub() -> void:
	_clear_content()
	_status_label.text = "HUB  /  wybór szkoły"
	_details_label.text = "grave_caller  ·  Popielne Krypty\nWalka jest automatyczna. Ty budujesz synergię hordy."
	_add_button("Rozpocznij run", _on_start_run)


func _show_map() -> void:
	_clear_content()
	var state := _controller.state
	_status_label.text = "MAPA  /  węzeł %d z %d" % [state.current_node_index + 1, RunController.ENCOUNTER_COUNT]
	_details_label.text = "Ashen Crypts · typ: combat\nEsencja: %d\nSeed: %d" % [state.essence, state.seed]
	_add_button("Wejdź do encounteru", _on_enter_encounter)


func _show_combat() -> void:
	_clear_content()
	_status_label.text = "WALKA AUTOMATYCZNA  /  %s" % ("PAUZA" if _controller.is_paused else "AKTYWNA")
	_details_label.text = _combat_details()
	_add_button("Pauza / gra", _on_toggle_pause)
	_add_button("Prędkość 1×", _on_speed_one)
	_add_button("Prędkość 2×", _on_speed_two)
	_add_button("Inspekcja jednostek", _on_inspect)


func _show_reward() -> void:
	_clear_content()
	_status_label.text = "NAGRODA  /  wybierz jeden dar"
	_details_label.text = "Wybór zatrzymuje symulację. Esencja: %d" % _controller.state.essence
	for reward_id in [&"soul_mark", &"grave_hymn", &"bone_debt"]:
		_add_button(_reward_label(reward_id), _on_reward.bind(reward_id))


func _show_summary() -> void:
	_clear_content()
	var victory := _controller.state.status == RunState.Status.VICTORY
	_status_label.text = "PODSUMOWANIE  /  %s" % ("ZWYCIĘSTWO" if victory else "PORAŻKA")
	_details_label.text = "Szkoła: %s\nEsencja: %d\nDary: %d" % [
		_controller.state.school_id,
		_controller.state.essence,
		_controller.state.build.size(),
	]
	_add_button("Wróć do hubu", _on_return_to_hub)


func _combat_details() -> String:
	var simulation := _controller.get_simulation()
	if simulation == null:
		return "Brak aktywnego encounteru"
	var parts: Array[String] = ["tick: %d  ·  prędkość: %.0f×" % [simulation.tick, _controller.speed_multiplier]]
	for actor in simulation.get_actors():
		parts.append("%s #%d  HP %d/%d" % [actor.faction, actor.runtime_id, actor.health.current, actor.health.maximum])
	return "\n".join(parts)


func _clear_content() -> void:
	for child in _content.get_children():
		child.queue_free()


func _add_button(label: String, callback: Callable) -> void:
	var button := Button.new()
	button.text = label
	button.custom_minimum_size = Vector2(0, 52)
	button.pressed.connect(callback)
	_content.add_child(button)


func _reward_label(reward_id: StringName) -> String:
	return {
		&"soul_mark": "Znak Duszy  ·  +obrażenia po śmierci sługi",
		&"grave_hymn": "Hymn Grobów  ·  +liczebność hordy",
		&"bone_debt": "Dług Kości  ·  +pancerz pierwszego celu",
	}.get(reward_id, "Nieznany dar")


func _on_start_run() -> void:
	_controller.start_run(&"grave_caller", 424242)


func _on_enter_encounter() -> void:
	_controller.start_encounter()


func _on_toggle_pause() -> void:
	_controller.set_paused(not _controller.is_paused)
	_show_combat()


func _on_speed_one() -> void:
	_controller.set_speed(1.0)
	_show_combat()


func _on_speed_two() -> void:
	_controller.set_speed(2.0)
	_show_combat()


func _on_inspect() -> void:
	_details_label.text = _combat_details() + "\n\nInspekcja: targetowanie jest stabilne po runtime_id."


func _on_reward(reward_id: StringName) -> void:
	_controller.choose_reward(reward_id)


func _on_return_to_hub() -> void:
	_controller.return_to_hub()
	_show_hub()


func _on_run_started(_state: RunState) -> void:
	_refresh_for_state()


func _on_encounter_started(_simulation: CombatSimulation) -> void:
	_refresh_for_state()


func _on_reward_offered(_reward_ids: Array[StringName]) -> void:
	_refresh_for_state()


func _on_run_finished(_victory: bool) -> void:
	_refresh_for_state()
