extends Node

var player_scene = preload("res://Scenes/Characters/Player/Player.tscn")
var player: Node2D

func _ready():
	player = player_scene.instantiate()
	get_tree().root.add_child(player)
	player.name = "Player"
	#player.z_index = 10  # Pour être au-dessus du décor
