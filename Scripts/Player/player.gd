extends CharacterBody2D

@onready var anim_tree = get_node("AnimationTree")
@onready var attack_area = $attack_area
@onready var healthbar = $Healthbar

const speed:int = 120
var attacking:bool = false
var dying:bool = false
var health:int = 300
#var health_max: int = 300
var regen: int = 1

var last_direction := Vector2.DOWN

func _ready():
	healthbar.init_health(health)


func _physics_process(delta):
	
	#while health < health_max:
		#health += regen
		#if health > health_max:
			#health = health_max
		#print(health)
	
	
	
	if Input.is_action_just_pressed("ui_accept") and not attacking and not dying:
		start_attack()
		return
		
	
	if (attacking == false) and (dying == false): 
		var input_vector = Vector2 (
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		).normalized()
		
		velocity = input_vector * speed 
		
		# self.velocity += input_vector*delta*500
		if input_vector != Vector2.ZERO:
			last_direction = input_vector
			anim_tree.get("parameters/playback").travel("Walk")
		else:
			anim_tree.get("parameters/playback").travel("Idle")

		anim_tree.set("parameters/Idle/BlendSpace2D/blend_position", last_direction)
		anim_tree.set("parameters/Attack/BlendSpace2D/blend_position", last_direction)
		anim_tree.set("parameters/Walk/BlendSpace2D/blend_position", last_direction)
		
		#print(health)
		move_and_slide()
		
func start_attack() -> void:
	attacking = true
	print("start_attack: last_direction=", last_direction)
	# Position and enable attack area
	attack_area.position = last_direction * 14
	attack_area.monitoring = true
	print("attack_area enabled at pos=", attack_area.global_position)
	# Wait one physics frame to register overlaps
	await get_tree().physics_frame
	# Check overlapping bodies
	var bodies = attack_area.get_overlapping_bodies()
	print("start_attack overlaps count=", bodies.size())
	for body in bodies:
		print("  candidate =", body.name)
		if body.has_method("take_damage"):
			print("  applying damage to", body.name)
			body.take_damage(20)
	# Trigger attack animation
	anim_tree.get("parameters/playback").travel("Attack")

func end_attack():
	attacking = false
	attack_area.monitoring = false	

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if "attack" in anim_name:
		
		end_attack()
		
func take_damage(damage: int):
	health -= damage
	print("player health :", health)
	healthbar.health = health
	if health <= 0:
		dying = true
		anim_tree.get("parameters/playback").travel("Death")
		await anim_tree.animation_finished
		get_tree().change_scene_to_file("res://Scenes/Menu/GameOver.tscn")
		queue_free()
