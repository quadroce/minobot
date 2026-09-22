extends CanvasLayer
## HUD di gioco: vite, punteggio, munizioni speciali e barra vita del boss.
## Non conosce player/nemici direttamente: ascolta solo i segnali di Game.

@onready var _lives_label: Label = $Margin/VBox/LivesLabel
@onready var _score_label: Label = $Margin/VBox/ScoreLabel
@onready var _ammo_label: Label = $Margin/VBox/AmmoLabel
@onready var _boss_bar: ProgressBar = $Margin/VBox/BossBar


func _ready() -> void:
	Game.lives_changed.connect(_on_lives_changed)
	Game.score_changed.connect(_on_score_changed)
	Game.ammo_changed.connect(_on_ammo_changed)
	Game.boss_started.connect(_on_boss_started)
	Game.boss_health_changed.connect(_on_boss_health_changed)

	_on_lives_changed(Game.lives)
	_on_score_changed(Game.score)
	_on_ammo_changed(Game.salami_ammo, Game.grana_ammo)
	_boss_bar.visible = false


func _on_lives_changed(lives: int) -> void:
	_lives_label.text = "Vite: %d" % lives


func _on_score_changed(score: int) -> void:
	_score_label.text = "Punti: %d" % score


func _on_ammo_changed(salami: int, grana: int) -> void:
	_ammo_label.text = "Salame x%d   Grana Padano x%d" % [salami, grana]


func _on_boss_started() -> void:
	_boss_bar.visible = true


func _on_boss_health_changed(current: int, max_health: int) -> void:
	_boss_bar.max_value = max_health
	_boss_bar.value = current
