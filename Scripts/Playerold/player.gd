extends CharacterBody2D

func _physics_process(delta):
	var input_vector_x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var input_vector_y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	self.velocity += Vector2(input_vector_x, input_vector_y)*delta*500
	
	move_and_slide()
