extends CanvasLayer
## Schermata di fine partita (vittoria o game over). Resta attiva anche a
## gioco in pausa e torna al menu principale su pressione di INVIO.

@onready var _message_label: Label = $Margin/VBox/MessageLabel
@onready var _hint_label: Label = $Margin/VBox/HintLabel


func setup(message: String, _victory: bool) -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_message_label.text = message
	_hint_label.text = "Premi INVIO per tornare al menu"


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("start_game"):
		get_tree().paused = false
		get_tree().change_scene_to_file("res://scenes/Main.tscn")
