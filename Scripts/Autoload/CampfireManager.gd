#extends Node
#
## Dictionnaire pour suivre quels feux sont allumés (par ID)
#var lit_campfires := {}
#
#func mark_campfire_as_lit(fire_id: String) -> void:
	#lit_campfires[fire_id] = true
#
#func is_campfire_lit(fire_id: String) -> bool:
	#return lit_campfires.get(fire_id, false)
#
#func _physics_process(delta):
	#print(lit_campfires)
