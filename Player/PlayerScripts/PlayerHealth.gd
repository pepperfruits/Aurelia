extends Health
class_name PlayerHealth

@onready var movement : PlayerMovementHandler = $"../Movement"
@onready var p : PlayerCharacter = $".."
@onready var DeathTransitionTimer : Timer = $DeathTransitionTimer

func death():
	if DeathTransitionTimer.is_stopped():
		$"../DebugLabel".text = "DEAD"
		p.set_camera_transition(true)
		DeathTransitionTimer.start()
		ScoreManager.deaths += 1

func apply_knockback(knockback : float, knockback_vector : Vector2) -> void:
	entity.velocity = knockback_vector.normalized() * knockback
	movement.momentum = entity.velocity.x

func _on_death_transition_timer_timeout():
	get_tree().reload_current_scene.bind().call_deferred()
