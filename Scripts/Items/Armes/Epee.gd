@icon("res://Assets/Sprites/UI/Icons/Items/equipment_icon.png")
extends Arme
class_name Epee

func attack(target: Node) -> void:
	print("🗡️ Coup d’épée sur %s !" % target.name)
	# Ici tu pourrais jouer une anim, déclencher un hitbox, etc.
