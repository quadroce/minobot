extends Node2D
## Livello unico a tre sezioni (Metropolitana / Campo da rugby / Clubhouse).
## Resetta lo stato di run, collega il trigger del traguardo e mostra la
## schermata finale su vittoria o game over.

const END_SCREEN_SCENE := preload("res://scenes/ui/EndScreen.tscn")

@onready var _goal: Area2D = $Goal

var _end_screen: CanvasLayer = null


func _ready() -> void:
	Game.reset_run()
	Game.game_over.connect(_on_game_over)
	Game.level_completed.connect(_on_level_completed)
	_goal.collision_layer = 0
	_goal.collision_mask = 0
	_goal.set_collision_mask_value(2, true) # player
	_goal.body_entered.connect(_on_goal_entered)


func _on_goal_entered(body: Node2D) -> void:
	if not body.has_method("take_hit"):
		return
	if Game.is_boss_defeated:
		Game.trigger_level_complete()


func _on_game_over() -> void:
	_show_end_screen("GAME OVER", false)


func _on_level_completed() -> void:
	_show_end_screen("META'! HAI VINTO!", true)


func _show_end_screen(message: String, victory: bool) -> void:
	if _end_screen != null:
		return
	get_tree().paused = true
	_end_screen = END_SCREEN_SCENE.instantiate()
	add_child(_end_screen)
	_end_screen.setup(message, victory)
