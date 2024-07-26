extends Area2D
class_name Crystal

var p : PlayerCharacter = null
@onready var PointerSprite : Sprite2D = $PointerSprite

func _process(_delta):
	if p:
		var h = p.InputHandler.get_horizontal_input()
		var v = p.InputHandler.get_vertical_input()
		if h or v:
			var direction : Vector2 = Vector2(h, -v)
			PointerSprite.position = (direction.normalized() * 300.0)
			PointerSprite.rotation = direction.angle()

func _on_area_entered(bullet : Projectile):
	p = bullet.sender
	teleport_player()
	p.enter_crystal(self)
	set_pointer(true)
	bullet.queue_free()

func teleport_player():
	p.global_position = global_position
	p.set_player_velocity(Vector2(0,0))

func set_pointer(b : bool) -> void:
	PointerSprite.visible = b

func use():
	set_pointer(false)
	p = null
