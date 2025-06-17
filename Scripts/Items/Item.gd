@icon("res://Assets/Sprites/UI/Icons/Items/default_icon.png")
extends Resource
class_name Item

@export var name: String
@export var description: String
@export_enum("D", "C", "B", "A", "S") var rank: String = "D"
@export var stackable: bool = false
@export_enum("Equipement", "Ressource", "Consommable", "Quete") var item_type: String = "Ressource"
@export_range(0.0, 1.0) var loot_rate: float = 1.0
@export var icon: Texture2D


func get_rank_color() -> Color:
	if rank == "S":
		return Color.from_rgba8(255, 215, 0)       # doré
	elif rank == "A":
		return Color.from_rgba8(155, 89, 182)      # violet
	elif rank == "B":
		return Color.from_rgba8(52, 152, 219)      # bleu
	elif rank == "C":
		return Color.from_rgba8(46, 204, 113)      # vert
	elif rank == "D":
		return Color.from_rgba8(189, 195, 199)     # gris
	else:
		return Color.WHITE
