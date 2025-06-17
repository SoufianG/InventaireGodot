extends Area2D

@export var target_scene: String
@export var target_spawn_node: NodePath
@export var fade_color: Color = Color.BLACK

func _on_body_entered(body):
	if body.name == "Player":
		var game = get_tree().current_scene
		game.change_map(target_scene, target_spawn_node, fade_color)
