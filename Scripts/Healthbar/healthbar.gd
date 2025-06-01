extends ProgressBar


@onready var timer = $Timer
@onready var damage_bar = $Damagebar

var health = 0 : set = _set_health

func _set_health(new_health):
	
	var prev_health = health
	health = min(max_value, new_health)

	print("Healthbar - MAIN VALUE:", health)
	value = health  # <- Important : met à jour la barre principale (verte par ex.)

	if health <= 0:
		queue_free()

	if health < prev_health:
		timer.start()
	else:
		damage_bar.value = health


func init_health(_health):
	# Set maximum before assigning health so setter clamps correctly
	max_value = _health
	damage_bar.max_value = _health
	# Assign health via setter now that max_value is correct
	health = _health
	value = health
	damage_bar.value = health
	
	
func _on_timer_timeout() -> void:
	print("Timer finished. Updating damage_bar to:", health)
	damage_bar.value = health

func set_health(new_health: int):
	health = new_health

func _ready() -> void:
	# Auto-configure max_value and initial current value from parent node's health
	var parent_node = get_parent()
	if parent_node and parent_node.has("health"):
		init_health(parent_node.health)
	else:
		print("Healthbar: cannot read parent health to initialize")
