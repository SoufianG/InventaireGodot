@icon("res://Assets/Sprites/UI/Icons/Items/bow_icon.png")
extends Arme
class_name Arc

@export var arrow_scene: PackedScene
@export var charge_time: float = 0.5
@export var projectile_speed: float = 600.0

func attack(target: Node) -> void:
	pass
