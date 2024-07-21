extends PathFollow2D

@export var swing : bool = true
@onready var cycle : CycleManager = $"../.."

func _process(_delta : float):
	progress_ratio = cycle.time
