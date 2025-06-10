extends StaticBody2D

@export var spawn_point_name := "spawn_fire_1" #a modifier depuis l'inspecteur
@export var campfire_id := "campfire_1"  # Un identifiant unique pour chaque feu

var player_in_range = false
var player_ref : Node = null
var is_lit = false

var base_energy = 1.0
var flicker_strenght = 0.2

func _ready():
	# Vérifie si ce feu a déjà été allumé
	if GameManager.is_campfire_lit(campfire_id):
		is_lit = true
		play_anim("Lit")
		$PointLight2D.visible = true
	
	# Cache l’indicateur d’interaction
	$InteractionLabel.visible = false
	$PointLight2D.visible = false
	
	# Connecte les signaux
	$Detector.connect("body_entered", Callable(self, "_on_body_entered"))
	$Detector.connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body):
	if body.is_in_group("Player"):
		player_in_range = true
		player_ref = body
		#print("player en range")
		if not is_lit:
			$InteractionLabel.visible = true

func _on_body_exited(body):
	if body == player_ref:
		player_in_range = false
		player_ref = null
		$InteractionLabel.visible = false

func _process(delta):
	if player_in_range and not is_lit and Input.is_action_just_pressed("ui_accept"):
		print("feu !")
		ignite()
		#print(GameManager.lit_campfires)
	#print("État du feu :", campfire_id, "=>", GameManager.is_campfire_lit(campfire_id))
	if is_lit:
		var variation = randf_range(-flicker_strenght, flicker_strenght)
		$PointLight2D.energy = base_energy + variation


func ignite(permanent = false):
	#print("test:",GameManager.test)
	#print("toto")
	#print("feu2")
	is_lit = true
	$PointLight2D.visible = true
	$InteractionLabel.visible = false
	play_anim("Igniting")
	#await $AnimationPlayer.animation_finished
	play_anim("Lit")
	#print(GameManager.lit_campfires)
	#print("test:",GameManager.test)
	#print("toto")

	if permanent:
		return # Animation d'allumage déjà jouée plus tôt

	# Marque ce feu comme allumé dans les sauvegardes
	GameManager.mark_campfire_lit(campfire_id)
	print("DEBUG - après allumage :", GameManager.lit_campfires)


	# Déclare ce feu comme le dernier checkpoint actif
	GameManager.set_last_checkpoint(get_tree().current_scene.scene_file_path, spawn_point_name)

func play_anim(name):
	$AnimationTree["parameters/playback"].travel(name)
