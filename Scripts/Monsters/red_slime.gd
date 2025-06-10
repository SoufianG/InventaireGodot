extends CharacterBody2D

@onready var anim_tree = $AnimationTree
@onready var anim_state = anim_tree.get("parameters/playback")
@onready var player = get_node("/root/World/Player")  

const SPEED: int = 75
const WALK_CHANGE_INTERVAL = 2.0 #en gros il marche pendant deux secs
const FLEE_CHANGE_INTERVAL = 2.5
const IDLE_MIN = 1.0
const IDLE_MAX = 3.0
const ATTACK_COOLDOWN = 3.0

var is_dead: bool = false
var can_attack:bool = true

enum SlimeState {IDLE, WALK, FLEE, CHASE, ATTACK, DAMAGED, DEATH }
var state = SlimeState.WALK
var previous_state: int = SlimeState.IDLE

var walk_direction = Vector2.ZERO
var last_direction = Vector2.DOWN  # c'est pour qu'il garde sa direction fixe apres avoir bougé

var walk_timer = 0.0
var idle_timer = 0.0
var flee_timer = 2.5


var attack_cooldown_timer: Timer
var recovery_timer: Timer


var health: int = 120
var force: int = 25

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	anim_tree.active = true
	walk_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	walk_timer = WALK_CHANGE_INTERVAL
	idle_timer = 0
	flee_timer = FLEE_CHANGE_INTERVAL


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match state:
		
		SlimeState.WALK:
			walk_timer -= delta
			if walk_timer <= 0:
				state = SlimeState.IDLE
				idle_timer = randf_range(IDLE_MIN, IDLE_MAX) #il s'arrete entre les deux valeurs là de facon random
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
				flee_timer = FLEE_CHANGE_INTERVAL
				
		SlimeState.FLEE:
			flee_timer -= delta
			idle_timer = 2.0
			if flee_timer <= 0:
				state = SlimeState.IDLE
				
			else:
				var direction = (player.global_position + global_position).normalized()
				velocity = direction * (SPEED * 1.5)
				move_and_slide()
				_play_animation("Chase", direction)
		
		SlimeState.CHASE:
			var direction = (player.global_position - global_position).normalized()
			velocity = direction * SPEED
			move_and_slide()
			_play_animation("Chase", direction)
			
		SlimeState.ATTACK:
			var direction = (last_direction).normalized()
			velocity = direction * 0
			move_and_slide()
			_play_animation("Attack", direction)
			
		SlimeState.DAMAGED:
			var direction = (last_direction).normalized()
			velocity = direction * -10
			move_and_slide()
			_play_animation("Damaged", direction)
			
		SlimeState.DEATH:
			move_and_slide()
			_play_animation("Death", last_direction)
			
	
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
