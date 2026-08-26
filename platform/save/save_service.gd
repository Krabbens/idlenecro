extends Node
## Small persistence boundary; schema migration and game-specific data arrive in E3.

const SAVE_PATH: String = "user://save.json"


func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)


func read_raw() -> Dictionary:
	if not has_save():
		return {}
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		push_error("Failed to open save file '%s'" % SAVE_PATH)
		return {}
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary:
		push_error("Save file '%s' is not a JSON object" % SAVE_PATH)
		return {}
	return parsed as Dictionary


func write_raw(payload: Dictionary) -> Error:
	var temporary_path := "%s.tmp" % SAVE_PATH
	var file := FileAccess.open(temporary_path, FileAccess.WRITE)
	if file == null:
		push_error("Failed to open temporary save file '%s'" % temporary_path)
		return ERR_CANT_OPEN
	file.store_string(JSON.stringify(payload))
	file.flush()
	file = null
	if not FileAccess.file_exists(temporary_path):
		push_error("Temporary save file '%s' was not created" % temporary_path)
		return ERR_FILE_CANT_WRITE
	var backup_path := "%s.backup" % SAVE_PATH
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.copy_absolute(SAVE_PATH, backup_path)
	var rename_error := DirAccess.rename_absolute(temporary_path, SAVE_PATH)
	if rename_error != OK:
		push_error("Failed to publish save file '%s'" % SAVE_PATH)
		return rename_error
	return OK
