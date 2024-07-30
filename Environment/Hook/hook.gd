extends Area2D
class_name Hook

#region Onready
@onready var timer : Timer = $HookCooldownTimer
@onready var collision : CollisionShape2D = $HookAreaCollisionShape
@onready var sprite : Sprite2D = $HookSprite
@onready var spriteAura : Sprite2D = $HookAuraSprite
@onready var auraRange : Area2D = $AuraRange
@onready var hookLight : PointLight2D = $HookLight
@onready var anim : AnimationPlayer = $AuraAnimation
#endregion

#region Exports
@export var spriteEnabled : Texture
@export var spriteDisabled : Texture
#endregion

var is_ground_refresh : bool = false
var is_cooldown_refresh : bool = false
var is_collision_enabled : bool = true

func _ready():
	if not ScoreManager.particles_enabled:
		hookLight.visible = false

func _process(_delta):
	collision.disabled = not is_collision_enabled

#region Helper Functions
func use():
	disable()

func released():
	sprite.texture = spriteDisabled
	if collision.disabled:
		timer.start()

func enable():
	is_ground_refresh = false
	is_cooldown_refresh = false
	
	
	is_collision_enabled = true
	sprite.texture = spriteEnabled
	hookLight.enabled = true
	if not auraRange.get_overlapping_bodies().is_empty():
		anim.play("aura_enable")

func disable():
	hookLight.enabled = false
	is_collision_enabled = false

func ground_refresh():
	is_ground_refresh = true
	if is_cooldown_refresh:
		enable()
#endregion

#region Signals
func _on_hook_cooldown_timer_timeout():
	is_cooldown_refresh = true
	if is_ground_refresh:
		enable()

func _on_aura_range_body_entered(_body):
	if not collision.disabled:
		anim.play("aura_enable")

func _on_body_entered(body : PlayerCharacter):
	body._on_player_entered_hook_range(self)

func _on_body_exited(body : PlayerCharacter):
	body._on_player_exited_hook_range(self)
#endregion
