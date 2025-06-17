extends Node

@onready var fade_player = $FadeLayer/AnimationPlayer
@onready var fade_rect = $FadeLayer/FadeRect
@onready var map_root = $MapRoot
@onready var player_root = $PlayerRoot
@onready var player = preload("res://Scenes/Characters/Player/Player.tscn").instantiate()

func _ready():
	player_root.add_child(player)
	change_map("res://Scenes/World/Map1.tscn", "StartPosition", Color.BLACK)

func change_map(scene_path: String, target_spawn_node: NodePath, fade_color: Color):
	fade_rect.color = fade_color
	fade_player.play("fade_out")
	await fade_player.animation_finished

	# Supprimer ancienne map
	for child in map_root.get_children():
		child.queue_free()

	# Charger la nouvelle
	var new_map = load(scene_path).instantiate()
	map_root.add_child(new_map)

	# Replacer le joueur
	var target = new_map.get_node_or_null(target_spawn_node)
	if target:
		player.global_position = target.global_position
	else:
		push_error("No valid target node for teleportation!")

	fade_player.play("fade_in")
	await fade_player.animation_finished
