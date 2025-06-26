@icon("res://Assets/Sprites/UI/Icons/Items/equipment_icon.png")
extends Item
class_name Equipement

@export_enum("Tete", "Torse", "Jambe", "Botte", "Anneau", "Collier", "Ceinture", "Arme") var slot: String = "Arme"
@export_range(1, 100) var perfection: int = 50
@export var stats: Dictionary = {}
@export var stats_theorique: Dictionary = {}
@export_range(1, 100) var niveau: int = 1
@export var scene_in_game: PackedScene

func get_poids() -> int:
	var total: float = 0.0
	for stat_name in stats_theorique.keys():
		var vector: Vector2 = stats_theorique[stat_name]
		var max_val: float = vector.y
		var poids_stat: float = StatWeightsManager.get_stat_weight(stat_name)
		total += max_val * poids_stat
	return int(round(total))

	stats.clear()

	# Étape 1 : calcul du poids min et max
	var poids_min := 0.0
	var poids_max := 0.0
	var stat_data := []

	for stat_name in stats_theorique.keys():
		var vect: Vector2 = stats_theorique[stat_name]
		var min_val := vect.x
		var max_val := vect.y
		var poids_stat := StatWeightsManager.get_stat_weight(stat_name)

		poids_min += min_val * poids_stat
		poids_max += max_val * poids_stat

		stat_data.append({
			"name": stat_name,
			"min": min_val,
			"max": max_val,
			"poids": poids_stat,
			"val": min_val  # initialisé à la valeur minimale
		})

	# Étape 2 : poids cible selon la perfection
	var poids_cible := poids_min + (perfection / 100.0) * (poids_max - poids_min)
	var poids_restant := poids_cible - poids_min

	print("→ Poids min :", poids_min, "| poids max :", poids_max, "| poids cible :", poids_cible, "| perfection :", perfection)

	# Étape 3 : allocation incrémentale
	while poids_restant > 0.01 and stat_data.size() > 0:
		var index := randi() % stat_data.size()
		var s :Dictionary= stat_data[index]

		var step := 0.1
		var increment_cost :float= s["poids"] * step
		var new_val :float= s["val"] + step

		if poids_restant >= increment_cost and new_val <= s["max"]:
			stat_data[index]["val"] = new_val
			poids_restant -= increment_cost
			print("  → Allocation à %s +%.1f (val = %.1f)" % [s["name"], step, new_val])
		else:
			stat_data.remove_at(index)

	# Étape 4 : application finale
	for s in stat_data:
		var final_value: float = clamp(s["val"], s["min"], s["max"])
		stats[s["name"]] = int(round(final_value))
		print("✅ Stat finale :%s=%d" % [s["name"], stats[s["name"]]])

func generer_stats_depuis_perfection2():
	stats.clear()

	# Cloner le dictionnaire sans garder de référence
	var stats_theorique_locale := {}
	for k in stats_theorique.keys():
		var v: Vector2 = stats_theorique[k]
		stats_theorique_locale[k] = Vector2(v.x, v.y)

	print("DEBUG - stats_theorique =", stats_theorique)
	print("🔎 Copie locale stats_theorique :", stats_theorique_locale)
	print("🔍 Même référence ? ", stats_theorique == stats_theorique_locale)

	var poids_min: float = 0.0
	var poids_max: float = 0.0
	var stat_data: Array = []

	for stat_name in stats_theorique_locale.keys():
		var vect: Vector2 = stats_theorique_locale[stat_name]
		var min_val: float = vect.x
		var max_val: float = vect.y
		var poids_stat: float = StatWeightsManager.get_stat_weight(stat_name)

		poids_min += min_val * poids_stat
		poids_max += max_val * poids_stat

		stat_data.append({
			"name": stat_name,
			"min": min_val,
			"max": max_val,
			"poids": poids_stat,
			"val": min_val
		})

	var poids_cible: float = poids_min + (perfection / 100.0) * (poids_max - poids_min)
	var poids_restant: float = poids_cible - poids_min

	print("→ Poids min : %.1f | poids max : %.1f | poids cible : %.1f | perfection : %d" % [poids_min, poids_max, poids_cible, perfection])

	while poids_restant > 0.01:
		var disponibles := stat_data.filter(func(s):
			return s["val"] < s["max"] and s["poids"] * 0.1 <= poids_restant
		)

		if disponibles.size() == 0:
			break  # Plus rien à allouer

		var index := randi() % disponibles.size()
		var s :Dictionary= disponibles[index]
		var step := 0.1
		var increment_cost :float= s["poids"] * step
		var new_val :float= s["val"] + step

		var real_index := stat_data.find(s)
		stat_data[real_index]["val"] = new_val
		poids_restant -= increment_cost
		#print("  → Allocation à %s +%.1f (val = %.1f)" % [s["name"], step, new_val])

	# Étape 4 : application finale
	for s in stat_data:
		var final_value: float = clamp(s["val"], s["min"], s["max"])
		stats[s["name"]] = int(round(final_value))
		print("✅ Stat finale :%s = %d" % [s["name"], stats[s["name"]]])


