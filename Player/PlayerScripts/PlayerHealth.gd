extends Health
class_name PlayerHealth

@onready var movement : PlayerMovementHandler = $"../Movement"
@onready var p : PlayerCharacter = $".."
@onready var DeathTransitionTimer : Timer = $DeathTransitionTimer

func damage(amount : int, knockback : float, knockback_vector : Vector2) -> void:
	health -= amount
	if knockback:
		apply_knockback(knockback, knockback_vector)
	if (health <= 0):
		death()

func death():
	if DeathTransitionTimer.is_stopped():
		$"../AnimationHandler".death()
		
		$"../InputHandler".set_player_input(false) 
		$"../InputHandler".set_forced_horizontal_input(0)
		
		p.set_camera_transition(true)
		DeathTransitionTimer.start()
		ScoreManager.deaths += 1

func apply_knockback(knockback : float, knockback_vector : Vector2) -> void:
	entity.velocity = knockback_vector.normalized() * knockback
	movement.momentum = entity.velocity.x

func _on_death_transition_timer_timeout():
	get_tree().reload_current_scene.bind().call_deferred()
