extends CharacterBody2D
## Minobot: controller del giocatore. Movimento, salto, lancio proiettili,
## gestione vite/checkpoint. Legge stato condiviso da Game (autoload) e non
## conosce direttamente la HUD: comunica solo tramite segnali/Game.

const SPEED := 120.0
const SPEED_BOOST_MULTIPLIER := 1.6
const JUMP_VELOCITY := -320.0
const MIN_JUMP_VELOCITY := -140.0
const SLOW_PULSE_MULTIPLIER := 0.5
const SLOW_PULSE_DURATION := 0.8
const AURA_SLOW_MULTIPLIER := 0.5
const INVULNERABILITY_DURATION := 1.5
const KNOCKBACK_SPEED := 160.0
const THROW_OFFSET := Vector2(10.0, -4.0)

@export var rugby_ball_scene: PackedScene
@export var salami_scene: PackedScene
@export var grana_padano_scene: PackedScene

var _facing_direction: int = 1
var _is_invulnerable: bool = false
var _invulnerability_time_left: float = 0.0
var _slow_pulse_time_left: float = 0.0
var _in_slow_aura: bool = false
var _is_dead: bool = false

@onready var _sprite: Sprite2D = $Sprite


func _ready() -> void:
	collision_layer = 0
	collision_mask = 0
	set_collision_layer_value(2, true) # player
	set_collision_mask_value(1, true) # world
	set_collision_mask_value(3, true) # enemies (blocco fisico, il danno passa dalla HitArea dei nemici)
	Game.set_checkpoint(global_position)


func _physics_process(delta: float) -> void:
	if _is_dead:
		return

	Game.tick_speed_boost(delta)
	_tick_timers(delta)

	if not is_on_floor():
		velocity.y += get_gravity_y() * delta

	var input_direction := Input.get_axis("move_left", "move_right")
	if input_direction != 0.0:
		_facing_direction = int(sign(input_direction))
		_sprite.scale.x = abs(_sprite.scale.x) * _facing_direction

	var current_speed := SPEED
	if Game.has_speed_boost():
		current_speed *= SPEED_BOOST_MULTIPLIER
	if _slow_pulse_time_left > 0.0:
		current_speed *= SLOW_PULSE_MULTIPLIER
	if _in_slow_aura:
		current_speed *= AURA_SLOW_MULTIPLIER

	velocity.x = input_direction * current_speed

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_released("jump") and velocity.y < MIN_JUMP_VELOCITY:
		velocity.y = MIN_JUMP_VELOCITY

	if Input.is_action_just_pressed("throw_ball"):
		_throw_rugby_ball()
	if Input.is_action_just_pressed("throw_special"):
		_throw_special()

	move_and_slide()

	if _is_invulnerable:
		_sprite.visible = int(_invulnerability_time_left * 10) % 2 == 0
	else:
		_sprite.visible = true


func get_gravity_y() -> float:
	return ProjectSettings.get_setting("physics/2d/default_gravity", 900.0)


func _tick_timers(delta: float) -> void:
	if _slow_pulse_time_left > 0.0:
		_slow_pulse_time_left = max(0.0, _slow_pulse_time_left - delta)
	if _is_invulnerable:
		_invulnerability_time_left -= delta
		if _invulnerability_time_left <= 0.0:
			_is_invulnerable = false
			_sprite.visible = true


func _throw_rugby_ball() -> void:
	if rugby_ball_scene == null:
		return
	_spawn_projectile(rugby_ball_scene)


func _throw_special() -> void:
	var kind := Game.consume_special_ammo()
	if kind == &"salami" and salami_scene != null:
		_spawn_projectile(salami_scene)
	elif kind == &"grana" and grana_padano_scene != null:
		_spawn_projectile(grana_padano_scene)


func _spawn_projectile(scene: PackedScene) -> void:
	var projectile: Node2D = scene.instantiate()
	get_parent().add_child(projectile)
	projectile.global_position = global_position + Vector2(THROW_OFFSET.x * _facing_direction, THROW_OFFSET.y)
	if projectile.has_method("launch"):
		projectile.launch(_facing_direction)


## Chiamato dai nemici e dai loro proiettili quando colpiscono Minobot.
func take_hit(_damage: int, source_position: Vector2) -> void:
	if _is_invulnerable or _is_dead:
		return
	Game.lose_life()
	if Game.lives <= 0:
		_die()
		return
	_is_invulnerable = true
	_invulnerability_time_left = INVULNERABILITY_DURATION
	var knockback_direction := int(sign(global_position.x - source_position.x))
	if knockback_direction == 0:
		knockback_direction = -_facing_direction
	velocity = Vector2(knockback_direction * KNOCKBACK_SPEED, JUMP_VELOCITY * 0.5)
	global_position = Game.checkpoint_position


func apply_whistle_slow() -> void:
	_slow_pulse_time_left = SLOW_PULSE_DURATION


func set_in_slow_aura(value: bool) -> void:
	_in_slow_aura = value


func set_checkpoint_here() -> void:
	Game.set_checkpoint(global_position)


func _die() -> void:
	_is_dead = true
	set_physics_process(false)
	Game.game_over.emit()
