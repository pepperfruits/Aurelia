extends ForcedInputArea
class_name ForcedHorizontalArea

@export var HORZIONTAL_INPUT : float = 0.0

func effect(body : PlayerCharacter, enabled : bool):
	body.set_player_input(not enabled)
	body.set_forced_horizontal_input(HORZIONTAL_INPUT)
