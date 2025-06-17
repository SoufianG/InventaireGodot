extends Node
class_name LootManager  # ← OK, on garde ce nom pour la classe

# Génère une perfection entre 1 et 100 selon une loi normale centrée
func generate_perfection(mean: float = 50.0, std_dev: float = 15.0) -> int:
	var value: float = clamp(randfn(mean, std_dev), 1.0, 100.0)
	return int(round(value))

# Duplique un équipement, génère perfection et stats
func generate_random_equipement(base: Equipement) -> Equipement:
	print(">> Génération de loot à partir de :", base.name)

	var new_item := base.duplicate(true) as Equipement
	if new_item == null:
		push_error("Échec de duplication de l'équipement de base.")
		return null

	new_item.perfection = generate_perfection()
	print("→ Perfection générée :", new_item.perfection)

	new_item.generer_stats_depuis_perfection()

	# Debug sécurité : est-ce que stats a bien été généré ?
	print("✅ Résultat stats dans new_item :", new_item.stats)

	return new_item
