extends CanvasLayer
## Schermata iniziale: premi INVIO per avviare il livello.


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("start_game"):
		_start()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.pressed:
		_start()


func _start() -> void:
	get_tree().change_scene_to_file("res://scenes/level/Level.tscn")
