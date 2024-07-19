extends Area2D
class_name Hook

@onready var p : PlayerCharacterBody2D = $"..".p
@onready var timer : Timer = $HookCooldownTimer
@onready var collision : CollisionShape2D = $HookAreaCollisionShape
@onready var sprite : Sprite2D = $HookSprite
@onready var spriteAura : Sprite2D = $HookAuraSprite
@onready var auraRange : Area2D = $AuraRange

@export var spriteEnabled : Texture
@export var spriteDisabled : Texture
@export var AURA_ROTATION_SPEED : float = 360.0

func _ready():
	pass

func _process(delta):
	if spriteAura.visible:
		spriteAura.rotation_degrees += AURA_ROTATION_SPEED * delta

func _on_body_entered(body : PlayerCharacterBody2D):
	body._on_player_entered_hook_range(self)

func _on_body_exited(body : PlayerCharacterBody2D):
	body._on_player_exited_hook_range(self)

func use():
	collision.disabled = true
	p._on_player_exited_hook_range(self)
	sprite.texture = spriteDisabled
	spriteAura.visible = false

func _on_hook_cooldown_timer_timeout():
	collision.disabled = false
	sprite.texture = spriteEnabled
	if not auraRange.get_overlapping_bodies().is_empty():
		spriteAura.visible = true

func _on_aura_range_body_entered(_body):
	if not collision.disabled:
		spriteAura.visible = true

func _on_aura_range_body_exited(_body):
	spriteAura.visible = false
	if collision.disabled:
		timer.start()