func generer_stats_depuis_perfection():
	stats.clear()

	if perfection >= 98:
		for stat_name in stats_theorique.keys():
			stats[stat_name] = int(round(stats_theorique[stat_name].y))
		print("💎 Stats forcées à max (perfection ≥ 98) :", stats)
		return

	# Cloner le dictionnaire sans garder de référence
	var stats_theorique_locale := {}
	for k in stats_theorique.keys():
		var v: Vector2 = stats_theorique[k]
		stats_theorique_locale[k] = Vector2(v.x, v.y)

	print("DEBUG - stats_theorique =", stats_theorique)
	print("🔎 Copie locale stats_theorique :", stats_theorique_locale)
	print("🔍 Même référence ? ", stats_theorique == stats_theorique_locale)

	var poids_min: float = 0.0
	var poids_max: float = 0.0
	var stat_data: Array = []

	for stat_name in stats_theorique_locale.keys():
		var vect: Vector2 = stats_theorique_locale[stat_name]
		var min_val: float = vect.x
		var max_val: float = vect.y
		var poids_stat: float = StatWeightsManager.get_stat_weight(stat_name)

		poids_min += min_val * poids_stat
		poids_max += max_val * poids_stat

		stat_data.append({
			"name": stat_name,
			"min": min_val,
			"max": max_val,
			"poids": poids_stat,
			"val": min_val
		})

	var poids_cible: float = poids_min + (perfection / 100.0) * (poids_max - poids_min)
	var poids_restant: float = poids_cible - poids_min

	print("→ Poids min : %.1f | poids max : %.1f | poids cible : %.1f | perfection : %d" % [poids_min, poids_max, poids_cible, perfection])

	while poids_restant > 0.01:
		var disponibles := stat_data.filter(func(s):
			return s["val"] < s["max"] and s["poids"] * 0.1 <= poids_restant
		)

		if disponibles.is_empty():
			break

		# Tirage pondéré basé sur le remplissage
		var ponderee := []
		for s in disponibles:
			var range : float= s["max"] - s["min"]
			var remplissage : float= (s["val"] - s["min"]) / range
			var poids_selection := pow(1.0 - remplissage, 2)  # plus c'est rempli, moins c'est sélectionné
			var slots := int(poids_selection * 100)
			for i in slots:
				ponderee.append(s)

		if ponderee.is_empty():
			break

		var s : Dictionary= ponderee[randi() % ponderee.size()]
		var step := 0.1
		var increment_cost : float= s["poids"] * step
		var new_val : float= s["val"] + step
		var real_index := stat_data.find(s)

		stat_data[real_index]["val"] = new_val
		poids_restant -= increment_cost
		#print("  → Allocation à %s +%.1f (val = %.1f)" % [s["name"], step, new_val])

	# Étape 4 : application finale
	for s in stat_data:
		var final_value: float = clamp(s["val"], s["min"], s["max"])
		stats[s["name"]] = int(round(final_value))
		print("✅ Stat finale :%s = %d" % [s["name"], stats[s["name"]]])

func get_suffixe_qualite() -> String:
	if perfection == 100:
		return " [miraculeuse]"
	elif perfection >= 90:
		return " [parfaite]"
	elif perfection >= 70:
		return " [excellente]"
	elif perfection >= 35:
		return ""
	elif perfection >= 15:
		return " [médiocre]"
	else:
		return " [cassée]"

func get_nom_complet() -> String:
	return name + get_suffixe_qualite()
