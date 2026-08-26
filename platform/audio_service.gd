extends Node
## Global audio settings boundary; bus content is configured by presentation tasks.


func set_bus_volume_db(bus_name: StringName, volume_db: float) -> bool:
	var bus_index := AudioServer.get_bus_index(bus_name)
	if bus_index < 0:
		push_error("Unknown audio bus '%s'" % bus_name)
		return false
	AudioServer.set_bus_volume_db(bus_index, volume_db)
	return true
