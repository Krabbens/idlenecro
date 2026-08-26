extends Node2D
## Root scene for the IdleNecro application shell.


func _ready() -> void:
	if get_node_or_null("World") == null:
		push_error("Game scene is missing required World node")
	if get_node_or_null("Systems") == null:
		push_error("Game scene is missing required Systems node")
	if get_node_or_null("UI") == null:
		push_error("Game scene is missing required UI node")
