extends "res://scripts/enemies/enemy_base.gd"
## Arbitro: pattuglia un tratto fisso. Se il giocatore entra nella sua zona
## di allerta, si ferma un istante e "fischia", rallentando Minobot.

@export var whistle_cooldown: float = 2.0
@export var freeze_duration: float = 0.5

var _cooldown_left: float = 0.0
var _freeze_left: float = 0.0

@onready var _alert_zone: Area2D = $AlertZone


func _ready() -> void:
	super._ready()
	_alert_zone.collision_layer = 0
	_alert_zone.collision_mask = 0
	_alert_zone.set_collision_mask_value(2, true) # player
	_alert_zone.body_entered.connect(_on_alert_zone_body_entered)


func _update_behavior(delta: float) -> void:
	if _cooldown_left > 0.0:
		_cooldown_left -= delta
	if _freeze_left > 0.0:
		_freeze_left -= delta
		velocity.x = 0.0
		return
	_patrol(delta)


func _on_alert_zone_body_entered(body: Node2D) -> void:
	if is_dead or _cooldown_left > 0.0:
		return
	if body.has_method("apply_whistle_slow"):
		body.apply_whistle_slow()
		_cooldown_left = whistle_cooldown
		_freeze_left = freeze_duration
