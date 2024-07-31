extends Health
class_name StaticBodyHealth

@onready var sfx : PackedScene = preload("res://Audio/sfx_player.tscn")
@export var sound : AudioStream

func apply_knockback(_knockback : float, _knockback_vector : Vector2) -> void:
	var s : AudioStreamPlayer = sfx.instantiate()
	s.stream = sound
	s.volume_db = -6
	get_tree().current_scene.add_child(s)
