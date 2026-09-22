extends CanvasLayer
## Schermata iniziale: premi INVIO per avviare il livello.


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("start_game"):
		get_tree().change_scene_to_file("res://scenes/level/Level.tscn")
