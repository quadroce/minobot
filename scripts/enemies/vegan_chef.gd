extends "res://scripts/enemies/enemy_base.gd"
## Chef Vegano: resta perlopiu' fermo e lancia verdure verso Minobot a
## intervalli regolari quando lo rileva nel raggio d'azione.

const THROW_OFFSET := Vector2(10.0, -6.0)

@export var vegetable_scene: PackedScene
@export var throw_interval: float = 2.5

var _target: Node2D = null
var _throw_timer: float = 0.0

@onready var _range_area: Area2D = $RangeArea


func _ready() -> void:
	super._ready()
	patrols = false
	_range_area.collision_layer = 0
	_range_area.collision_mask = 0
	_range_area.set_collision_mask_value(2, true) # player
	_range_area.body_entered.connect(_on_range_body_entered)
	_range_area.body_exited.connect(_on_range_body_exited)
	_throw_timer = throw_interval


func _update_behavior(delta: float) -> void:
	velocity.x = 0.0
	if _target == null or not is_instance_valid(_target):
		return
	_face(int(sign(_target.global_position.x - global_position.x)))
	_throw_timer -= delta
	if _throw_timer <= 0.0:
		_throw_timer = throw_interval
		_throw_vegetable()


func _throw_vegetable() -> void:
	if vegetable_scene == null:
		return
	var projectile: Node2D = vegetable_scene.instantiate()
	get_parent().add_child(projectile)
	projectile.global_position = global_position + Vector2(THROW_OFFSET.x * direction, THROW_OFFSET.y)
	if projectile.has_method("launch"):
		projectile.launch(direction)


func _on_range_body_entered(body: Node2D) -> void:
	if body.has_method("take_hit"):
		_target = body


func _on_range_body_exited(body: Node2D) -> void:
	if body == _target:
		_target = null
