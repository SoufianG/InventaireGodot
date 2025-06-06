extends CharacterBody2D

@onready var anim_tree = $AnimationTree
@onready var anim_state = anim_tree.get("parameters/playback")
@onready var player = get_node("/root/World/Player")  
@onready var area_chase = $AreaChase
@onready var area_attack = $AreaAttack
@onready var healthbar = $Healthbar  # updated to new Healthbar node name



const SPEED: int = 300


var is_dead: bool = false
enum SlimeState {IDLE, WALK, CHASE, ATTACK, DAMAGED, DEATH }
var state = SlimeState.WALK
var walk_direction = Vector2.ZERO
var walk_timer = 0.0
const WALK_CHANGE_INTERVAL = 2.0 #en gros il change de direction toutes les deux secs
var idle_timer = 0.0
const IDLE_MIN = 1.0
const IDLE_MAX = 3.0

var last_direction = Vector2.DOWN  # c'est pour qu'il garde sa direction fixe apres avoir bougé
var attack_cooldown_timer: Timer

const ATTACK_COOLDOWN = 3.0
var can_attack:bool = true

var recovery_timer: Timer

var previous_state: int = SlimeState.IDLE
var health: int = 120
var current_health = 120


func _ready():
	
	
		
	
	area_chase.connect("body_entered", Callable(self, "_on_chase_area_entered"))
	area_chase.connect("body_exited", Callable(self, "_on_chase_area_exited"))
	area_attack.connect("body_entered", Callable(self, "_on_attack_area_entered"))
	area_attack.connect("body_exited", Callable(self, "_on_attack_area_exited"))
	anim_tree.active = true
	walk_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	walk_timer = WALK_CHANGE_INTERVAL
	idle_timer = 0

	attack_cooldown_timer = Timer.new()
	attack_cooldown_timer.wait_time = ATTACK_COOLDOWN
	attack_cooldown_timer.one_shot = true
	attack_cooldown_timer.connect("timeout", Callable(self, "_on_attack_cooldown_timeout"))
	add_child(attack_cooldown_timer)
	
	recovery_timer = Timer.new()
	recovery_timer.wait_time = 1.0
	recovery_timer.one_shot = true
	recovery_timer.connect("timeout", Callable(self, "_on_recovery_timeout"))
	add_child(recovery_timer)
	
	# Initialize health bar to full health
	healthbar.init_health(health)  # initialize max and damage bar correctly
	
func _physics_process(delta):
	
	#print("Slime state:", state) #futur debug tu connais
	#print(last_direction) 
	
	match state:
		SlimeState.WALK:
			walk_timer -= delta
			if walk_timer <= 0:
				state = SlimeState.IDLE
				idle_timer = randf_range(IDLE_MIN, IDLE_MAX)
				velocity = Vector2.ZERO #j'lui stop le mvt apres sa course
			else:
				velocity = walk_direction * (SPEED /  1.5)
				move_and_slide()
				_play_animation("Walk", walk_direction)
				
		SlimeState.IDLE:
			idle_timer -= delta
			velocity = Vector2.ZERO
			_play_animation("Walk", Vector2.ZERO)
			if idle_timer <= 0:
				state = SlimeState.WALK
				walk_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
				walk_timer = WALK_CHANGE_INTERVAL
				
		SlimeState.CHASE:
			var direction = (player.global_position - global_position).normalized()
			velocity = direction * SPEED
			move_and_slide()
			_play_animation("Chase", direction)
			
		SlimeState.ATTACK:
			velocity = last_direction * (1.5 * SPEED)
			move_and_slide()
			_play_animation("Attack", last_direction)
			
		SlimeState.DAMAGED:
			velocity = last_direction * -10


func _update_blend_position(direction: Vector2):
	anim_tree.set("parameters/Walk/BlendSpace2D/blend_position", direction)
	anim_tree.set("parameters/Chase/BlendSpace2D/blend_position", direction)
	anim_tree.set("parameters/Attack/BlendSpace2D/blend_position", direction)


func _play_animation(anim_name: String, direction: Vector2):
	if direction != Vector2.ZERO:
		last_direction = direction
	if anim_state.get_current_node() != anim_name:
		anim_state.travel(anim_name)
	_update_blend_position(last_direction)
	
func _on_chase_area_entered(body):
	if body == player:
		state = SlimeState.CHASE

func _on_chase_area_exited(body):
	if body == player:
		state = SlimeState.WALK
		
func _on_attack_area_entered(body):
	if body == player and can_attack:
		state = SlimeState.ATTACK
		can_attack = false  # bloque les prochaines attaques
		attack_cooldown_timer.start()
		if body.has_method("take_damage"):
			body.take_damage(50)
		

func _on_attack_area_exited(body):
	if body == player:
		pass
		#state = SlimeState.CHASE
		

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if "attack" in anim_name:
		can_attack = false
		print("fin attaque")
		# attaque unique → on retourne en CHASE immédiatement après
		#state = SlimeState.CHASE
		recovery_timer.start()
		state = SlimeState.IDLE
		
	elif "damaged" in anim_name:
		state = previous_state		
		
func _on_recovery_timeout():
	state = SlimeState.CHASE
	can_attack = true
		
func _on_attack_cooldown_timeout():
	can_attack = true

func take_damage(damage: int):
	if is_dead:
		return
	# Prevent further damage while in damaged state
	if state == SlimeState.DAMAGED:
		return
	health -= damage
	if health < 0:
		health = 0
	print("slime health :", health)


	if health <= 0:
		is_dead = true
		state = SlimeState.DEATH
		anim_state.travel("Death")
		await anim_tree.animation_finished
		queue_free()
		return
	# non-lethal damage: enter damaged state
	if state != SlimeState.DAMAGED:
		previous_state = state
	state = SlimeState.DAMAGED
	velocity = last_direction * -10
	anim_state.travel("Damaged")
