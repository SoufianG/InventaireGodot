extends Control


@onready var bar = $Bar

func set_health(value):
	bar.value = value
