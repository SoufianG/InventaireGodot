extends Control
class_name CarteItem

@export var item: Item

func _ready():
	if not item:
		print("Aucun item assigné à la carte.")
		return

	$Fond/MarginContainer/VBoxContainer/LigneIconDesc/Icon.texture = item.inventory_icon
	$Fond/MarginContainer/VBoxContainer/LigneNomRank/Nom.text = item.name
	$Fond/MarginContainer/VBoxContainer/LigneNomRank/Rank.text = item.rank
	$Fond/MarginContainer/VBoxContainer/LigneIconDesc/Description.text = item.description
