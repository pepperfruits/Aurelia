extends PathFollow2D

@export var swing : bool = true
@export var offset : float = 0.0
@onready var cycle : CycleManager = $"../.."

func _process(_delta : float):
	progress_ratio = cycle.time + offset
