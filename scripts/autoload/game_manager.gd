extends Node
## Autoload singleton ("Game"). Tiene lo stato di run: vite, punteggio,
## munizioni speciali, checkpoint e stato del boss. Comunica con il resto
## del gioco solo tramite segnali, per non accoppiare HUD/player/livello.

signal lives_changed(lives: int)
signal score_changed(score: int)
signal ammo_changed(salami: int, grana: int)
signal speed_boost_changed(active: bool)
signal boss_health_changed(current: int, max_health: int)
signal boss_started
signal boss_defeated
signal level_completed
signal game_over

const MAX_LIVES := 3
const BEER_BOOST_DURATION := 8.0

var lives: int = MAX_LIVES
var score: int = 0
var salami_ammo: int = 0
var grana_ammo: int = 0
var speed_boost_time_left: float = 0.0
var checkpoint_position: Vector2 = Vector2.ZERO
var is_boss_defeated: bool = false


func reset_run() -> void:
	lives = MAX_LIVES
	score = 0
	salami_ammo = 0
	grana_ammo = 0
	speed_boost_time_left = 0.0
	checkpoint_position = Vector2.ZERO
	is_boss_defeated = false
	lives_changed.emit(lives)
	score_changed.emit(score)
	ammo_changed.emit(salami_ammo, grana_ammo)
	speed_boost_changed.emit(false)


func add_score(amount: int) -> void:
	score += amount
	score_changed.emit(score)


func add_ammo(kind: StringName, amount: int = 1) -> void:
	if kind == &"salami":
		salami_ammo += amount
	elif kind == &"grana":
		grana_ammo += amount
	ammo_changed.emit(salami_ammo, grana_ammo)


## Consuma una munizione speciale seguendo la priorita' salame -> grana.
## Ritorna il tipo consumato ("salami"/"grana") o "" se non c'e' scorta.
func consume_special_ammo() -> StringName:
	if salami_ammo > 0:
		salami_ammo -= 1
		ammo_changed.emit(salami_ammo, grana_ammo)
		return &"salami"
	if grana_ammo > 0:
		grana_ammo -= 1
		ammo_changed.emit(salami_ammo, grana_ammo)
		return &"grana"
	return &""


func activate_speed_boost() -> void:
	var was_active := speed_boost_time_left > 0.0
	speed_boost_time_left = BEER_BOOST_DURATION
	if not was_active:
		speed_boost_changed.emit(true)


func tick_speed_boost(delta: float) -> void:
	if speed_boost_time_left <= 0.0:
		return
	speed_boost_time_left = max(0.0, speed_boost_time_left - delta)
	if speed_boost_time_left == 0.0:
		speed_boost_changed.emit(false)


func has_speed_boost() -> bool:
	return speed_boost_time_left > 0.0


func set_checkpoint(pos: Vector2) -> void:
	checkpoint_position = pos


func lose_life() -> void:
	lives = max(0, lives - 1)
	lives_changed.emit(lives)
	if lives == 0:
		game_over.emit()


func report_boss_health(current: int, max_health: int) -> void:
	boss_health_changed.emit(current, max_health)


func notify_boss_started() -> void:
	boss_started.emit()


func notify_boss_defeated() -> void:
	is_boss_defeated = true
	boss_defeated.emit()


func trigger_level_complete() -> void:
	level_completed.emit()
