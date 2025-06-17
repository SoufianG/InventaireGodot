extends CanvasLayer

@onready var sprite = $CursorSprite

func _ready():
	# Masquer le curseur système
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	sprite.visible = true

func _process(delta):
	# Suivre la position de la souris
	sprite.global_position = get_viewport().get_mouse_position()
