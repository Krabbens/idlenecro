extends Node
## Owns validated scene transitions; callers provide intent, not node paths.


func change_scene(scene_path: String) -> Error:
	if not ResourceLoader.exists(scene_path, "PackedScene"):
		push_error("Cannot change scene; missing PackedScene '%s'" % scene_path)
		return ERR_FILE_NOT_FOUND
	return get_tree().change_scene_to_file(scene_path)
