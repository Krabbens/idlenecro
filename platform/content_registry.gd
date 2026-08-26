extends Node
## Validated in-memory registry for immutable content definitions.

var _actors: Dictionary[StringName, ActorDefinition] = {}
var _abilities: Dictionary[StringName, AbilityDefinition] = {}
var _encounters: Dictionary[StringName, EncounterDefinition] = {}


func register_actor(definition: ActorDefinition) -> bool:
	if not _validate_definition(definition, "ActorDefinition"):
		return false
	if _actors.has(definition.id):
		push_error("Duplicate ActorDefinition '%s'" % definition.id)
		return false
	_actors[definition.id] = definition
	return true


func register_ability(definition: AbilityDefinition) -> bool:
	if not _validate_definition(definition, "AbilityDefinition"):
		return false
	if _abilities.has(definition.id):
		push_error("Duplicate AbilityDefinition '%s'" % definition.id)
		return false
	_abilities[definition.id] = definition
	return true


func register_encounter(definition: EncounterDefinition) -> bool:
	if not _validate_definition(definition, "EncounterDefinition"):
		return false
	if _encounters.has(definition.id):
		push_error("Duplicate EncounterDefinition '%s'" % definition.id)
		return false
	_encounters[definition.id] = definition
	return true


func resolve_actor(id: StringName) -> ActorDefinition:
	return _resolve(_actors, id, "ActorDefinition") as ActorDefinition


func resolve_ability(id: StringName) -> AbilityDefinition:
	return _resolve(_abilities, id, "AbilityDefinition") as AbilityDefinition


func resolve_encounter(id: StringName) -> EncounterDefinition:
	return _resolve(_encounters, id, "EncounterDefinition") as EncounterDefinition


func _validate_definition(definition: Resource, type_name: String) -> bool:
	if definition == null:
		push_error("Cannot register null %s" % type_name)
		return false
	var errors: Array[String] = definition.validate()
	if not errors.is_empty():
		push_error("Invalid %s: %s" % [type_name, "; ".join(errors)])
		return false
	return true


func _resolve(store: Dictionary, id: StringName, type_name: String) -> Resource:
	var definition: Resource = store.get(id) as Resource
	if definition == null:
		push_error("Unknown %s '%s'" % [type_name, id])
	return definition
