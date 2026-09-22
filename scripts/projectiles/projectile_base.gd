extends Area2D
class_name ProjectileBase
## Base per tutti i proiettili (palla da rugby, salame, Grana Padano,
## verdura). Movimento orizzontale costante + arco opzionale, si distrugge
## dopo lifetime secondi o al primo contatto utile.

@export var speed: float = 300.0
@export var damage: int = 1
@export var lifetime: float = 2.5
@export var arc_gravity: float = 0.0

var direction: int = 1
var _age: float = 0.0
var _fall_speed: float = 0.0

@onready var _sprite: Sprite2D = $Sprite


func _ready() -> void:
	body_entered.connect(_apply_hit)
	area_entered.connect(_apply_hit)


func launch(facing_direction: int) -> void:
	direction = facing_direction
	_sprite.scale.x = abs(_sprite.scale.x) * direction


func _physics_process(delta: float) -> void:
	_age += delta
	if _age >= lifetime:
		queue_free()
		return
	if arc_gravity > 0.0:
		_fall_speed += arc_gravity * delta
	position += Vector2(direction * speed, _fall_speed) * delta


func get_damage() -> int:
	return damage


func _apply_hit(target: Node) -> void:
	_on_hit(target)
	queue_free()


## Sovrascritto dalle sottoclassi: applica danno solo al bersaglio giusto
## (nemico per i proiettili del giocatore, giocatore per quelli nemici).
## Un contatto col mondo (muro/pavimento) non ha un metodo corrispondente
## e quindi il proiettile si limita a sparire.
func _on_hit(_target: Node) -> void:
	pass
