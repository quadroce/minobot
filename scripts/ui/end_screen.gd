extends CanvasLayer
## Schermata di fine partita (vittoria o game over). Resta attiva anche a
## gioco in pausa e torna al menu principale su pressione di INVIO.

@onready var _message_label: Label = $Margin/VBox/MessageLabel
@onready var _hint_label: Label = $Margin/VBox/HintLabel
@onready var _fireworks: TextureRect = $FireworksBackground
@onready var _dim_overlay: ColorRect = $Background


func setup(message: String, victory: bool) -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_message_label.text = message
	_hint_label.text = "Premi INVIO\nper tornare al menu"
	_fireworks.visible = victory
	_dim_overlay.color.a = 0.45 if victory else 0.85


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("start_game"):
		_return_to_menu()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.pressed:
		_return_to_menu()


func _return_to_menu() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/Main.tscn")
