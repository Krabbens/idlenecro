class_name CombatView
extends Node2D
## Read-only placeholder renderer for the vertical slice; final art belongs to E5.

var _simulation: CombatSimulation


func _process(_delta: float) -> void:
	queue_redraw()


func set_simulation(simulation: CombatSimulation) -> void:
	_simulation = simulation
	queue_redraw()


func clear_simulation(_victory: bool = false) -> void:
	_simulation = null
	queue_redraw()


func _draw() -> void:
	draw_rect(Rect2(-560.0, -300.0, 1120.0, 600.0), Color("111318"), true)
	if _simulation == null:
		return
	for actor in _simulation.get_actors():
		var actor_position := Vector2(actor.position) * 100.0
		var color := Color("70a8a1") if actor.faction == &"grave_caller" else Color("c56a3d")
		draw_circle(actor_position, 28.0, color)
		draw_circle(actor_position, 28.0, Color("d6c7a1"), false, 3.0)
		var health_ratio := float(actor.health.current) / float(actor.health.maximum)
		draw_rect(
			Rect2(actor_position + Vector2(-30.0, -45.0), Vector2(60.0, 6.0)),
			Color("252932"),
			true
		)
		draw_rect(
			Rect2(actor_position + Vector2(-30.0, -45.0), Vector2(60.0 * health_ratio, 6.0)),
			Color("d6c7a1"),
			true
		)
