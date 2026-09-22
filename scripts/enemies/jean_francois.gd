extends "res://scripts/enemies/enemy_base.gd"
## Boss finale: lo chef vegano Jean-Francois. Alterna volley di verdure e
## cariche; i tempi di recupero si accorciano man mano che la vita scende,
## rendendo lo scontro progressivamente piu' aggressivo.

const THROW_OFFSET := Vector2(14.0, -10.0)

@export var vegetable_scene: PackedScene
@export var charge_speed: float = 200.0
@export var volley_count: int = 3
@export var volley_spread: float = 40.0

var _target: Node2D = null
var _phase_timer: float = 0.0
var _is_charging: bool = false
var _charge_time_left: float = 0.0
var _has_started: bool = false

@onready var _arena_trigger: Area2D = $ArenaTrigger


func _ready() -> void:
	super._ready()
	patrols = false
	_arena_trigger.collision_layer = 0
	_arena_trigger.collision_mask = 0
	_arena_trigger.set_collision_mask_value(2, true) # player
	_arena_trigger.body_entered.connect(_on_arena_body_entered)
	_phase_timer = _current_attack_cooldown()


func _current_attack_cooldown() -> float:
	var health_ratio := float(health) / float(max_health)
	return lerp(1.2, 3.0, clampf(health_ratio, 0.0, 1.0))


func _update_behavior(delta: float) -> void:
	if not _has_started:
		velocity.x = 0.0
		return

	if _is_charging:
		velocity.x = direction * charge_speed
		_charge_time_left -= delta
		if _charge_time_left <= 0.0 or _wall_ray.is_colliding():
			_is_charging = false
			_phase_timer = _current_attack_cooldown()
		return

	velocity.x = 0.0
	if _target != null and is_instance_valid(_target):
		_face(int(sign(_target.global_position.x - global_position.x)))

	_phase_timer -= delta
	if _phase_timer <= 0.0:
		if randf() < 0.5:
			_start_volley()
		else:
			_start_charge()


func _start_volley() -> void:
	if vegetable_scene == null:
		_phase_timer = _current_attack_cooldown()
		return
	for i in range(volley_count):
		var projectile: Node2D = vegetable_scene.instantiate()
		get_parent().add_child(projectile)
		var spawn_offset := THROW_OFFSET + Vector2(0.0, i * volley_spread - volley_spread)
		projectile.global_position = global_position + Vector2(spawn_offset.x * direction, spawn_offset.y)
		if projectile.has_method("launch"):
			projectile.launch(direction)
	_phase_timer = _current_attack_cooldown()


func _start_charge() -> void:
	_is_charging = true
	_charge_time_left = 1.0


func _on_arena_body_entered(body: Node2D) -> void:
	if not body.has_method("take_hit"):
		return
	_target = body
	if not _has_started:
		_has_started = true
		Game.notify_boss_started()


func take_damage(amount: int) -> void:
	super.take_damage(amount)
	if not is_dead:
		Game.report_boss_health(health, max_health)


func _die() -> void:
	is_dead = true
	Game.add_score(score_reward)
	Game.notify_boss_defeated()
	queue_free()
