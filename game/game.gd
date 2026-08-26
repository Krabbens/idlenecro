extends Node2D
## Root scene for the IdleNecro application shell.


func _ready() -> void:
	if get_node_or_null("World") == null:
		push_error("Game scene is missing required World node")
	if get_node_or_null("Systems") == null:
		push_error("Game scene is missing required Systems node")
	if get_node_or_null("UI") == null:
		push_error("Game scene is missing required UI node")
	var controller := get_node("Systems/RunController") as RunController
	var screen := get_node("UI/MainScreen") as MainScreen
	var combat_view := get_node("World/Actors/CombatView") as CombatView
	screen.setup(controller)
	controller.encounter_started.connect(combat_view.set_simulation)
	controller.run_finished.connect(combat_view.clear_simulation)
