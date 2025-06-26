#@icon("res://Assets/Sprites/UI/Icons/Items/staff_icon.png")
extends Arme
class_name Sceptre

@export var spell_scene: PackedScene
@export var mana_cost: int = 10
@export var projectile_speed: float = 500.0

func attack(target: Node) -> void:
	pass
