extends Area2D
class_name Hook

#region Onready
@onready var p : PlayerCharacter = $"..".p
@onready var timer : Timer = $HookCooldownTimer
@onready var collision : CollisionShape2D = $HookAreaCollisionShape
@onready var sprite : Sprite2D = $HookSprite
@onready var spriteAura : Sprite2D = $HookAuraSprite
@onready var auraRange : Area2D = $AuraRange
#endregion

#region Exports
@export var spriteEnabled : Texture
@export var spriteDisabled : Texture
@export var AURA_ROTATION_SPEED : float = 360.0
#endregion

func _process(delta):
	if spriteAura.visible:
		spriteAura.rotation_degrees += AURA_ROTATION_SPEED * delta

#region Helper Functions
func use():
	disable()
	p._on_player_exited_hook_range(self)

func enable():
	collision.disabled = false
	sprite.texture = spriteEnabled
	if not auraRange.get_overlapping_bodies().is_empty():
		spriteAura.visible = true

func disable():
#endregion
	collision.disabled = true
	sprite.texture = spriteDisabled
	spriteAura.visible = false

#region Signals
func _on_hook_cooldown_timer_timeout():
	enable()

func _on_aura_range_body_entered(_body):
	if not collision.disabled:
		spriteAura.visible = true

func _on_aura_range_body_exited(_body):
	spriteAura.visible = false
	if collision.disabled:
		timer.start()

func _on_body_entered(body : PlayerCharacter):
	body._on_player_entered_hook_range(self)

func _on_body_exited(body : PlayerCharacter):
	body._on_player_exited_hook_range(self)
#endregion
