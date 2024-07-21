extends Node2D
class_name ToggleManager

@export var starts_enabled : bool = true
@export var disabled_alpha : float = 0.25
@onready var cycle : CycleManager = $".."

var enabled : bool = true

func _ready():
	enabled = starts_enabled
	if not starts_enabled:
		toggle()
	for node in self.get_children():
		node.use_parent_material = true

func _process(_delta):
	if cycle.firstFrame:
		toggle()

func toggle() -> void:
	if enabled:
		enabled = false
		material.set("shader_parameter/alpha", disabled_alpha)
		for node in self.get_children():
			node.process_mode = Node.PROCESS_MODE_DISABLED
	else:
		enabled = true
		material.set("shader_parameter/alpha", 1.0)
		for node in self.get_children():
			node.process_mode = Node.PROCESS_MODE_INHERIT
