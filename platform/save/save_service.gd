extends Node
## Small persistence boundary; schema migration and game-specific data arrive in E3.

const SAVE_PATH: String = "user://save.json"
const BACKUP_PATH: String = "user://save.backup.json"


func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)


func read_raw() -> Dictionary:
	return _read_raw_path(SAVE_PATH)


func load_data() -> SaveData:
	var primary := _read_raw_path(SAVE_PATH)
	if not primary.is_empty():
		var data := SaveData.from_dict(primary)
		if data.validate().is_empty():
			return data
		push_error("Primary save failed semantic validation; trying backup")
	var backup := _read_raw_path(BACKUP_PATH)
	if not backup.is_empty():
		var backup_data := SaveData.from_dict(backup)
		if backup_data.validate().is_empty():
			return backup_data
	if has_save():
		push_error("Save and backup are invalid; preserving files for recovery")
	return null


func write_data(data: SaveData) -> Error:
	if data == null or not data.validate().is_empty():
		push_error("Refusing to write invalid SaveData")
		return ERR_INVALID_DATA
	return write_raw(data.to_dict())


func claim_offline_reward(now_utc: int, dust_per_hour: int = 1) -> int:
	var current := load_data()
	if current == null:
		return -1
	var elapsed := clampi(now_utc - current.last_seen_utc, 0, SaveData.MAX_OFFLINE_SECONDS)
	var reward := (elapsed / 3600) * maxi(0, dust_per_hour)
	var candidate := current.duplicate_data()
	candidate.meta_progress.grave_dust += reward
	candidate.last_seen_utc = now_utc
	candidate.offline_claim_state["claimed_until_utc"] = now_utc
	if write_data(candidate) != OK:
		return -1
	return reward


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
	if _read_raw_path(temporary_path).is_empty():
		push_error("Temporary save file '%s' failed validation" % temporary_path)
		return ERR_INVALID_DATA
	if FileAccess.file_exists(SAVE_PATH):
		var backup_error := DirAccess.copy_absolute(SAVE_PATH, BACKUP_PATH)
		if backup_error != OK:
			push_error("Failed to preserve backup save '%s'" % BACKUP_PATH)
			return backup_error
	var rename_error := DirAccess.rename_absolute(temporary_path, SAVE_PATH)
	if rename_error != OK:
		push_error("Failed to publish save file '%s'" % SAVE_PATH)
		return rename_error
	return OK


func _read_raw_path(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {}
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Failed to open save file '%s'" % path)
		return {}
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary:
		push_error("Save file '%s' is not a JSON object" % path)
		return {}
	return parsed as Dictionary
