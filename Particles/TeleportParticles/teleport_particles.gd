extends GPUParticles2D

func _ready():
	print("peepee poopoo")
	emitting = true
	await get_tree().create_timer(1.0).timeout
	queue_free()

