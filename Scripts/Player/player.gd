extends CharacterBody2D

@onready var anim_tree = get_node("AnimationTree")

const speed:int = 200
var attacking:bool = false
var dying:bool = false
var health:int = 1000

var last_direction := Vector2.DOWN


func _physics_process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		anim_tree.get("parameters/playback").travel("Attack")
		attacking = true
	
	
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
		
		hit(0)
		#print(health)
		move_and_slide()

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if "attack" in anim_name:
		print("fin attaque")
		attacking = false
		
func hit(damage):
	health -= damage
	if health <= 0 :
		dying = true
		anim_tree.get("parameters/playback").travel("Death")
		await anim_tree.animation_finished
		self.queue_free()
