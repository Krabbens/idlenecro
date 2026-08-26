class_name SaveData
extends RefCounted
## Versioned persistence envelope shared by SaveService and domain tests.

const CURRENT_SCHEMA_VERSION: int = 1
const CURRENT_CONTENT_VERSION: int = 1
const MAX_OFFLINE_SECONDS: int = 8 * 60 * 60

var schema_version: int = CURRENT_SCHEMA_VERSION
var content_version: int = CURRENT_CONTENT_VERSION
var meta_progress: MetaProgress = MetaProgress.new()
var suspended_run: Dictionary = {}
var settings: Dictionary = {
	"language": "pl",
	"text_scale": 1.0,
	"reduced_vfx": false,
	"screen_shake": "full",
}
var last_seen_utc: int = 0
var offline_claim_state: Dictionary = {"claimed_until_utc": 0}


func to_dict() -> Dictionary:
	return {
		"schema_version": schema_version,
		"content_version": content_version,
		"meta_progress": meta_progress.to_dict(),
		"suspended_run": null if suspended_run.is_empty() else suspended_run.duplicate(true),
		"settings": settings.duplicate(true),
		"last_seen_utc": last_seen_utc,
		"offline_claim_state": offline_claim_state.duplicate(true),
	}


func duplicate_data() -> SaveData:
	return SaveData.from_dict(to_dict())


func validate() -> Array[String]:
	var errors: Array[String] = []
	if schema_version != CURRENT_SCHEMA_VERSION:
		errors.append("unsupported schema_version %d" % schema_version)
	if content_version <= 0:
		errors.append("content_version must be positive")
	if last_seen_utc < 0:
		errors.append("last_seen_utc cannot be negative")
	if offline_claim_state.get("claimed_until_utc", 0) is not int:
		errors.append("offline_claim_state.claimed_until_utc must be an integer")
	return errors


static func from_dict(raw: Dictionary) -> SaveData:
	var migrated := _migrate(raw)
	var data := SaveData.new()
	data.schema_version = int(migrated.get("schema_version", CURRENT_SCHEMA_VERSION))
	data.content_version = int(migrated.get("content_version", CURRENT_CONTENT_VERSION))
	var raw_meta: Variant = migrated.get("meta_progress", {})
	if raw_meta is Dictionary:
		data.meta_progress = MetaProgress.from_dict(raw_meta as Dictionary)
	var raw_run: Variant = migrated.get("suspended_run", null)
	if raw_run is Dictionary:
		data.suspended_run = (raw_run as Dictionary).duplicate(true)
	var raw_settings: Variant = migrated.get("settings", {})
	if raw_settings is Dictionary:
		for key in (raw_settings as Dictionary).keys():
			data.settings[key] = (raw_settings as Dictionary)[key]
	data.last_seen_utc = maxi(0, int(migrated.get("last_seen_utc", 0)))
	var raw_offline: Variant = migrated.get("offline_claim_state", {})
	if raw_offline is Dictionary:
		for key in (raw_offline as Dictionary).keys():
			data.offline_claim_state[key] = (raw_offline as Dictionary)[key]
	return data


static func _migrate(raw: Dictionary) -> Dictionary:
	var migrated := raw.duplicate(true)
	var version := int(migrated.get("schema_version", 0))
	if version == 0:
		# v0 had only meta/settings and no offline clock; all new fields get safe defaults.
		migrated["schema_version"] = CURRENT_SCHEMA_VERSION
		migrated["content_version"] = int(migrated.get("content_version", CURRENT_CONTENT_VERSION))
		migrated["meta_progress"] = migrated.get("meta_progress", {})
		migrated["suspended_run"] = migrated.get("suspended_run", null)
		migrated["settings"] = migrated.get("settings", {})
		migrated["last_seen_utc"] = int(migrated.get("last_seen_utc", 0))
		migrated["offline_claim_state"] = {"claimed_until_utc": 0}
	return migrated
