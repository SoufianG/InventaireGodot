extends Node


const STAT_WEIGHTS := {
	"force": 1.0,
	"hp": 0.5,
	"mana": 0.5,
	"defense": 1.0
}

func get_stat_weight(stat: String) -> float:
	if STAT_WEIGHTS.has(stat):
		return STAT_WEIGHTS[stat]
	else:
		push_warning("Stat inconnue dans StatWeights: %s" % stat)
		return 1.0  # ← Valeur par défaut si inconnue
