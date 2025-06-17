extends Camera2D

var desired_offset: Vector2
var min_offset = -50
var max_offset = 50
@onready var player := get_parent()  # La caméra est enfant du joueur

func _process(delta: float) -> void:
	var mouse = get_global_mouse_position()
	var center = player.global_position
	var direction = (mouse - center).normalized()
	var distance = min((mouse - center).length() * 0.25, max_offset)
	
	desired_offset = direction * distance
	desired_offset.x = clamp(desired_offset.x, min_offset, max_offset)
	desired_offset.y = clamp(desired_offset.y, min_offset / 2.0, max_offset / 2.0)

	global_position = center + desired_offset
