extends Area2D
class_name CameraControlArea

@export var marker : Marker2D
@export var zoom : Vector2 = Vector2(0.6, 0.6)

func _on_body_entered(body : PlayerCharacter):
	body.add_camera_area(self)

func _on_body_exited(body : PlayerCharacter):
	body.remove_camera_area()
