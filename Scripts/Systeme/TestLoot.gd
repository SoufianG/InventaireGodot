extends Node

func _ready():
	await get_tree().process_frame

	var base_epee = preload("res://Resources/Items/Equipements/Armes/EpeeFer.tres")

	var loot = LootSystem.generate_random_equipement(base_epee)

	await get_tree().process_frame

	print("Nom :", loot.get_nom_complet())
	print("Perfection :", loot.perfection)
	print("Stats :", loot.stats)

	for k in loot.stats.keys():
		print("▶ %s = %d" % [k, loot.stats[k]])
