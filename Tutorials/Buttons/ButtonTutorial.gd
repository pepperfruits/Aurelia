extends Sprite2D

@export var ZXC_image : Texture2D
@export var JKL_image : Texture2D
@export var MOUSE_image : Texture2D

func _ready():
	match ScoreManager.control_scheme:
		0:
			texture = ZXC_image
		1:
			texture = JKL_image
		2:
			texture = MOUSE_image

