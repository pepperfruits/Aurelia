extends Button

@export var control_scheme : int = 0

func _on_pressed():
	ScoreManager.control_scheme = control_scheme
	for i : TutorialButton in $"../../../TutorialButtons".get_children():
		i.update()
