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
	health = _health
	max_value = health
	value = health
	damage_bar.max_value = health
	damage_bar.value = health
	
	
func _on_timer_timeout() -> void:
	print("Timer finished. Updating damage_bar to:", health)
	damage_bar.value = health

func set_health(new_health: int):
	health = new_health
