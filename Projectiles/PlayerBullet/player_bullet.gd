extends Hitbox
class_name Projectile

@export var velocity : Vector2 = Vector2(2000.0,0)
var sender = null

func _process(delta):
	position += velocity * delta

func _on_body_entered(_body):
	self.queue_free()
