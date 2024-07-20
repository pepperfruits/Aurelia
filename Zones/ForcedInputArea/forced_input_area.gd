extends Area2D
class_name ForcedInputArea

func _on_body_entered(body : PlayerCharacter):
	effect(body, true)

func _on_body_exited(body : PlayerCharacter):
	effect(body, false)

func effect(_body : PlayerCharacter, _enabled : bool):
	pass
