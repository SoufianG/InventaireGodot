extends Node

# --- Données persistantes globales ---
var lit_campfires := {}  # Ex: { "campfire_1": true, "campfire_2": true }
var last_checkpoint_scene : String = ""
var last_checkpoint_spawn : String = ""

# Référence à la scène actuelle
var current_scene: Node = null

# --- Feux de camp ---

## Marque un feu de camp comme allumé
func mark_campfire_lit(id: String) -> void:
	lit_campfires[id] = true

## Vérifie si un feu de camp est déjà allumé
func is_campfire_lit(id: String) -> bool:
	return lit_campfires.get(id, false)

# --- Checkpoints ---

## Définit la scène et le point de spawn du dernier checkpoint
func set_last_checkpoint(scene_path: String, spawn_name: String) -> void:
	last_checkpoint_scene = scene_path
	last_checkpoint_spawn = spawn_name

## Récupère le checkpoint actif sous forme de dictionnaire
func get_last_checkpoint() -> Dictionary:
	return {
		"scene": last_checkpoint_scene,
		"spawn": last_checkpoint_spawn
	}

# --- Changement de scène ---
