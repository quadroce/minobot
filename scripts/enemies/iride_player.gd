extends "res://scripts/enemies/enemy_base.gd"
## Giocatore dell'Iride Cologno Rugby: pattuglia finche' non avvista Minobot
## alla stessa altezza, poi parte in carica per colpirlo.

@export var charge_speed: float = 180.0
@export var charge_duration: float = 1.2

var _is_charging: bool = false
var _charge_time_left: float = 0.0
var _target: Node2D = null

@onready var _detection_area: Area2D = $DetectionArea


func _ready() -> void:
	super._ready()
	_detection_area.collision_layer = 0
	_detection_area.collision_mask = 0
	_detection_area.set_collision_mask_value(2, true) # player
	_detection_area.body_entered.connect(_on_detection_body_entered)
	_detection_area.body_exited.connect(_on_detection_body_exited)


func _update_behavior(delta: float) -> void:
	if _is_charging:
		_charge_time_left -= delta
		velocity.x = direction * charge_speed
		if _charge_time_left <= 0.0 or _wall_ray.is_colliding():
			_is_charging = false
		return

	if _target != null and is_instance_valid(_target):
		var same_level: bool = abs(_target.global_position.y - global_position.y) < 24.0
		if same_level:
			_face(int(sign(_target.global_position.x - global_position.x)))
			_is_charging = true
			_charge_time_left = charge_duration
			return

	_patrol(delta)


func _on_detection_body_entered(body: Node2D) -> void:
	if body.has_method("take_hit"):
		_target = body


func _on_detection_body_exited(body: Node2D) -> void:
	if body == _target:
		_target = null
