extends AudioStreamPlayer

func _ready():
	play()

func _on_finished():
	queue_free()
