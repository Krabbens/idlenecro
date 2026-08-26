extends SceneTree
## Minimal headless smoke runner; domain tests will be added in E1.

var _failures: int = 0


func _initialize() -> void:
	_check_project_identity()
	_check_display_contract()
	_check_documentation_contract()
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


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures += 1
	push_error(message)
