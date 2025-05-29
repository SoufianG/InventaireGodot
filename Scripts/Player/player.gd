extends CharacterBody2D

@onready var anim_tree = get_node("AnimationTree")
@onready var attack_area = $attack_area

const speed:int = 200
var attacking:bool = false
var dying:bool = false
var health:int = 1000

var last_direction := Vector2.DOWN

func _ready():
	attack_area.connect("body_entered", Callable(self, "_on_attack_area_body_entered"))


func _physics_process(delta):
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
		
func start_attack():
	attacking = true
	print (last_direction)

	var offset = Vector2()
	offset = last_direction * 14
	attack_area.position = offset
	attack_area.monitoring = true
	print("fin attaque")

	anim_tree.get("parameters/playback").travel("Attack")

func end_attack():
	attacking = false
	attack_area.monitoring = false	

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if "attack" in anim_name:
		
		end_attack()
		
func _on_attack_area_body_entered(body):
	if body.has_method("take_damage") and attacking:
		print("tac")
		body.take_damage(100) #degat arbitraire bg, faudrait faire une formule ici
		
		
func take_damage(damage: int):
	health -= damage
	print("player health :", health)
	if health <= 0:
		dying = true
		anim_tree.get("parameters/playback").travel("Death")
		await anim_tree.animation_finished
		queue_free()
