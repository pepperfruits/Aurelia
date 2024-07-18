extends Area2D
class_name HookArea2D

@onready var p : PlayerCharacterBody2D = $"..".p
@onready var timer : Timer = $HookCooldownTimer
@onready var collision : CollisionShape2D = $HookAreaCollisionShape
@onready var sprite : Sprite2D = $HookSprite
@onready var spriteAura : Sprite2D = $HookAuraSprite
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
	timer.start()
	collision.disabled = true
	p._on_player_exited_hook_range(self)
	sprite.texture = spriteDisabled

func _on_hook_cooldown_timer_timeout():
	collision.disabled = false
	sprite.texture = spriteEnabled


func _on_aura_range_body_entered(body):
	spriteAura.visible = true

func _on_aura_range_body_exited(body):
	spriteAura.visible = false
