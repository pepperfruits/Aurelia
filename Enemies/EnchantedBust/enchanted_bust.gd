extends StaticBody2D
class_name EnchantedBust

@onready var Sprite : Sprite2D = $Sprite
@onready var Light : PointLight2D = $Light

@export var EYES_CLOSED : Texture2D
@export var EYES_OPEN : Texture2D
@export var Bullet : PackedScene
@export var ShootingMarker : Marker2D

func shoot() -> void:
	var bullet : Projectile = Bullet.instantiate()
	bullet.global_position = ShootingMarker.global_position
	bullet.velocity.x *= scale.x
	get_tree().current_scene.add_child(bullet)

func close_eyes() -> void:
	Sprite.texture = EYES_CLOSED
	Light.enabled = false

func open_eyes() -> void:
	Sprite.texture = EYES_OPEN
	Light.enabled = true
